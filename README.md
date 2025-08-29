# FPGA-Based Signal Filtering Pipeline (Verilog + Python Testbench)

Implementation of a digital **Butterworth bandpass** filter with Python tooling for data capture, analysis, and visualization, and a Verilog IIR (Direct Form II Transposed) hardware implementation.

---

## Filter Design Documentation

This project implements a bandpass Butterworth filter for human voice (300 Hz – 3.4 kHz).

- **[Filter Specifications (PDF)](docs/Filter_Specifications_Updated.pdf)**  
  Contains detailed filter requirements, floating-point & Q1.15 coefficients, and the Direct Form II structure used in the Verilog implementation.  

The document explains:
- A 2nd-order lowpass prototype becomes a **4th-order bandpass** (two cascaded biquads).
- Coefficients generated via SciPy: `butter(..., output='sos')`.
- Each SOS row corresponds to one biquad in **Direct Form II Transposed**.
- The Verilog design implements the filter by cascading two biquad blocks.

---

## Project Workflow

**Python (signal generation) → Verilog (sample + filter) → Python (FFT & plots)**

1. Generate test signal & memory file in Python (`test_signal_t.mem`).
2. Simulate `sample.v` to capture the signal (`Captured_Signal_t.txt`).
3. Cascade `sample.v` → `iir_filter.v` in `top.v` to produce filtered output (`F_captured_signal_t.txt`).
4. Use Python FFT to visualize original, filtered, and spectrum results.

---

## Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/<your-username>/<your-repo>.git
cd <your-repo>

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

  <img width="511" height="288" alt="image" src="https://github.com/user-attachments/assets/a5b03349-d729-47cf-b409-0cfba2cce5db" />

