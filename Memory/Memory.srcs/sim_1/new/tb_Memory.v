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


module tb_Memory;
  // Định nghĩa tham số
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 5;

    // Định nghĩa tín hiệu cho module
    reg clk;
    reg rst;
    reg enable;
    reg read_write;              // 0: ghi, 1: đọc
    reg load_instruction_flag;
    reg [ADDR_WIDTH-1:0] address;

    // Testbench sẽ điều khiển cổng bidirectional khi ở chế độ ghi.
    // Khi không ghi, testbench đặt giá trị high-impedance.
    reg drive_data;              // Khi drive_data = 1, testbench sẽ điều khiển dữ liệu
    reg [DATA_WIDTH-1:0] tb_data;
    wire [DATA_WIDTH-1:0] data;
    
    // Tri-state driver từ testbench:
    assign data = (drive_data) ? tb_data : {DATA_WIDTH{1'bz}};
    
    // Xuất ra chỉ số lệnh (instr_address) từ module
    wire [ADDR_WIDTH-1:0] instr_address;
    
    // Instantiate module memory
    Memory #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) uut (
        .data(data),
        .instr_address(instr_address),
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .read_write(read_write),
        .load_instruction_flag(load_instruction_flag),
        .address(address)
    );
    
    // Sinh xung clock: chu kỳ 10ns (5ns HIGH, 5ns LOW)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Phần test: khởi tạo và điều khiển các tín hiệu
    initial begin
        // Khởi tạo các tín hiệu
        rst = 1;
        enable = 0;
        read_write = 0;         // Mặc định ở chế độ ghi
        load_instruction_flag = 0;
        address = 0;
        drive_data = 0;         // Ban đầu không drive dữ liệu
        tb_data = 0;
        
        // Giữ reset trong vài chu kỳ rồi giải phóng
        #20;
        rst = 0;
        enable = 1;
        
        // --- Thao tác ghi ---
        // Ghi giá trị 0x55 vào địa chỉ 5
        #10;
        read_write = 0;         // Chuyển sang chế độ ghi
        drive_data = 1;         // Testbench bắt đầu drive dữ liệu
        address = 5;
        tb_data = 8'h55;        // Ghi 0x55
        load_instruction_flag = 1; // Kiểm tra việc tăng instr_address nếu cần
        #10;                   // Đợi một chu kỳ clock
        
        // Dừng drive dữ liệu sau khi ghi
        drive_data = 0;
        load_instruction_flag = 0;
        
        // --- Thao tác đọc ---
        // Đọc tại địa chỉ 5, kết quả mong đợi là 0x55
        #10;
        read_write = 1;         // Chuyển sang chế độ đọc
        address = 5;
        // Testbench không drive dữ liệu khi đang đọc
        drive_data = 0;
        #10;
        
        // Đọc thêm một giá trị từ địa chỉ 0 (nội dung đã được khởi tạo trong reset)
        #10;
        address = 0;
        #10;
        
        // Kết thúc mô phỏng sau một khoảng thời gian
        #50;
        $finish;
    end

    // Giám sát tín hiệu: in ra các giá trị quan trọng theo thời gian
    initial begin
        $monitor("Time=%t | rst=%b | en=%b | rw=%b | addr=%h | data=%h | instr_addr=%h", 
                 $time, rst, enable, read_write, address, data, instr_address);
    end

endmodule