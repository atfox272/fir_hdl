clear;

function out = ground(in, n)
    // in: input array
    // n: number of decimal digits to round
    factor = 10^n;
    out = round(in * factor) / factor;
endfunction

// Create a sample ECG signal
fs = 500; // Sampling frequency (Hz)
t = 0:1/fs:5; // Time vector for 5 seconds

// Generate a simple ECG-like signal: low-frequency component + noise
ecg_raw = 1.5*sin(2*%pi*1.7*t) + 0.5*sin(2*%pi*50*t) + 0.2*rand(1, length(t), "normal");
// ecg_raw = 1.5*sin(2*%pi*1.7*t) + 0.5*sin(2*tr%pi*50*t);
// ecg_raw = 1.5*sin(2*%pi*1.7*t);

// Design a FIR Low Pass Filter
cutoff_freq = 15; // Cutoff frequency (Hz)
norm_cutoff = cutoff_freq / (fs/2); // Normalize cutoff frequency to [0, 1]
flt_len = 36; // Filter length

h = wfir('lp', flt_len, [norm_cutoff], 'hm', [0]); // Design FIR LPF with Hamming window

// Adapt with FPGA implementaion
h = ground(h, 5);

// Filter the ECG signal
ecg_filtered = convol(h, ecg_raw);
ecg_filtered = ecg_filtered(1:length(t)); // Truncate to original signal length


// Plot the signals

scf(0); // Create a new figure
clf();

subplot(2,1,1);
plot(t, ecg_raw);
title('Raw ECG Signal');
xlabel('Time (s)');
ylabel('Amplitude');
// grid();

subplot(2,1,2);
plot(t, ecg_filtered);
title('Filtered ECG Signal');
xlabel('Time (s)');
ylabel('Amplitude');
// grid();
