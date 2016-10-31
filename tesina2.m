clear all
close all
clc

%% DATI INPUT
Qev=100;    %kW
Th=96;       %�C
deltaTh=3;   %�C
Tl=-3;      %�C
deltaTl=1;  %�C
Tamb=25;    %�C
deltaTcond=4;   %�C
deltaTass=1;    %�C

Tge=Th-deltaTh; %�C
Tco=Tamb+deltaTcond;    %�C
Tev=Tl-deltaTl;         %�C
Tass=Tamb+deltaTass;    %�C

% %% grafico csi-T (giusto per il codice)
% csi=linspace(0,1);
% for i=1:length(csi);
%     Tl(i)=refpropm('t','p',P*100,'q',0,'ammonia','water',[csi(i) 1-csi(i)])-273.15;
%     Tv(i)=refpropm('t','p',P*100,'q',1,'ammonia','water',[csi(i) 1-csi(i)])-273.15;
% end
% 
% plot(csi, Tl, csi, Tv)

%% CALCOLI Pressione del punto 1 e 2

csi=linspace(0,1);

% for j=1:2
    for i=1:length(csi);
        pv(i)=refpropm('p','t',Tge+273.15,'q',1,'ammonia','water',[csi(i) 1-csi(i)])/100;  %bar Calcola la pressione per la fase VAPORE a temperatura del GE
        pl(i)=refpropm('p','t',Tco+273.15,'q',0,'ammonia','water',[csi(i) 1-csi(i)])/100;  %bar Calcola la pressione per la fase LIQUIDA a temperatura del CO
    end
[csiv,p1]=polyxpoly(csi, pl, csi, pv)
        if csiv(2)>0.9
            csi1=csiv(2);
        end

%% PLOT GRAFICO csi-P
t=[Tge Tco];
for j=1:2;
    for i=1:length(csi);
        pv(i)=refpropm('p','t',t(j)+273.15,'q',1,'ammonia','water',[csi(i) 1-csi(i)])/100;  %bar
        pl(i)=refpropm('p','t',t(j)+273.15,'q',0,'ammonia','water',[csi(i) 1-csi(i)])/100;  %bar
    end
    semilogy(csi, pl, csi, pv)
    grid on
    hold on
end




