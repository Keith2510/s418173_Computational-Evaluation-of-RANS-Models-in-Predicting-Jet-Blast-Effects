% This MATLAB script was created to fulfill the thesis requirements of Keith Sequeira (Msc Computational Fluid Dynamics, IRP -2024), titled "Computational Evaluation of RANS Models in Predicting Jet Blast Effects."
% This MATLAB code was made with assistance from ChatGPT and Bing AI

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc;

% Define file names for xvelocity, stemperature, and turbulent kinetic energy
xvelocity_files = {''};
stemperature_files = {''};
tke_files = {''};

% Define the folder where plots will be saved
save_folder = '';


if ~exist(save_folder, 'dir')
    mkdir(save_folder);
end

markerStyles = {'o', '+', '*', 's', 'd'}; % Updated to match number of datasets

xvelocity_data = cell(1, 5);
stemperature_data = cell(1, 5);
tke_data = cell(1, 5);

% Read xvelocity files
for i = 1:5
    try
        xvelocity_data{i} = load(xvelocity_files{i});
    catch
        disp(['Error loading file: ', xvelocity_files{i}]);
    end
end

% Read stemperature files
for i = 1:5
    try
        stemperature_data{i} = load(stemperature_files{i});
    catch
        disp(['Error loading file: ', stemperature_files{i}]);
    end
end

% Read turbulent kinetic energy files
for i = 1:5
    try
        tke_data{i} = load(tke_files{i});
    catch
        disp(['Error loading file: ', tke_files{i}]);
    end
end

% X Velocity Plot
fig = figure;
set(fig, 'Position', get(0, 'ScreenSize')); % Maximize figure to full screen
hold on;
legend_entries_xvelocity = {'One Million Cells', 'Two Million Cells', 'Four Million Cells', 'Six Million Cells', 'Eight Million Cells'};
for i = 1:5
    if ~isempty(xvelocity_data{i})
        plot(xvelocity_data{i}(:,1), xvelocity_data{i}(:,2), 'LineStyle', 'none', 'Marker', markerStyles{i}, 'DisplayName', legend_entries_xvelocity{i});
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
exportgraphics(fig, fullfile(save_folder, 'MeshIndependence_XVelocity.jpeg'), 'Resolution', 300);

% Static Temperature Plot
fig = figure;
set(fig, 'Position', get(0, 'ScreenSize')); % Maximize figure to full screen
hold on;
legend_entries_stemperature = {'One Million Cells', 'Two Million Cells', 'Four Million Cells', 'Six Million Cells', 'Eight Million Cells'};
for i = 1:5
    if ~isempty(stemperature_data{i})
        plot(stemperature_data{i}(:,1), stemperature_data{i}(:,2), 'LineStyle', 'none', 'Marker', markerStyles{i}, 'DisplayName', legend_entries_stemperature{i});
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
exportgraphics(fig, fullfile(save_folder, 'MeshIndependence_StaticTemperature.jpeg'), 'Resolution', 300);

% Turbulent Kinetic Energy Plot
fig = figure;
set(fig, 'Position', get(0, 'ScreenSize')); % Maximize figure to full screen
hold on;
legend_entries_tke = {'One Million Cells', 'Two Million Cells', 'Four Million Cells', 'Six Million Cells', 'Eight Million Cells'};
for i = 1:5
    if ~isempty(tke_data{i})
        plot(tke_data{i}(:,1), tke_data{i}(:,2), 'LineStyle', 'none', 'Marker', markerStyles{i}, 'DisplayName', legend_entries_tke{i});
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
exportgraphics(fig, fullfile(save_folder, 'MeshIndependence_tke.jpeg'), 'Resolution', 300);
