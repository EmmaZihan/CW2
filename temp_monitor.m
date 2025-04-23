function temp_monitor(a)
    % Create two arrays to contain time and temperature
    time = [];
    temp = [];
    % Set the Digital signal of three different LEDs
    greenLED = 'D9';
    yellowLED = 'D7';
    redLED = 'D8';
    
    % Open a figure
    figure;

    while true  % Ensure it can progress indefinitely
        % Use voltage to calculate the temperature
        voltage = readVoltage(a, 'A0');  
        TC = 10; 
        V0 = 500;
        temperature = (voltage * 1000 - V0) / TC;

        if length(time) == 0 % When time = 0 s, record the initial temperature
            time(1) = 0;
            temp(1) = temperature;
        else                 % Record the current temperature
            time(end+1) = time(end) + 1;
            temp(end+1) = temperature;
        end

        % When the temperature is above the range, the red LED should blink intermittently at 0.25 s intervals.
        if temperature > 24
            writeDigitalPin(a, greenLED, 0);
            writeDigitalPin(a, yellowLED, 0);
            writeDigitalPin(a, redLED, 1);
            pause(0.25);
            writeDigitalPin(a, redLED, 0);
            pause(0.25);
        % When the temperature is below the range, the yellow LED should blink intermittently at 0.5 s intervals.
        elseif temperature < 18
            writeDigitalPin(a, greenLED, 0);
            writeDigitalPin(a, redLED, 0);
            writeDigitalPin(a, yellowLED, 1);
            pause(0.5);
            writeDigitalPin(a, yellowLED, 0);
            pause(0.5);
        % When the temperature is in the range 18-24 °C, the green LED should show a constant light.
        else
            writeDigitalPin(a, greenLED, 1);
            writeDigitalPin(a, yellowLED, 0);
            writeDigitalPin(a, redLED, 0);
        end

        % Live graph that shows the recorded values of the temperature
        plot(time, temp, '-', 'LineWidth', 1.5);
        % Set labels of axis
        xlabel('Time (s)');
        ylabel('Temperature (°C)');
        title('Real-time Temperature Monitoring'); % set the title of figure
        grid on;
        % Set an appropriate span for the dataset.
        xlim([max(0, time(end)-30), time(end)+5]); 
        % Show 30-second history data and 'max(0, time(end)-30)' ensures all x-axis is positive
        % 'time(end)+5' create some blank of figure.
        ylim([10 30]);  
        drawnow;

        pause(1); % The intervals is approximately 1 s
    end
end

%% doc temp_monitor
% This function monitors temperature with the sensor which was connected to the 'A0'.
% Based on the temperature, the LEDs will blink in real-time temperature:
% Green LED will turn on with temp between 18 and 24 °C;
% Yellow LED will blink once 1 s with temperature below 18 °C;
% Red LED will blink once 0.5 s with temperature above 24 °C.
% The graph displays the live plot of temperature vs. time。
% The data will update indefinitely once 1 s.