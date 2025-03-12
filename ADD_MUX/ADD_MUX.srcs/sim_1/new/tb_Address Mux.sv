`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2025 01:43:14 PM
// Design Name: 
// Module Name: tb_ADD_MUX
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


module tb_ADD_MUX;
   // Parameter khởi tạo độ rộng của địa chỉ (có thể thay đổi nếu cần)
    parameter WIDTH_ADDRESS_BIT = 5;

    // Khai báo các tín hiệu testbench
    reg [WIDTH_ADDRESS_BIT-1:0] instr_address;
    reg [WIDTH_ADDRESS_BIT-1:0] operand_address;
    reg                         select;
    wire [WIDTH_ADDRESS_BIT-1:0] address_out;

    // Instantiate module address_mux
    ADD_MUX #(
        .WIDTH_ADDRESS_BIT(WIDTH_ADDRESS_BIT)
    ) uut (
        .instr_address(instr_address),
        .operand_address(operand_address),
        .select(select),
        .address_out(address_out)
    );

    // Khối khởi tạo các trường hợp kiểm tra
    initial begin
        $display("Bắt đầu testbench cho address_mux");
        $monitor("Time = %0t | select = %b | instr_address = %b | operand_address = %b | address_out = %b", 
                 $time, select, instr_address, operand_address, address_out);

        // Test vector 1: select = 0, nên chọn instr_address
        instr_address  = 5'b10101; // Giá trị mẫu cho địa chỉ lệnh
        operand_address = 5'b01010; // Giá trị mẫu cho địa chỉ toán hạng
        select = 0;
        #10; // chờ 10 ns

        // Test vector 2: select = 1, nên chọn operand_address
        select = 1;
        #10;

        // Test vector 3: thay đổi giá trị của các địa chỉ, select = 0
        instr_address  = 5'b11100;
        operand_address = 5'b00011;
        select = 0;
        #10;

        // Test vector 4: select = 1
        select = 1;
        #10;

        $display("Kết thúc testbench.");
        $finish;
    end

endmodule
