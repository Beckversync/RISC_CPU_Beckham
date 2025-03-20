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
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 5,
    parameter MEM_DEPTH  = (1 << ADDR_WIDTH)
)(
    input                       clk,       // Clock
    input                       rst,       // Reset
    input                       sel,       // Chọn bộ nhớ
    input                       rd,        // 1 = cho phép đọc
    input                       wr,        // 1 = cho phép ghi
    input                       ld_ir,     // 1 = cho phép nạp vào IR
    input                       data_e,    // Tín hiệu cho phép dữ liệu
    input      [ADDR_WIDTH-1:0] address,   // Địa chỉ bộ nhớ
    input      [DATA_WIDTH-1:0] data_in,   // Dữ liệu đầu vào (khi ghi)
    output reg [DATA_WIDTH-1:0] data_out   // Ngõ ra (khi đọc, hoặc nạp IR)
);

    // Mảng bộ nhớ 32 ô (5 bit địa chỉ)
    reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];

    // Thanh ghi tạm cho việc đọc
    reg [DATA_WIDTH-1:0] read_data_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset thanh ghi
            data_out      <= {DATA_WIDTH{1'b0}};
            read_data_reg <= {DATA_WIDTH{1'b0}};
        end 
        else if (sel) begin
            // Thao tác ghi (write) - chỉ thực hiện khi wr=1, rd=0, data_e=1
            if (wr && !rd && data_e) begin
                mem[address] <= data_in;
            end
            // Thao tác đọc (read) - chỉ thực hiện khi rd=1, wr=0, data_e=1
            else if (rd && !wr && data_e) begin
                read_data_reg <= mem[address];
                // Nếu cần nạp IR thì cập nhật data_out
                if (ld_ir) begin
                    data_out <= mem[address];
                end
            end
        end
    end
    
    // assign data_out = (rd && sel && data_e) ? mem[address] : {DATA_WIDTH{1'b0}};

endmodule
