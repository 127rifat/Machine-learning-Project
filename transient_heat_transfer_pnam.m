% Transient simulation of 1D hydrogel insulation for HVAC using variable boundary conditions
clc; clear;

% Defining a 1D Thermal Model
thermalModel = createpde('thermal', 'transient'); % Initializes a transient thermal model

% Set the Geometry (1D Slab of Insulation)
% Define a simple rectangular slab for insulation (0 to 0.1m in x-direction)
R1 = [3; 4; 0; 0.1; 0.1; 0; 0; 0; 0.05; 0.05]; % Define a rectangle (10cm width, 5cm height)
gdm = R1;
g = decsg(gdm); % Convert geometry description to proper format
geometryFromEdges(thermalModel, g); % Assign geometry to the thermal model

% Generate Mesh (Fix for Mesh Error)
generateMesh(thermalModel, 'Hmax', 0.01); % Mesh size set to 0.01m (1cm)

% Define Material Properties (Hydrogel Insulation)
thermalProperties(thermalModel, 'ThermalConductivity', 0.5, ...  % W/m·K
                               'MassDensity', 900, ...          % kg/m³
                               'SpecificHeat', 2500);           % J/kg·K

% Apply Boundary Conditions: One side at 20°C, Other side dynamically varying
externalTemp = @(region, state) 20 + 5 * abs(sin(state.time / 100)); %+ 8 % Varies between 20°C and 25°C
thermalBC(thermalModel, 'Edge', 1, 'Temperature', 20);
thermalBC(thermalModel, 'Edge', 2, 'Temperature', externalTemp);

% Define Initial Temperature
thermalIC(thermalModel, 20);

% Solve for Temperature Over Time
tlist = linspace(0, 3000, 400); % Increased time resolution
thermalResults = solve(thermalModel, tlist);

% Extract Temperature Data for ML Training
T = thermalResults.Temperature;
inner_surface_temp = T(1,:); % Inner surface temperature
outer_surface_temp = T(end,:); % Outer surface temperature

% Store Data in Table
thermalData = table(tlist(:), inner_surface_temp(:), outer_surface_temp(:), ...
    'VariableNames', {'Time', 'Inner_Temperature', 'Outer_Temperature'});

% Save Data to CSV for Machine Learning
writetable(thermalData, 'thermal_data.csv');

% Visualize Results
figure;
plot(tlist, inner_surface_temp, 'r', 'LineWidth', 2);
hold on;
plot(tlist, outer_surface_temp, 'b', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Temperature (°C)');
legend('Inner Surface', 'Outer Surface');
title('Temperature Profile Across Hydrogel Insulation');
grid on;

% Multiple Simulations with Different Thicknesses
thicknessValues = linspace(0.01, 0.12, 12);
 % Test 5cm, 10cm, 20cm insulation
allResults = [];
for i = 1:length(thicknessValues)
    % Define a new Thermal Model for each simulation
    thermalModel = createpde('thermal', 'transient');
    
    % Modify Geometry for Different Thicknesses
    R1 = [3; 4; 0; thicknessValues(i); thicknessValues(i); 0; 0; 0; 0.05; 0.05];
    g = decsg(R1);
    geometryFromEdges(thermalModel, g);
    generateMesh(thermalModel, 'Hmax', 0.01);
    
    % Define Material Properties
    thermalProperties(thermalModel, 'ThermalConductivity', 0.5, ...
                                   'MassDensity', 900, ...
                                   'SpecificHeat', 2500);
    
    % Apply Boundary Conditions
    thermalBC(thermalModel, 'Edge', 1, 'Temperature', 20);
    thermalBC(thermalModel, 'Edge', 2, 'Temperature', externalTemp);
    
    % Define Initial Temperature
    thermalIC(thermalModel, 20);
    
    % Solve Again
    thermalResults = solve(thermalModel, tlist);
    
    % Store Data
    T = thermalResults.Temperature;
    tempData = table(repmat(thicknessValues(i), length(tlist), 1), tlist(:), T(end,:)', ...
        'VariableNames', {'Thickness', 'Time', 'Outer_Temperature'});
    allResults = [allResults; tempData];
end

% Save Multi-Thickness Data
writetable(allResults, 'multi_thickness_thermal_data.csv');

% Visualize Effect of Insulation Thickness
figure;
hold on;
for i = 1:length(thicknessValues)
    idx = allResults.Thickness == thicknessValues(i);
    plot(allResults.Time(idx), allResults.Outer_Temperature(idx), 'DisplayName', ['Thickness ' num2str(thicknessValues(i)) 'm']);
end
xlabel('Time (s)');
ylabel('Outer Surface Temperature (°C)');
legend;
title('Effect of Insulation Thickness on Temperature');
grid on;
hold off;

