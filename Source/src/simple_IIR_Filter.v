`timescale 1us / 1ns

module simple_IIR_Filter(
    input clk,
    input rst,
    input [15:0] d_in,
    output [15:0] d_out
    );

    // Coefficients (Q1.15 format)
    reg signed [15:0] b0_1 = 19766;  // b0
    reg signed [15:0] b1_1 = 32767;  // b1
    reg signed [15:0] b2_1 = 19766;  // b2
    reg signed [15:0] a0_1 = 32767;  // a0 (Q1.15 of 1.0)
    reg signed [15:0] a1_1 = -44091; // -a1
    reg signed [15:0] a2_1 = -16921; // -a2

    // Input/output
    reg signed [15:0] r_in;
    reg signed [31:0] r_out;
    wire signed [31:0] scaled_output;

    // Delay registers
    reg signed [15:0] v_z1 = 0;     // v[n-1]
    reg signed [15:0] v_z2 = 0;     // v[n-2]
    reg signed [15:0] y_z1 = 0;     // y[n-1]
    reg signed [15:0] y_z2 = 0;     // y[n-2]

  reg signed [31:0] product_a1;
  reg signed [31:0] product_a2;
  reg signed [31:0] product_b0;
  reg signed [31:0] product_b1;
  reg signed [31:0] product_b2;
  reg signed [31:0] sum_1; // v[n]
  reg signed [31:0] sum_2; // y[n]
    always @(posedge clk) begin
        if (rst) begin
            r_in <= 0;
            r_out <= 0;
            v_z1 <= 0;
            v_z2 <= 0;
            y_z1 <= 0;
            y_z2 <= 0;
            sum_1 <= 0;
            sum_2 <= 0;
            product_a1 <= 0; product_a2 <= 0;
            product_b0 <= 0; product_b1 <= 0; product_b2 <= 0;
        end else begin
            r_in <= d_in;

            // Feedback: v[n] = x[n] - a1*y[n-1] - a2*y[n-2]
            product_a1 <= (a1_1 * y_z1);
            product_a2 <= (a2_1 * y_z2);
            sum_1 <= (r_in<<<15) - product_a1 - product_a2;

            // Feedforward: y[n] = b0*v[n] + b1*v[n-1] + b2*v[n-2]
            product_b0 <= (b0_1 * sum_1) >>> 15;
            product_b1 <= (b1_1 * v_z1) >>> 15;
            product_b2 <= (b2_1 * v_z2) >>> 15;
            sum_2 <= product_b0 + product_b1 + product_b2;

            r_out <= sum_2;

            // Update delay lines
            v_z2 <= v_z1;
            v_z1 <= sum_1;
            y_z2 <= y_z1;
            y_z1 <= sum_2;
        end
    end

    //assign scaled_output = r_out <<< 1;  // optional gain compensation
    //assign d_out = scaled_output[30:15]; // truncate to Q1.15
    assign d_out = r_out[15:0];
endmodule
/*
`timescale 1us / 1ns

module simple_IIR_Filter(
    input clk,
    input rst,
    input [15:0] d_in,
    output [15:0] d_out
    );

    // Coefficients (Q1.15 format)
    reg signed [15:0] b0_1 = 19766; // b0
    reg signed [15:0] b1_1 = 32767; // b1
    reg signed [15:0] b2_1 = 19766; // b2
    reg signed [15:0] a0_1 = 32767; // a0 (normally 1.0 in Q1.15)
    reg signed [15:0] a1_1 = -44091; // a1
    reg signed [15:0] a2_1 = -16921; // a2

    // Input and output
    reg signed [15:0] r_in;
    reg signed [15:0] r_out;
    wire signed [31:0] scaled_output;

    // Delay registers (stage 1)
    reg signed [15:0] r_in_z1 = 0;
    reg signed [15:0] r_in_z2 = 0;

    // Multiplier results (stage 1)
    reg signed [15:0] product_a1;
    reg signed [15:0] product_a2;
    reg signed [15:0] product_b0;
    reg signed [15:0] product_b1;
    reg signed [15:0] product_b2;

    // Sums (stage 1)
    reg signed [15:0] sum_1; // v(n)
    reg signed [15:0] sum_2; // y(n)

    always @(posedge clk) begin
        if (rst) begin
            r_out <= 0;
            r_in <= 0;
            r_in_z1 <= 0;
            r_in_z2 <= 0;
            product_a1 <= 0; product_a2 <= 0;
            product_b0 <= 0; product_b1 <= 0; product_b2 <= 0;
            sum_1 <= 0; sum_2 <= 0;
        end else begin
            r_in <= d_in;

            // Feedback: v(n) = x(n) - a1*y(n-1) - a2*y(n-2)
            product_a1 <= (a1_1 * r_in_z1) >>> 15;
            product_a2 <= (a2_1 * r_in_z2) >>> 15;
            sum_1 <= r_in - product_a1 - product_a2;

            // Feedforward: y(n) = b0*v(n) + b1*v(n-1) + b2*v(n-2)
            product_b0 <= (b0_1 * sum_1) >>> 15;
            product_b1 <= (b1_1 * r_in_z1) >>> 15;
            product_b2 <= (b2_1 * r_in_z2) >>> 15;
            sum_2 <= product_b0 + product_b1 + product_b2;

            r_out <= sum_2;

            // Update delays
            r_in_z2 <= r_in_z1;
            r_in_z1 <= sum_1;
        end
    end

    assign scaled_output = r_out <<< 1; // Multiply output by 2
    assign d_out = scaled_output[30:15]; // Truncate to Q1.15 output
endmodule

*/