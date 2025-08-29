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

  - **[Results from the Filtering Process](Results)**
