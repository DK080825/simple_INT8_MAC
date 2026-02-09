#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>

#include "./FPGA_Driver_MAC.c"

#define WOFF(x) ((x) >> 2)

// Register offsets (byte offsets)
#define MAC_START_OFF      0x00
#define MAC_NUM_OFF        0x04
#define MAC_ZA_ZW_OFF      0x08
#define MAC_ZO_N_OFF       0x0C
#define MAC_M0_OFF         0x10
#define MAC_BIAS_OFF       0x14

#define MAC_ACT_ADDR_OFF   0x20
#define MAC_ACT_DATA_OFF   0x24
#define MAC_ACT_WE_OFF     0x28

#define MAC_WGT_ADDR_OFF   0x30
#define MAC_WGT_DATA_OFF   0x34
#define MAC_WGT_WE_OFF     0x38

#define MAC_STATUS_OFF     0x40
#define MAC_RESULT_OFF     0x44

static inline void reg_write32(uint32_t byte_off, uint32_t v) {
    *(MAC_IP_info.pio_32_mmap + WOFF(byte_off)) = v;
}

static inline uint32_t reg_read32(uint32_t byte_off) {
    return *(MAC_IP_info.pio_32_mmap + WOFF(byte_off));
}

static inline void pulse_we(uint32_t we_off) {
    reg_write32(we_off, 1);
    reg_write32(we_off, 0);
}

static inline void write_act(uint16_t addr, uint8_t data) {
    reg_write32(MAC_ACT_ADDR_OFF, addr);
    reg_write32(MAC_ACT_DATA_OFF, data);
    pulse_we(MAC_ACT_WE_OFF);
}

static inline void write_wgt(uint16_t addr, int8_t data) {
    reg_write32(MAC_WGT_ADDR_OFF, addr);
    reg_write32(MAC_WGT_DATA_OFF, (uint8_t)data); 
    pulse_we(MAC_WGT_WE_OFF);
}

static inline void mac_start() {
    reg_write32(MAC_START_OFF, 1);
    reg_write32(MAC_START_OFF, 0);
}

static inline int mac_done() {
    return (reg_read32(MAC_STATUS_OFF) & 0x1) ? 1 : 0;
}

// Output is QUINT8 -> read low 8 bits as uint8
static inline uint8_t mac_result_u8() {
    return (uint8_t)(reg_read32(MAC_RESULT_OFF) & 0xFF);
}

// 8x8 with pad=1, padding value in quantized domain = Za (input zero_point)
static inline uint8_t get_xq_padded(const uint8_t xq[8][8], int r, int c, uint8_t Za) {
    if (r < 0 || r >= 8 || c < 0 || c >= 8) return Za;
    return xq[r][c];
}


static inline uint32_t compute_M0_int_with_fixed_n(double Sx, double Sw, double Sy, uint32_t n) {
    double M  = (Sx * Sw) / Sy;
    double M0 = ldexp(M, (int)n);               // M * 2^n
    double scaled = M0 * 2147483648.0;          // 2^31
    long long tmp = llround(scaled);            // round-to-nearest
    // Clamp to uint32 range (normally not needed if M0 in [0.5,1))
    if (tmp < 0) tmp = 0;
    if (tmp > 0xFFFFFFFFLL) tmp = 0xFFFFFFFFLL;
    return (uint32_t)tmp;
}

int main() {
    if (mac_ip_open() != 1) {
        fprintf(stderr, "Failed to open MAC IP device.\n");
        exit(EXIT_FAILURE);
    }
    const uint32_t NUM  = 9;

    const uint8_t  Za   = 60;   // Zx (input zero_point)
    const uint8_t  Zw   = 0;    // Zw (weight zero_point)
    const uint8_t  Zo   = 55;   // Zy (output zero_point)  
    const uint32_t n    = 8;    // shift amount            

    const double Sx = 0.03349945694208145;
    const double Sw = 0.002510311547666788;
    const double Sy = 0.026669856160879135;

    const int32_t BIAS = 3284;

    const uint32_t M0 = compute_M0_int_with_fixed_n(Sx, Sw, Sy, n);

    printf("[DBG] Requant (Zo,n fixed externally):\n");
    printf("  M = (Sx*Sw)/Sy = %.18f\n", (Sx*Sw)/Sy);
    printf("  Zo = %u (fixed)\n", (unsigned)Zo);
    printf("  n  = %u (fixed)\n", (unsigned)n);
    printf("  M0_int = 0x%08X (%u)\n", M0, M0);

    //Program registers
    reg_write32(MAC_NUM_OFF, NUM);
    reg_write32(MAC_ZA_ZW_OFF, ((uint32_t)Za & 0xFFu) | (((uint32_t)Zw & 0xFFu) << 8));
    reg_write32(MAC_ZO_N_OFF,  ((uint32_t)Zo & 0xFFu) | (((uint32_t)n  & 0x3Fu) << 8));
    reg_write32(MAC_M0_OFF, M0);
    reg_write32(MAC_BIAS_OFF, (uint32_t)BIAS);

    printf("[DBG] Readback:\n");
    printf("  NUM   = %u\n", reg_read32(MAC_NUM_OFF));
    printf("  ZA_ZW = 0x%08X\n", reg_read32(MAC_ZA_ZW_OFF));
    printf("  ZO_N  = 0x%08X\n", reg_read32(MAC_ZO_N_OFF));
    printf("  M0    = 0x%08X\n", reg_read32(MAC_M0_OFF));
    printf("  BIAS  = %d\n", (int32_t)reg_read32(MAC_BIAS_OFF));

    //INPUT activations xq 8x8
    const uint8_t xq[8][8] = {
        { 61,  97,   8,  14,  37,  79,  61, 114},
        { 56,  79,  42,  49,   0,  19,  35,  64},
        { 88, 101,  18,  34,  86, 116,  49, 111},
        { 51,  69, 121,   1,  21,  45,  37, 118},
        { 20,  32,  16,   1,  24, 118,  91,  94},
        { 65,  29,  73,   1,  15,  28, 103, 100},
        { 33,  60, 104, 127,  88,  71, 106,  24},
        { 74,  11,  17,  28,  91,  88,  23,  82}
    };

    // WEIGHTS w_q 3x3
    const int8_t w[3][3] = {
        {  73, -17,   5},
        {  31,  82, 127},
        {-102, -49,  52}
    };

    // Load weights 
    int idx = 0;
    for (int r = 0; r < 3; r++) {
        for (int c = 0; c < 3; c++) {
            write_wgt((uint16_t)idx, w[r][c]);
            idx++;
        }
    }
    printf("[DBG] Weights loaded.\n");

    // EXPECTED y_q 8x8 
    const uint8_t expected[8][8] = {
        { 84,  50,  32,  37,  69,  90, 107,  87},
        { 75,  38,  58,  49,  37,  14,  54,  57},
        { 92,  71,  31,  44, 115,  77,  98,  70},
        { 67, 105,  76,  50,  71,  59,  78,  58},
        { 39,  40,  24,  46,  82, 107, 102,  49},
        { 60,  71,  41,   6,   0,  56,  85,  76},
        { 47,  79, 112, 127,  82,  61,  55,  77},
        { 51,  31,  35,  72,  96,  67,  67,  80}
    };

    uint8_t actual[8][8];

    // Run conv: 8x8 output, 3x3 kernel, pad=1, stride=1
    //    Each output pixel => one MAC run with 9 activation writes
    for (int out_r = 0; out_r < 8; out_r++) {
        for (int out_c = 0; out_c < 8; out_c++) {

            idx = 0;
            for (int kr = -1; kr <= 1; kr++) {
                for (int kc = -1; kc <= 1; kc++) {
                    uint8_t v = get_xq_padded(xq, out_r + kr, out_c + kc, Za);
                    write_act((uint16_t)idx, v);
                    idx++;
                }
            }

            mac_start();
            while (!mac_done()) { /* spin */ }

            actual[out_r][out_c] = mac_result_u8();
        }
    }

    //Print EXPECTED vs ACTUAL + mismatch count
    printf("\nEXPECTED OUTPUT (y_q int_repr [0,0]):\n");
    for (int r = 0; r < 8; r++) {
        for (int c = 0; c < 8; c++) {
            printf("%u\t", (unsigned)expected[r][c]);
        }
        printf("\n");
    }

    printf("\nACTUAL OUTPUT (MAC IP):\n");
    for (int r = 0; r < 8; r++) {
        for (int c = 0; c < 8; c++) {
            printf("%u\t", (unsigned)actual[r][c]);
        }
        printf("\n");
    }

    int mism = 0;
    for (int r = 0; r < 8; r++) {
        for (int c = 0; c < 8; c++) {
            if (actual[r][c] != expected[r][c]) mism++;
        }
    }
    printf("\nMISMATCH COUNT = %d / %d\n", mism, 8 * 8);

    return 0;
}
