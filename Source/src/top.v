`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/01/2025 03:37:21 PM
// Design Name: 
// Module Name: top
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


module top(
    input clk,
    input rst,
    input [9:0] addr,
    output [15:0] filtered_output,
    output [15:0] raw_input
    );
    wire [15:0] sample_data;
    Sample sample1(
        .clk(clk),
        .reset(rst),
        .addr(addr),
        .data(sample_data)
     );
     
     simple_IIR_Filter iir(
        .clk(clk),
        .rst(rst),
        .d_in(sample_data),
        .d_out(filtered_output)
     );
     assign raw_input = sample_data;
endmodule
