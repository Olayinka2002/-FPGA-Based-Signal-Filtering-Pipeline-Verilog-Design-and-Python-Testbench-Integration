`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/24/2025 05:37:30 PM
// Design Name:
// Module Name: Sample_tb
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


module Sample_tb(

    );
    reg clk_tb;
    reg reset_tb;
    reg [9:0] addr_tb;
    wire [15:0] data_tb;
    integer file;//File Handler

    Sample UUT(.clk(clk_tb), .reset(reset_tb), .addr(addr_tb), .data(data_tb));

    initial begin//8kHz --> 62.5us
        clk_tb = 0;
        forever #62.5 clk_tb = ~clk_tb;
    end

    initial begin
        //file = $fopen("Captured_Signal.txt", "w");
        file = $fopen("Captured_Signal_t.txt", "w");

        if (file == 0) begin
            $display("ERROR: Could not open Captured_Signal.txt for writing!");
            $finish;
        end else begin
            $display("S File opened successfully.");
        end

        reset_tb = 1; addr_tb = 0;

        #20;
        reset_tb = 0;

        repeat (1024) begin
           @(posedge clk_tb); // Wait for the positive clock edge
           $fwrite(file, "%04x\n", data_tb);//Write each sample in hex.
           $display("%04x", data_tb); // NEW line for debugging
           $fflush(file); 
           #10; // Small delay after writing (optional, but can help in some cases)
           addr_tb = addr_tb + 1;
    
              
        end
        

        #500;
        $fclose(file);//close the file
        $finish;
    end

endmodule
