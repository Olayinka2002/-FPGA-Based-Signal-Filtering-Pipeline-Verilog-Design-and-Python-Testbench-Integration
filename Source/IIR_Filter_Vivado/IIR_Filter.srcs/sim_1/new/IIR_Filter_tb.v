`timescale 1us / 1ns

module tb_simple_IIR_Filter;

    reg clk;
    reg rst;
    reg [15:0] d_in;
    wire [15:0] d_out;

    // Instantiate the IIR filter
    simple_IIR_Filter uut (
        .clk(clk),
        .rst(rst),
        .d_in(d_in),
        .d_out(d_out)
    );

    // Clock generation: 1 MHz clock (1 us period)
    always #0.5 clk = ~clk;

    integer i;

    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        d_in = 0;

        // Apply reset for a few cycles
        #5;
        rst = 0;
        
        #2;

        // Stimulus: Impulse input
        d_in = 16'sh4000;  // Q1.15 format for 0.5 impulse
        #1;

        // Feed zeros for the rest of the simulation
        for (i = 0; i < 50; i = i + 1) begin
            d_in = 0;
            #1;
        end

        $finish;
    end

endmodule
