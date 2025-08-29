`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2025 12:24:10 PM
// Design Name: 
// Module Name: hann_coeff
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

module Sample (
    input clk,
    input reset,                 
    input [9:0] addr,            
    output [15:0] data
);
    reg [15:0] rom [0:1023];//memory  
    reg [15:0] data_out;

    initial begin
        $readmemh("test_signal_t.mem", rom);
        //$readmemh("test_signal_t.mem", rom);
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            data_out <= 16'h0000;
        else
            data_out <= rom[addr];
    end

    assign data = data_out;
endmodule
