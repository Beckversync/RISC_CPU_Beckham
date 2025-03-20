`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2025 03:01:15 PM
// Design Name: 
// Module Name: Memory
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


module Memory #(
 parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 5
)(
    inout [DATA_WIDTH-1:0] data,             // Cổng dữ liệu hai chiều
    output reg [ADDR_WIDTH-1:0] instr_address, // Địa chỉ của instruction (có thể dùng để load lệnh)
    input clk,                               // Xung đồng bộ
    input rst,                               // Tín hiệu reset (asynchronous)
    input enable,                            // Tín hiệu kích hoạt module
    input read_write,                        // Tín hiệu chọn chế độ: 0 - ghi, 1 - đọc
    input load_instruction_flag,             // Cờ cho biết có cần tăng instr_address sau ghi không
    input [ADDR_WIDTH-1:0] address           // Địa chỉ của bộ nhớ cần đọc/ghi
);

    // Khai báo bộ nhớ với 2^ADDR_WIDTH vị trí
    reg [DATA_WIDTH-1:0] mem [0:(2**ADDR_WIDTH)-1];

    // Thanh ghi nội bộ để đẩy dữ liệu ra ngoài khi đọc
    reg [DATA_WIDTH-1:0] data_out_reg;

    // Cổng dữ liệu được điều khiển theo chế độ:
    // - Khi đang ở chế độ đọc (read_write = 1) và enable = 1, dữ liệu được đẩy ra.
    // - Ngược lại, cổng dữ liệu ở trạng thái high impedance.
    assign data = (read_write && enable) ? data_out_reg : {DATA_WIDTH{1'bz}};

    // Luồng đồng bộ theo xung clk và reset bất đồng bộ
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Khởi tạo các thanh ghi và bộ nhớ
            data_out_reg   <= 0;
            instr_address  <= 0;
            // Khởi tạo nội dung bộ nhớ (các giá trị dưới đây có thể chỉnh sửa theo yêu cầu)
            mem[0]  <= 8'b11111110; // 00: BEGIN - JMP TST_JMP
            mem[1]  <= 8'b00000000; // 01: HLT 
            mem[2]  <= 8'b00000000; // 02: HLT 
            mem[3]  <= 8'b10111010; // 03: JMP_OK - LDA DATA_1
            mem[4]  <= 8'b00100000; // 04: SKZ
            mem[5]  <= 8'b00000000; // 05: HLT 
            mem[6]  <= 8'b10111011; // 06: LDA DATA_2
            mem[7]  <= 8'b00100000; // 07: SKZ
            mem[8]  <= 8'b11101010; // 08: JMP SKZ_OK
            mem[9]  <= 8'b00000000; // 09: HLT 
            mem[10] <= 8'b11011100; // 0A: SKZ_OK - STO TEMP
            mem[11] <= 8'b10111010; // 0B: LDA DATA_1
            mem[12] <= 8'b11011100; // 0C: STO TEMP
            mem[13] <= 8'b10111100; // 0D: LDA TEMP
            mem[14] <= 8'b00100000; // 0E: SKZ
            mem[15] <= 8'b00000000; // 0F: HLT 
            mem[16] <= 8'b10011011; // 10: XOR DATA_2
            mem[17] <= 8'b00100000; // 11: SKZ
            mem[18] <= 8'b11110100; // 12: JMP XOR_OK
            mem[19] <= 8'b00000000; // 13: HLT  
            mem[20] <= 8'b10011011; // 14: XOR_OK - XOR DATA_2
            mem[21] <= 8'b00100000; // 15: SKZ
            mem[22] <= 8'b00000000; // 16: HLT
            mem[23] <= 8'b00000000; // 17: END - HLT 
            mem[24] <= 8'b11100000; // 18: JMP BEGIN

            mem[26] <= 8'b00000000; // 1A: DATA_1 (giá trị: 0x00)
            mem[27] <= 8'b11111111; // 1B: DATA_2 (giá trị: 0xFF)
            mem[28] <= 8'b10101010; // 1C: TEMP (khởi tạo: 0xAA)
             
            mem[30] <= 8'b11100011; // 1E: TST_JMP - JMP JMP_OK
            mem[31] <= 8'b00000000; // 1F: HLT  
        end 
        else if (enable) begin
            if (!read_write) begin
                // Ghi: Lấy dữ liệu từ cổng data và ghi vào bộ nhớ tại địa chỉ 'address'
                mem[address] <= data;
                // Cập nhật thanh ghi đẩy dữ liệu ra (có thể để phản ánh dữ liệu vừa ghi)
                data_out_reg <= data;
                // Nếu có cờ load_instruction_flag, tăng chỉ số lệnh
                if (load_instruction_flag)
                    instr_address <= instr_address + 1;
            end 
            else begin
                // Đọc: Lấy dữ liệu từ bộ nhớ tại địa chỉ 'address' và lưu vào thanh ghi đẩy ra
                data_out_reg <= mem[address];
            end
        end
    end
endmodule
