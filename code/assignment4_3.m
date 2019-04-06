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


G = zeros (5,5);
C = zeros (5,5);
B = zeros (5,1);

%Stamp the components
MyVoltageSource ( 0,1,1);
Myresistor(1,2,1);
Myresistor(0,2,2);
Myresistor(0,3,10);
Myresistor(4,5,0.1);
Myresistor(0,5,1000);
Mycapacitor (1,2,0.25);
Mycapacitor (3,0,0.00001);
Myinductor (2,3,0.2);
MyVoltageControlledSource(4,0,3,0,100/10);
Mycurrentsource (3,0,0.001);




G
C
B


h = 1/1000;
time = linspace(0,1,1000);
distribution = makedist('normal','mu',.06,'sigma', 0.03);
pulseFunction = pdf(distribution, time);
pulse3 = pulseFunction/max(pulseFunction);

bn=zeros(length(B));
bn1=zeros(length(B));
xn=zeros(length(B));
vout1 = zeros(1,1000);
vout = zeros(1,1000);



%AC Sweep
for n=2:1000
    
    %Trapezoidal Rule
    bn1(6) = pulse3(n);
    bn(6) = pulse3(n-1);
    trap =(2*C/h-G)*xn+bn1+bn;
    xn1=(2*C/h + G)\trap;
    vout1(n) = xn(5)*2;
    xn = xn1;
    
    vout(n-1) = xn(5);
end

vout(n) = xn(5);

figure(1)
subplot(3,1,1)
plot(time,pulse3,time,vout)
title('Input vs. Output')
legend('Voltage In', 'Voltage Out (V5)');


subplot(3,1,2)
plot(abs(fftshift(fft(pulse3))))
title('FFT of Vin')

subplot(3,1,3)
plot(abs(fftshift(fft(vout))))
title('FFT of Vout')



randCurrent = randn(1,1000)*.001;
% randCurrent = randCurrent/max(randCurrent);

figure(2)
subplot(2,1,1)
histogram (randCurrent);
title ('Distribution of Noise Current')
xlabel('Current (A)'); 


h = 1/1000;
time = linspace(0,1,1000);
distribution = makedist('normal','mu',0.4,'sigma', 0.03);
pulseFunction = pdf(distribution, time);
pulse3 = pulseFunction/max(pulseFunction);

bn=zeros(length(B));
bn1=zeros(length(B));
xn=zeros(length(B));
vout1 = zeros(1,1000);
vout = zeros(1,1000);
omega = logspace (0, 5 ,20000);




%AC Sweep
for n=2:1000
    
    %Trapezoidal Rule
    bn(3) = randCurrent(n);
    bn1(6) = pulse3(n);
    bn(6) = pulse3(n-1);
    trap =(2*C/h-G)*xn+bn1+bn;
    xn1=(2*C/h + G)\trap;
    vout1(n) = xn(5)*2;
    xn = xn1;
    
    vout(n-1) = xn(5);
end

vout(n) = xn(5);

figure(2)
subplot(2,1,2)
plot(time,pulse3,time,vout)
title('Input vs. Output')
legend('Voltage In', 'Voltage Out (V5)');
xlabel ('Time (s)'); ylabel('Voltage (V)');






F = zeros(8,1);
F(7) = 1;

for w = 1:length(omega)
    V2  = (G + ((1i*omega(w)).*C))\F; 
    vout2(w) = V2(5);
end
gain = 20*log10(vout2);


figure (3)
semilogx (omega, vout2);
title ('V0 as a Function of Omega')
xlabel ('Omega (rads)'); ylabel('Voltage (V)')
grid on;

figure (4)
semilogx (omega, gain);
title ('Gain of Circuit')
xlabel ('Omega (rads)'); ylabel('Gain (dB)')
grid on;


