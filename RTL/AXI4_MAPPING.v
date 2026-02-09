
`timescale 1 ns  1 ps
    
    `define MAC_BASE_PHYS            40'h00A0000000
    
     CONTROL  CONFIG
    `define MAC_START_PHYS           (`MAC_BASE_PHYS + 40'h00)
    `define MAC_NUM_PHYS             (`MAC_BASE_PHYS + 40'h04)
    `define MAC_ZA_ZW_PHYS           (`MAC_BASE_PHYS + 40'h08)
    `define MAC_ZO_N_PHYS            (`MAC_BASE_PHYS + 40'h0C)
    `define MAC_M0_PHYS              (`MAC_BASE_PHYS + 40'h10)
    `define MAC_BIAS_PHYS            (`MAC_BASE_PHYS + 40'h14)
    
     ACT BRAM write port
    `define MAC_ACT_ADDR_PHYS        (`MAC_BASE_PHYS + 40'h20)
    `define MAC_ACT_DATA_PHYS        (`MAC_BASE_PHYS + 40'h24)
    `define MAC_ACT_WE_PHYS          (`MAC_BASE_PHYS + 40'h28)
    
     WGT BRAM write port
    `define MAC_WGT_ADDR_PHYS        (`MAC_BASE_PHYS + 40'h30)
    `define MAC_WGT_DATA_PHYS        (`MAC_BASE_PHYS + 40'h34)
    `define MAC_WGT_WE_PHYS          (`MAC_BASE_PHYS + 40'h38)
    
     STATUS  RESULT
    `define MAC_STATUS_PHYS          (`MAC_BASE_PHYS + 40'h40)  busydone
    `define MAC_RESULT_PHYS          (`MAC_BASE_PHYS + 40'h44)  result[70]
    
	module myip_slave_full_v1_0_S00_AXI #
	(
		 Users to add parameters here

		 User parameters ends
		 Do not modify the parameters beyond this line

		 Width of ID for for write address, write data, read address and read data
		parameter integer C_S_AXI_ID_WIDTH	= 1,
		 Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		 Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 8,
		 Width of optional user defined signal in write address channel
		parameter integer C_S_AXI_AWUSER_WIDTH	= 0,
		 Width of optional user defined signal in read address channel
		parameter integer C_S_AXI_ARUSER_WIDTH	= 0,
		 Width of optional user defined signal in write data channel
		parameter integer C_S_AXI_WUSER_WIDTH	= 0,
		 Width of optional user defined signal in read data channel
		parameter integer C_S_AXI_RUSER_WIDTH	= 0,
		 Width of optional user defined signal in write response channel
		parameter integer C_S_AXI_BUSER_WIDTH	= 0
	)
	(
		 Users to add ports here

		 User ports ends
		 Do not modify the ports beyond this line

		 Global Clock Signal
		input wire  S_AXI_ACLK,
		 Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		 Write Address ID
		input wire [C_S_AXI_ID_WIDTH-1  0] S_AXI_AWID,
		 Write address
		input wire [C_S_AXI_ADDR_WIDTH-1  0] S_AXI_AWADDR,
		 Burst length. The burst length gives the exact number of transfers in a burst
		input wire [7  0] S_AXI_AWLEN,
		 Burst size. This signal indicates the size of each transfer in the burst
		input wire [2  0] S_AXI_AWSIZE,
		 Burst type. The burst type and the size information, 
     determine how the address for each transfer within the burst is calculated.
		input wire [1  0] S_AXI_AWBURST,
		 Lock type. Provides additional information about the
     atomic characteristics of the transfer.
		input wire  S_AXI_AWLOCK,
		 Memory type. This signal indicates how transactions
     are required to progress through a system.
		input wire [3  0] S_AXI_AWCACHE,
		 Protection type. This signal indicates the privilege
     and security level of the transaction, and whether
     the transaction is a data access or an instruction access.
		input wire [2  0] S_AXI_AWPROT,
		 Quality of Service, QoS identifier sent for each
     write transaction.
		input wire [3  0] S_AXI_AWQOS,
		 Region identifier. Permits a single physical interface
     on a slave to be used for multiple logical interfaces.
		input wire [3  0] S_AXI_AWREGION,
		 Optional User-defined signal in the write address channel.
		input wire [C_S_AXI_AWUSER_WIDTH-1  0] S_AXI_AWUSER,
		 Write address valid. This signal indicates that
     the channel is signaling valid write address and
     control information.
		input wire  S_AXI_AWVALID,
		 Write address ready. This signal indicates that
     the slave is ready to accept an address and associated
     control signals.
		output wire  S_AXI_AWREADY,
		 Write Data
		input wire [C_S_AXI_DATA_WIDTH-1  0] S_AXI_WDATA,
		 Write strobes. This signal indicates which byte
     lanes hold valid data. There is one write strobe
     bit for each eight bits of the write data bus.
		input wire [(C_S_AXI_DATA_WIDTH8)-1  0] S_AXI_WSTRB,
		 Write last. This signal indicates the last transfer
     in a write burst.
		input wire  S_AXI_WLAST,
		 Optional User-defined signal in the write data channel.
		input wire [C_S_AXI_WUSER_WIDTH-1  0] S_AXI_WUSER,
		 Write valid. This signal indicates that valid write
     data and strobes are available.
		input wire  S_AXI_WVALID,
		 Write ready. This signal indicates that the slave
     can accept the write data.
		output wire  S_AXI_WREADY,
		 Response ID tag. This signal is the ID tag of the
     write response.
		output wire [C_S_AXI_ID_WIDTH-1  0] S_AXI_BID,
		 Write response. This signal indicates the status
     of the write transaction.
		output wire [1  0] S_AXI_BRESP,
		 Optional User-defined signal in the write response channel.
		output wire [C_S_AXI_BUSER_WIDTH-1  0] S_AXI_BUSER,
		 Write response valid. This signal indicates that the
     channel is signaling a valid write response.
		output wire  S_AXI_BVALID,
		 Response ready. This signal indicates that the master
     can accept a write response.
		input wire  S_AXI_BREADY,
		 Read address ID. This signal is the identification
     tag for the read address group of signals.
		input wire [C_S_AXI_ID_WIDTH-1  0] S_AXI_ARID,
		 Read address. This signal indicates the initial
     address of a read burst transaction.
		input wire [C_S_AXI_ADDR_WIDTH-1  0] S_AXI_ARADDR,
		 Burst length. The burst length gives the exact number of transfers in a burst
		input wire [7  0] S_AXI_ARLEN,
		 Burst size. This signal indicates the size of each transfer in the burst
		input wire [2  0] S_AXI_ARSIZE,
		 Burst type. The burst type and the size information, 
     determine how the address for each transfer within the burst is calculated.
		input wire [1  0] S_AXI_ARBURST,
		 Lock type. Provides additional information about the
     atomic characteristics of the transfer.
		input wire  S_AXI_ARLOCK,
		 Memory type. This signal indicates how transactions
     are required to progress through a system.
		input wire [3  0] S_AXI_ARCACHE,
		 Protection type. This signal indicates the privilege
     and security level of the transaction, and whether
     the transaction is a data access or an instruction access.
		input wire [2  0] S_AXI_ARPROT,
		 Quality of Service, QoS identifier sent for each
     read transaction.
		input wire [3  0] S_AXI_ARQOS,
		 Region identifier. Permits a single physical interface
     on a slave to be used for multiple logical interfaces.
		input wire [3  0] S_AXI_ARREGION,
		 Optional User-defined signal in the read address channel.
		input wire [C_S_AXI_ARUSER_WIDTH-1  0] S_AXI_ARUSER,
		 Write address valid. This signal indicates that
     the channel is signaling valid read address and
     control information.
		input wire  S_AXI_ARVALID,
		 Read address ready. This signal indicates that
     the slave is ready to accept an address and associated
     control signals.
		output wire  S_AXI_ARREADY,
		 Read ID tag. This signal is the identification tag
     for the read data group of signals generated by the slave.
		output wire [C_S_AXI_ID_WIDTH-1  0] S_AXI_RID,
		 Read Data
		output wire [C_S_AXI_DATA_WIDTH-1  0] S_AXI_RDATA,
		 Read response. This signal indicates the status of
     the read transfer.
		output wire [1  0] S_AXI_RRESP,
		 Read last. This signal indicates the last transfer
     in a read burst.
		output wire  S_AXI_RLAST,
		 Optional User-defined signal in the read address channel.
		output wire [C_S_AXI_RUSER_WIDTH-1  0] S_AXI_RUSER,
		 Read valid. This signal indicates that the channel
     is signaling the required read data.
		output wire  S_AXI_RVALID,
		 Read ready. This signal indicates that the master can
     accept the read data and response information.
		input wire  S_AXI_RREADY
	);

	 AXI4FULL signals
	reg [C_S_AXI_ADDR_WIDTH-1  0] 	axi_awaddr;
	reg  	axi_awready;
	reg  	axi_wready;
	reg [1  0] 	axi_bresp;
	reg [C_S_AXI_BUSER_WIDTH-1  0] 	axi_buser;
	reg  	axi_bvalid;
	reg [C_S_AXI_ADDR_WIDTH-1  0] 	axi_araddr;
	reg  	axi_arready;
	reg [C_S_AXI_DATA_WIDTH-1  0] 	axi_rdata;
	reg [1  0] 	axi_rresp;
	reg  	axi_rlast;
	reg [C_S_AXI_RUSER_WIDTH-1  0] 	axi_ruser;
	reg  	axi_rvalid;
	 aw_wrap_en determines wrap boundary and enables wrapping
	wire aw_wrap_en;
	 ar_wrap_en determines wrap boundary and enables wrapping
	wire ar_wrap_en;
	 aw_wrap_size is the size of the write transfer, the
	 write address wraps to a lower address if upper address
	 limit is reached
	wire [310]  aw_wrap_size ; 
	 ar_wrap_size is the size of the read transfer, the
	 read address wraps to a lower address if upper address
	 limit is reached
	wire [310]  ar_wrap_size ; 
	 The axi_awv_awr_flag flag marks the presence of write address valid
	reg axi_awv_awr_flag;
	The axi_arv_arr_flag flag marks the presence of read address valid
	reg axi_arv_arr_flag; 
	 The axi_awlen_cntr internal write address counter to keep track of beats in a burst transaction
	reg [70] axi_awlen_cntr;
	The axi_arlen_cntr internal read address counter to keep track of beats in a burst transaction
	reg [70] axi_arlen_cntr;
	reg [10] axi_arburst;
	reg [10] axi_awburst;
	reg [70] axi_arlen;
	reg [70] axi_awlen;
	
	
	 Signals for MAC_IP
	localparam [70] MAC_START_OFF     = 8'h00;
    localparam [70] MAC_NUM_OFF       = 8'h04;
    localparam [70] MAC_ZA_ZW_OFF     = 8'h08;
    localparam [70] MAC_ZO_N_OFF      = 8'h0C;
    localparam [70] MAC_M0_OFF        = 8'h10;
    localparam [70] MAC_BIAS_OFF      = 8'h14;
    
    localparam [70] MAC_ACT_ADDR_OFF  = 8'h20;
    localparam [70] MAC_ACT_DATA_OFF  = 8'h24;
    localparam [70] MAC_ACT_WE_OFF    = 8'h28;
    
    localparam [70] MAC_WGT_ADDR_OFF  = 8'h30;
    localparam [70] MAC_WGT_DATA_OFF  = 8'h34;
    localparam [70] MAC_WGT_WE_OFF    = 8'h38;
    
    localparam [70] MAC_STATUS_OFF    = 8'h40;
    localparam [70] MAC_RESULT_OFF    = 8'h44;
    

	reg                    ctrl_start_r;
	reg        [90]       ctrl_num_r;
	reg signed [70]       ctrl_Za_r;
	reg signed [70]       ctrl_Zw_r;
	reg signed [70]       ctrl_Zo_r;
	reg signed [310]      ctrl_M0_r;
	reg  [50]             ctrl_n_r;
	reg signed [310]      ctrl_bias_r;
	
	reg                    act_we_r;
	reg [90]              act_waddr_r;
	reg signed [70]       act_wdata_r;
	
	reg                    wgt_we_r;
	reg [90]              wgt_waddr_r;
	reg signed [70]       wgt_wdata_r;
	
	wire signed [70]      status_result_w;
	wire                   status_done_w;
	
    local parameter for addressing 32 bit  64 bit C_S_AXI_DATA_WIDTH
	ADDR_LSB is used for addressing 3264 bit registersmemories
	ADDR_LSB = 2 for 32 bits (n downto 2) 
	ADDR_LSB = 3 for 42 bits (n downto 3)

	localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH32)+ 1;
	localparam integer OPT_MEM_ADDR_BITS = 3;
	localparam integer USER_NUM_MEM = 1;
	----------------------------------------------
	-- Signals for user logic memory space example
	------------------------------------------------
	wire [OPT_MEM_ADDR_BITS0] mem_address;
	wire [USER_NUM_MEM-10] mem_select;
	reg [C_S_AXI_DATA_WIDTH-10] mem_data_out[0  USER_NUM_MEM-1];
	wire [C_S_AXI_DATA_WIDTH-1  0] 	axi_rdata_wr;
	
	genvar i;
	genvar j;
	genvar mem_byte_index;

	 IO Connections assignments

	assign S_AXI_AWREADY	= axi_awready;
	assign S_AXI_WREADY	= axi_wready;
	assign S_AXI_BRESP	= axi_bresp;
	assign S_AXI_BUSER	= axi_buser;
	assign S_AXI_BVALID	= axi_bvalid;
	assign S_AXI_ARREADY	= axi_arready;
	assign S_AXI_RDATA	= axi_rdata;
	 assign S_AXI_RDATA	= axi_rdata_wr;
	assign S_AXI_RRESP	= axi_rresp;
	assign S_AXI_RLAST	= axi_rlast;
	assign S_AXI_RUSER	= axi_ruser;
	assign S_AXI_RVALID	= axi_rvalid;
	assign S_AXI_BID = S_AXI_AWID;
	assign S_AXI_RID = S_AXI_ARID;
	assign  aw_wrap_size = (C_S_AXI_DATA_WIDTH8  (axi_awlen)); 
	assign  ar_wrap_size = (C_S_AXI_DATA_WIDTH8  (axi_arlen)); 
	assign  aw_wrap_en = ((axi_awaddr & aw_wrap_size) == aw_wrap_size) 1'b1 1'b0;
	assign  ar_wrap_en = ((axi_araddr & ar_wrap_size) == ar_wrap_size) 1'b1 1'b0;

	 Implement axi_awready generation

	 axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	 S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	 de-asserted when reset is low.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awready = 1'b0;
	      axi_awv_awr_flag = 1'b0;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && ~axi_awv_awr_flag && ~axi_arv_arr_flag)
	        begin
	           slave is ready to accept an address and
	           associated control signals
	          axi_awready = 1'b1;
	          axi_awv_awr_flag  = 1'b1; 
	           used for generation of bresp() and bvalid
	        end
	      else if (S_AXI_WLAST && axi_wready)          
	       preparing to accept next address after current write burst tx completion
	        begin
	          axi_awv_awr_flag  = 1'b0;
	        end
	      else        
	        begin
	          axi_awready = 1'b0;
	        end
	    end 
	end       
	 Implement axi_awaddr latching

	 This process is used to latch the address when both 
	 S_AXI_AWVALID and S_AXI_WVALID are valid. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awaddr = 0;
	      axi_awlen_cntr = 0;
	      axi_awburst = 0;
	      axi_awlen = 0;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && ~axi_awv_awr_flag)
	        begin
	           address latching 
	          axi_awaddr = S_AXI_AWADDR[C_S_AXI_ADDR_WIDTH - 10];  
	           axi_awburst = S_AXI_AWBURST; 
	           axi_awlen = S_AXI_AWLEN;     
	           start address of transfer
	          axi_awlen_cntr = 0;
	        end   
	      else if((axi_awlen_cntr = axi_awlen) && axi_wready && S_AXI_WVALID)        
	        begin

	          axi_awlen_cntr = axi_awlen_cntr + 1;

	          case (axi_awburst)
	            2'b00  fixed burst
	             The write address for all the beats in the transaction are fixed
	              begin
	                axi_awaddr = axi_awaddr;          
	                for awsize = 4 bytes (010)
	              end   
	            2'b01 incremental burst
	             The write address for all the beats in the transaction are increments by awsize
	              begin
	                axi_awaddr[C_S_AXI_ADDR_WIDTH - 1ADDR_LSB] = axi_awaddr[C_S_AXI_ADDR_WIDTH - 1ADDR_LSB] + 1;
	                awaddr aligned to 4 byte boundary
	                axi_awaddr[ADDR_LSB-10]  = {ADDR_LSB{1'b0}};   
	                for awsize = 4 bytes (010)
	              end   
	            2'b10 Wrapping burst
	             The write address wraps when the address reaches wrap boundary 
	              if (aw_wrap_en)
	                begin
	                  axi_awaddr = (axi_awaddr - aw_wrap_size); 
	                end
	              else 
	                begin
	                  axi_awaddr[C_S_AXI_ADDR_WIDTH - 1ADDR_LSB] = axi_awaddr[C_S_AXI_ADDR_WIDTH - 1ADDR_LSB] + 1;
	                  axi_awaddr[ADDR_LSB-10]  = {ADDR_LSB{1'b0}}; 
	                end                      
	            default reserved (incremental burst for example)
	              begin
	                axi_awaddr = axi_awaddr[C_S_AXI_ADDR_WIDTH - 1ADDR_LSB] + 1;
	                for awsize = 4 bytes (010)
	              end
	          endcase              
	        end
	    end 
	end       
	 Implement axi_wready generation

	 axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	 S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	 de-asserted when reset is low. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_wready = 1'b0;
	    end 
	  else
	    begin    
	      if ( ~axi_wready && S_AXI_WVALID && axi_awv_awr_flag)
	        begin
	           slave can accept the write data
	          axi_wready = 1'b1;
	        end
	      else if (~axi_awv_awr_flag)
	      else if (S_AXI_WLAST && axi_wready)
	        begin
	          axi_wready = 1'b0;
	        end
	    end 
	end       
	 Implement write response logic generation

	 The write response and response valid signals are asserted by the slave 
	 when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	 This marks the acceptance of address and indicates the status of 
	 write transaction.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_bvalid = 0;
	      axi_bresp = 2'b0;
	      axi_buser = 0;
	    end 
	  else
	    begin    
	      if (axi_awv_awr_flag && axi_wready && S_AXI_WVALID && ~axi_bvalid && S_AXI_WLAST )
	        begin
	          axi_bvalid = 1'b1;
	          axi_bresp  = 2'b0; 
	           'OKAY' response 
	        end                   
	      else
	        begin
	          if (S_AXI_BREADY && axi_bvalid) 
	          check if bready is asserted while bvalid is high) 
	          (there is a possibility that bready is always asserted high)   
	            begin
	              axi_bvalid = 1'b0; 
	            end  
	        end
	    end
	 end   
	 Implement axi_arready generation

	 axi_arready is asserted for one S_AXI_ACLK clock cycle when
	 S_AXI_ARVALID is asserted. axi_awready is 
	 de-asserted when reset (active low) is asserted. 
	 The read address is also latched when S_AXI_ARVALID is 
	 asserted. axi_araddr is reset to zero on reset assertion.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_arready = 1'b0;
	      axi_arv_arr_flag = 1'b0;
	    end 
	  else
	    begin    
	      if (~axi_arready && S_AXI_ARVALID && ~axi_awv_awr_flag && ~axi_arv_arr_flag)
	        begin
	          axi_arready = 1'b1;
	          axi_arv_arr_flag = 1'b1;
	        end
	      else if (axi_rvalid && S_AXI_RREADY && axi_arlen_cntr == axi_arlen)
	       preparing to accept next address after current read completion
	        begin
	          axi_arv_arr_flag  = 1'b0;
	        end
	      else        
	        begin
	          axi_arready = 1'b0;
	        end
	    end 
	end       
	 Implement axi_araddr latching

	This process is used to latch the address when both 
	S_AXI_ARVALID and S_AXI_RVALID are valid. 
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_araddr = 0;
	      axi_arlen_cntr = 0;
	      axi_arburst = 0;
	      axi_arlen = 0;
	      axi_rlast = 1'b0;
	      axi_ruser = 0;
	    end 
	  else
	    begin    
	      if (~axi_arready && S_AXI_ARVALID && ~axi_arv_arr_flag)
	        begin
	           address latching 
	          axi_araddr = S_AXI_ARADDR[C_S_AXI_ADDR_WIDTH - 10]; 
	          axi_arburst = S_AXI_ARBURST; 
	          axi_arlen = S_AXI_ARLEN;     
	           start address of transfer
	          axi_arlen_cntr = 0;
	          axi_rlast = 1'b0;
	        end   
	      else if((axi_arlen_cntr = axi_arlen) && axi_rvalid && S_AXI_RREADY)        
	        begin
	         
	          axi_arlen_cntr = axi_arlen_cntr + 1;
	          axi_rlast = 1'b0;
	        
	          case (axi_arburst)
	            2'b00  fixed burst
	              The read address for all the beats in the transaction are fixed
	              begin
	                axi_araddr       = axi_araddr;        
	                for arsize = 4 bytes (010)
	              end   
	            2'b01 incremental burst
	             The read address for all the beats in the transaction are increments by awsize
	              begin
	                axi_araddr[C_S_AXI_ADDR_WIDTH - 1ADDR_LSB] = axi_araddr[C_S_AXI_ADDR_WIDTH - 1ADDR_LSB] + 1; 
	                araddr aligned to 4 byte boundary
	                axi_araddr[ADDR_LSB-10]  = {ADDR_LSB{1'b0}};   
	                for awsize = 4 bytes (010)
	              end   
	            2'b10 Wrapping burst
	             The read address wraps when the address reaches wrap boundary 
	              if (ar_wrap_en) 
	                begin
	                  axi_araddr = (axi_araddr - ar_wrap_size); 
	                end
	              else 
	                begin
	                axi_araddr[C_S_AXI_ADDR_WIDTH - 1ADDR_LSB] = axi_araddr[C_S_AXI_ADDR_WIDTH - 1ADDR_LSB] + 1; 
	                araddr aligned to 4 byte boundary
	                axi_araddr[ADDR_LSB-10]  = {ADDR_LSB{1'b0}};   
	                end                      
	            default reserved (incremental burst for example)
	              begin
	                axi_araddr = axi_araddr[C_S_AXI_ADDR_WIDTH - 1ADDR_LSB]+1;
	                for arsize = 4 bytes (010)
	              end
	          endcase              
	        end
	      else if((axi_arlen_cntr == axi_arlen) && ~axi_rlast && axi_arv_arr_flag )   
	        begin
	          axi_rlast = 1'b1;
	        end          
	      else if (S_AXI_RREADY)   
	        begin
	          axi_rlast = 1'b0;
	        end          
	    end 
	end       
	 Implement axi_arvalid generation

	 axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	 S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	 data are available on the axi_rdata bus at this instance. The 
	 assertion of axi_rvalid marks the validity of read data on the 
	 bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	 is deasserted on reset (active low). axi_rresp and axi_rdata are 
	 cleared to zero on reset (active low).  

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rvalid = 0;
	      axi_rresp  = 0;
	    end 
	  else
	    begin    
	      if (axi_arv_arr_flag && ~axi_rvalid)
	        begin
	          axi_rvalid = 1'b1;
	          axi_rresp  = 2'b0; 
	           'OKAY' response
	        end   
	      else if (axi_rvalid && S_AXI_RREADY)
	        begin
	          axi_rvalid = 1'b0;
	        end            
	    end
	end    
	 ------------------------------------------
	 -- Example code to access user logic memory region
	 ------------------------------------------

	generate
	  if (USER_NUM_MEM = 1)
	    begin
	      assign mem_select  = 1;
	      assign mem_address = (axi_arv_arr_flag axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITSADDR_LSB](axi_awv_awr_flag axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITSADDR_LSB]0));
	    end
	endgenerate
	     
	 implement Block RAM(s)
	generate 
	  for(i=0; i= USER_NUM_MEM-1; i=i+1)
	    beginBRAM_GEN
	      wire mem_rden;
	      wire mem_wren;
	
	      assign mem_wren = axi_wready && S_AXI_WVALID ;
	
	      assign mem_rden = axi_arv_arr_flag ; & ~axi_rvalid
	     
	      for(mem_byte_index=0; mem_byte_index= (C_S_AXI_DATA_WIDTH8-1); mem_byte_index=mem_byte_index+1)
	      beginBYTE_BRAM_GEN
	        wire [8-10] data_in ;
	        wire [8-10] data_out;
	        reg  [8-10] byte_ram [0  15];
	        integer  j;
	     
	        assigning 8 bit data
	        assign data_in  = S_AXI_WDATA[(mem_byte_index8+7) - 8];
	        assign data_out = byte_ram[mem_address];
	     
	        always @( posedge S_AXI_ACLK )
	        begin
	          if (mem_wren && S_AXI_WSTRB[mem_byte_index])
	            begin
	              byte_ram[mem_address] = data_in;
	            end   
	        end    
	      
	        always @( posedge S_AXI_ACLK )
	        begin
	          if (mem_rden)
	            begin
	              mem_data_out[i][(mem_byte_index8+7) - 8] = data_out;
	            end   
	        end    
	               
	    end
	  end       
	endgenerate
	Output register or memory read data
                         
	-- ------------------------------------------
	-- -- Example code to access user logic memory region
	-- ------------------------------------------
	 generate                                 
	    if (USER_NUM_MEM = 1)                                 
	      begin                                 
	        assign mem_address_read = axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITSADDR_LSB];                                 
	        assign mem_address_write = (S_AXI_AWVALID && S_AXI_WVALID)  S_AXI_AWADDR[ADDR_LSB+OPT_MEM_ADDR_BITSADDR_LSB]  axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITSADDR_LSB];                                 
	      end                                 
	 endgenerate                                 
	   implement Block RAM(s)                                 
		generate                                  
	   for(i=0; i= USER_NUM_MEM-1; i=i+1)                                 
	     beginBRAM_GEN                                 
	       wire mem_wren;                                 
	       assign mem_wren = axi_wready && S_AXI_WVALID ;                                   
	       for(mem_byte_index=0; mem_byte_index= (C_S_AXI_DATA_WIDTH8-1); mem_byte_index=mem_byte_index+1)                                 
	         beginBYTE_BRAM_GEN                                 
	           wire [8-10] data_in ;                                 
	           wire [8-10] data_out;                                 
	           reg  [8-10] byte_ram [0  15];                                   
	           assigning 8 bit data                                 
	           assign data_in  = S_AXI_WDATA[(mem_byte_index8+7) - 8];                                 
	           assign data_out = byte_ram[mem_address_read];                                   
	           always @(posedge S_AXI_ACLK)                                 
	             begin                                 
	               if (mem_wren && S_AXI_WSTRB[mem_byte_index])                                 
	                 begin                                 
	                   byte_ram[mem_address_write] = data_in;                                 
	                 end                                    
	             end                                    
	           assign mem_data_out[i][(mem_byte_index8+7) - 8] = data_out;                                  
	         end                                 
	       end                                        
	 endgenerate 
	 
	                                 
	 Add user logic here
    always @(posedge S_AXI_ACLK) begin
      if (!S_AXI_ARESETN) begin
        ctrl_start_r = 1'b0;
        ctrl_num_r   = 'd0;
        ctrl_Za_r    = 8'sd0;
        ctrl_Zw_r    = 8'sd0;
        ctrl_Zo_r    = 8'sd0;
        ctrl_M0_r    = 32'sd0;
        ctrl_n_r     = 6'd0;
        ctrl_bias_r  = 32'sd0;
    
        act_we_r     = 1'b0;
        act_waddr_r  = 'd0;
        act_wdata_r  = 8'sd0;
    
        wgt_we_r     = 1'b0;
        wgt_waddr_r  = 'd0;
        wgt_wdata_r  = 8'sd0;
      end else begin
         pulse default low
        ctrl_start_r = 1'b0;
		
        act_we_r     = act_we_r;
		act_waddr_r  = act_waddr_r;
        act_wdata_r  = act_wdata_r;
		
        wgt_we_r     = wgt_we_r;
		wgt_waddr_r  = wgt_waddr_r;
        wgt_wdata_r  = wgt_wdata_r;
		
		ctrl_num_r   = ctrl_num_r;
		ctrl_Za_r    = ctrl_Za_r;
        ctrl_Zw_r    = ctrl_Zw_r ;
        ctrl_Zo_r    = ctrl_Zo_r;
        ctrl_M0_r    = ctrl_M0_r;
        ctrl_n_r     = ctrl_n_r;
        ctrl_bias_r  = ctrl_bias_r;
		
        if (axi_awv_awr_flag) begin
          case (axi_awaddr)
            MAC_START_OFF   ctrl_start_r = S_AXI_WDATA[0];
    
            MAC_NUM_OFF     ctrl_num_r   = S_AXI_WDATA[90];
    
            MAC_ZA_ZW_OFF begin
              ctrl_Za_r = S_AXI_WDATA[70];
              ctrl_Zw_r = S_AXI_WDATA[158];
            end
    
            MAC_ZO_N_OFF begin
              ctrl_Zo_r = S_AXI_WDATA[70];
              ctrl_n_r  = S_AXI_WDATA[138];
            end
    
            MAC_M0_OFF      ctrl_M0_r   = S_AXI_WDATA;
            MAC_BIAS_OFF    ctrl_bias_r = S_AXI_WDATA;
    
            MAC_ACT_ADDR_OFF act_waddr_r = S_AXI_WDATA[90];
            MAC_ACT_DATA_OFF act_wdata_r = S_AXI_WDATA[70];
            MAC_ACT_WE_OFF   act_we_r    = S_AXI_WDATA[0];
    
            MAC_WGT_ADDR_OFF wgt_waddr_r = S_AXI_WDATA[90];
            MAC_WGT_DATA_OFF wgt_wdata_r = S_AXI_WDATA[70];
            MAC_WGT_WE_OFF   wgt_we_r    = S_AXI_WDATA[0];
    
            default ;
          endcase
        end
      end
    end 

   
    reg status_done_latched;

    always @(posedge S_AXI_ACLK) begin
      if (!S_AXI_ARESETN) begin
        status_done_latched = 1'b0;
      end else begin
        if (status_done_w)
          status_done_latched = 1'b1;
    
         clear khi write 1 vào STATUS
        if (w_hs && (wr_addr_r == `MAC_STATUS_PHYS) && S_AXI_WDATA[0])
          status_done_latched = 1'b0;
      end
    end

     ------------------------------
     READ decode (PHYSICAL address compare like template)
     ------------------------------

    always @(posedge S_AXI_ACLK) begin
      if (!S_AXI_ARESETN) begin
        axi_rdata = 32'd0;
      end else if (axi_arv_arr_flag ) begin
        case (axi_araddr)
         for debugging
          MAC_NUM_OFF  axi_rdata = {21'd0, ctrl_num_r};
          MAC_ZA_ZW_OFF axi_rdata = {16'd0, ctrl_Za_r, ctrl_Zw_r};
          MAC_ZO_N_OFF axi_rdata = {18'd0, ctrl_Zo_r, ctrl_n_r};
          MAC_M0_OFF axi_rdata = ctrl_M0_r;
          MAC_BIAS_OFF axi_rdata = ctrl_bias_r;
          
          MAC_STATUS_OFF axi_rdata = {31'd0, status_done_w};
          MAC_RESULT_OFF axi_rdata = {24'd0, status_result_w};
          default          axi_rdata = 32'd0;
        endcase
      end
    end 
    
    MAC_IP1 #(
        .MO_WIDTH(32),
        .ADDR_WIDTH(10),
        .ITE_NUM(110)
      ) mac (
        .clk(S_AXI_ACLK),
        .rstn(S_AXI_ARESETN),
    
        .ctrl_start(ctrl_start_r),
        .ctrl_num(ctrl_num_r),
        .ctrl_Za(ctrl_Za_r),
        .ctrl_Zw(ctrl_Zw_r),
        .ctrl_Zo(ctrl_Zo_r),
        .ctrl_M0(ctrl_M0_r),
        .ctrl_n(ctrl_n_r),
        .ctrl_bias(ctrl_bias_r),
    
        .act_we(act_we_r),
        .act_waddr(act_waddr_r),
        .act_wdata(act_wdata_r),
    
        .wgt_we(wgt_we_r),
        .wgt_waddr(wgt_waddr_r),
        .wgt_wdata(wgt_wdata_r),
    
        .status_result(status_result_w),
        .status_done(status_done_w),
        .status_busy()
      );
 	 User logic ends 


	 Add user logic here

	 User logic ends

	endmodule
