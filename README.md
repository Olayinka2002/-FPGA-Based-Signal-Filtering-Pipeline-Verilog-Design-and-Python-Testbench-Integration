# -FPGA-Based-Signal-Filtering-Pipeline-Verilog-Design-and-Python-Testbench-Integration
Implementation of digital filters with Python – includes data capture, analysis, and visualization.


## Filter Design Documentation

This project implements a bandpass Butterworth filter for audio signals in the human voice range (300 Hz – 3.4 kHz).  

- **[Filter Specifications (PDF)](Filter_Specifications_Updated.pdf)**  
  Contains detailed filter requirements, Butterworth coefficients (floating-point and Q1.15 fixed-point), and the Direct Form II structure diagram used for the Verilog implementation.  

The PDF explains how:
- The bandpass filter was derived from a lowpass prototype, resulting in a 4th-order design (two biquads in cascade).  
- Coefficients were generated in Python using SciPy’s `butter(..., output='sos')`.  
- Each SOS row corresponds to one biquad stage, implemented in hardware using the Direct Form II transposed structure.
- The algorithm was implemented in verilog by cascading the difference equation derived from the direct from II form **[Filter_Design](Source/src/simple_IIR_Filter.v)**

- The initial signal generated in python along with the filtered signal after **[Results from the Filtering Process](Results)**

## Getting Started
 - ## Clone Repo
     -  git clone https: //github.com/yourname/FPGA-Filter-Project.git
     -  cd FPGA-Filter-Project
     -  Requirement:
         - Python 3.i version
         -  Libraries: numpy, scipy, matplotlib
         -  Verilog simulator (Modelsim, Vivado, Synopsys vcs)
      -Steps:
         - Run the Signal_Source.py file
         - retrieve the generated test_signal_t.mem hex file generated from converting the signal into hex file
         - open the sample.v file, add the test_signal_t.mem file as a memory initialization file
         - Run the sample.v file
         - Retrieved the sampled hex file called Captured_Signal_t.txt from the sim folder
         - Ensure that the top.v can access this file
         - Inside the top.c file, the filtering algorithm iir_filter.v along with the sample.v are instantiated.
         - The output of the sample.v are fed into iir_filter.v and then a final filtered hex file is generated.
         - This file is called F_caputured_signal_t.txt. The file can be found inside the sim folder of the Top folder.
         - This final file is then passed into python fft function to generate the output waveform for the filtered, original and frequency spectrum signals.
           
