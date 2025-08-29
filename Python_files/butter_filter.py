from scipy.signal import butter
import numpy as np

fs = 8000
lowcut = 300
highcut = 3400

sos = butter(N=2, Wn=[lowcut, highcut], btype='bandpass', fs=fs, output='sos')#used to create a butterworth filter. 'sos'-->second order section
print("Floating point:\n", sos)

# Convert to Q1.15
q15_s = np.round(sos * (2**15)).astype(np.int32)
q15_s = np.clip(q15_s, -32768, 32767)
q15 = q15_s.astype(np.int16)
print("Q1.15 coefficients:\n", q15)
#We are using thise to generate the needed coefficient for the filter.\

