% Zihan Zheng 
% ssyzz33@nottingham.edu.cn

%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [10 MARKS]
% The GitHub account was created--finished
% Arduino was configured
% The breadcoard was connected and shown in attachment 'Pre-Task_Breadboard.jpg'
% Arduino communication
a = arduino('COM6','Uno'); % Connect MATLAB and Arduino
% 'COM6' and 'Uno' can be known from the properties of arduino throuh command window when you enter 'a = arduino'
% The loop about the LED blinking
for i = 1:10                     % Assumed that the yellow LED blinks within 10 s
    writeDigitalPin(a, 'D7', 1); % LED ON
    pause(0.5);                  % Wait 0.5 seconds
    writeDigitalPin(a, 'D7', 0); % LED OFF
    pause(0.5);                  % Wait 0.5 seconds
end

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
% The breadcoard was connected and shown in attachment 'Task1_Breadboard.jpg'
clear;
a = arduino('COM6', 'Uno');
duration = 600;            % The acquisition time in seconds
n_minutes = duration / 60; % The number of minutes 

temperature = zeros(1, duration);      % Array to contain the temperature
mean_temp = zeros(1, n_minutes);       % Array to contain the mean temoerature in each minute

% Generate the real date and location
date_recorded = datestr(now, 'mm/dd/yyyy');
location = 'Nottingham';

% Printout the date and location
fprintf('Date logging initiated - %s\n', date_recorded);
fprintf('Location - %s\n\n', location);

% Open a figure to plot timely
figure;

% Read, record temperature in arrays and plot the figure in every minutes
for i = 1:duration

    voltage = readVoltage(a, 'A0');
    TC = 10;   % Temperature coefficient
    V0 = 500;  % Zero-degree voltage
    temperature(i) = (voltage * 1000 - V0) / TC;  % Convert the voltage to temperature

    % Every 60 seconds, print and plot average temperature
    if mod(i, 60) == 0     % Every minute to printout and plot
        idx = i / 60;
        mean_temp(idx) = mean(temperature(i - 60 + 1:i));

        % Printout in command window
        fprintf('Minute\t\t %d\n', idx - 1);
        fprintf('Temperature\t %.2f°C\n\n', mean_temp(idx));

        % Plot it in figure timely
        time = 0:(idx - 1);   % X-axis in every minute
        plot(time, mean_temp(1:idx), '.-', 'LineWidth', 2);
        xlabel('Time (minute)');
        ylabel('Temperature (°C)');
        title('Cabin Temperature Over Time');
        grid on;   % Set grid background
        drawnow;
    end
    pause(1);      % Read data every second
end

% Record minimum, maximum and average of temperature
min_temp = min(mean_temp);   
max_temp = max(mean_temp);
avg_temp = mean(mean_temp);

% Create a file which is named 'cabin_temperature.txt'
% Record the data into the file
file = fopen('cabin_temperature.txt', 'w');
fprintf(file, 'Date logging initiated - %s\n', date_recorded);
fprintf(file, 'Location - %s\n\n', location);

for i = 1:n_minutes
    fprintf(file, 'Minute\t\t %d\n', i - 1);
    fprintf(file, 'Temperature\t %.2f°C\n\n', mean_temp(i));
end

% Record the max, min and average data into the file
fprintf(file, 'Max Temp: %.2f°C\n', max_temp);
fprintf(file, 'Min Temp: %.2f°C\n', min_temp);
fprintf(file, 'Average Temp: %.2f°C\n', avg_temp);
fprintf('\n'); % Blank space in txt file
fprintf(file, 'Data Logging terminated');

fclose(file);

% Reopen the file and download the data into 'content'
file = fopen('cabin_temperature.txt', 'r');
content = fscanf(file, '%c');
fclose(file);
% Printout the 'content' and check
disp(content);

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]
% The breadcoard was connected and shown in attachment 'Task2_Breadboard.jpg'
% The flowchart of Q(b) is shown in attachment 'Task2_b_Flowchart.jpg'
% The flowchart of Q(h) is shown in attachment 'Task2_h_Flowchart.jpg'
clear
a = arduino('COM6','Uno');
temp_monitor(a);

%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]
% The breadcoard was connected and shown in attachment 'Task3_Breadboard.jpg'
% The flowchart of Q(a) is shown in attachment 'Task3_a_Flowchart.jpg'
clear
a = arduino('COM6','Uno');
temp_prediction(a);

%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]
% This Coursework was about how to make the LED on, how to get the real-time temperature and predict the future temperature. 
% However, in my opinions, the most challenging thing was to set GitHub ready and setup the  Arduino. 
% Additionally, the process to write the part of predicting temperature was struggled, because the sensitivity of sensor, using the rate of historical data to predict temperature in 5 minutes’ time was also not a good idea. The prediction were both abstract, but actually the coding was written by my best.
% As for the strengths, I think that my coding is easy to view for all parameters explained clearly. Also, it is simple and effective in visualizing temperature changes in Task 2. 
% However, there are some limitations. The prediction model assumes linear temperature trends, which may not suit to the real world changes, which was also easily impacted  by noisiness. 
% Future improvements can involve using more accurate sensors to reduce noise effect. Furthermore, using historical data to predict nearly time but 5 minutes, for the accuracy was very poor.
