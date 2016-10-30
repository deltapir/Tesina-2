clear all
close all
clc

%% DATI INPUT
Qev=100;    %kW
Th=96;       %°C
deltaTh=3;   %°C
Tl=-3;      %°C
deltaTl=1;  %°C
Tamb=25;    %°C
deltaTcond=4;   %°C
deltaTass=1;    %°C
P=1;

%% grafico csi-T (giusto per il codice)
csi=linspace(0,1);
for i=1:length(csi);
    Tl(i)=refpropm('t','p',P*100,'q',0,'ammonia','water',[csi(i) 1-csi(i)])-273.15;
    Tv(i)=refpropm('t','p',P*100,'q',1,'ammonia','water',[csi(i) 1-csi(i)])-273.15;
end

plot(csi, Tl, csi, Tv)
