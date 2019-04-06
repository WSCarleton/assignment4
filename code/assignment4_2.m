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
Myinductor (2,3,0.2);
MyVoltageControlledSource(4,0,3,0,100/10);


h = 1/1000;
bn=zeros(length(B));
bn1=zeros(length(B));
xn=zeros(length(B));
time = linspace(0,1,1000);
pulse = zeros(1,1000);
vout1 = zeros(1,1000);
vin = zeros(1,1000);
vout = zeros(1,1000);

C
G

%DC Sweep Input
for n=2:1000
    for n2 = 1:1000
        if time(n2)<0.03
            pulse(n2) = 0;
        else
            pulse(n2) = 1;
        end
    end
    %Trapezoid
    bn1(6) = pulse(n);
    bn(6) = pulse(n-1);
    trap =(2*C/h-G)*xn+bn1+bn;
    xn1=(2*C/h + G)\trap;
    vout1(n) = xn(5)*2;
    xn = xn1;
    
    vout(n-1) = xn(5);
end

vout(n) = xn(5);

figure(1)
subplot(3,1,1)
plot(time,pulse,time,vout)
title('Input vs. Output')
legend('Voltage In', 'Voltage Out (V5)');
xlabel ('Time (s)'); ylabel('Voltage (V)');


subplot(3,1,2)
plot(abs(fftshift(fft(pulse))))
title('FFT of Vin')

subplot(3,1,3)
plot(abs(fftshift(fft(vout))))
title('FFT of Vout')




pulse2 = zeros(1,1000);

%AC Sweep
for n=2:1000
    for n2 = 1:1000
        pulse2(n2) = sin(2*pi*(1/0.03)*time(n2));
    end
    %Trapezoid
    bn1(6) = pulse2(n);
    bn(6) = pulse2(n-1);
    trap =(2*C/h-G)*xn+bn1+bn;
    xn1=(2*C/h + G)\trap;
    vout1(n) = xn(5)*2;
    xn = xn1;
    
    vout(n-1) = xn(5);
end

vout(n) = xn(5);

figure(2)
subplot(3,1,1)
plot(time,pulse2,time,vout)
title('Input vs. Output')
legend('Voltage In', 'Voltage Out (V5)');
xlabel ('Time (s)'); ylabel('Voltage (V)');


subplot(3,1,2)
plot(abs(fftshift(fft(pulse2))))
title('FFT of Vin')

subplot(3,1,3)
plot(abs(fftshift(fft(vout))))
title('FFT of Vout')



distribution = makedist('normal','mu',.06,'sigma', 0.03);
pulseFunction = pdf(distribution, time);
pulse3 = pulseFunction/max(pulseFunction);




%AC Sweep
for n=2:1000
    
    %Trapezoid
    bn1(6) = pulse3(n);
    bn(6) = pulse3(n-1);
    trap =(2*C/h-G)*xn+bn1+bn;
    xn1=(2*C/h + G)\trap;
    vout1(n) = xn(5)*2;
    xn = xn1;
    
    vout(n-1) = xn(5);
end

vout(n) = xn(5);

figure(3)
subplot(3,1,1)
plot(time,pulse3,time,vout)
title('Input vs. Output')
legend('Voltage In', 'Voltage Out (V5)');
xlabel ('Time (s)'); ylabel('Voltage (V)');


subplot(3,1,2)
plot(abs(fftshift(fft(pulse3))))
title('FFT of Vin')

subplot(3,1,3)
plot(abs(fftshift(fft(vout))))
title('FFT of Vout')

