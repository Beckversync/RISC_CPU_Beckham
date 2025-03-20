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


module memory_5x8 (
    input             clk,       // Clock
    input             rst,       // Reset
    input             sel,       // Tín hiệu chọn 
    input             rd,        // 1 = cho phép đọc
    input             wr,        // 1 = cho phép ghi
    input             ld_ir,     // 1 = cho phép nạp IR 
    inout      [7:0]  data_e,    // Bus dữ liệu 2 chiều
    input      [4:0]  address,   // Địa chỉ 5 bit

    output reg [7:0]  data_out   // Dữ liệu đầu ra (có thể là lệnh hoặc dữ liệu)
);

    // Mảng nhớ 32 ô, mỗi ô 8 bit
    reg [7:0] mem_array [0:31];
    
    // Thanh ghi IR (nếu cần lưu lệnh)
    reg [7:0] IR;
    
    integer i;

    // Bus dữ liệu hai chiều: chỉ xuất dữ liệu ra khi sel=1 và rd=1
    assign data_e = (sel && rd && !wr) ? data_out : 8'hZZ;

    // Khối always đồng bộ theo clk (và reset bất đồng bộ nếu muốn)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Khởi tạo các thanh ghi và nội dung bộ nhớ
            data_out <= 8'd0;
            IR       <= 8'd0;
            for (i = 0; i < 32; i = i + 1) begin
                mem_array[i] <= 8'd0;
            end
        end else if (sel) begin
            // Đảm bảo không đọc và ghi cùng lúc
            if (wr && !rd) begin
                mem_array[address] <= data_e;
            end 
            else if (rd && !wr) begin
                data_out <= mem_array[address];
                
                // Nạp IR nếu ld_ir=1
                if (ld_ir) begin
                    IR <= mem_array[address];
                end
            end
            // sel=1 nhưng rd=0 và wr=0 => không làm gì
        end
        // sel=0 => không làm gì
    end

endmodule
