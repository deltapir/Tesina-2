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

ref='ammonia';
ass='water';

Tge=Th-deltaTh; %°C
Tco=Tamb+deltaTcond;    %°C
Tev=Tl-deltaTl;         %°C
Tass=Tamb+deltaTass;    %°C

%% CALCOLI Pressione del punto 1 e 2

csi=linspace(0,1,20);
    for i=1:length(csi);
        pv(i)=refpropm('p','t',Tge+273.15,'q',1,'ammonia','water',[csi(i) 1-csi(i)])/100;  %bar Calcola la pressione per la fase VAPORE a temperatura del GE
        pl(i)=refpropm('p','t',Tco+273.15,'q',0,'ammonia','water',[csi(i) 1-csi(i)])/100;  %bar Calcola la pressione per la fase LIQUIDA a temperatura del CO
    end
[csiv,pv]=polyxpoly(csi, pl, csi, pv);
        if csiv(2)>0.9          %csiv(2) perchè prendo la curva del vapore.
            csi1=csiv(2);
            p1=pv(2);
        end
h1=refpropm('h','t',Tge+273.15,'q',1,'ammonia','water',[csi1 1-csi1])/1000;
h2=refpropm('h','t',Tco+273.15,'q',0,'ammonia','water',[csi1 1-csi1])/1000;

%% determino il punto 8
% faccio una semplice intersezione tra la curva e l'isoterma
for i=1:length(csi);
    Tv(i)=refpropm('t','p',p1*100,'q',1,'ammonia','water',[csi(i) 1-csi(i)])-273.15;  %bar Calcola la pressione per la fase VAPORE a pressione del GE
    Tl(i)=refpropm('t','p',p1*100,'q',0,'ammonia','water',[csi(i) 1-csi(i)])-273.15;  %bar Calcola la pressione per la fase LIQUIDA a pressione del GE
end

csia=linspace(0,csi1);
for i=1:length(csia)
    t1(i)=Tge;
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

%csi=linspace(0,1);
for i=1:length(csi);
    p3min(i)=refpropm('p','t',Tass+273.15,'q',0,'ammonia','water',[csi(i) 1-csi(i)])/100;  %bar
end
figure(3)
plot(csi,p3min);
xlabel('\xi');
ylabel('Pressione [bar]');
grid on

% siccome la pressione corrispondente alla concentrazione csi1 è maggiore
% di quella permessa dalla p3max, il range di pressione è limitata da p3max
% e p3min corrispondente alla concentrazione csi8.

p3min=refpropm('p','t',Tass+273.15,'q',0,'ammonia','water',[csi8 1-csi8])/100;  %bar

p3var=linspace(p3min, p3max,20);   %range ammesso all'evaporatore

% posso quindi ora calcolarmi la portata che sarà ancora variabile in
% quanto h4 varia con la pressione (anche se di pochissimo!).
% for i=1:length(p3var);
%     m1(i)=Qev/(h4(i)-h2);       %kg/s
% end

% conoscendo il vettore della pressione al punto 5 mi calcolo il vettore
% della concentrazione al punto 5. Per fare questo faccio variare la
% pressione all'interno del range ammessibile e la concentrazione tra 0 e
% 1. Mi disegno la curva del liquido (x=0) ad una determinata pressione.
% Questa curva la interseco con l'isoterma Tass. L'intersezione con
% polyxpoly mi restituisce l'ascissa (cioè la concentrazione ricca) e
% l'ordinata (cioè Tass). Usando il plot sotto il grafico assomiglia ad una
% banana grigia!

for i=1:length(p3var);
    i
    for j=1:length(csi)
        j
        T5var(j)=refpropm('t','p',p3var(i)*100,'q',0,'ammonia','water',[csi(j) 1-csi(j)])-273.15;
        T5retta(j)=Tass;
        %calcolo h4 usando la regola della leva. Nel grafico h-csi interseco
        %l'isoterma con le curve di saturazione della miscela alla pressione
        %p3var(i). Ottengo un vettore di h4(i).
        h4v(j)=refpropm('h','p',p3var(i)*100,'q',1,'ammonia','water',[csi(j) 1-csi(j)])/1000; %h4 vapore
        h4l(j)=refpropm('h','p',p3var(i)*100,'q',0,'ammonia','water',[csi(j) 1-csi(j)])/1000; %h4 vapore
%         disegno le curve di saturazione nel grafico T-csi
        T4v(j)=refpropm('t','p',p3var(i)*100,'q',1,'ammonia','water',[csi(j) 1-csi(j)])-273.15;
        T4l(j)=refpropm('t','p',p3var(i)*100,'q',0,'ammonia','water',[csi(j) 1-csi(j)])-273.15;
        Tv(j)=Tev;
    end
%    interseco le curve del liquido nel grafico h-csi con l'isoterma al
%    variare della pressione.
    [csili4 Tev]=polyxpoly(csi,T4l,csi,Tv);
%   interseco le curve del vapore nel grafico h-csi con l'isoterma al
%   variare della pressione.
    [csiva4 Tev]=polyxpoly(csi,T4v,csi,Tv);
    h4li=refpropm('h','p',p3var(i)*100,'q',0,'ammonia','water',[csili4 1-csili4])/1000;
    h4va=refpropm('h','p',p3var(i)*100,'q',1,'ammonia','water',[csiva4 1-csiva4])/1000;
%     calcolo h4 che sarà variabile con la pressione
    h4(i)=h4li+(h4va-h4li)*(csi1-csili4)/(csiva4-csili4);
    
    [csi5(i), y(i)]=polyxpoly(csi,T5retta,csi,T5var);

    %mi calcolo h5 che sarà variabile
    h5(i)=refpropm('h','t',Tass+273.15,'p',p3var(i)*100,'ammonia','water',[csi5(i) 1-csi5(i)])/1000;
    %calcolo f
    f(i)=(csi1-csi8)/(csi5(i)-csi8);
    %calcolo hq alla temperatura del GV con la concentrazione ricca
    hq(i)=refpropm('h','t',Tge+273.15,'p',p3var(i)*100,'ammonia','water',[csi8 1-csi8])/1000;
    qGV(i)=f(i)*(hq(i)-h5(i));
    %CALCOLO COOOOOOOOOOOOOOOOOOOOOOOOOOOOOOP!
    COPvar(i)=(h4(i)-h2)/(qGV(i));
%     COPvar(i)=((h4(i)-h2)/(h1-h8+f(i)*(h8-h5(i)))); %usando questa
%     formula il cop viene più basso.
%     plot(csi,T5var);
%     hold on
end
%   calcolo il COP massimo
[COP, p3]=max(COPvar);

    
    
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




