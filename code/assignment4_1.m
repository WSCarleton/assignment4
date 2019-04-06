clearvars
clear
clc
clearvars -GLOBAL
close all
format shorte

global C
global G
global B

C.q_0 = 1.60217653e-19;             % electron charge
C.hb = 1.054571596e-34;             % Dirac constant
C.h = C.hb * 2 * pi;                % Planck constant
C.m_0 = 9.10938215e-31;             % electron mass
C.kb = 1.3806504e-23;               % Boltzmann constant
C.eps_0 = 8.854187817e-12;          % vacuum permittivity
C.mu_0 = 1.2566370614e-6;           % vacuum permeability
C.c = 299792458;                    % speed of light
C.g = 9.80665;                      %metres (32.1740 ft) per s²
C.am = 1.66053892e-27;

vin = zeros (0, 21);
vout = zeros (0,21);
vout2 = zeros (0,11);
v3 = zeros(0,21);
omega = logspace (0, 5 ,20000);
numCaps = 10000;
vout4 = zeros(1,numCaps);
gainVector = zeros(1,numCaps);


%Part a) starts here
for i = -10 : 10

    G = zeros (5,5);
    C = zeros (5,5);
    B = zeros (5,1);

    Myresistor(1,2,1);
    Myresistor(0,2,2);
    Myresistor(0,3,10);
    Myresistor(4,5,0.1);
    Myresistor(0,5,1000);
    Mycapacitor (1,2,0.25);
    Myinductor (2,3,0.2);
    MyVoltageSource ( 0,1,i);
    MyVoltageControlledSource(4,0,3,0,100/10);

    Voltage = G\B;
    
    vin(i+11) = i;
    vout(i+11) = Voltage(5);
    v3(i+11) = Voltage(3);

end

figure(1)
plot (vin, vout,vin, v3);
xlabel('Vin (V)'); ylabel('Vout (V)');
title ('Voltage from MNA Simulation');
grid on;
legend('Voltage Out (V5)', 'Voltage at Node 3 (V3)');





%Part b) starts here
F = zeros(8,1);
F(7) = 1;

for w = 1:length(omega)
    V2  = (G + ((1i*omega(w)).*C))\F; 
    vout2(w) = V2(5);
end
gain = 20*log10(vout2);


figure (2)
semilogx (omega, vout2);
title ('V0 as a Function of Omega')
xlabel ('Omega (rads)'); ylabel('Voltage (V)')
grid on;

figure (3)
semilogx (omega, gain);
title ('Gain of Circuit')
xlabel ('Omega (rads)'); ylabel('Gain (dB)')
grid on;




%Part c) starts here
a = .05;
b = .25;
capacitorValues = a.*randn(numCaps,1) + b;

for i = 1 : numCaps

    G = zeros (5,5);
    C = zeros (5,5);
    B = zeros (5,1);

    Myresistor(1,2,1);
    Myresistor(0,2,2);
    Myresistor(0,3,10);
    Myresistor(4,5,0.1);
    Myresistor(0,5,1000);

    Mycapacitor (1,2,capacitorValues(i));

    Myinductor (2,3,0.2);

    MyVoltageSource ( 0,1,i);

    MyVoltageControlledSource(4,0,3,0,100/10);

    V4  = (G + ((1i*3.141592654).*C))\F; 
    vout4(i) = V4(5);    
    gainVector(i) = 20*log10(vout4(i));

end


figure(4)
histogram (abs(gainVector), 40);
title('Gain as a Result of Pertibations in Capacitance Value');
xlabel('Gain of Circuit'); ylabel('Number of Capacitance Values');

