module fir_optimized #(
    parameter N     = 100,         // total taps (must be even)
    parameter HALF  = 50,          // N/2
    parameter WIDTH = 16,          // input / coefficient bit width  (Q2.14)
    parameter OUTW  = 40           // accumulator width
)(
    input  wire                      clk,
    input  wire                      rst,
    input  wire signed [WIDTH-1:0]   x_in,
    output reg  signed [OUTW-1:0]    y_out
);

    // ---- Coefficient memory (only HALF coefficients needed) ----
    wire signed [WIDTH-1:0] h [0:HALF-1];
    assign h[0]  = -16'sd3;    assign h[1]  = -16'sd7;
    assign h[2]  = -16'sd9;    assign h[3]  = -16'sd8;
    assign h[4]  = -16'sd3;    assign h[5]  =  16'sd4;
    assign h[6]  =  16'sd11;   assign h[7]  =  16'sd15;
    assign h[8]  =  16'sd14;   assign h[9]  =  16'sd6;
    assign h[10] = -16'sd7;    assign h[11] = -16'sd21;
    assign h[12] = -16'sd29;   assign h[13] = -16'sd26;
    assign h[14] = -16'sd11;   assign h[15] =  16'sd13;
    assign h[16] =  16'sd38;   assign h[17] =  16'sd52;
    assign h[18] =  16'sd47;   assign h[19] =  16'sd20;
    assign h[20] = -16'sd22;   assign h[21] = -16'sd64;
    assign h[22] = -16'sd87;   assign h[23] = -16'sd78;
    assign h[24] = -16'sd33;   assign h[25] =  16'sd36;
    assign h[26] =  16'sd104;  assign h[27] =  16'sd141;
    assign h[28] =  16'sd125;  assign h[29] =  16'sd52;
    assign h[30] = -16'sd57;   assign h[31] = -16'sd164;
    assign h[32] = -16'sd222;  assign h[33] = -16'sd197;
    assign h[34] = -16'sd83;   assign h[35] =  16'sd91;
    assign h[36] =  16'sd263;  assign h[37] =  16'sd360;
    assign h[38] =  16'sd324;  assign h[39] =  16'sd139;
    assign h[40] = -16'sd156;  assign h[41] = -16'sd465;
    assign h[42] = -16'sd661;  assign h[43] = -16'sd625;
    assign h[44] = -16'sd285;  assign h[45] =  16'sd352;
    assign h[46] =  16'sd1194; assign h[47] =  16'sd2077;
    assign h[48] =  16'sd2811; assign h[49] =  16'sd3227;

    // ---- Delay line (shift register) ----
    reg signed [WIDTH-1:0] shift_reg [0:N-1];

    // ---- Internal computation signals ----
    reg signed [WIDTH:0]     sym_sum;    // 17-bit: sum of two Q(2,14) values
    reg signed [2*WIDTH:0]   prod;       // 33-bit: 17-bit * 16-bit
    reg signed [OUTW-1:0]    acc;
    integer k;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y_out <= {OUTW{1'b0}};
            for (k = 0; k < N; k = k+1)
                shift_reg[k] <= {WIDTH{1'b0}};
        end else begin
            // --- Step 1: Shift register update ---
            for (k = N-1; k > 0; k = k-1)
                shift_reg[k] <= shift_reg[k-1];
            shift_reg[0] <= x_in;

            // --- Step 2: Symmetric MAC ---
            acc = {OUTW{1'b0}};
            for (k = 0; k < HALF; k = k+1) begin
                sym_sum = shift_reg[k] + shift_reg[N-1-k];
                prod    = sym_sum * h[k];
                acc     = acc + prod;
            end
            y_out <= acc;
        end
    end

endmodule
