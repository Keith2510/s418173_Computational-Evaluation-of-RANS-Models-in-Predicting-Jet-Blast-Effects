% This MATLAB script was created to fulfill the thesis requirements of Keith Sequeira (Msc Computational Fluid Dynamics, IRP: 2023-24),, titled "Jet Blast Prediction in Complex Flow Scenarios: A Study of Turbulence Model Performance."
% This MATLAB code was made with assistance from ChatGPT, Bing AI and Perplexity
% Special thanks to Dr. Tamás Józsa for his assitance in troubleshooting issues with the script

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc;

% Parameters
% ------------------------------
% Jet Mach number, Jet Temperature (K), and Jet Velocity (m/s)
% Case 1 Parameters
Mj = ; % Jet Mach number
Tj = ; % Jet Temperature in Kelvin
Uj = ; % Jet Velocity in meters per second
D = ; % Diameter of the Jet Outlet in meters
L = ; % Length of the Jet in meters

% Constants
Tinf = ; % Ambient temperature
alpha = ; % Constant for the centerline velocity decay

% Data Files
% ------------------------------
% Centreline Velocity, Potential Core Length, and Normalized Velocity Profile
kep_data = load(""); % k-epsilon model data
sa_data = load(""); % SA model data
komega_sst_data = load(""); % k-omega SST model data
komega_geko_data = load(""); % k-omega GEKO model data
rsm_lps_data = load(""); % RSM LPS model data

% Normalized Radial Velocity Profiles
kep_radial_data = load(""); % k-epsilon radial data
sa_radial_data = load(""); % SA model radial data
komega_sst_radial_data = load(""); % k-omega SST radial data
komega_geko_radial_data = load(""); % k-omega GEKO radial data
rsm_lps_radial_data = load(""); % RSM LPS radial data
Reference_radial_Maslov = load(""); % Reference radial data

% Normalized Radial Velocity Profiles at X/D = 50
kep_radial_fifty_data = load(""); % k-epsilon data
sa_radial_fifty_data = load(""); % SA model data
kosst_radial_fifty_data = load(""); % k-omega SST data
koGEKO_radial_fifty_data = load(""); % k-omega GEKO data
rsm_radial_fifty_data = load(""); % RSM data

% Normalized Radial Velocity Profiles at X/D = 100
kep_radial_hundred_data = load(""); % k-epsilon data
sa_radial_hundred_data = load(""); % SA model data
kosst_radial_hundred_data = load(""); % k-omega SST data
koGEKO_radial_hundred_data = load(""); % k-omega GEKO data
rsm_radial_hundred_data = load(""); % RSM data

% Load data from .dat files
% ------------------------------
kep_vertical_data = load(""); % Vertical jet spread data for kepsilon model
sa_vertical_data = load("");  % Vertical jet spread data for SA model
komega_sst_vertical_data = load(""); % Vertical jet spread data for k-omega SST model
komega_geko_vertical_data = load(""); % Vertical jet spread data for k-omega GEKO model
rsm_lps_vertical_data = load(""); % Vertical jet spread data for RSM model
Reference_vertical_Maslov = load(""); % Reference vertical jet spread data

% Radial Jet Spread .dat files at different X/D
% ------------------------------
kepsilon_rjs = { ...
    ''; % Radial jet spread data for kepsilon model at X/D = 50
    ''; % Radial jet spread data for kepsilon model at X/D = 100
    ''; % Radial jet spread data for kepsilon model at X/D = 200
    ''; % Radial jet spread data for kepsilon model at X/D = 300
    ''; % Radial jet spread data for kepsilon model at X/D = 400
    ''; % Radial jet spread data for kepsilon model at X/D = 470
};

kosst_rjs = { ...
    ''; % Radial jet spread data for k-omega SST model at X/D = 50
    ''; % Radial jet spread data for k-omega SST model at X/D = 100
    ''; % Radial jet spread data for k-omega SST model at X/D = 200
    ''; % Radial jet spread data for k-omega SST model at X/D = 300
    ''; % Radial jet spread data for k-omega SST model at X/D = 400
    ''; % Radial jet spread data for k-omega SST model at X/D = 470
};

koGEKO_rjs = { ...
    ''; % Radial jet spread data for k-omega GEKO model at X/D = 50
    ''; % Radial jet spread data for k-omega GEKO model at X/D = 100
    ''; % Radial jet spread data for k-omega GEKO model at X/D = 200
    ''; % Radial jet spread data for k-omega GEKO model at X/D = 300
    ''; % Radial jet spread data for k-omega GEKO model at X/D = 400
    ''; % Radial jet spread data for k-omega GEKO model at X/D = 470
};

SA_rjs = { ...
    ''; % Radial jet spread data for SA model at X/D = 50
    ''; % Radial jet spread data for SA model at X/D = 100
    ''; % Radial jet spread data for SA model at X/D = 200
    ''; % Radial jet spread data for SA model at X/D = 300
    ''; % Radial jet spread data for SA model at X/D = 400
    ''; % Radial jet spread data for SA model at X/D = 470
};

RSM_rjs = { ...
    ''; % Radial jet spread data for RSM model at X/D = 50
    ''; % Radial jet spread data for RSM model at X/D = 100
    ''; % Radial jet spread data for RSM model at X/D = 200
    ''; % Radial jet spread data for RSM model at X/D = 300
    ''; % Radial jet spread data for RSM model at X/D = 400
    ''; % Radial jet spread data for RSM model at X/D = 470
};

Reference_rjs = { ...
    ''; % Reference radial jet spread data
};

% Vertical Jet Spread Data Files
% ------------------------------
kepsilon_vjs = {}; % k-epsilon vertical jet spread data
kosst_vjs = {}; % k-omega SST vertical jet spread data
koGEKO_vjs = {}; % k-omega GEKO vertical jet spread data
SA_vjs = {}; % SA model vertical jet spread data
RSM_vjs = {}; % RSM vertical jet spread data
Reference_vjs = {}; % Reference vertical jet spread data

% Aspect Ratio Jet Spread and Self Similarity
% ------------------------------
kepsilon_aspect = {}; % k-epsilon aspect ratio data
sa_aspect = {}; % SA model aspect ratio data
kosst_aspect = {}; % k-omega SST aspect ratio data
kogeko_aspect = {}; % k-omega GEKO aspect ratio data
rsm_aspect = {}; % RSM aspect ratio data
AspectRatio_Reference = ''; % Reference aspect ratio data

% Ground Temperature Profile Data Files
% ------------------------------
gnd_temp_kep = ''; % k-epsilon ground temperature profile data
gnd_temp_sa = ''; % SA model ground temperature profile data
gnd_temp_komega_sst = ''; % k-omega SST ground temperature profile data
gnd_temp_komega_geko = ''; % k-omega GEKO ground temperature profile data
gnd_temp_rsm_lps = ''; % RSM ground temperature profile data

% Ground Radial Temperature Profile Data Files
% ------------------------------
gnd_temp_kep_radial_fifty = ''; % k-epsilon radial temperature profile at X/D = 50
gnd_temp_kep_radial_hundred = ''; % k-epsilon radial temperature profile at X/D = 100
gnd_temp_kep_radial_twohundred = ''; % k-epsilon radial temperature profile at X/D = 200
gnd_temp_kep_radial_threehundred = ''; % k-epsilon radial temperature profile at X/D = 300
gnd_temp_kep_radial_fourhundred = ''; % k-epsilon radial temperature profile at X/D = 400
gnd_temp_kep_radial_fourseventy = ''; % k-epsilon radial temperature profile at X/D = 470

gnd_temp_sa_radial_fifty = ''; % SA model radial temperature profile at X/D = 50
gnd_temp_sa_radial_hundred = ''; % SA model radial temperature profile at X/D = 100
gnd_temp_sa_radial_twohundred = ''; % SA model radial temperature profile at X/D = 200
gnd_temp_sa_radial_threehundred = ''; % SA model radial temperature profile at X/D = 300
gnd_temp_sa_radial_fourhundred = ''; % SA model radial temperature profile at X/D = 400
gnd_temp_sa_radial_fourseventy = ''; % SA model radial temperature profile at X/D = 470

gnd_temp_kosst_radial_fifty = ''; % k-omega SST radial temperature profile at X/D = 50
gnd_temp_kosst_radial_hundred = ''; % k-omega SST radial temperature profile at X/D = 100
gnd_temp_kosst_radial_twohundred = ''; % k-omega SST radial temperature profile at X/D = 200
gnd_temp_kosst_radial_threehundred = ''; % k-omega SST radial temperature profile at X/D = 300
gnd_temp_kosst_radial_fourhundred = ''; % k-omega SST radial temperature profile at X/D = 400
gnd_temp_kosst_radial_fourseventy = ''; % k-omega SST radial temperature profile at X/D = 470

gnd_temp_koGEKO_radial_fifty = ''; % k-omega GEKO radial temperature profile at X/D = 50
gnd_temp_koGEKO_radial_hundred = ''; % k-omega GEKO radial temperature profile at X/D = 100
gnd_temp_koGEKO_radial_twohundred = ''; % k-omega GEKO radial temperature profile at X/D = 200
gnd_temp_koGEKO_radial_threehundred = ''; % k-omega GEKO radial temperature profile at X/D = 300
gnd_temp_koGEKO_radial_fourhundred = ''; % k-omega GEKO radial temperature profile at X/D = 400
gnd_temp_koGEKO_radial_fourseventy = ''; % k-omega GEKO radial temperature profile at X/D = 470

gnd_temp_rsm_lps_radial_fifty = ''; % RSM radial temperature profile at X/D = 50
gnd_temp_rsm_lps_radial_hundred = ''; % RSM radial temperature profile at X/D = 100
gnd_temp_rsm_lps_radial_twohundred = ''; % RSM radial temperature profile at X/D = 200
gnd_temp_rsm_lps_radial_threehundred = ''; % RSM radial temperature profile at X/D = 300
gnd_temp_rsm_lps_radial_fourhundred = ''; % RSM radial temperature profile at X/D = 400
gnd_temp_rsm_lps_radial_fourseventy = ''; % RSM radial temperature profile at X/D = 470

% Wall Shear Stress (Ground) Data Files
% ------------------------------
wss_kep = ''; % k-epsilon wall shear stress data
wss_sa = ''; % SA model wall shear stress data
wss_kosst = ''; % k-omega SST wall shear stress data
wss_koGEKO = ''; % k-omega GEKO wall shear stress data
wss_rsm = ''; % RSM wall shear stress data

% Simulation Time for Each Turbulence Model
% ------------------------------
time_kep = " hours minutes"; % Time for k-epsilon model
time_sa = " hours minutes"; % Time for SA model
time_komega_sst = " hours minutes"; % Time for k-omega SST model
time_komega_geko = " hours minutes"; % Time for k-omega GEKO model
time_rsm_lps = " hours minutes"; % Time for RSM model

% Surface Integral: Wall Shear Stress Data for each Turbulence Model
% ------------------------------
tau_w_kep = ; % Wall shear stress for k-epsilon model
tau_w_sa = ; % Wall shear stress for SA model
tau_w_komega_sst = ; % Wall shear stress for k-omega SST model
tau_w_komega_geko = ; % Wall shear stress for k-omega GEKO model
tau_w_rsm_lps = ; % Wall shear stress for RSM model

% Plots.jpeg Location
% ------------------------------
output_folder = ''; % Directory to save plots
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Remove existing JPEG files in the output folder
jpeg_files = dir(fullfile(output_folder, '*.PNG'));
for k = 1:length(jpeg_files)
    delete(fullfile(output_folder, jpeg_files(k).name));
end

% Function to save figures
% ------------------------------
function save_figure(fig, filename, output_folder, width, height)
    % Construct the full path for the output file
    full_path = fullfile(output_folder, filename);
    
    % Set the figure size before saving
    set(fig, 'Units', 'pixels'); % Set units to pixels for precise control
    set(fig, 'Position', [100, 100, 850, 650]); % Adjust the position and size

    % Save the figure as a JPEG file
    saveas(fig, full_path, 'jpeg');
end
%% Potential Core Length %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Measurements from 30m to 500m
X_kep = kep_data(:, 1);  
Uc_kep = kep_data(:, 2);

X_sa = sa_data(:, 1);
Uc_sa = sa_data(:, 2);

X_komega_sst = komega_sst_data(:, 1);
Uc_komega_sst = komega_sst_data(:, 2);

X_komega_geko = komega_geko_data(:, 1);
Uc_komega_geko = komega_geko_data(:, 2);

X_rsm_lps = rsm_lps_data(:, 1);
Uc_rsm_lps = rsm_lps_data(:, 2);

% Potential Core Length
hat_xc_equation = (4.2 + 1.1 * Mj^2) / (Tj / Tinf)^0.2;

% Normalize X and Uc
xi_kep = X_kep / hat_xc_equation;
xi_kep = vertcat(0,xi_kep);
Uc_normalized_kep = Uc_kep / Uj;
Uc_normalized_kep = vertcat(1,Uc_normalized_kep);

xi_sa = X_sa / hat_xc_equation;
xi_sa = vertcat(0,xi_sa);
Uc_normalized_sa = Uc_sa / Uj;
Uc_normalized_sa = vertcat(1,Uc_normalized_sa);

xi_komega_sst = X_komega_sst / hat_xc_equation;
xi_komega_sst = vertcat(0,xi_komega_sst);
Uc_normalized_komega_sst = Uc_komega_sst / Uj;
Uc_normalized_komega_sst = vertcat(1,Uc_normalized_komega_sst);

xi_komega_geko = X_komega_geko / hat_xc_equation;
xi_komega_geko = vertcat(0,xi_komega_geko);
Uc_normalized_komega_geko = Uc_komega_geko / Uj;
Uc_normalized_komega_geko = vertcat(1,Uc_normalized_komega_geko);

xi_rsm_lps = X_rsm_lps / hat_xc_equation;
xi_rsm_lps = vertcat(0,xi_rsm_lps);
Uc_normalized_rsm_lps = Uc_rsm_lps / Uj;
Uc_normalized_rsm_lps = vertcat(1,Uc_normalized_rsm_lps);

% Sort the data by xi values
[xi_kep, sortIdx] = sort(xi_kep);
Uc_normalized_kep = Uc_normalized_kep(sortIdx);

[xi_sa, sortIdx] = sort(xi_sa);
Uc_normalized_sa = Uc_normalized_sa(sortIdx);

[xi_komega_sst, sortIdx] = sort(xi_komega_sst);
Uc_normalized_komega_sst = Uc_normalized_komega_sst(sortIdx);

[xi_komega_geko, sortIdx] = sort(xi_komega_geko);
Uc_normalized_komega_geko = Uc_normalized_komega_geko(sortIdx);

[xi_rsm_lps, sortIdx] = sort(xi_rsm_lps);
Uc_normalized_rsm_lps = Uc_normalized_rsm_lps(sortIdx);

% Find the maximum Uc/Uj value from the turbulence models
max_Uc_normalized = max([Uc_normalized_kep; Uc_normalized_sa; Uc_normalized_komega_sst; Uc_normalized_komega_geko; Uc_normalized_rsm_lps]);

% Potential Core Length
fig1 = figure;
hold on;

% K-Epsilon data
plot(xi_kep, Uc_normalized_kep, 'LineWidth', 2, 'DisplayName', 'k-\epsilon');

% Spalart-Allmaras data
plot(xi_sa, Uc_normalized_sa, 'LineWidth', 2, 'DisplayName', 'Spalart-Allmaras');

% K-Omega SST data
plot(xi_komega_sst, Uc_normalized_komega_sst, 'LineWidth', 2, 'DisplayName', 'SST k-\omega');

% K-Omega GEKO data
plot(xi_komega_geko, Uc_normalized_komega_geko, 'LineWidth', 2, 'DisplayName', 'k-\omega GEKO');

% RSM-LPS data
plot(xi_rsm_lps, Uc_normalized_rsm_lps, 'LineWidth', 2, 'DisplayName', 'RSM-LPS');

% Determine range for theoretical model plot
x_min = min([xi_kep; xi_sa; xi_komega_sst; xi_komega_geko; xi_rsm_lps]);
x_max = max([xi_kep; xi_sa; xi_komega_sst; xi_komega_geko; xi_rsm_lps]);

% Theoretical model
x_theory = linspace(x_min, x_max, 100); % Create theoretical x range
Uc_theory = ones(size(x_theory)); % Initialize with ones
x_offset = 30 / hat_xc_equation;  % Convert 30m to normalized units
Uc_theory(x_theory > x_offset) = 1 - exp(-alpha ./ (x_theory(x_theory > x_offset) - x_offset));

% Limit the theoretical model to the maximum Uc/Uj value from the turbulence models
Uc_theory = min(Uc_theory, max_Uc_normalized);

% Plot theoretical model
plot(x_theory, Uc_theory, 'k:', 'LineWidth', 2, 'DisplayName', 'Theoretical Model');

xlabel('\xi');
ylabel('U_c/U_j');
legend('show');
grid on;
hold off;


%%%%%%%%%%%% Printing Potential Core Length Values %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xi_kep_one = X_kep / hat_xc_equation;
Uc_normalized_kep_one = Uc_kep / Uj;

xi_sa_one = X_sa / hat_xc_equation;
Uc_normalized_sa_one = Uc_sa / Uj;

xi_komega_sst_one = X_komega_sst / hat_xc_equation;
Uc_normalized_komega_sst_one = Uc_komega_sst / Uj;

xi_komega_geko_one = X_komega_geko / hat_xc_equation;
Uc_normalized_komega_geko_one = Uc_komega_geko / Uj;

xi_rsm_lps_one = X_rsm_lps / hat_xc_equation;
Uc_normalized_rsm_lps_one = Uc_rsm_lps / Uj;

% Sort the data by xi values
[xi_kep_one, sortIdx] = sort(xi_kep_one);
Uc_normalized_kep_one = Uc_normalized_kep_one(sortIdx);

[xi_sa_one, sortIdx] = sort(xi_sa_one);
Uc_normalized_sa_one = Uc_normalized_sa_one(sortIdx);

[xi_komega_sst_one, sortIdx] = sort(xi_komega_sst_one);
Uc_normalized_komega_sst_one = Uc_normalized_komega_sst_one(sortIdx);

[xi_komega_geko_one, sortIdx] = sort(xi_komega_geko_one);
Uc_normalized_komega_geko_one = Uc_normalized_komega_geko_one(sortIdx);

[xi_rsm_lps_one, sortIdx] = sort(xi_rsm_lps_one);
Uc_normalized_rsm_lps_one = Uc_normalized_rsm_lps_one(sortIdx);

% Function to find the x value where y is approximately 1
function [x_at_y_one, min_y, max_y] = findXAtYOne(x, y)
    % Find indices where y is less than or equal to 1
    idx = find(y <= 1, 1, 'first');
    if isempty(idx)
        x_at_y_one = NaN;
    else
        x_at_y_one = x(idx);
    end
    min_y = min(y);
    max_y = max(y);
end

% Find x values where Uc/Uj is approximately 1 for each model
[x_kep_at_one, min_y_kep, max_y_kep] = findXAtYOne(xi_kep_one, Uc_normalized_kep_one);
[x_sa_at_one, min_y_sa, max_y_sa] = findXAtYOne(xi_sa_one, Uc_normalized_sa_one);
[x_komega_sst_at_one, min_y_komega_sst, max_y_komega_sst] = findXAtYOne(xi_komega_sst_one, Uc_normalized_komega_sst_one);
[x_komega_geko_at_one, min_y_komega_geko, max_y_komega_geko] = findXAtYOne(xi_komega_geko_one, Uc_normalized_komega_geko_one);
[x_rsm_lps_at_one, min_y_rsm_lps, max_y_rsm_lps] = findXAtYOne(xi_rsm_lps_one, Uc_normalized_rsm_lps_one);

% Print the potential core length values
fprintf('Potential Core Length Values (First ξ where Uc/Uj falls below 1):\n');
fprintf('K-Epsilon: %.4f\n', x_kep_at_one);
fprintf('Spalart-Allmaras: %.4f\n', x_sa_at_one);
fprintf('K-Omega SST: %.4f\n', x_komega_sst_at_one);
fprintf('K-Omega GEKO: %.4f\n', x_komega_geko_at_one);
fprintf('RSM-LPS: %.4f\n', x_rsm_lps_at_one);

%% Centreline Velocity Decay %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate actual potential core lengths
x_kep_actual = x_kep_at_one + 30;
x_sa_actual = x_sa_at_one + 30;
x_komega_sst_actual = x_komega_sst_at_one + 30;
x_komega_geko_actual = x_komega_geko_at_one + 30;
x_rsm_lps_actual = x_rsm_lps_at_one + 30;

% Normalize X and Uc using actual potential core lengths
xi_kep_actual = X_kep / x_kep_actual;
xi_kep_actual = vertcat(0, xi_kep_actual);
Uc_normalized_kep_actual = Uc_kep / Uj;
Uc_normalized_kep_actual = vertcat(1, Uc_normalized_kep_actual);

xi_sa_actual = X_sa / x_sa_actual;
xi_sa_actual = vertcat(0, xi_sa_actual);
Uc_normalized_sa_actual = Uc_sa / Uj;
Uc_normalized_sa_actual = vertcat(1, Uc_normalized_sa_actual);

xi_komega_sst_actual = X_komega_sst / x_komega_sst_actual;
xi_komega_sst_actual = vertcat(0, xi_komega_sst_actual);
Uc_normalized_komega_sst_actual = Uc_komega_sst / Uj;
Uc_normalized_komega_sst_actual = vertcat(1, Uc_normalized_komega_sst_actual);

xi_komega_geko_actual = X_komega_geko / x_komega_geko_actual;
xi_komega_geko_actual = vertcat(0, xi_komega_geko_actual);
Uc_normalized_komega_geko_actual = Uc_komega_geko / Uj;
Uc_normalized_komega_geko_actual = vertcat(1, Uc_normalized_komega_geko_actual);

xi_rsm_lps_actual = X_rsm_lps / x_rsm_lps_actual;
xi_rsm_lps_actual = vertcat(0, xi_rsm_lps_actual);
Uc_normalized_rsm_lps_actual = Uc_rsm_lps / Uj;
Uc_normalized_rsm_lps_actual = vertcat(1, Uc_normalized_rsm_lps_actual);

% Sort the data by xi values
[xi_kep_actual, sortIdx] = sort(xi_kep_actual);
Uc_normalized_kep_actual = Uc_normalized_kep_actual(sortIdx);

[xi_sa_actual, sortIdx] = sort(xi_sa_actual);
Uc_normalized_sa_actual = Uc_normalized_sa_actual(sortIdx);

[xi_komega_sst_actual, sortIdx] = sort(xi_komega_sst_actual);
Uc_normalized_komega_sst_actual = Uc_normalized_komega_sst_actual(sortIdx);

[xi_komega_geko_actual, sortIdx] = sort(xi_komega_geko_actual);
Uc_normalized_komega_geko_actual = Uc_normalized_komega_geko_actual(sortIdx);

[xi_rsm_lps_actual, sortIdx] = sort(xi_rsm_lps_actual);
Uc_normalized_rsm_lps_actual = Uc_normalized_rsm_lps_actual(sortIdx);

% Centreline Velocity Decay Plot with Actual Core Lengths
fig2 = figure;
hold on;

% K-Epsilon data
plot(xi_kep_actual, Uc_normalized_kep_actual, 'LineWidth', 2, 'DisplayName', 'k-\epsilon');

% Spalart-Allmaras data
plot(xi_sa_actual, Uc_normalized_sa_actual, 'LineWidth', 2, 'DisplayName', 'Spalart-Allmaras');

% K-Omega SST data
plot(xi_komega_sst_actual, Uc_normalized_komega_sst_actual, 'LineWidth', 2, 'DisplayName', 'SST k-\omega');

% K-Omega GEKO data
plot(xi_komega_geko_actual, Uc_normalized_komega_geko_actual, 'LineWidth', 2, 'DisplayName', 'k-\omega GEKO');

% RSM-LPS data
plot(xi_rsm_lps_actual, Uc_normalized_rsm_lps_actual, 'LineWidth', 2, 'DisplayName', 'RSM-LPS');

xlabel('\xi');
ylabel('U_c/U_j');
legend('show', 'Location', 'southoutside', 'Orientation', 'horizontal');
grid on;
hold off;

%% Normalized Radial Velocity Profile Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract radial positions and velocities

r_kep = kep_radial_fifty_data(:, 1);
U_radial_kep = kep_radial_fifty_data(:, 2);

r_sa = sa_radial_fifty_data(:, 1);
U_radial_sa = sa_radial_fifty_data(:, 2);

r_komega_sst = kosst_radial_fifty_data(:, 1);
U_radial_komega_sst = kosst_radial_fifty_data(:, 2);

r_komega_geko = koGEKO_radial_fifty_data(:, 1);
U_radial_komega_geko = koGEKO_radial_fifty_data(:, 2);

r_rsm_lps = rsm_radial_fifty_data(:, 1);
U_radial_rsm_lps = rsm_radial_fifty_data(:, 2);

% Extract reference radial positions and velocities
r_ref = Reference_radial_Maslov(:, 1);
U_radial_ref = Reference_radial_Maslov(:, 2);

% Function to ensure unique and sorted values
function [r_unique_sorted, U_unique_sorted] = ensure_unique_and_sorted(r, U)
    [U_unique, idx] = unique(U, 'stable');
    r_unique = r(idx);
    
    % Remove duplicates by averaging
    if length(U_unique) < length(U)
        [~, uniqueIdx] = unique(U, 'stable');
        U_unique = U(uniqueIdx);
        r_unique = r(uniqueIdx);
    end
    
    % Sort the values based on r
    [r_unique_sorted, sortIdx] = sort(r_unique);
    U_unique_sorted = U_unique(sortIdx);
end

% Remove duplicate points and sort
[r_kep, U_radial_kep] = ensure_unique_and_sorted(r_kep, U_radial_kep);
[r_sa, U_radial_sa] = ensure_unique_and_sorted(r_sa, U_radial_sa);
[r_komega_sst, U_radial_komega_sst] = ensure_unique_and_sorted(r_komega_sst, U_radial_komega_sst);
[r_komega_geko, U_radial_komega_geko] = ensure_unique_and_sorted(r_komega_geko, U_radial_komega_geko);
[r_rsm_lps, U_radial_rsm_lps] = ensure_unique_and_sorted(r_rsm_lps, U_radial_rsm_lps);

% Calculate U_max for each model
U_max_kep = max(U_radial_kep);
U_max_sa = max(U_radial_sa);
U_max_komega_sst = max(U_radial_komega_sst);
U_max_komega_geko = max(U_radial_komega_geko);
U_max_rsm_lps = max(U_radial_rsm_lps);

% Calculate r0.5 for each model
r0_5_kep = interp1(U_radial_kep(1:round(length(U_radial_kep)/2)), r_kep(1:round(length(U_radial_kep)/2)), U_max_kep / 2);
r0_5_sa = interp1(U_radial_sa(1:round(length(U_radial_sa)/2)), r_sa(1:round(length(U_radial_sa)/2)), U_max_sa / 2);
r0_5_komega_sst = interp1(U_radial_komega_sst(1:round(length(U_radial_komega_sst)/2)), r_komega_sst(1:round(length(U_radial_komega_sst)/2)), U_max_komega_sst / 2);
r0_5_komega_geko = interp1(U_radial_komega_geko(1:round(length(U_radial_komega_geko)/2)), r_komega_geko(1:round(length(U_radial_komega_geko)/2)), U_max_komega_geko / 2);
r0_5_rsm_lps = interp1(U_radial_rsm_lps(1:round(length(U_radial_rsm_lps)/2)), r_rsm_lps(1:round(length(U_radial_rsm_lps)/2)), U_max_rsm_lps / 2);

% Normalize radial distances and velocities
eta_kep = r_kep / r0_5_kep;
U_Umax_kep = U_radial_kep / U_max_kep;
U_mean_Umax_kep = mean(U_radial_kep) / U_max_kep;

eta_sa = r_sa / r0_5_sa;
U_Umax_sa = U_radial_sa / U_max_sa;
U_mean_Umax_sa = mean(U_radial_sa) / U_max_sa;

eta_komega_sst = r_komega_sst / r0_5_komega_sst;
U_Umax_komega_sst = U_radial_komega_sst / U_max_komega_sst;
U_mean_Umax_komega_sst = mean(U_radial_komega_sst) / U_max_komega_sst;

eta_komega_geko = r_komega_geko / r0_5_komega_geko;
U_Umax_komega_geko = U_radial_komega_geko / U_max_komega_geko;
U_mean_Umax_komega_geko = mean(U_radial_komega_geko) / U_max_komega_geko;

eta_rsm_lps = r_rsm_lps / r0_5_rsm_lps;
U_Umax_rsm_lps = U_radial_rsm_lps / U_max_rsm_lps;
U_mean_Umax_rsm_lps = mean(U_radial_rsm_lps) / U_max_rsm_lps;

% Function to compute RMSD
function rmsd = compute_rmsd(r_ref, U_ref, eta_model, U_model)
    % Interpolate model data onto reference r points
    U_model_interp = interp1(eta_model * max(r_ref), U_model, r_ref, 'linear', 'extrap');
    
    % Calculate squared differences
    squared_diffs = (U_ref - U_model_interp).^2;
    
    % Compute Mean Squared Error
    mse = mean(squared_diffs);
    
    % Compute Root Mean Square Deviation
    rmsd = sqrt(mse);
end

% Compute RMSD for each model
rmsd_kep = compute_rmsd(r_ref, U_radial_ref, eta_kep, U_Umax_kep);
rmsd_sa = compute_rmsd(r_ref, U_radial_ref, eta_sa, U_Umax_sa);
rmsd_komega_sst = compute_rmsd(r_ref, U_radial_ref, eta_komega_sst, U_Umax_komega_sst);
rmsd_komega_geko = compute_rmsd(r_ref, U_radial_ref, eta_komega_geko, U_Umax_komega_geko);
rmsd_rsm_lps = compute_rmsd(r_ref, U_radial_ref, eta_rsm_lps, U_Umax_rsm_lps);

% Display RMSD values
disp(['RMSD_Radial for K-Epsilon: ', num2str(rmsd_kep)]);
disp(['RMSD_Radial for Spalart-Allmaras: ', num2str(rmsd_sa)]);
disp(['RMSD_Radial for K-Omega SST: ', num2str(rmsd_komega_sst)]);
disp(['RMSD_Radial for K-Omega GEKO: ', num2str(rmsd_komega_geko)]);
disp(['RMSD_Radial for RSM-LPS: ', num2str(rmsd_rsm_lps)]);

% Calculate and display U_mean/U_max values
disp(['U_mean/U_max for K-Epsilon: ', num2str(U_mean_Umax_kep)]);
disp(['U_mean/U_max for Spalart-Allmaras: ', num2str(U_mean_Umax_sa)]);
disp(['U_mean/U_max for K-Omega SST: ', num2str(U_mean_Umax_komega_sst)]);
disp(['U_mean/U_max for K-Omega GEKO: ', num2str(U_mean_Umax_komega_geko)]);
disp(['U_mean/U_max for RSM-LPS: ', num2str(U_mean_Umax_rsm_lps)]);

% Plot normalized velocity profiles
fig3 = figure;
hold on;

% K-Epsilon data
plot(eta_kep, U_Umax_kep, 'LineWidth', 2, 'DisplayName', 'k-\epsilon');

% Spalart-Allmaras data
plot(eta_sa, U_Umax_sa, 'LineWidth', 2, 'DisplayName', 'Spalart-Allmaras');

% K-Omega SST data
plot(eta_komega_sst, U_Umax_komega_sst, 'LineWidth', 2, 'DisplayName', 'SST k-\omega');

% K-Omega GEKO data
plot(eta_komega_geko, U_Umax_komega_geko, 'LineWidth', 2, 'DisplayName', 'k-\omega GEKO');

% RSM-LPS data
plot(eta_rsm_lps, U_Umax_rsm_lps, 'LineWidth', 2, 'DisplayName', 'RSM-LPS');


% Reference data (already normalized)
plot(r_ref, U_radial_ref, 'r--', 'LineWidth', 2, 'DisplayName', 'Maslov et al');

% Set axis limits
x_limit = [0, 3];
y_limit = [0, 1];

xlim(x_limit);
ylim(y_limit);

% Set x-axis ticks to multiples of 1
xticks(0:1:ceil(max(x_limit)));

% Set y-axis ticks to multiples of 0.2 up to 1
yticks(0:0.2:1);

xlabel('\eta');
ylabel('U / U_{c}');
legend('Location', 'best');
grid on;
hold off;


%% Normalised Vertical Velocity Profile Data %%%%%%%%%%%%%%%%%%%%

% Extract vertical positions and velocities
y_kep = kep_vertical_data(:, 1);
U_vertical_kep = kep_vertical_data(:, 2);

y_sa = sa_vertical_data(:, 1);
U_vertical_sa = sa_vertical_data(:, 2);

y_komega_sst = komega_sst_vertical_data(:, 1);
U_vertical_komega_sst = komega_sst_vertical_data(:, 2);

y_komega_geko = komega_geko_vertical_data(:, 1);
U_vertical_komega_geko = komega_geko_vertical_data(:, 2);

y_rsm_lps = rsm_lps_vertical_data(:, 1);
U_vertical_rsm_lps = rsm_lps_vertical_data(:, 2);

% Load and extract Maslov data
y_maslov = Reference_vertical_Maslov(:, 2);
U_vertical_maslov = Reference_vertical_Maslov(:, 1);

% Define a function to remove duplicates and sort data
function [v_unique_sorted, U_unique_sorted] = unique_sorted(v, U)
    [U_unique, idx] = unique(U, 'stable');
    v_unique = v(idx);
    [v_unique_sorted, sortIdx] = sort(v_unique);
    U_unique_sorted = U_unique(sortIdx);
end

% Remove duplicate points and sort
[y_kep, U_vertical_kep] = unique_sorted(y_kep, U_vertical_kep);
[y_sa, U_vertical_sa] = unique_sorted(y_sa, U_vertical_sa);
[y_komega_sst, U_vertical_komega_sst] = unique_sorted(y_komega_sst, U_vertical_komega_sst);
[y_komega_geko, U_vertical_komega_geko] = unique_sorted(y_komega_geko, U_vertical_komega_geko);
[y_rsm_lps, U_vertical_rsm_lps] = unique_sorted(y_rsm_lps, U_vertical_rsm_lps);

% Calculate Uc_max for each model
Uc_max_kep = max(U_vertical_kep);
Uc_max_sa = max(U_vertical_sa);
Uc_max_komega_sst = max(U_vertical_komega_sst);
Uc_max_komega_geko = max(U_vertical_komega_geko);
Uc_max_rsm_lps = max(U_vertical_rsm_lps);
Uc_max_maslov = max(U_vertical_maslov);

% Calculate y0.5 for each model
y0_5_kep = interp1(U_vertical_kep, y_kep, Uc_max_kep / 2, 'linear', 'extrap');
y0_5_sa = interp1(U_vertical_sa, y_sa, Uc_max_sa / 2, 'linear', 'extrap');
y0_5_komega_sst = interp1(U_vertical_komega_sst, y_komega_sst, Uc_max_komega_sst / 2, 'linear', 'extrap');
y0_5_komega_geko = interp1(U_vertical_komega_geko, y_komega_geko, Uc_max_komega_geko / 2, 'linear', 'extrap');
y0_5_rsm_lps = interp1(U_vertical_rsm_lps, y_rsm_lps, Uc_max_rsm_lps / 2, 'linear', 'extrap');
y0_5_maslov = interp1(U_vertical_maslov, y_maslov, Uc_max_maslov / 2, 'linear', 'extrap');

% Normalize vertical distances and velocities
zeta_kep = (y_kep - min(y_kep)) / y0_5_kep;
U_Uc_kep = U_vertical_kep / Uc_max_kep;

zeta_sa = (y_sa - min(y_sa)) / y0_5_sa;
U_Uc_sa = U_vertical_sa / Uc_max_sa;

zeta_komega_sst = (y_komega_sst - min(y_komega_sst)) / y0_5_komega_sst;
U_Uc_komega_sst = U_vertical_komega_sst / Uc_max_komega_sst;

zeta_komega_geko = (y_komega_geko - min(y_komega_geko)) / y0_5_komega_geko;
U_Uc_komega_geko = U_vertical_komega_geko / Uc_max_komega_geko;

zeta_rsm_lps = (y_rsm_lps - min(y_rsm_lps)) / y0_5_rsm_lps;
U_Uc_rsm_lps = U_vertical_rsm_lps / Uc_max_rsm_lps;

zeta_maslov = (y_maslov - min(y_maslov)) / y0_5_maslov;
U_Uc_maslov = U_vertical_maslov / Uc_max_maslov;

% Compute U_mean for each model
U_mean_kep = mean(U_vertical_kep);
U_mean_sa = mean(U_vertical_sa);
U_mean_komega_sst = mean(U_vertical_komega_sst);
U_mean_komega_geko = mean(U_vertical_komega_geko);
U_mean_rsm_lps = mean(U_vertical_rsm_lps);
U_mean_maslov = mean(U_vertical_maslov);

% Compute U_mean/Uc for each model
U_mean_Uc_kep = U_mean_kep / Uc_max_kep;
U_mean_Uc_sa = U_mean_sa / Uc_max_sa;
U_mean_Uc_komega_sst = U_mean_komega_sst / Uc_max_komega_sst;
U_mean_Uc_komega_geko = U_mean_komega_geko / Uc_max_komega_geko;
U_mean_Uc_rsm_lps = U_mean_rsm_lps / Uc_max_rsm_lps;
U_mean_Uc_maslov = U_mean_maslov / Uc_max_maslov;

% Define colors for each dataset
color_kep = [0, 0.4470, 0.7410]; % Blue
color_sa = [0.8500, 0.3250, 0.0980]; % Red-Orange
color_komega_sst = [0.9290, 0.6940, 0.1250]; % Yellow
color_komega_geko = [0.4940, 0.1840, 0.5560]; % Purple
color_rsm_lps = [0.4660, 0.6740, 0.1880]; % Green
color_maslov = [0.6350, 0.0780, 0.1840]; % Dark Red

% Define a function to calculate RMSD
function rmsd = calculate_rmsd(U, zeta, U_ref, zeta_ref)
    % Interpolate reference data to match the zeta values of U
    U_interp = interp1(zeta_ref, U_ref, zeta, 'linear', 'extrap');
    % Calculate RMSD
    rmsd = sqrt(mean((U - U_interp).^2));
end

% Calculate RMSD for each model compared to Maslov reference
rmsd_kep = calculate_rmsd(U_Uc_kep, zeta_kep, U_Uc_maslov, zeta_maslov);
rmsd_sa = calculate_rmsd(U_Uc_sa, zeta_sa, U_Uc_maslov, zeta_maslov);
rmsd_komega_sst = calculate_rmsd(U_Uc_komega_sst, zeta_komega_sst, U_Uc_maslov, zeta_maslov);
rmsd_komega_geko = calculate_rmsd(U_Uc_komega_geko, zeta_komega_geko, U_Uc_maslov, zeta_maslov);
rmsd_rsm_lps = calculate_rmsd(U_Uc_rsm_lps, zeta_rsm_lps, U_Uc_maslov, zeta_maslov);

% Display RMSD values in the command window
fprintf('RMSD_Vertical K-Epsilon: %.4f\n', rmsd_kep);
fprintf('RMSD_Vertical Spalart-Allmaras: %.4f\n', rmsd_sa);
fprintf('RMSD_Vertical K-Omega SST: %.4f\n', rmsd_komega_sst);
fprintf('RMSD_Vertical K-Omega GEKO: %.4f\n', rmsd_komega_geko);
fprintf('RMSD_Vertical RSM-LPS: %.4f\n', rmsd_rsm_lps);

% Create the XY plot
fig4 = figure;
hold on;

% Plot each turbulence model's normalized vertical velocity profile
plot(U_Uc_kep, zeta_kep, 'Color', color_kep, 'LineWidth', 2, 'DisplayName', 'k-\epsilon');
plot(U_Uc_sa, zeta_sa, 'Color', color_sa, 'LineWidth', 2, 'DisplayName', 'Spalart-Allmaras');
plot(U_Uc_komega_sst, zeta_komega_sst, 'Color', color_komega_sst, 'LineWidth', 2, 'DisplayName', 'SST k-\omega');
plot(U_Uc_komega_geko, zeta_komega_geko, 'Color', color_komega_geko, 'LineWidth', 2, 'DisplayName', 'k-\omega GEKO');
plot(U_Uc_rsm_lps, zeta_rsm_lps, 'Color', color_rsm_lps, 'LineWidth', 2, 'DisplayName', 'RSM-LPS');

% Plot the Maslov data
plot(U_Uc_maslov, zeta_maslov, 'r--', 'LineWidth', 2, 'DisplayName', 'Maslov et al');

% Set axis limits
x_limit = [0, 1];
y_limit = [0, 3.4];

xlim(x_limit);
ylim(y_limit);

% Add labels, title, and legend
xlabel('U / U_c'); % Label for the x-axis
ylabel('\zeta'); % Label for the y-axis
title('Normalized Vertical Velocity Profiles for Different Turbulence Models');
legend('Location', 'best');
grid on;
hold off;


%% Normalised Velocity Profile Data %%%%%%%%%%%%%%%%%%%%
% Velocity Profile Normalised
Uc_normalized_kep = Uc_kep / Uj;
Uc_normalized_sa = Uc_sa / Uj;
Uc_normalized_komega_sst = Uc_komega_sst / Uj;
Uc_normalized_komega_geko = Uc_komega_geko / Uj;
Uc_normalized_rsm_lps = Uc_rsm_lps / Uj;

% Adjust X values by subtracting 30
X_kep_adjusted = X_kep - 30;
X_sa_adjusted = X_sa - 30;
X_komega_sst_adjusted = X_komega_sst - 30;
X_komega_geko_adjusted = X_komega_geko - 30;
X_rsm_lps_adjusted = X_rsm_lps - 30;

% Ensure data is sorted and complete
[X_kep_sorted, idx_kep] = sort(X_kep_adjusted);
Uc_normalized_kep_sorted = Uc_normalized_kep(idx_kep);

[X_sa_sorted, idx_sa] = sort(X_sa_adjusted);
Uc_normalized_sa_sorted = Uc_normalized_sa(idx_sa);

[X_komega_sst_sorted, idx_komega_sst] = sort(X_komega_sst_adjusted);
Uc_normalized_komega_sst_sorted = Uc_normalized_komega_sst(idx_komega_sst);

[X_komega_geko_sorted, idx_komega_geko] = sort(X_komega_geko_adjusted);
Uc_normalized_komega_geko_sorted = Uc_normalized_komega_geko(idx_komega_geko);

[X_rsm_lps_sorted, idx_rsm_lps] = sort(X_rsm_lps_adjusted);
Uc_normalized_rsm_lps_sorted = Uc_normalized_rsm_lps(idx_rsm_lps);

% Normalised Velocity Plot
fig5 = figure;
hold on;

% K-Epsilon data
plot(X_kep_sorted, Uc_normalized_kep_sorted, '-', 'LineWidth', 2, 'DisplayName', 'k-\epsilon');

% Spalart-Allmaras data
plot(X_sa_sorted, Uc_normalized_sa_sorted, '-', 'LineWidth', 2, 'DisplayName', 'Spalart-Allmaras');

% K-Omega SST data
plot(X_komega_sst_sorted, Uc_normalized_komega_sst_sorted, '-', 'LineWidth', 2, 'DisplayName', 'SST k-\omega');

% K-Omega GEKO data
plot(X_komega_geko_sorted, Uc_normalized_komega_geko_sorted, '-', 'LineWidth', 2, 'DisplayName', 'k-\omega GEKO');

% RSM-LPS data
plot(X_rsm_lps_sorted, Uc_normalized_rsm_lps_sorted, '-', 'LineWidth', 2, 'DisplayName', 'RSM-LPS');

xlabel('X/D');
ylabel('U_c/U_j');
legend('show');
grid on;
hold off;


%% Ground Temperature Profile Data %%%%%%%%%%%%%%%%%%%%

% K-Epsilon Temperature Data
temp_kep_data = load(gnd_temp_kep);
X_temp_kep = (temp_kep_data(:, 1) / D) - 30; % Normalize x-axis data and subtract 30
T_kep = temp_kep_data(:, 2) / Tj; % Normalize temperature data

% Spalart-Allmaras Temperature Data
temp_sa_data = load(gnd_temp_sa);
X_temp_sa = (temp_sa_data(:, 1) / D) - 30; % Normalize x-axis data and subtract 30
T_sa = temp_sa_data(:, 2) / Tj; 

% K-Omega SST Temperature Data
temp_komega_sst_data = load(gnd_temp_komega_sst);
X_temp_komega_sst = (temp_komega_sst_data(:, 1) / D) - 30; % Normalize x-axis data and subtract 30
T_komega_sst = temp_komega_sst_data(:, 2) / Tj; 

% K-Omega GEKO Temperature Data
temp_komega_geko_data = load(gnd_temp_komega_geko);
X_temp_komega_geko = (temp_komega_geko_data(:, 1) / D) - 30; % Normalize x-axis data and subtract 30
T_komega_geko = temp_komega_geko_data(:, 2) / Tj; 

% RSM-LPS Temperature Data
temp_rsm_lps_data = load(gnd_temp_rsm_lps);
X_temp_rsm_lps = (temp_rsm_lps_data(:, 1) / D) - 30; % Normalize x-axis data and subtract 30
T_rsm_lps = temp_rsm_lps_data(:, 2) / Tj;

% Sort data by X_temp_kep for K-Epsilon
[X_temp_kep_sorted, idx_kep] = sort(X_temp_kep);
T_kep_sorted = T_kep(idx_kep);

% Sort data by X_temp_sa for Spalart-Allmaras
[X_temp_sa_sorted, idx_sa] = sort(X_temp_sa);
T_sa_sorted = T_sa(idx_sa);

% Sort data by X_temp_komega_sst for K-Omega SST
[X_temp_komega_sst_sorted, idx_komega_sst] = sort(X_temp_komega_sst);
T_komega_sst_sorted = T_komega_sst(idx_komega_sst);

% Sort data by X_temp_komega_geko for K-Omega GEKO
[X_temp_komega_geko_sorted, idx_komega_geko] = sort(X_temp_komega_geko);
T_komega_geko_sorted = T_komega_geko(idx_komega_geko);

% Sort data by X_temp_rsm_lps for RSM-LPS
[X_temp_rsm_lps_sorted, idx_rsm_lps] = sort(X_temp_rsm_lps);
T_rsm_lps_sorted = T_rsm_lps(idx_rsm_lps);
% Ground Temperature Plot
fig6 = figure;
hold on;

% K-Epsilon Temperature Data
plot(X_temp_kep_sorted, T_kep_sorted, '-', 'LineWidth', 1.5, 'DisplayName', 'k-\epsilon');

% Spalart-Allmaras Temperature Data
plot(X_temp_sa_sorted, T_sa_sorted, '-', 'LineWidth', 1.5, 'DisplayName', 'Spalart-Allmaras');

% K-Omega SST Temperature Data
plot(X_temp_komega_sst_sorted, T_komega_sst_sorted, '-', 'LineWidth', 1.5, 'DisplayName', 'SST k-\omega');

% K-Omega GEKO Temperature Data
plot(X_temp_komega_geko_sorted, T_komega_geko_sorted, '-', 'LineWidth', 1.5, 'DisplayName', 'k-\omega GEKO');

% RSM-LPS Temperature Data
plot(X_temp_rsm_lps_sorted, T_rsm_lps_sorted, '-', 'LineWidth', 1.5, 'DisplayName', 'RSM-LPS');

xlabel('X/D');
ylabel('T_{g}/T_{j}');
legend('show', 'Location', 'southoutside', 'Orientation', 'horizontal');
grid on;
hold off;

% Find and display maximum temperature values and locations
[~, idx_max_kep] = max(T_kep_sorted);
max_temp_kep = T_kep_sorted(idx_max_kep);
location_max_temp_kep = X_temp_kep_sorted(idx_max_kep);
fprintf('K-Epsilon Max Temp_gnd: %.2f K/T_j at X/D = %.2f\n', max_temp_kep, location_max_temp_kep);

[~, idx_max_sa] = max(T_sa_sorted);
max_temp_sa = T_sa_sorted(idx_max_sa);
location_max_temp_sa = X_temp_sa_sorted(idx_max_sa);
fprintf('Spalart-Allmaras Max Temp_gnd: %.2f K/T_j at X/D = %.2f\n', max_temp_sa, location_max_temp_sa);

[~, idx_max_komega_sst] = max(T_komega_sst_sorted);
max_temp_komega_sst = T_komega_sst_sorted(idx_max_komega_sst);
location_max_temp_komega_sst = X_temp_komega_sst_sorted(idx_max_komega_sst);
fprintf('K-Omega SST Max Temp_gnd: %.2f K/T_j at X/D = %.2f\n', max_temp_komega_sst, location_max_temp_komega_sst);

[~, idx_max_komega_geko] = max(T_komega_geko_sorted);
max_temp_komega_geko = T_komega_geko_sorted(idx_max_komega_geko);
location_max_temp_komega_geko = X_temp_komega_geko_sorted(idx_max_komega_geko);
fprintf('K-Omega GEKO Max Temp_gnd: %.2f K/T_j at X/D = %.2f\n', max_temp_komega_geko, location_max_temp_komega_geko);

[~, idx_max_rsm_lps] = max(T_rsm_lps_sorted);
max_temp_rsm_lps = T_rsm_lps_sorted(idx_max_rsm_lps);
location_max_temp_rsm_lps = X_temp_rsm_lps_sorted(idx_max_rsm_lps);
fprintf('RSM-LPS Max Temp_gnd: %.2f K/T_j at X/D = %.2f\n', max_temp_rsm_lps, location_max_temp_rsm_lps);

%% Ground Radial Temperature Profile

% Load and process data
function [X, T] = load_and_normalize(file, Tj, D)
    data = load(file);
    X = data(:, 1) / D;   % Normalize radial coordinates
    T = data(:, 2) / Tj;  % Normalize temperature
end

% Load and sort data
[X_kep, T_kep] = load_and_normalize(gnd_temp_kep_radial_fifty, Tj, D);
[X_sa, T_sa] = load_and_normalize(gnd_temp_sa_radial_fifty, Tj, D);
[X_kosst, T_kosst] = load_and_normalize(gnd_temp_kosst_radial_fifty, Tj, D);
[X_koGEKO, T_koGEKO] = load_and_normalize(gnd_temp_koGEKO_radial_fifty, Tj, D);
[X_rsm, T_rsm] = load_and_normalize(gnd_temp_rsm_lps_radial_fifty, Tj, D);

% Sort data for smooth plotting
[X_kep_sorted, idx_kep] = sort(X_kep);
T_kep_sorted = T_kep(idx_kep);

[X_sa_sorted, idx_sa] = sort(X_sa);
T_sa_sorted = T_sa(idx_sa);

[X_kosst_sorted, idx_kosst] = sort(X_kosst);
T_kosst_sorted = T_kosst(idx_kosst);

[X_koGEKO_sorted, idx_koGEKO] = sort(X_koGEKO);
T_koGEKO_sorted = T_koGEKO(idx_koGEKO);

[X_rsm_sorted, idx_rsm] = sort(X_rsm);
T_rsm_sorted = T_rsm(idx_rsm);

% Plotting
fig7 = figure;
hold on;

% Plot data with lines only (no markers)
plot(X_kep_sorted, T_kep_sorted, '-', 'LineWidth', 1.5, 'DisplayName', 'k-\epsilon');
plot(X_sa_sorted, T_sa_sorted, '-', 'LineWidth', 1.5, 'DisplayName', 'Spalart-Allmaras');
plot(X_kosst_sorted, T_kosst_sorted, '-', 'LineWidth', 1.5, 'DisplayName', 'SST k-\omega');
plot(X_koGEKO_sorted, T_koGEKO_sorted, '-', 'LineWidth', 1.5, 'DisplayName', 'k-\omega GEKO');
plot(X_rsm_sorted, T_rsm_sorted, '-', 'LineWidth', 1.5, 'DisplayName', 'RSM-LPS');

% Labels and legend
xlabel('Z/D');
ylabel('T_g/T_j');
legend('show', 'Location', 'southoutside', 'Orientation', 'horizontal');
grid on;
hold off;

%% Ground Temperture Radial Profiles at Different X/D
% Define file names for each turbulence model and distance
kep_files = { ...
    gnd_temp_kep_radial_fifty, gnd_temp_kep_radial_hundred, ...
    gnd_temp_kep_radial_twohundred, gnd_temp_kep_radial_threehundred, ...
    gnd_temp_kep_radial_fourhundred, gnd_temp_kep_radial_fourseventy };

sa_files = { ...
    gnd_temp_sa_radial_fifty, gnd_temp_sa_radial_hundred, ...
    gnd_temp_sa_radial_twohundred, gnd_temp_sa_radial_threehundred, ...
    gnd_temp_sa_radial_fourhundred, gnd_temp_sa_radial_fourseventy };

kosst_files = { ...
    gnd_temp_kosst_radial_fifty, gnd_temp_kosst_radial_hundred, ...
    gnd_temp_kosst_radial_twohundred, gnd_temp_kosst_radial_threehundred, ...
    gnd_temp_kosst_radial_fourhundred, gnd_temp_kosst_radial_fourseventy };

koGEKO_files = { ...
    gnd_temp_koGEKO_radial_fifty, gnd_temp_koGEKO_radial_hundred, ...
    gnd_temp_koGEKO_radial_twohundred, gnd_temp_koGEKO_radial_threehundred, ...
    gnd_temp_koGEKO_radial_fourhundred, gnd_temp_koGEKO_radial_fourseventy };

rsm_files = { ...
    gnd_temp_rsm_lps_radial_fifty, gnd_temp_rsm_lps_radial_hundred, ...
    gnd_temp_rsm_lps_radial_twohundred, gnd_temp_rsm_lps_radial_threehundred, ...
    gnd_temp_rsm_lps_radial_fourhundred, gnd_temp_rsm_lps_radial_fourseventy };

% Reference temperature and distance
Tj = 354.3; % Reference temperature
D = 1;      % Reference distance

% Define radial distances for plotting
distances = [50, 100, 200, 300, 400, 470];

% Function to load, normalize, and sort data
function [X, T] = load_and_process(file, Tj, D)
    data = load(file);
    X = data(:, 1) / D;   % Normalize radial coordinates
    T = data(:, 2) / Tj;  % Normalize temperature
    
    % Sort data by X
    [X, sortIdx] = sort(X);
    T = T(sortIdx);
end

% List of subplot labels
subplot_labels = {'(a)', '(b)', '(c)', '(d)', '(e)'};

% List of turbulence models
models = {'k-epsilon', 'Spalart-Allmaras', 'K-Omega SST', 'K-Omega GEKO', 'RSM-LPS'};
file_sets = {kep_files, sa_files, kosst_files, koGEKO_files, rsm_files};

% Create the figure
fig8 = figure;
num_models = length(models);
ncols = 3; % Number of columns in the subplot grid
nrows = ceil(num_models / ncols); % Number of rows in the subplot grid

% Initialize an array to store plot handles for the legend
plot_handles = [];

% Plot each turbulence model in a subplot
for i = 1:num_models
    % Create subplot for the current model
    subplot(nrows, ncols, i);
    hold on;
    
    % Load and plot data for each distance
    file_set = file_sets{i};
    for j = 1:length(file_set)
        [X, T] = load_and_process(file_set{j}, Tj, D);
        h = plot(X, T, '-', 'LineWidth', 1.5, 'DisplayName', sprintf('%d D', distances(j)));
        
        % Store the plot handle from the first subplot for legend creation
        if i == 1
            plot_handles(j) = h;
        end
    end
    
    % Set x-axis limits
    xlim([-30, 30]);
    
    % Labels and title for each subplot
    xlabel('Z/D');
    ylabel('T_g/T_j');
    title(subplot_labels{i});
    grid on;
    hold off;
end

% Create a single legend for the entire figure
lgd = legend(plot_handles, 'Orientation', 'horizontal');

% Manually set the position of the legend below the "RSM-LPS" subplot
% Adjust these values to position the legend
lgd.Position = [0.35, 0.01, 0.3, 0.05]; 

% Print velocities at X = 0 for each turbulence model and distance
for i = 1:numel(models)
    fprintf('\n%s Model Velocities at X = 0:\n', models{i});
    file_set = file_sets{i};
    for j = 1:length(file_set)
        [X, T] = load_and_process(file_set{j}, Tj, D);
        
        % Find the index where X is closest to 0
        [~, idx_zero] = min(abs(X));
        
        % Print the temperature at X = 0
        fprintf('Distance %d D: T_g/T_j = %.2f\n', distances(j), T(idx_zero));
    end
end

%% Ground Friction Velocity %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_kep = load(wss_kep);
data_sa = load(wss_sa);
data_kosst = load(wss_kosst);
data_koGEKO = load(wss_koGEKO);
data_rsm = load(wss_rsm);

% Function to sort data, subtract 30 from X, calculate friction velocity, and normalize it
function [x_sorted, u_star_sorted, u_star_norm] = process_and_normalize_data(data, rho)
    x = data(:, 1) - 30; % Subtract 30 from X
    [x_sorted, sort_idx] = sort(x);
    tau_w_sorted = data(sort_idx, 2);
    u_star_sorted = sqrt(tau_w_sorted / rho);
    
    % Normalize the friction velocity
    max_u_star = max(u_star_sorted);
    u_star_norm = u_star_sorted / max_u_star;
end

% Process and normalize data for each model
[x_kep, u_star_kep, u_star_kep_norm] = process_and_normalize_data(data_kep, rho);
[x_sa, u_star_sa, u_star_sa_norm] = process_and_normalize_data(data_sa, rho);
[x_kosst, u_star_kosst, u_star_kosst_norm] = process_and_normalize_data(data_kosst, rho);
[x_koGEKO, u_star_koGEKO, u_star_koGEKO_norm] = process_and_normalize_data(data_koGEKO, rho);
[x_rsm, u_star_rsm, u_star_rsm_norm] = process_and_normalize_data(data_rsm, rho);

% Plot the normalized friction velocity against adjusted x-coordinates
fig9 = figure;
hold on;
plot(x_kep, u_star_kep_norm, 'LineWidth', 2, 'DisplayName', 'k-\epsilon');
plot(x_sa, u_star_sa_norm, 'LineWidth', 2, 'DisplayName', 'Spalart-Allmaras');
plot(x_kosst, u_star_kosst_norm, 'LineWidth', 2, 'DisplayName', 'SST k-\omega');
plot(x_koGEKO, u_star_koGEKO_norm, 'LineWidth', 2, 'DisplayName', 'k-\omega GEKO');
plot(x_rsm, u_star_rsm_norm, 'LineWidth', 2, 'DisplayName', 'RSM-LPS');

xlabel('X/D');
ylabel('u*/u*_{max}');
legend('show', 'Location', 'southoutside', 'Orientation', 'horizontal');
grid on;
hold off;

% Calculate and display maximum normalized friction velocity for each model
fprintf('Maximum Normalized Friction Velocities:\n');
fprintf('K-Epsilon: %.4f at X = %.4f\n', max(u_star_kep_norm), x_kep(find(u_star_kep_norm == max(u_star_kep_norm), 1)));
fprintf('Spalart-Allmaras: %.4f at X = %.4f\n', max(u_star_sa_norm), x_sa(find(u_star_sa_norm == max(u_star_sa_norm), 1)));
fprintf('K-Omega SST: %.4f at X = %.4f\n', max(u_star_kosst_norm), x_kosst(find(u_star_kosst_norm == max(u_star_kosst_norm), 1)));
fprintf('K-Omega GEKO: %.4f at X = %.4f\n', max(u_star_koGEKO_norm), x_koGEKO(find(u_star_koGEKO_norm == max(u_star_koGEKO_norm), 1)));
fprintf('RSM-LPS: %.4f at X = %.4f\n', max(u_star_rsm_norm), x_rsm(find(u_star_rsm_norm == max(u_star_rsm_norm), 1)));


%% Simulation Time for Each Turbulence Model %%%%%%%%%%%%%%%%%%%% 

% Extract hours and minutes using regular expressions
pattern = '(\d+)\s*hour[s]*\s*(\d+)\s*minute[s]*';
tokens_kep = regexp(time_kep, pattern, 'tokens', 'once');
tokens_sa = regexp(time_sa, pattern, 'tokens', 'once');
tokens_komega_sst = regexp(time_komega_sst, pattern, 'tokens', 'once');
tokens_komega_geko = regexp(time_komega_geko, pattern, 'tokens', 'once');
tokens_rsm_lps = regexp(time_rsm_lps, pattern, 'tokens', 'once');

% Convert extracted strings to numeric values
hours = cellfun(@(x) str2double(x{1}), {tokens_kep, tokens_sa, tokens_komega_sst, tokens_komega_geko, tokens_rsm_lps});
minutes = cellfun(@(x) str2double(x{2}), {tokens_kep, tokens_sa, tokens_komega_sst, tokens_komega_geko, tokens_rsm_lps});

% Calculate total time in minutes
total_minutes = hours * 60 + minutes;

% Plotting the bar graph
fig10 = figure;
bar(total_minutes);
set(gca, 'XTickLabel', {'k-\epsilon', 'Spalart-Allmaras', 'SST k-\omega', 'k-\omega GEKO', 'RSM LPS'});
ylabel('Total Time (minutes)');
grid on;

% Add a legend with location set to the bottom
legend({'Total Time'}, 'Location', 'southoutside', 'Orientation', 'horizontal');


%% Ground Friction Velocity Data %%%%%%%%%%%%%%%%%%%%
% Calculate Friction Velocity u_*
u_tau_kep = sqrt(tau_w_kep / rho);
u_tau_sa = sqrt(tau_w_sa / rho);
u_tau_komega_sst = sqrt(tau_w_komega_sst / rho);
u_tau_komega_geko = sqrt(tau_w_komega_geko / rho);
u_tau_rsm_lps = sqrt(tau_w_rsm_lps / rho);

% Models for plotting
models = {'k-\epsilon', 'Spalart-Allmaras', 'SST k-\omega', 'k-\omega GEKO', 'RSM-LPS'};
u_tau_values = [u_tau_kep, u_tau_sa, u_tau_komega_sst, u_tau_komega_geko, u_tau_rsm_lps];

% Plotting friction velocity u_tau as a bar graph
fig11 = figure;
bar(u_tau_values, 'FaceColor', [0.2, 0.6, 0.8]);
ylabel('Friction Velocity (u_*) [m/s]');
xticks(1:length(models));
xticklabels(models);
xtickangle(45);
grid on;

% Display numeric values on top of each bar
text(1:length(models), u_tau_values, compose('%.4f', u_tau_values), ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10);

% Adjust the figure to fit the text properly
set(gca, 'LooseInset', get(gca, 'TightInset'));

%% Radial Jet Spread %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the X/D values corresponding to each file
x = [100, 200, 300, 400, 470]; 
numFiles = length(kepsilon_rjs);
r0_5_kepsilon = zeros(1, numFiles);
r0_5_kosst = zeros(1, numFiles);
r0_5_koGEKO = zeros(1, numFiles);
r0_5_SA = zeros(1, numFiles);
r0_5_RSM = zeros(1, numFiles); % Array for RSM

% Function to calculate r0_5
function r0_5 = calculate_radial_half_width(fileName)
    data = load(fileName);
    radialCoordinate = data(:, 1);
    velocity = data(:, 2);
    
    % Filter out negative radial coordinates
    positiveIndices = radialCoordinate >= 0;
    radialCoordinate = radialCoordinate(positiveIndices);
    velocity = velocity(positiveIndices);
    
    % Handle duplicate velocities
    [uniqueVelocity, ~, idx] = unique(velocity);
    % Compute mean radial coordinates for each unique velocity
    meanRadialCoordinate = accumarray(idx, radialCoordinate, [], @mean);
    
    % Sort the unique velocity and corresponding mean radial coordinate values
    [sortedVelocity, sortIndex] = sort(uniqueVelocity);
    sortedRadialCoordinate = meanRadialCoordinate(sortIndex);
    
    % Find the maximum velocity
    vmax = max(sortedVelocity);
    
    % Compute the half maximum velocity
    v_half = vmax / 2;
    
    % Interpolate to find r0_5 where velocity is half of the maximum
    if v_half < min(sortedVelocity) || v_half > max(sortedVelocity)
        % Handle out-of-range cases
        r0_5 = NaN; % Assign NaN if v_half is out of the range
    else
        try
            r0_5 = interp1(sortedVelocity, sortedRadialCoordinate, v_half, 'linear');
        catch ME
            disp(['Interpolation error: ', ME.message]);
            r0_5 = NaN; % Assign NaN if interpolation fails
        end
    end
end

% Compute r0_5 values for each model
for i = 1:numFiles
    r0_5_kepsilon(i) = calculate_radial_half_width(kepsilon_rjs{i});
    r0_5_kosst(i) = calculate_radial_half_width(kosst_rjs{i});
    r0_5_koGEKO(i) = calculate_radial_half_width(koGEKO_rjs{i});
    r0_5_SA(i) = calculate_radial_half_width(SA_rjs{i});
    r0_5_RSM(i) = calculate_radial_half_width(RSM_rjs{i}); % Compute RSM
end

% Read and plot the reference data
referenceData = load(Reference_rjs{1});
referenceRadialCoordinate = referenceData(:, 1);
referenceVelocity = referenceData(:, 2);

% Plot the results
fig12 = figure;
hold on;
plot(x, r0_5_kepsilon, 'o-', 'LineWidth', 2, 'DisplayName', 'k-\epsilon');
plot(x, r0_5_SA, 's-', 'LineWidth', 2, 'DisplayName', 'Spalart-Allmaras');
plot(x, r0_5_kosst, 'd-', 'LineWidth', 2, 'DisplayName', 'SST k-\omega');
plot(x, r0_5_koGEKO, '^-', 'LineWidth', 2, 'DisplayName', 'k-\omega GEKO');
plot(x, r0_5_RSM, 'p-', 'LineWidth', 2, 'DisplayName', 'RSM-LPS');

% Plot the reference data
plot(referenceRadialCoordinate, referenceVelocity, 'ro', 'LineWidth', 2, 'DisplayName', 'Maslov et al');

% Configure plot appearance
xlabel('X/D');
ylabel('r_{0.5} / D');
title('Jet Spread Comparison');
legend('show');
grid on;

% Calculate the spreading rate dr0_5/dx for each model
spreadRate_kepsilon = diff(r0_5_kepsilon) ./ diff(x);
spreadRate_kosst = diff(r0_5_kosst) ./ diff(x);
spreadRate_koGEKO = diff(r0_5_koGEKO) ./ diff(x);
spreadRate_SA = diff(r0_5_SA) ./ diff(x);
spreadRate_RSM = diff(r0_5_RSM) ./ diff(x);

% Print the spreading rates to the terminal
disp('Spreading Rates (dr0_5/dx):');
disp('k-epsilon_radial:');
disp(spreadRate_kepsilon);

disp('SST k-omega_radial:');
disp(spreadRate_kosst);

disp('k-omega GEKO_radial:');
disp(spreadRate_koGEKO);

disp('Spalart-Allmaras_radial:');
disp(spreadRate_SA);

disp('RSM-LPS_radial:');
disp(spreadRate_RSM);
%% Vertical Jet Spread
% Define the X/D values corresponding to each file
x = [100, 200, 300, 400, 470]; % Ensure this matches the number of files
numFiles = length(kepsilon_vjs);

% Initialize arrays for y0_5 values
y0_5_kepsilon_vj = zeros(1, numFiles);
y0_5_kosst_vj = zeros(1, numFiles);
y0_5_koGEKO_vj = zeros(1, numFiles);
y0_5_SA_vj = zeros(1, numFiles);
y0_5_RSM_vj = zeros(1, numFiles);

% Function to calculate y0_5 for vertical jet spread
function y0_5 = calculate_vertical_half_width(fileName)
    data = load(fileName);
    verticalCoordinate = data(:, 1);
    velocity = data(:, 2);
    
    % Handle duplicate velocities
    [uniqueVelocity, ~, idx] = unique(velocity);
    % Compute mean vertical coordinates for each unique velocity
    meanVerticalCoordinate = accumarray(idx, verticalCoordinate, [], @mean);
    
    % Sort the unique velocity and corresponding mean vertical coordinate values
    [sortedVelocity, sortIndex] = sort(uniqueVelocity);
    sortedVerticalCoordinate = meanVerticalCoordinate(sortIndex);
    
    % Find the maximum velocity
    vmax = max(sortedVelocity);
    
    % Compute the half maximum velocity
    v_half = vmax / 2;
    
    % Interpolate to find y0_5 where velocity is half of the maximum
    if v_half < min(sortedVelocity) || v_half > max(sortedVelocity)
        % Handle out-of-range cases
        y0_5 = NaN; % Assign NaN if v_half is out of the range
    else
        try
            y0_5 = interp1(sortedVelocity, sortedVerticalCoordinate, v_half, 'linear');
        catch ME
            disp(['Interpolation error: ', ME.message]);
            y0_5 = NaN; % Assign NaN if interpolation fails
        end
    end
end

% Compute y0_5 values for each model
for i = 1:numFiles
    y0_5_kepsilon_vj(i) = calculate_vertical_half_width(kepsilon_vjs{i});
    y0_5_kosst_vj(i) = calculate_vertical_half_width(kosst_vjs{i});
    y0_5_koGEKO_vj(i) = calculate_vertical_half_width(koGEKO_vjs{i});
    y0_5_SA_vj(i) = calculate_vertical_half_width(SA_vjs{i});
    y0_5_RSM_vj(i) = calculate_vertical_half_width(RSM_vjs{i});
end

% Read and plot the reference data
referenceData_vj = load(Reference_vjs{1});
referenceVerticalCoordinate = referenceData_vj(:, 1);
referenceVelocity_vj = referenceData_vj(:, 2);

% Plot the results
fig13 = figure;
hold on;
plot(x, y0_5_kepsilon_vj, 'o-', 'LineWidth', 2, 'DisplayName', 'k-\epsilon');
plot(x, y0_5_SA_vj, 's-', 'LineWidth', 2, 'DisplayName', 'Spalart-Allmaras');
plot(x, y0_5_kosst_vj, 'd-', 'LineWidth', 2, 'DisplayName', 'SST k-\omega');
plot(x, y0_5_koGEKO_vj, '^-', 'LineWidth', 2, 'DisplayName', 'k-\omega GEKO');
plot(x, y0_5_RSM_vj, 'p-', 'LineWidth', 2, 'DisplayName', 'RSM-LPS');

% Plot the reference data
plot(referenceVerticalCoordinate, referenceVelocity_vj, 'ro', 'LineWidth', 2, 'DisplayName', 'Maslov et al');

% Configure plot appearance
xlabel('X/D');
ylabel('y_{0.5} / D');
legend('show');
grid on;


xlim([0 500]); 
ylim([0, 40]); 

% Calculate the spreading rate dy0_5/dx for each model
spreadRate_kepsilon_vj = diff(y0_5_kepsilon_vj) ./ diff(x);
spreadRate_kosst_vj = diff(y0_5_kosst_vj) ./ diff(x);
spreadRate_koGEKO_vj = diff(y0_5_koGEKO_vj) ./ diff(x);
spreadRate_SA_vj = diff(y0_5_SA_vj) ./ diff(x);
spreadRate_RSM_vj = diff(y0_5_RSM_vj) ./ diff(x);

% Print the spreading rates to the terminal
disp('Vertical Jet Spreading Rates (dy0_5/dx):');
disp('k-epsilon_vertical:');
disp(spreadRate_kepsilon_vj);

disp('SST k-omega_vertical:');
disp(spreadRate_kosst_vj);

disp('k-omega GEKO_vertical:');
disp(spreadRate_koGEKO_vj);

disp('Spalart-Allmaras_vertical:');
disp(spreadRate_SA_vj);

disp('RSM-LPS_vertical:');
disp(spreadRate_RSM_vj);

%% Aspect Ratio %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define the X/D values corresponding to each file
x = [100, 200, 300, 400, 470]; % Ensure this matches the number of files

% Initialize arrays to store r0_5 and y0_5 values for each model
r0_5 = struct();
y0_5 = struct();
ratio = struct();

% Load reference data
reference_data = load(AspectRatio_Reference);
ref_x = reference_data(:, 1); % X/D values
ref_ratio = reference_data(:, 2); % r0_5 / y0_5 ratios

% Define a function to calculate r0_5
function r0_5 = calculate_half_width(fileName)
    if ~isfile(fileName)
        warning(['File not found: ', fileName]);
        r0_5 = NaN; % Return NaN if file is not found
        return;
    end
    data = load(fileName);
    radialCoordinate = data(:, 1);
    velocity = data(:, 2);
    
    % Filter out negative radial coordinates
    positiveIndices = radialCoordinate >= 0;
    radialCoordinate = radialCoordinate(positiveIndices);
    velocity = velocity(positiveIndices);
    
    % Handle duplicate velocities
    [uniqueVelocity, ~, idx] = unique(velocity);
    % Compute mean radial coordinates for each unique velocity
    meanRadialCoordinate = accumarray(idx, radialCoordinate, [], @mean);
    
    % Sort the unique velocity and corresponding mean radial coordinate values
    [sortedVelocity, sortIndex] = sort(uniqueVelocity);
    sortedRadialCoordinate = meanRadialCoordinate(sortIndex);
    
    % Find the maximum velocity
    vmax = max(sortedVelocity);
    
    % Compute the half maximum velocity
    v_half = vmax / 2;
    
    % Interpolate to find r0_5 where velocity is half of the maximum
    if v_half < min(sortedVelocity) || v_half > max(sortedVelocity)
        % Handle out-of-range cases
        r0_5 = NaN; % Assign NaN if v_half is out of the range
    else
        try
            r0_5 = interp1(sortedVelocity, sortedRadialCoordinate, v_half, 'linear');
        catch ME
            disp(['Interpolation error: ', ME.message]);
            r0_5 = NaN; % Assign NaN if interpolation fails
        end
    end
end

% Define a function to calculate y0_5
function y0_5 = calculate_halfwidth(fileName)
    if ~isfile(fileName)
        warning(['File not found: ', fileName]);
        y0_5 = NaN; % Return NaN if file is not found
        return;
    end
    data = load(fileName);
    radialCoordinate = data(:, 1);
    velocity = data(:, 2);
    
    % Handle duplicate velocities
    [uniqueVelocity, ~, idx] = unique(velocity);
    % Compute mean radial coordinates for each unique velocity
    meanRadialCoordinate = accumarray(idx, radialCoordinate, [], @mean);
    
    % Sort the unique velocity and corresponding mean radial coordinate values
    [sortedVelocity, sortIndex] = sort(uniqueVelocity);
    sortedRadialCoordinate = meanRadialCoordinate(sortIndex);
    
    % Find the maximum velocity
    vmax = max(sortedVelocity);
    
    % Compute the half maximum velocity
    v_half = vmax / 2;
    
    % Interpolate to find y0_5 where velocity is half of the maximum
    if v_half < min(sortedVelocity) || v_half > max(sortedVelocity)
        % Handle out-of-range cases
        y0_5 = NaN; % Assign NaN if v_half is out of the range
    else
        try
            y0_5 = interp1(sortedVelocity, sortedRadialCoordinate, v_half, 'linear');
        catch ME
            disp(['Interpolation error: ', ME.message]);
            y0_5 = NaN; % Assign NaN if interpolation fails
        end
    end
end

% Compute r0_5 and y0_5 values for each model
models = {'sa', 'kosst', 'koGEKO', 'kepsilon'}; % Exclude 'rsm'
file_names_aspect = {sa_aspect, kosst_aspect, kogeko_aspect, kepsilon_aspect}; % Exclude 'rsm'
file_names_vertical = {SA_vjs, kosst_vjs, koGEKO_vjs, kepsilon_vjs}; % Exclude 'rsm'

for m = 1:length(models)
    for i = 1:length(x)
        % Use try-catch to handle any potential file loading issues
        try
            if i <= length(file_names_aspect{m})
                r0_5.(models{m})(i) = calculate_half_width(file_names_aspect{m}{i});
            else
                r0_5.(models{m})(i) = NaN; % If not enough files, assign NaN
            end

            if i <= length(file_names_vertical{m})
                y0_5.(models{m})(i) = calculate_halfwidth(file_names_vertical{m}{i});
            else
                y0_5.(models{m})(i) = NaN; % If not enough files, assign NaN
            end
        catch ME
            disp(['Error processing file for ', models{m}, ' at index ', num2str(i), ': ', ME.message]);
            r0_5.(models{m})(i) = NaN;
            y0_5.(models{m})(i) = NaN;
        end
    end
    % Compute the ratio r0_5 / y0_5 for each model
    ratio.(models{m}) = r0_5.(models{m}) ./ y0_5.(models{m});
    
    % Check for length consistency
    if length(x) ~= length(r0_5.(models{m})) || length(x) ~= length(y0_5.(models{m})) || length(x) ~= length(ratio.(models{m}))
        warning(['Mismatch between X/D values and computed r0_5, y0_5, or ratio values for ', models{m}, '.']);
    end
end

% Plot the results
fig14 = figure;
hold on;

% Define marker styles and line widths for each model
markers = {'s-', 'd-', '^-', 'o-'}; % Square, Diamond, Triangle, Circle (excluding 'RSM-LPS')
lineWidth = 1.5; % Slightly thicker line width
legendNames = {'k-\epsilon', 'Spalart-Allmaras', 'SST k-\omega', 'k-\omega GEKO'}; % Exclude 'RSM-LPS'

for m = 1:length(models)
    if isfield(ratio, models{m})
        plot(x, ratio.(models{m}), markers{m}, 'LineWidth', lineWidth, 'DisplayName', legendNames{m});
    end
end

% Plot the reference data as discrete dots only
plot(ref_x, ref_ratio, 'ro', 'MarkerSize', 8, 'LineWidth', 2, 'DisplayName', 'Maslov et al');

% Configure plot appearance
xlabel('X/D');
ylabel('r_{0.5} / y_{0.5}');
xlim([0 500]);
ylim([0 6]); 
legend show; 
grid on;
hold off;

%% Self Similar Radial Profile
% List of turbulence models
models = {'k-epsilon', 'SA', 'Kosst', 'KoGEKO', 'RSM'};
all_files = {kepsilon_aspect, sa_aspect, kosst_aspect, kogeko_aspect, rsm_aspect};

% Manually define custom legend labels for each turbulence model
legend_labels = {
    '100D', '200D', '300D', '400D', '470D'; % k-epsilon
    '100D', '200D', '300D', '400D', '470D'; % SA
    '100D', '200D', '300D', '400D', '470D'; % Kosst
    '100D', '200D', '300D', '400D', '470D'; % KoGEKO
    '100D', '200D', '300D', '400D', '470D'  % RSM
};

% Initialize a figure for subplots
figure;

% Number of models
num_models = length(models);

% Alphabet labels for subplots
alphabet_labels = 'abcdefghijklmnopqrstuvwxyz';

% Loop through each turbulence model
for m = 1:num_models
    % Get file list for current turbulence model
    files = all_files{m};
    
    % Create a subplot for the current turbulence model
    subplot(num_models, 1, m);
    hold on;
    
    % Get custom legend labels for the current turbulence model
    current_legend_labels = legend_labels(m, :); % Correct indexing
    
    % Initialize a cell array to store plot handles for legend
    plot_handles = [];
    
    % Loop through each file for the current turbulence model
    for i = 1:length(files)
        % Load data from the current file
        data = load(files{i});
        
        % Extract columns
        r = data(:,1);  % Radial distance
        U = data(:,2);  % Velocity
        
        % Sort data by radial distance r
        [r, sort_idx] = sort(r);
        U = U(sort_idx);
        
        % Normalize velocity by maximum velocity
        Umax = max(U);
        U_norm = U / Umax;
        
        % Calculate r0.5 (distance where velocity is half the maximum value)
        U_half_max = Umax / 2;
        
        % Find r0.5
        r0_5_index = find(U_norm >= 0.5, 1, 'first');
        if ~isempty(r0_5_index)
            r0_5 = r(r0_5_index);
        else
            r0_5 = NaN; % Handle case where no valid r0_5 is found
        end
        
        % Plot self-similar profile for this dataset
        if ~isnan(r0_5)
            % Store plot handle for legend
            h = plot(r / r0_5, U_norm, 'LineWidth', 2);
            plot_handles = [plot_handles, h];
        else
            warning('r0.5 could not be determined for file: %s', files{i});
        end
    end
    
    % Customize the plot for the current turbulence model
    xlabel('r / r_{0.5}');
    ylabel('U / U_{c}');
    
    % Add legend with custom labels
    legend(plot_handles, current_legend_labels, 'Location', 'best'); % Create legend with custom labels
    
    % Add subplot label
    text(-0.1, 1.1, sprintf('(%c)', alphabet_labels(m)), 'Units', 'normalized', 'FontSize', 12, 'FontWeight', 'bold');
    
    % Ensure that legend is not obscured
    axis tight; % Adjust axis limits
    grid on;
    hold off; % Release the hold for future plots
end



%% JPEG Plot Names
%save_figure(fig1, 'Potential_Core_Length.jpeg', output_folder);
%save_figure(fig2, 'Centerline_Velocity_Decay.jpeg', output_folder);
%save_figure(fig3, 'Normalized_Radial_Velocity.jpeg', output_folder);
%save_figure(fig4, 'Normalized_Vertical_Velocity.jpeg', output_folder);
%save_figure(fig5, 'Normalized_Radial_Velocity.jpeg', output_folder);
%save_figure(fig6, 'Ground_Temperature.jpeg', output_folder);
%save_figure(fig7, 'Ground_Temperature_Radial_Profile.jpeg', output_folder);
%save_figure(fig8, 'GroundTemperatureRadialatDifferentX/D.jpeg', output_folder);
%save_figure(fig9, 'Ground_Friction_Velocity.jpeg', output_folder);
%save_figure(fig10, 'Simulation_Runtime.jpeg', output_folder);
%save_figure(fig11, 'Friction_Velocity.jpeg', output_folder);
%save_figure(fig12, 'Radial_Jet_Spread.jpeg', output_folder);
%save_figure(fig13, 'Vertical_Jet_Spread.jpeg', output_folder);
%save_figure(fig14, 'Aspect_Ratio.jpeg', output_folder);
%save_figure(fig15, 'Self_Similar.jpeg', output_folder);
