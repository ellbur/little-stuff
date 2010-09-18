
% Approximate field strength [1]
B = 50e-6 % Tesla

% Equatorial radius of earth [1]
Rad = 6378e+3 % meters

% Average time for field reversal [2]
T = 250 * 365 * 3600 % seconds

Area = pi * Rad^2
Flux = B * Area
Emf  = 2*Flux/T % 2x b/c reverses

% 5cm-thick copper cable [1]
Cable_Rad   = 5e-2
Cable_Area  = pi * Cable_Rad^2
Resistivity = 1.7e-8 % Ohm*meter

L = 2*pi*Rad
Res = Resistivity * L / Cable_Area
I = Emf / Res
Power = Emf^2 / Res

% Heating the cable [1]
Spec_Heat =  384 % J/(kg*K)
Density   = 8920 % kg/m^3

Volume = L * Cable_Area
Mass = Volume * Density
Heat_Capacity = Mass * Spec_Heat

Heating_Rate = Power / Heat_Capacity

% Sources
% [1] Wolfram Alpha
% [2] http://en.wikipedia.org/wiki/Earth's_magnetic_field

