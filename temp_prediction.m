function temp_prediction(a)
    comfort_change = 4 / 60;    % Change unit to °C/s
    % Create three arrays to contain time, temperature and rate of change
    time = [];
    temp = [];
    rate = [0]; % Set the initial rate is 0 °C/s
    % Set the Digital signal of three different LEDs
    greenLED = 'D9';
    yellowLED = 'D7';
    redLED = 'D8';

    % Open the timer
    tic;

    while true  % Ensure it can progress indefinitely
        current_time = toc;  % Record the current time

        % Use voltage to calculate the temperature
        voltage = readVoltage(a, 'A0');  
        TC = 10; 
        V0 = 500;
        current_temp = (voltage * 1000 - V0) / TC;
        
        % Record the current time and temperature to the arrays
        temp(end+1) = current_temp;
        time(end+1) = current_time;

        if length(temp) > 1  
            % Calculate the rate of temperature changing
            delta_time = time(end) - time(end-1);
            delta_temp = temp(end) - temp(end-1);
            rate_of_change = delta_temp / delta_time;
            rate(end+1) = rate_of_change;

            % Use no more than 5 history data of rate to get the mean rate,which is used to predict the temperature
            if length(rate) > 6  
                mean_rate = mean(rate(end-4:end));
            else
                mean_rate = mean(rate(2:end));
            end

            % Prediction of temperatue in 5 minutes' time
            predict_temp = current_temp + 5 * 60 * mean_rate;

            % Printout the current temperature with and the prediction temperature
            fprintf('Current Temp: %.2f°C, Rate of Change: %.4f°C/s, Predicted Temp (5 min): %.2f°C\n', ...
                current_temp, mean_rate, predict_temp);
            % The rate of change in temperature is within 4°C/min, the green LED is constant.
            if abs(mean_rate) <= comfort_change
                writeDigitalPin(a, greenLED, 1);
                writeDigitalPin(a, redLED, 0);
                writeDigitalPin(a, yellowLED, 0);
            % The rate of change in temperature is greater than -4°C/min(decrease), the yellow LED is constant.
            elseif mean_rate < -comfort_change
                writeDigitalPin(a, yellowLED, 1);
                writeDigitalPin(a, redLED, 0);
                writeDigitalPin(a, greenLED, 0);
            % The rate of change in temperature is greater than 4°C/min(increase), the red LED is constant.
            elseif mean_rate > comfort_change
                writeDigitalPin(a, redLED, 1);
                writeDigitalPin(a, greenLED, 0);
                writeDigitalPin(a, yellowLED, 0);
            end
        end
        pause(1); % Read the temperature every second
    end
end

%% doc temp_prediction
% This function monitors temperature with the sensor which was connected to the 'A0'.
% Then, using no more than 5 historical data calculates the mean rate of change, which can ensure a smoother prediction
% The temperature in 5 minutes' time is predicted.
% Also, to monitor the temperature rate. If the rate is within 4 °C/min, the green LED will be constantly bright
% If the rate is greater the 4 °C/min in increasing, the red LED will be constantly bright
% If the rate is greater the 4 °C/min in decreasing, the yellow LED will be constantly bright
% Data is updated every second, and all values will be printed out every second.