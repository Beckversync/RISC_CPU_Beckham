    `timescale 1ns / 1ps
    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 03/11/2025 03:01:56 PM
    // Design Name: 
    // Module Name: tb_Memory
    // Project Name: 
    // Target Devices: 
    // Tool Versions: 
    // Description: 
    // 
    // Dependencies: 
    // 
    // Revision:
    // Revision 0.01 - File Created
    // Additional Comments:
    // 
    //////////////////////////////////////////////////////////////////////////////////
    
    
 module tb_memory_5x8;

    // Thông số
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 5;

    // Tín hiệu mô phỏng
    reg                       clk;      
    reg                       rst;      
    reg                       sel;      
    reg                       rd;       
    reg                       wr;       
    reg                       ld_ir;    
    reg                       data_e;   
    reg   [ADDR_WIDTH-1:0]    address;  
    reg   [DATA_WIDTH-1:0]    data_in;  
    wire  [DATA_WIDTH-1:0]    data_out; 

    // -----------------------
    //  Instance DUT (Device Under Test)
    // -----------------------
    memory_5x8 #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk      (clk),
        .rst      (rst),
        .sel      (sel),
        .rd       (rd),
        .wr       (wr),
        .ld_ir    (ld_ir),
        .data_e   (data_e),
        .address  (address),
        .data_in  (data_in),
        .data_out (data_out)
    );

    // -----------------------
    //  Tạo clock 10ns (tần số 100 MHz)
    // -----------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // -----------------------
    //  Khối test chính
    // -----------------------
    initial begin
        // Khởi tạo
        rst      = 1;
        sel      = 0;
        rd       = 0;
        wr       = 0;
        ld_ir    = 0;
        data_e   = 0;
        address  = 0;
        data_in  = 0;

        // Giữ reset cao trong 20 ns
        #20;
        rst = 0;

        // ---------------------------------------------------------
        // Bắt đầu ghi/đọc thử
        // ---------------------------------------------------------

        // B1: Ghi 0xAA vào địa chỉ 0
        sel      = 1;
        wr       = 1;
        data_e   = 1;         // cho phép dữ liệu
        address  = 5'b00000;
        data_in  = 8'hAA;     // dữ liệu cần ghi
        #10;                  // chờ 1 chu kỳ clock

        // Kết thúc ghi
        wr     = 0;
        data_e = 0;
        #10;

        // B2: Ghi 0x55 vào địa chỉ 1
        wr      = 1;
        data_e  = 1;
        address = 5'b00001;
        data_in = 8'h55;
        #10;

        // Kết thúc ghi
        wr     = 0;
        data_e = 0;
        #10;

        // B3: Đọc dữ liệu từ địa chỉ 0
        rd      = 1;
        data_e  = 1;
        address = 5'b00000;
        #10;  
        $display("Time=%0t, Read address=0, data_out=%h", $time, data_out);

        // Kết thúc đọc
        rd     = 0;
        data_e = 0;
        #10;

        // B4: Đọc dữ liệu từ địa chỉ 1
        rd      = 1;
        data_e  = 1;
        address = 5'b00001;
        #10;  
        $display("Time=%0t, Read address=1, data_out=%h", $time, data_out);

        // Kết thúc đọc
        rd     = 0;
        data_e = 0;
        #10;

        // B5: Thử nạp IR (ld_ir=1) khi đọc
        rd      = 1;
        data_e  = 1;
        ld_ir   = 1;
        address = 5'b00000; // Lấy giá trị ở địa chỉ 0
        #10;
        $display("Time=%0t, (ld_ir=1) data_out=%h", $time, data_out);

        // Kết thúc đọc + ld_ir
        rd     = 0;
        data_e = 0;
        ld_ir  = 0;
        #10;

        // Đưa sel về 0 để "nghỉ"
        sel = 0;
        #20;

        // Dừng mô phỏng
        $stop;
    end

endmodule
