`timescale 1ns/1ps
module tb;

reg clk, rst;
reg signed [7:0] in_real, in_imag;
reg in_valid;
wire signed [10:0] out_real, out_imag;
wire out_valid;

fft_top uut (
    .clk(clk), .rst(rst),
    .in_real(in_real), .in_imag(in_imag),
    .in_valid(in_valid),
    .out_real(out_real), .out_imag(out_imag),
    .out_valid(out_valid)
);

always #5 clk = ~clk;

integer i, count;
integer file, r;
integer f_real, f_imag;
real    data_float;
real    scaled;
integer data_fixed;

localparam real SCALE = 32.0;  // Q3.5

initial begin
    clk      = 0;
    rst      = 1;
    in_valid = 0;
    count    = 0;

    file   = $fopen("input.txt",  "r");
    f_real = $fopen("fft_real_verilog.txt", "w");
    f_imag = $fopen("fft_imag_verilog.txt", "w");

    #20 rst = 0;

    for(i = 0; i < 8; i = i + 1) begin
        r = $fscanf(file, "%f\n", data_float);

        // Multiply, truncate toward zero using $rtoi
        scaled     = data_float * SCALE;
        data_fixed = $rtoi(scaled);   // $rtoi truncates toward zero — matches fix()

        @(posedge clk);
        in_real  <= data_fixed;  // assign integer directly to signed [7:0] — no bit slice
        in_imag  <= 8'sd0;
        in_valid <= 1;
    end

    @(posedge clk);
    in_valid <= 0;
    $fclose(file);
end

real out_real_float, out_imag_float;

always @(posedge clk) begin
    if(out_valid) begin
        out_real_float = $itor(out_real) / SCALE;
        out_imag_float = $itor(out_imag) / SCALE;

        $display("Y[%0d] = %.4f + j%.4f", count, out_real_float, out_imag_float);
        $fwrite(f_real, "%.4f\n", out_real_float);
        $fwrite(f_imag, "%.4f\n", out_imag_float);

        count = count + 1;
        if(count == 8) begin
            $fclose(f_real);
            $fclose(f_imag);
            #20 $finish;
        end
    end
end

endmodule
