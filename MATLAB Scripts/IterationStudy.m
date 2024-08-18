% This MATLAB script was created to fulfill the thesis requirements of Keith Sequeira (MSc Computational Fluid Dynamics, IRP -2024), titled "Computational Evaluation of RANS Models in Predicting Jet Blast Effects."
% This MATLAB code was made with assistance from ChatGPT and Bing AI

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc;

% Input .dat files for xvelocity, stemperature, turbulent kinetic energy, force, and mass flow
xvelocity_files = {};
stemperature_files = {};
tke_files = {};
force_files = {};
massflow_files = {};

% Simulation Run-Times
simulation_times = {% Time taken for each simulation eg. '1h 1min '}; 
iterations = [% Iterations for each simulation]; 

% Folder where plots will be saved
save_folder = '';


markerStyles = {'o', '+', '*', 's', 'd', '^'}; % Added an extra marker style for consistency


xvelocity_data = cell(1, 6);
stemperature_data = cell(1, 6);
tke_data = cell(1, 6);
force_data = cell(1, 6);
massflow_data = cell(1, 6);

% Read xvelocity files
for i = 1:6
    try
        xvelocity_data{i} = load(xvelocity_files{i});
    catch
        disp(['Error loading file: ', xvelocity_files{i}]);
    end
end

% Read stemperature files
for i = 1:6
    try
        stemperature_data{i} = load(stemperature_files{i});
    catch
        disp(['Error loading file: ', stemperature_files{i}]);
    end
end

% Read turbulent kinetic energy files
for i = 1:6
    try
        tke_data{i} = load(tke_files{i});
    catch
        disp(['Error loading file: ', tke_files{i}]);
    end
end

% Read force files
for i = 1:6
    try
        force_data{i} = load(force_files{i});
    catch
        disp(['Error loading file: ', force_files{i}]);
    end
end

% Read mass flow files
for i = 1:6 % Corrected loop to match the number of files
    try
        massflow_data{i} = load(massflow_files{i});
    catch
        disp(['Error loading file: ', massflow_files{i}]);
    end
end

%%%%%%%%%%%%%%%%%%%%% Plots JPEG %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist(save_folder, 'dir')
    mkdir(save_folder);
end

screen_size = get(0, 'ScreenSize');

% X Velocity Plot
fig = figure;
set(fig, 'Position', screen_size); % Set figure to full screen
hold on;
legend_entries_xvelocity = {'1000 Iterations', '2000 Iterations', '3000 Iterations', '5000 Iterations', '7000 Iterations', '10000 Iterations'};
for i = 1:6
    if ~isempty(xvelocity_data{i})
        plot(xvelocity_data{i}(:, 1), xvelocity_data{i}(:, 2), 'LineStyle', 'none', 'Marker', markerStyles{i}, 'DisplayName', legend_entries_xvelocity{i});
    else
        disp(['xvelocity data not loaded: ', xvelocity_files{i}]);
    end
end
xlabel('X');
ylabel('X Velocity (m/s)');
legend('show');
grid on;
hold off;

% X Velocity.jpeg 
exportgraphics(fig, fullfile(save_folder, 'IterationStudy_Xvelocity.jpeg'), 'Resolution', 300);

% Static Temperature Plot
fig = figure;
set(fig, 'Position', screen_size); % Set figure to full screen
hold on;
legend_entries_stemperature = {'1000 Iterations', '2000 Iterations', '3000 Iterations', '5000 Iterations', '7000 Iterations', '10000 Iterations'};
for i = 1:6
    if ~isempty(stemperature_data{i})
        plot(stemperature_data{i}(:, 1), stemperature_data{i}(:, 2), 'LineStyle', 'none', 'Marker', markerStyles{i}, 'DisplayName', legend_entries_stemperature{i});
    else
        disp(['stemperature data not loaded: ', stemperature_files{i}]);
    end
end
xlabel('X');
ylabel('Static Temperature (K)');
legend('show');
grid on;
hold off;

% Static Temperature.jpeg
exportgraphics(fig, fullfile(save_folder, 'IterationStudy_StaticTemperature.jpeg'), 'Resolution', 300);

% Turbulent Kinetic Energy Plot
fig = figure;
set(fig, 'Position', screen_size); % Set figure to full screen
hold on;
legend_entries_tke = {'1000 Iterations', '2000 Iterations', '3000 Iterations', '5000 Iterations', '7000 Iterations', '10000 Iterations'};
for i = 1:6
    if ~isempty(tke_data{i})
        plot(tke_data{i}(:, 1), tke_data{i}(:, 2), 'LineStyle', 'none', 'Marker', markerStyles{i}, 'DisplayName', legend_entries_tke{i});
    else
        disp(['TKE data not loaded: ', tke_files{i}]);
    end
end
xlabel('X');
ylabel('Turbulent Kinetic Energy (m^2/s^2)');
legend('show');
grid on;
hold off;

% Turbulent Kinetic Energy.jpeg
exportgraphics(fig, fullfile(save_folder, 'IterationStudy_TKE.jpeg'), 'Resolution', 300);

% Force Report Subplots
fig = figure;
set(fig, 'Position', screen_size); % Set figure to full screen
for i = 1:6
    subplot(6, 1, i);
    if ~isempty(force_data{i})
        plot(force_data{i}(:, 1), force_data{i}(:, 2), 'LineStyle', 'none', 'Marker', markerStyles{i});
        xlabel('Iterations');
        ylabel('Force (Newtons)');
        grid on;
        title(sprintf('%s)', char('a' + i - 1))); % Titles: a), b), c), d), e), f)
    else
        disp(['Force data not loaded: ', force_files{i}]);
    end
end

% Force.jpeg
exportgraphics(fig, fullfile(save_folder, 'IterationStudy_Force.jpeg'), 'Resolution', 300);

% Mass Flow Report Subplots
fig = figure;
set(fig, 'Position', screen_size); % Set figure to full screen
for i = 1:6
    subplot(6, 1, i);
    if ~isempty(massflow_data{i})
        plot(massflow_data{i}(:, 1), massflow_data{i}(:, 2), 'LineStyle', 'none', 'Marker', markerStyles{i});
        xlabel('Iterations');
        ylabel('Mass Flow (kg/s)');
        grid on
        title(sprintf('%s)', char('a' + i - 1))); % Titles: a), b), c), d), e), f)
    else
        disp(['Mass Flow data not loaded: ', massflow_files{i}]);
    end
end

% Mass Flow.jpeg
exportgraphics(fig, fullfile(save_folder, 'IterationStudy_MassFlow.jpeg'), 'Resolution', 300);

% Convert simulation times to total minutes
simulation_times_minutes = [112, 222, 332, 551, 771, 1173]; 

% Plot simulation time against iterations
fig = figure;
set(fig, 'Position', screen_size); % Set figure to full screen
plot(iterations, simulation_times_minutes, '-o');
xlabel('Iterations');
ylabel('Simulation Time (minutes)');
grid on;

% Display the actual time taken in hours and minutes as annotations
for i = 1:length(iterations)
    text(iterations(i), simulation_times_minutes(i), simulation_times{i}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end

% Simulation Time.jpeg
exportgraphics(fig, fullfile(save_folder, 'IterationStudy_SimulationTimes.jpeg'), 'Resolution', 300);
