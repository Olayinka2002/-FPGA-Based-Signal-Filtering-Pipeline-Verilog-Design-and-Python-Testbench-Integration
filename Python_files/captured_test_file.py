import numpy as np
import os
import matplotlib.pyplot as plt
from scipy.fft import fft, fftfreq

def main ():
    # Generate a test signal (example)
    fs = 8000
    duration = 0.128#we want 1024 samples
    t = np.linspace(0, duration, int(fs * duration), endpoint=False)
    components = [
        (100,   0.05),
        (200, 0.04),
        (270, 0.03),
        (300, 0.6),
        (250,   0.15),   
        (500,   0.3),    
        (750,   0.2),    
        (1000,  0.25),   
        (1500,  0.18),   
        (2000,  0.15),   
        (2500,  0.12),   
        (3000,  0.1),    
        (3500,  0.08), 
        (3700,  0.5),
        (3800, 0.4),
        (3900, 0.01),
        (3950, 0.35),  
        (4000,  0.05),     
    ]
    signal = sum(
        amp * np.sin(2 * np.pi * freq * t) for freq, amp in components
    )


    N = len(signal)
    window = np.hamming(N)
    signal_win = signal * window
    fft_vals = fft(signal_win)
    freqs = fftfreq(N, 1/fs)
    mag = (2/N) * np.abs(fft_vals) / (np.sum(window)/N)
    
    
    plt.figure(figsize=(10, 4))
    plt.plot(freqs[:N//2], mag[:N//2])
    plt.title("FFT of Original Generated Signal (Before Filtering)")
    plt.xlabel("Frequency (Hz)")
    plt.ylabel("Amplitude")
    plt.grid(False)
    plt.tight_layout()
    plt.show()

    plt.figure(figsize=(10, 4))
    plt.plot(t[:300], signal[:300])  # show first 300 samples (~37.5ms)
    plt.title("Original Test Signal (Sum of Sine Wave)")
    plt.xlabel("Time [s]")
    plt.ylabel("Amplitude")
    plt.grid(True)
    plt.tight_layout()
    plt.show()
    # Convert to Q1.15 fixed-point format
    signal_scaled = signal 
    q15 = np.clip(signal_scaled, -1.0, 0.999969) * (2**15)
    q15_int = np.round(q15).astype(np.int16)

    # Check the working directory
    print(f"Saving .mem file to: {os.getcwd()}")

    # Write to .mem file in decimal (hex format optional)
    # Python: save as hex for $readmemh
    # Save to hex file with 16-bit unsigned representation
    with open("test_signal_t.mem", "w") as f:
        for sample in q15_int:
            # Convert signed int16 to unsigned 16-bit representation
            unsigned_sample = np.uint16(sample)  # reinterpret the bits
            f.write(f"{unsigned_sample:04x}\n")



    print("✅ test_signal.mem written successfully.")


if __name__ == '__main__':
    main()
