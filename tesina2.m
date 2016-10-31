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

Tge=Th-deltaTh; %°C
Tco=Tamb+deltaTcond;    %°C
Tev=Tl-deltaTl;         %°C
Tass=Tamb+deltaTass;    %°C

%% CALCOLI Pressione del punto 1 e 2

csi=linspace(0,1);
    for i=1:length(csi);
        pv(i)=refpropm('p','t',Tge+273.15,'q',1,'ammonia','water',[csi(i) 1-csi(i)])/100;  %bar Calcola la pressione per la fase VAPORE a temperatura del GE
        pl(i)=refpropm('p','t',Tco+273.15,'q',0,'ammonia','water',[csi(i) 1-csi(i)])/100;  %bar Calcola la pressione per la fase LIQUIDA a temperatura del CO
    end
[csiv,pv]=polyxpoly(csi, pl, csi, pv);
        if csiv(2)>0.9
            csi1=csiv(2);
            p1=pv(2);
        end
h1=refpropm('h','t',Tge+273.15,'q',1,'ammonia','water',[csi1 1-csi1])/1000;
h2=refpropm('h','t',Tco+273.15,'q',1,'ammonia','water',[csi1 1-csi1])/1000;

%% determino il punto 8
% faccio una semplice intersezione tra la curva e l'isoterma
for i=1:length(csi);
    Tv(i)=refpropm('t','p',p1*100,'q',1,'ammonia','water',[csi(i) 1-csi(i)])-273.15;  %bar Calcola la pressione per la fase VAPORE a temperatura del GE
    Tl(i)=refpropm('t','p',p1*100,'q',0,'ammonia','water',[csi(i) 1-csi(i)])-273.15;  %bar Calcola la pressione per la fase LIQUIDA a temperatura del CO
end
T1=refpropm('t','p',p1*100,'q',1,'ammonia','water',[csi1 1-csi1])-273.15;
csia=linspace(0,csi1);
for i=1:length(csia)
    t1(i)=T1;
end

[csi8, T8]=polyxpoly(csia,t1,csi,Tl);   %Interseca la retta (csia,t1) con la curva della miscela liquida (csi,Tl) per determinare la concentrazione del punto 8. 
h8=refpropm('h','t',Tge+273.15,'q',1,'ammonia','water',[csi8 1-csi8])/1000;

% %plotto il grafico      %QUESTA PARTE DEL PLOT PUO' ESSERE ELIMINATA AI
% %FINI DEL CALCOLO
% figure(1)
% plot(csi,Tv,csi,Tl,csia,t1)
% title('Temperatura - \xi')
% xlabel('\xi')
% ylabel('Temperatura [°C]')
% grid on

%% ASSORBITORE (punto 3-5)
% la temperatura a monte dell'assorbitore (punto 3) non deve essere
% superiore a quella del set dell'evaporatore (Tl) altrimenti non c'è una
% Qev che entra nel fluido dell'evaporatore. Pertanto la T3 deve essere
% minore o uguale a Tev che è uguale a Tl-deltaTl. Pongo quindi la T3 al
% massimo pari a Tev. Conoscendo anche la csi3 posso determinare la
% pressione del punto 3. Questa pressione è quella massima che può esistere
% nell'evaporatore (e quindi anche assorbitore).

p3max=refpropm('p','t',Tev+273.15,'q',0,'ammonia','water',[csi1 1-csi1])/100;  %bar

%devo ora determinare la pressione minima che può esistere nell'evaporatore
%e nell'assorbitore. Per fare questo devo considerare che la concentrazione
%nel punto 5 è compresa tra quella del punto 1 e quella povera del punto 8.
%Muovendomi a temperatura costante (quella a valle dell'assorbitore - punto
%5) determino un range di pressione-concentrazione.

csiev=linspace(0,1);
for i=1:length(csiev);
    p3min(i)=refpropm('p','t',Tass+273.15,'q',0,'ammonia','water',[csiev(i) 1-csiev(i)])/100;  %bar
end
figure(3)
plot(csiev,p3min);
xlabel('\xi');
ylabel('Pressione [bar]');
grid on

% siccome la pressione corrispondente alla concentrazione csi1 è maggiore
% di quella permessa dalla p3max, il range di pressione è limitata da p3max
% e p3min corrispondente alla concentrazione csi8.

p3min=refpropm('p','t',Tass+273.15,'q',0,'ammonia','water',[csi8 1-csi8])/100;  %bar

p3var=linspace(p3min, p3max);   %range ammesso all'evaporatore
for i=1:length(p3var);
    h4(i)=refpropm('h','t',Tass+273.15,'p',p3var(i),'ammonia','water',[csi1 1-csi1])/1000;
end
% posso quindi ora calcolarmi la portata che sarà ancora variabile in
% quanto h4 varia con la pressione (anche se di pochissimo!).
for i=1:length(p3var);
    m1(i)=Qev/(h4(i)-h2);       %kg/s
end

% conoscendo il vettore della pressione al punto 5 mi calcolo il vettore
% della concentrazione al punto 5
for i=1:length(p3var);
[csi51(i) csi52(i)]=refpropm('x','p',p3var(i)*100,'q',0,'ammonia','water');
end
    
    
    
% %% PLOT GRAFICO csi-P
% t=[Tge Tco];
% for j=1:2;
%     for i=1:length(csi);
%         pv(i)=refpropm('p','t',t(j)+273.15,'q',1,'ammonia','water',[csi(i) 1-csi(i)])/100;  %bar
%         pl(i)=refpropm('p','t',t(j)+273.15,'q',0,'ammonia','water',[csi(i) 1-csi(i)])/100;  %bar
%     end
%     figure(2)
%     title('Pressione - \xi')
%     semilogy(csi, pl, csi, pv);
%     xlabel('\xi')
%     ylabel('Pressione [bar]')
%     grid on
%     hold on
% end




