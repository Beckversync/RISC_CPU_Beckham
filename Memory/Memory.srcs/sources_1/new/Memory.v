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


module memory_5x8 #(
    parameter DATA_WIDTH = 8,                  // Độ rộng dữ liệu
    parameter ADDR_WIDTH = 5,                  // Độ rộng địa chỉ (cho 2^5 = 32 ô)
    parameter MEM_DEPTH  = (1 << ADDR_WIDTH)    // Số lượng ô bộ nhớ (32)
)(
    input                        clk,         // Clock
    input                        rst,         // Reset (đồng bộ)
    input                        sel,         // Tín hiệu chọn bộ nhớ
    input                        rd,          // 1 = cho phép đọc
    input                        wr,          // 1 = cho phép ghi
    input                        ld_ir,       // 1 = cho phép nạp vào IR (data_out)
    inout       [DATA_WIDTH-1:0] data_e,      // Bus dữ liệu 2 chiều
    input       [ADDR_WIDTH-1:0] address,     // Địa chỉ
    output reg  [DATA_WIDTH-1:0] data_out     // Dữ liệu đầu ra (có thể là lệnh hoặc dữ liệu)
);

    // Mảng bộ nhớ với số lượng ô là MEM_DEPTH
    reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];
    // Thanh ghi tạm lưu dữ liệu đọc ra
    reg [DATA_WIDTH-1:0] read_data_reg;

    // Khối đồng bộ xử lý đọc/ghi và cập nhật data_out nếu cần nạp IR
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            read_data_reg <= {DATA_WIDTH{1'b0}};
            data_out      <= {DATA_WIDTH{1'b0}};
        end 
        else if (sel) begin
            if (wr && !rd) begin
                // Ghi dữ liệu  vào bộ nhớ
                mem[address] <= data_e;
            end 
            else if (rd && !wr) begin
                // Đọc dữ liệu từ bộ nhớ
                read_data_reg <= mem[address];
                // Cập nhật data_out nếu có yêu cầu nạp IR
                if (ld_ir)
                    data_out <= mem[address];
            end
            // Nếu cả rd và wr đều 0 hoặc 1 thì không có hành động
        end
    end

    // Điều khiển bus 2 chiều: chỉ cho phép dữ liệu ra khi đang thực hiện đọc
    assign data_e = (sel && rd && !wr) ? read_data_reg : {DATA_WIDTH{1'bz}};

endmodule
