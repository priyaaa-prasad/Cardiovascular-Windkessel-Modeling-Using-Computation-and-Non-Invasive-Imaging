% Constants and Parameters
heart_rate = 60; % Heart rate in beats per minute
systolic_period = 1/3; % Systolic period as a fraction of cardiac cycle
physiological_stroke_volume = 70; % SAMPLE VALUE Physiological stroke volume in mL
% Calculate time parameters
time_per_beat = 60 / heart_rate; % Time for one heartbeat in seconds
systolic_time = systolic_period * time_per_beat; % Duration of systole
% Create time vector for one beat
t_one_beat = linspace(0, systolic_time, 1000); % Adjust the number of points as needed

% Generate a positive sine wave for blood flow during systole for one beat
sine_wave_amplitude = physiological_stroke_volume / (systolic_time * 2); % Amplitude for the sine wave
t_one_third = linspace(0, 1/3, 1000); % Time vector for 1/3 of a second
sine_wave_one_third = sine_wave_amplitude * sin(2 * pi * t_one_third / (1/3)); % Sine wave for 1/3 sec

flow_wave_one_sec = zeros(1, 1000); % Initialize as zeros
flow_wave_one_sec(1:length(t_one_third)) = sine_wave_one_third; % Add the sine wave for 1/3 sec

% Identify the indices for the remaining 2/3 sec and set them to zero
remaining_indices = length(t_one_third) + 1:length(flow_wave_one_sec);
flow_wave_one_sec(remaining_indices) = 0;

% Constants
R = 1; % Resistance
C = 0.1; % Updated capacitance value
% Number of beats for simulation
num_beats = 10; % Adjust as needed
% Generate input flow wave for multiple beats
flow_wave = repmat(flow_wave_one_sec, 1, num_beats); % Repeat the single beat wave for multiple beats

% Plotting input flow wave (systole) for multiple beats
figure;
plot(flow_wave, 'b', 'LineWidth', 1.5);
title('Input Flow Wave During Systole for Multiple Beats');
xlabel('Time');
ylabel('Flow');

% Plotting pressure based on the flow input for multiple beats
% Using Euler's method with corrected equation for dP: ((flow/C) - (pressure(n-1) / (R * C))) * dt
figure;
hold on;
% Initialize pressure for multiple beats
pressure = zeros(size(flow_wave));
pressure(1) = 80; % Initial condition for pressure (diastolic pressure)
% Loop through time steps
for j = 2:length(flow_wave)
    dt = t_one_beat(2) - t_one_beat(1); % Assuming equal time steps in a beat
    dP = ((flow_wave(j) / C) - (pressure(j-1) / (R * C))) * dt;
    pressure(j) = pressure(j-1) + dP;
end
plot(pressure);
title('Pressure Response Based on Input Flow for Multiple Beats');
xlabel('Time');
ylabel('Pressure');
hold off;
