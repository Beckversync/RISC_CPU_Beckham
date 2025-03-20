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
    // Tín hiệu testbench
    reg         clk;
    reg         rst;
    reg         sel;
    reg         rd;
    reg         wr;
    reg         ld_ir;
    reg  [4:0]  address;

    // Mô phỏng bus 2 chiều: sử dụng data_reg và cờ drive_data để điều khiển
    reg  [7:0]  data_reg;    // Giá trị sẽ được ghi ra bus
    reg         drive_data;  // Cờ cho biết testbench có đang drive bus hay không

    // Tín hiệu kết nối với module
    wire [7:0]  data_e;      // Bus 2 chiều
    wire [7:0]  data_out;    // Đầu ra từ bộ nhớ (có thể là lệnh hoặc dữ liệu)

    // Kết nối tới module memory_5x8 
    memory_5x8 uut (
        .clk      (clk),
        .rst      (rst),
        .sel      (sel),
        .rd       (rd),
        .wr       (wr),
        .ld_ir    (ld_ir),
        .data_e   (data_e),
        .address  (address),
        .data_out (data_out)
    );

    // Cơ chế ba trạng thái cho bus data_e
    // Khi drive_data = 1 => bus được drive bởi data_reg, ngược lại thì bus ở trạng thái Z
    assign data_e = drive_data ? data_reg : 8'bz;

    // Tạo xung clock với chu kỳ 10ns (tần số 100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Kịch bản test cho module
    initial begin
        // Khởi tạo các tín hiệu
        rst        = 1;
        sel        = 0;
        rd         = 0;
        wr         = 0;
        ld_ir      = 0;
        drive_data = 0;
        data_reg   = 8'd0;
        address    = 5'd0;

        // Bước 1: Reset module
        #10;
        rst = 0;   // Kết thúc reset

        // Bước 2: Ghi dữ liệu vào bộ nhớ tại địa chỉ 0
        sel        = 1;       // Chọn module memory
        wr         = 1;       // Cho phép ghi
        rd         = 0;       // Không đọc
        address    = 5'd0;    // Địa chỉ 0
        data_reg   = 8'hAA;   // Dữ liệu cần ghi (0xAA)
        drive_data = 1;       // Drive bus với data_reg
        #10;                  // Đợi 1 chu kỳ clock
        #10;                  // Thêm chu kỳ để hoàn tất ghi

        // Dừng ghi: Ngừng drive bus và tắt tín hiệu ghi
        wr         = 0;
        drive_data = 0;
        #10;

        // Bước 3: Đọc dữ liệu từ địa chỉ 0
        rd         = 1;       // Cho phép đọc
        // Sau cạnh clock tới, module sẽ lấy dữ liệu từ mem[address]
        #10;
        #10;
        $display("Read from address 0: data_e = 0x%h, data_out = 0x%h", data_e, data_out);

        // Bước 4: Kích hoạt ld_ir để nạp giá trị từ bộ nhớ vào data_out
        ld_ir = 1;
        #10;
        ld_ir = 0;
        #10;
        $display("After ld_ir, data_out = 0x%h", data_out);

        // Bước 5: Thử ghi dữ liệu vào địa chỉ 1
        rd         = 0;
        wr         = 1;
        address    = 5'd1;
        data_reg   = 8'h55;   // Dữ liệu mới (0x55)
        drive_data = 1;
        #10;
        #10;

        // Đọc lại dữ liệu tại địa chỉ 1
        wr         = 0;
        drive_data = 0;
        rd         = 1;
        address    = 5'd1;
        #10;
        #10;
        $display("Read from address 1: data_e = 0x%h, data_out = 0x%h", data_e, data_out);

        // Kết thúc mô phỏng
        #10;
        $stop;
    end

endmodule