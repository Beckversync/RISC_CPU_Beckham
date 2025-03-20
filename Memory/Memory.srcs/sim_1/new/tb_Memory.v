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


module memory_5x8_tb;

    // Thông số mô phỏng
    localparam CLK_PERIOD = 10;  // Clock 100 MHz (10 ns mỗi chu kỳ)

    // Tín hiệu điều khiển
    reg             clk;
    reg             rst;
    reg             sel;
    reg             rd;
    reg             wr;
    reg             ld_ir;

    // Bus dữ liệu 2 chiều
    wire [7:0]      data_e;
    reg  [7:0]      data_out_driver; // Thanh ghi để lái bus khi ghi

    // Địa chỉ
    reg  [4:0]      address;

    // Đầu ra từ module memory
    wire [7:0]      data_out;
    wire [7:0]      inB;

    // ==========================================
    // ========== Mô phỏng bus 2 chiều ==========
    // ==========================================
    // Khi ghi (wr=1), ta cần lái data_e từ bên ngoài
    // Khi đọc (rd=1), ta để data_e ở trạng thái Z để module memory_5x8 có thể xuất data_out
    // -> Dùng một tri-state driver mô phỏng bên ngoài
    assign data_e = (wr && sel) ? data_out_driver : 8'hZZ;

    // ==========================================
    // ========== DUT: memory_5x8 ===============
    // ==========================================
    memory_5x8 dut (
        .clk      (clk),
        .rst      (rst),
        .sel      (sel),
        .rd       (rd),
        .wr       (wr),
        .ld_ir    (ld_ir),
        .data_e   (data_e),
        .address  (address),
        .data_out (data_out),
        .inB      (inB)
    );

    // ==========================================
    // ========== Tạo xung clock ================
    // ==========================================
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // ==========================================
    // ========== Quá trình mô phỏng chính ======
    // ==========================================
    initial begin
        // Bật waveform (nếu dùng ModelSim/Questa, VCS, v.v.)
        // $dumpfile("memory_5x8_tb.vcd");
        // $dumpvars(0, memory_5x8_tb);

        // Khởi tạo
        rst             = 1;
        sel             = 0;
        rd              = 0;
        wr              = 0;
        ld_ir           = 0;
        data_out_driver = 8'd0;
        address         = 5'd0;

        // Đợi vài chu kỳ clock để reset
        #(CLK_PERIOD*5);
        rst = 0;   // Thả reset
        #(CLK_PERIOD*2);

        // ======================================
        // Bật sel, chuẩn bị ghi vào ô nhớ 0
        // ======================================
        sel     = 1;   
        wr      = 1;   // Ghi
        rd      = 0;
        address = 5'd0;
        data_out_driver = 8'hAA; // Dữ liệu muốn ghi
        #(CLK_PERIOD);  // Chờ 1 chu kỳ clock để thực hiện ghi

        // Ghi vào ô nhớ 1
        address = 5'd1;
        data_out_driver = 8'h55;
        #(CLK_PERIOD);

        // Dừng ghi
        wr = 0;
        #(CLK_PERIOD);

        // ======================================
        // Đọc từ ô nhớ 0
        // ======================================
        rd      = 1;    // Kích hoạt đọc
        address = 5'd0;
        #(CLK_PERIOD);
        // Kiểm tra giá trị data_out, inB (kỳ vọng 0xAA)
        $display("Read mem[0]: data_out=%h, inB=%h (expect AA)", data_out, inB);

        // Đọc từ ô nhớ 1
        address = 5'd1;
        #(CLK_PERIOD);
        // Kiểm tra giá trị data_out, inB (kỳ vọng 0x55)
        $display("Read mem[1]: data_out=%h, inB=%h (expect 55)", data_out, inB);

        // Tắt rd
        rd = 0;
        #(CLK_PERIOD);

        // ======================================
        // Thử ghi ô nhớ 2 và nạp IR cùng lúc
        // ======================================
        wr      = 1;
        ld_ir   = 1;   // Cho phép nạp IR
        address = 5'd2;
        data_out_driver = 8'hF0;
        #(CLK_PERIOD);
        wr    = 0;
        ld_ir = 0;

        // Đọc ô nhớ 2
        rd      = 1;
        address = 5'd2;
        #(CLK_PERIOD);
        $display("Read mem[2]: data_out=%h, inB=%h (expect F0)", data_out, inB);

        // Tắt rd
        rd = 0;
        #(CLK_PERIOD);

        // ======================================
        // Tắt sel, kiểm tra bus data_e ở trạng thái Z
        // ======================================
        sel = 0;
        #(CLK_PERIOD);

        // Kết thúc mô phỏng
        $finish;
    end

endmodule