'''import numpy as np
import matplotlib.pyplot as plt
from scipy.fft import fft, fftfreq
def main():
    with open("Captured_Signal_t.txt", "r") as f:
        hex_lines = f.readlines()

    unsigned_vals = np.array([int(line.strip(), 16) for line in hex_lines], dtype=np.uint16)
    signed_vals = unsigned_vals.astype(np.int16) 
    signal = signed_vals / 32768.0  
    fs = 8000
    N = len(signal) #Number of samples

    #Hamming to avoid leakage
    window = np.hamming(N)
    signal_win = signal * window
    #FFT
    fft_vals = fft(signal_win)
    freqs = fftfreq(N, 1/fs)

    #Normalized magnitude
    window_crr = np.sum(window) /N
    mag = (2/N) * np.abs(fft_vals) / window_crr

    # Plot only positive frequencies
    plt.figure(figsize=(10, 4))
    plt.plot(freqs[:N//2], mag[:N//2])
    plt.title("FFT Spectrum of Captured Signal")
    plt.xlabel("Frequency (Hz)")
    plt.ylabel("Amplitude")
    plt.grid(True)
    plt.tight_layout()
    plt.show(block = False)

    #Applying bandpass --> We want to do this in verilog
    bandpass = (np.abs(freqs) >= 300) & (np.abs(freqs) < 3400)
    filtered_fft  = fft_vals * bandpass#gives us a bandpass result

    #Inverse fft
    filtered_sig = np.real(np.fft.ifft(filtered_fft))
    plt.figure(figsize=(10, 4))
    plt.plot(filtered_sig)
    plt.title("Time-Domain Signal After Bandpass Filtering")
    plt.xlabel("Sample Index")
    plt.ylabel("Amplitude")
    plt.grid(True)
    plt.tight_layout()
    plt.show(block = False)

    plt.figure(figsize=(10, 4))
    plt.plot(signal, label='Original')
    #plt.plot(filtered_sig, label='Filtered', linestyle='--')
    plt.title("Time-Domain: Original vs Filtered Signal")
    plt.xlabel("Sample Index")
    plt.ylabel("Amplitude")
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.show()


if __name__ == '__main__':
    main()
'''
'''
import numpy as np
import matplotlib.pyplot as plt
from scipy.fft import fft, fftfreq
def main():
    with open("F_captured_signal.txt", "r") as f:
        hex_lines = f.readlines()

    unsigned_vals = np.array([int(line.strip(), 16) for line in hex_lines], dtype=np.uint16)
    signed_vals = unsigned_vals.astype(np.int16) 
    signal = signed_vals / 32768.0  
    fs = 8000
    N = len(signal) #Number of samples

    #Hamming to avoid leakage
    window = np.hamming(N)
    signal_win = signal * window
    #FFT
    fft_vals = fft(signal_win)
    freqs = fftfreq(N, 1/fs)

    #Normalized magnitude
    window_crr = np.sum(window) /N
    mag = (2/N) * np.abs(fft_vals) / window_crr

     #Applying bandpass --> We want to do this in verilog
    #bandpass = (np.abs(freqs) >= 300) & (np.abs(freqs) < 3400)
    #filtered_fft  = fft_vals * bandpass#gives us a bandpass result
    #Inverse FFT
    filtered_sig = np.real(np.fft.ifft(filtered_fft))
    # Plot only positive frequencies
    fig, axs = plt.subplots(nrows=3, figsize=(16, 10))

    # 1. FFT Spectrum
    #mag_db = 20 * np.log10(mag + 1e-12)
    axs[0].plot(freqs[:N//2], mag[:N//2])
    axs[0].set_title("FFT Spectrum of Captured Signal")
    axs[0].set_xlabel("Frequency (Hz)")
    axs[0].set_ylabel("Amplitude")
    axs[0].grid(True)

    # 2. Time-Domain Signal After Bandpass Filtering
    axs[1].plot(filtered_sig)
    axs[1].set_title("Time-Domain Signal After Bandpass Filtering")
    axs[1].set_xlabel("Sample Index")
    axs[1].set_ylabel("Amplitude")
    axs[1].grid(True)

    # 3. Original vs Filtered
    axs[2].plot(signal, label='Original')
    #axs[2].plot(filtered_sig, label='Filtered', linestyle='--')
    axs[2].set_title("Time-Domain: Original vs Filtered Signal")
    axs[2].set_xlabel("Sample Index")
    axs[2].set_ylabel("Amplitude")
    axs[2].legend()
    axs[2].grid(True)

    plt.tight_layout()
    plt.show()



if __name__ == '__main__':
    main()
'''

import numpy as np
import matplotlib.pyplot as plt
from scipy.fft import fft, fftfreq

def main():
    # Read Verilog output
    with open("F_captured_signal.txt", "r") as f:
        hex_lines = f.readlines()

    # Convert from Q1.15 hex to float
    unsigned_vals = np.array([int(line.strip(), 16) for line in hex_lines], dtype=np.uint16)
    signed_vals = unsigned_vals.astype(np.int16) 
    signal = signed_vals / 32768.0  

    fs = 8000
    N = len(signal)

    #Hamming window
    window = np.hamming(N)
    signal_win = signal * window

    # FFT and frequency
    fft_vals = fft(signal_win)
    freqs = fftfreq(N, 1/fs)

    # Normalized magnitude spectrum
    window_crr = np.sum(window) / N
    mag = (2/N) * np.abs(fft_vals) / window_crr

    #FFT Spectrum
    plt.figure(figsize=(10, 4))
    plt.plot(freqs[:N//2], mag[:N//2])
    plt.title("FFT Spectrum of Captured Signal")
    plt.xlabel("Frequency (Hz)")
    plt.ylabel("Amplitude")
    plt.grid(True)
    plt.tight_layout()
    plt.show(block=False)

    # Time domain signal
    plt.figure(figsize=(10, 4))
    plt.plot(signal)
    plt.title("Time-Domain Signal from Verilog Filter")
    plt.xlabel("Sample Index")
    plt.ylabel("Amplitude")
    plt.grid(True)
    plt.tight_layout()
    plt.show(block=False)

        # Original Signal Sampled
    with open("test_signal_t.mem", "r") as f:
        original_hex_lines = f.readlines()

    original_unsigned = np.array([int(line.strip(), 16) for line in original_hex_lines], dtype=np.uint16)
    original_signed = original_unsigned.astype(np.int16)
    original_signal = original_signed / 32768.0  # Q1.15 to float

    #Original Signal
    plt.figure(figsize=(10, 4))
    plt.plot(original_signal, label='Original (Input)')
    #plt.plot(signal, label='Verilog Filtered', linestyle='--')
    plt.title("Time-Domain: Original")
    plt.xlabel("Sample Index")
    plt.ylabel("Amplitude")
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.show()

if __name__ == '__main__':
    main()
    
