clc; clear; close all;

%% Initial Parameters
sr = 500;                   % sample rate [Hz]
lin = 512;                  % Number of the lines
Tend = 10;                  % Signal duration [s]

n = sr*Tend;                % Total number of samples
p = lin * 64/25;            % Minimum number of sampels considering lines
Tmin = p/sr;                % Minimum data acquisition duration [s]

%% Importing signal
% In real sitation the signal DOES NOT have analytical function.
% However, here we make one to demonstrate the FFT procedure

t = linspace(0, Tend, n);                           % Time domain
x = sin(2*pi*50*t+0.2) + 0.5*sin(2*pi*60*t);        % Signal function
x = x + 0.001*randn(1, n);                           % Adding white noise

%% FFT with no window and no line consideration (rectangular window)

m = round(n/2);                 % to avoid the mirror effect of FFT
F1 = abs(fft(x));               % Use FFT and its amplitude
F1 = F1(1:m);
F1 = F1/max(F1);                % Normalization for comparison
freq = linspace(0, sr/2, m);    % Defining the frequency domain

%% FFT with various windows and no line consideration
% Here just one window has been applied (no overlapping) and winlen = n
% Note: FFT usually uses for stationary signals

F2 = abs(fft(x.*hann(n)'));                  % hann window
F2 = F2(1:m);
F2 = F2/max(F2);

F3 = abs(fft(x.*hamming(n)'));               % hamming window
F3 = F3(1:m);
F3 = F3/max(F3);

F4 = abs(fft(x.*flattopwin(n)'));            % flat-top window
F4 = F4(1:m);
F4 = F4/max(F4);

%% FFT with no window and with line consideration (rectangular window)

m = lin;                        
lin = lin*2;                    % to avoid the mirror effect of FFT
A1 = abs(fft(x, lin));          % Use FFT and its amplitude
A1 = A1(1:m);
A1 = A1/max(A1);                % Normalization for comparison
areq = linspace(0, sr/2, m);    % Defining the frequency domain

%% FFT with various windows and line consideration
% Here just one window has been applied (no overlapping)
% Note: FFT usually uses for stationary signals

A2 = abs(fft(x.*hann(n)', lin));                  % hann window
A2 = A2(1:m);
A2 = A2/max(A2);

A3 = abs(fft(x.*hamming(n)', lin));               % hamming window
A3 = A3(1:m);
A3 = A3/max(A3);

A4 = abs(fft(x.*flattopwin(n)', lin));            % flat-top window
A4 = A4(1:m);
A4 = A4/max(A4);

%% Plotting
rows = 3;
cols = 1;

% Main signal
ncutt = 350;                    % trimming the signal for better view
subplot(rows, cols, 1)
plot(t(1:ncutt), x(1:ncutt))
title("Signal")
xlabel("time [s]")

% FFT (no line)
subplot(rows, cols, 2)
semilogy(freq, F1,'DisplayName','rect')
hold on
semilogy(freq, F2,'DisplayName','hann')
semilogy(freq, F3,'DisplayName','hamming')
semilogy(freq, F4,'DisplayName','flat top')

legend
title("FFT")
xlabel("frequency [Hz]")

% FFT (no line)
subplot(rows, cols, 3)
semilogy(areq, A1,'DisplayName','rect')
hold on
semilogy(areq, A2,'DisplayName','hann')
semilogy(areq, A3,'DisplayName','hamming')
semilogy(areq, A4,'DisplayName','flat top')

legend
title(sprintf("FFT with %d lines", lin/2))
xlabel("frequency [Hz]")

