`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2025 01:42:03 PM
// Design Name: 
// Module Name: ADD_MUX
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


module ADD_MUX #(
   parameter WIDTH_ADDRESS_BIT = 5  // Độ rộng mặc định của địa chỉ là 5 bit, có thể thay đổi thông qua parameter
) (
    input  [WIDTH_ADDRESS_BIT-1:0] instr_address,   // Địa chỉ lệnh (Instruction Address)
    input  [WIDTH_ADDRESS_BIT-1:0] operand_address, // Địa chỉ toán hạng (Operand Address)
    input                         select,         // Tín hiệu chọn: 0 chọn instr_address, 1 chọn operand_address
    output [WIDTH_ADDRESS_BIT-1:0] address_out     // Đầu ra của địa chỉ sau khi chọn
);
    // Logic Mux: nếu select = 1 thì chọn operand_address, nếu không thì chọn instr_address
    assign address_out = (select) ? operand_address : instr_address;

endmodule
