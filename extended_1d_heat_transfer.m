% Extended simulation for various hydrogel insulation thicknesses and dynamic temperature profiles
clc; clear;

% Define simulation time
tlist = linspace(0, 3000, 400);

% Thermal properties
thermalConductivity = 0.5;
density = 900;
specificHeat = 2500;

% Thickness and temperature variations
thicknessValues = linspace(0.01, 0.15, 20);
tempProfiles = {@(t) 20 + 5 * abs(sin(t / 100)), @(t) 20 + 5 * cos(t / 150), ...
                @(t) 25 * (t > 1500) + 20 * (t <= 1500)};
tempLabels = {'sin', 'cos', 'step'};

% Output
allResults = [];

for p = 1:length(tempProfiles)
    extTemp = tempProfiles{p};

    for i = 1:length(thicknessValues)
        L = thicknessValues(i);
        thermalModel = createpde('thermal', 'transient');
        
        R1 = [3;4;0;L;L;0;0;0;0.05;0.05]; % 1D slab geometry
        g = decsg(R1);
        geometryFromEdges(thermalModel, g);
        generateMesh(thermalModel, 'Hmax', 0.01);
        
        thermalProperties(thermalModel, 'ThermalConductivity', thermalConductivity, ...
            'MassDensity', density, 'SpecificHeat', specificHeat);
        
        thermalBC(thermalModel, 'Edge', 1, 'Temperature', 20);
        thermalBC(thermalModel, 'Edge', 2, 'Temperature', @(region, state) extTemp(state.time));
        thermalIC(thermalModel, 20);
        
        results = solve(thermalModel, tlist);
        T = results.Temperature;

        tempData = table(...
            repmat(L, length(tlist), 1), ...
            tlist(:), ...
            T(end,:)', ...
            repmat(tempLabels(p), length(tlist), 1), ...
            'VariableNames', {'Thickness', 'Time', 'Outer_Temperature', 'Profile'});
        
        allResults = [allResults; tempData];
    end
end

% Save
writetable(allResults, 'extended_thermal_data.csv');
disp("✅ Extended simulation data saved to extended_thermal_data.csv");
