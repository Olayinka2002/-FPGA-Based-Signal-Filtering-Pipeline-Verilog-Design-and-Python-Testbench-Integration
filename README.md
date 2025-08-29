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
``bash
git clone https://github.com/<your-username>/<your-repo>.git
cd <your-repo>

## Getting Started
 - ## A Clone Repo
     -  git clone https: //github.com/yourname/FPGA-Filter-Project.git
     -  cd FPGA-Filter-Project
    Produces: test_signal_t.mem

B) Run sample capture

 - In sample.v, load test_signal_t.mem as the memory initialization file.
 - Run simulation.
 - Output: sim/Captured_Signal_t.txt

C) Filter at the top level
 - In top.v, instantiate both sample.v and iir_filter.v.
 - Ensure top.v can read sim/Captured_Signal_t.txt.
 - Run simulation.
 - Output: Top/sim/F_captured_signal_t.txt
D) Post-process & visualize
 - Run the FFT analysis in Python:
 - Original signal
 - Filtered signal
 - Frequency spectrum plots
  <img width="511" height="288" alt="image" src="https://github.com/user-attachments/assets/a5b03349-d729-47cf-b409-0cfba2cce5db" />

