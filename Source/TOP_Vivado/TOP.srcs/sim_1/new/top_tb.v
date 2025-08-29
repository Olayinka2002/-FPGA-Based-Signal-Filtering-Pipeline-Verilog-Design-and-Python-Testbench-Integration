`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/01/2025 03:39:20 PM
// Design Name: 
// Module Name: top_tb
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


module top_tb();
     // Testbench signals
    reg clk_tb = 0;
    reg rst_tb = 1;
    reg [9:0] addr_tb = 0;
    wire [15:0] filtered_output_tb;
    wire [15:0] raw_input_tb;

    // Instantiate Top Module
    top uut (
        .clk(clk_tb),
        .rst(rst_tb),
        .addr(addr_tb),
        .filtered_output(filtered_output_tb),
        .raw_input(raw_input_tb)
    );
    integer file_w;
    
    initial begin
        forever #5 clk_tb = ~clk_tb;
    end
    
    initial begin
        // Open the file for writing
        file_w = $fopen("F_captured_signal.txt", "w");

        // Apply reset for a few cycles
        #20 rst_tb = 0;
        
        @(posedge clk_tb);
        addr_tb <= addr_tb + 1;
        // Simulate enough cycles to read all samples (assume 1024)
        repeat (1023) begin
            @(posedge clk_tb);
            addr_tb <= addr_tb + 1;

            // Write the filtered output to file
            $fwrite(file_w, "%04x\n", filtered_output_tb);
        end
        // Clean up
        $fclose(file_w);
        $finish;
    end
endmodule
