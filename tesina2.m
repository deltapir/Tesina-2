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

ref='ammonia';
ass='water';

Tge=Th-deltaTh; %�C
Tco=Tamb+deltaTcond;    %�C
Tev=Tl-deltaTl;         %�C
Tass=Tamb+deltaTass;    %�C

%% CALCOLI Pressione del punto 1 e 2

csi=linspace(0,1,20);
    for i=1:length(csi);
        pv(i)=refpropm('p','t',Tge+273.15,'q',1,'ammonia','water',[csi(i) 1-csi(i)])/100;  %bar Calcola la pressione per la fase VAPORE a temperatura del GE
        pl(i)=refpropm('p','t',Tco+273.15,'q',0,'ammonia','water',[csi(i) 1-csi(i)])/100;  %bar Calcola la pressione per la fase LIQUIDA a temperatura del CO
    end
[csiv,pv]=polyxpoly(csi, pl, csi, pv);
        if csiv(2)>0.9          %csiv(2) perch� prendo la curva del vapore.
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
h8=refpropm('h','t',Tge+273.15,'q',0,'ammonia','water',[csi8 1-csi8])/1000;

% %plotto il grafico      %QUESTA PARTE DEL PLOT PUO' ESSERE ELIMINATA AI
% %FINI DEL CALCOLO
% figure(1)
% plot(csi,Tv,csi,Tl,csia,t1)
% title('Temperatura - \xi')
% xlabel('\xi')
% ylabel('Temperatura [�C]')
% grid on

%% ASSORBITORE (punto 3-5)
% la temperatura a monte dell'assorbitore (punto 3) non deve essere
% superiore a quella del set dell'evaporatore (Tl) altrimenti non c'� una
% Qev che entra nel fluido dell'evaporatore. Pertanto la T3 deve essere
% minore o uguale a Tev che � uguale a Tl-deltaTl. Pongo quindi la T3 al
% massimo pari a Tev. Conoscendo anche la csi3 posso determinare la
% pressione del punto 3. Questa pressione � quella massima che pu� esistere
% nell'evaporatore (e quindi anche assorbitore).

p3max=refpropm('p','t',Tev+273.15,'q',0,'ammonia','water',[csi1 1-csi1])/100;  %bar

%devo ora determinare la pressione minima che pu� esistere nell'evaporatore
%e nell'assorbitore. Per fare questo devo considerare che la concentrazione
%nel punto 5 � compresa tra quella del punto 1 e quella povera del punto 8.
%Muovendomi a temperatura costante (quella a valle dell'assorbitore - punto
%5) determino un range di pressione-concentrazione.

for i=1:length(csi);
    p3min(i)=refpropm('p','t',Tass+273.15,'q',0,'ammonia','water',[csi(i) 1-csi(i)])/100;  %bar
end
% figure(3)
% plot(csi,p3min);
% xlabel('\xi');
% ylabel('Pressione [bar]');
% grid on

% siccome la pressione corrispondente alla concentrazione csi1 � maggiore
% di quella permessa dalla p3max, il range di pressione � limitata da p3max
% e p3min corrispondente alla concentrazione csi8.

p3min=refpropm('p','t',Tass+273.15,'q',0,'ammonia','water',[csi8 1-csi8])/100;  %bar

p3var=linspace(p3min, p3max,10);   %range ammesso all'evaporatore

% posso quindi ora calcolarmi la portata che sar� ancora variabile in
% quanto h4 varia con la pressione (anche se di pochissimo!).
% for i=1:length(p3var);
%     m1(i)=Qev/(h4(i)-h2);       %kg/s
% end

% conoscendo il vettore della pressione al punto 5 mi calcolo il vettore
% della concentrazione al punto 5. Per fare questo faccio variare la
% pressione all'interno del range ammessibile e la concentrazione tra 0 e
% 1. Mi disegno la curva del liquido (x=0) ad una determinata pressione.
% Questa curva la interseco con l'isoterma Tass. L'intersezione con
% polyxpoly mi restituisce l'ascissa (cio� la concentrazione ricca) e
% l'ordinata (cio� Tass). Usando il plot sotto il grafico assomiglia ad una
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
%     calcolo h4 che sar� variabile con la pressione
    h4(i)=h4li+(h4va-h4li)*(csi1-csili4)/(csiva4-csili4);
    
    [csi5(i), y(i)]=polyxpoly(csi,T5retta,csi,T5var);

    %mi calcolo h5 che sar� variabile
    h5(i)=refpropm('h','t',Tass+273.15,'p',p3var(i)*100,'ammonia','water',[csi5(i) 1-csi5(i)])/1000;
    %calcolo f
    f(i)=(csi1-csi8)/(csi5(i)-csi8);
    %calcolo hq alla temperatura del GV con la concentrazione ricca
    hq(i)=refpropm('h','t',Tge+273.15,'p',p3var(i)*100,'ammonia','water',[csi8 1-csi8])/1000;
    qGV(i)=f(i)*(hq(i)-h5(i));
    m4p(i)=Qev/(h4(i)-h2);
    %CALCOLO COOOOOOOOOOOOOOOOOOOOOOOOOOOOOOP!
    COPvar(i)=(h4(i)-h2)/(qGV(i));
%     COPvar(i)=((h4(i)-h2)/(h1-h8+f(i)*(h8-h5(i)))); %usando questa
%     formula il cop viene pi� basso.
%     plot(csi,T5var);
%     hold on
end
%   calcolo il COP massimo
[COP, p3]=max(COPvar);
fR=f(p3);       %mi prendo il valore di ricircolo corrispondente al cop massimo R:reale
p3=p3var(p3);   %determino il valore della p3 corrispondente al cop massimo
csi5=(csi1-csi8)/fR+csi8;

figure(2)           %plotto il grafico P-COP
plot(p3var,COPvar,'k','linewidth',2);
hold on
plot([p3 1],[COP COP],'-.k');
text(p3/2,COP+0.01,'COP massimo','horizontalalignment','center','fontweight','bold');
hold on
plot([p3var(1) p3var(1)],[COPvar(1) -0.1],'--k');
text(p3var(1),-0.12,'Press MIN','color','black','horizontalalignment','center','fontweight','bold');
hold on
plot([p3var(end) p3var(end)],[COPvar(end) -0.1],'--k');
text(p3var(end),-0.12,'Press MAX','color','black','horizontalalignment','center','fontweight','bold');
xlabel('Pressione [bar]');
ylabel('COP');
title('Pressione - COP');
grid on

%ricalcolo a questo punto le varie propriet� visto che ho ottenuto la
%pressione all'evaporatore. R:reale
h3R=h2;
T3R=refpropm('t','h',h3R*1000,'p',p3*100,'ammonia','water',[csi1 1-csi1])-273.15;
h3RL=refpropm('h','p',p3*100,'q',0,'ammonia','water',[csi1 1-csi1])/1000;
h3RV=refpropm('h','p',p3*100,'q',1,'ammonia','water',[csi1 1-csi1])/1000;
x3R=(h3R-h3RL)/(h3RV-h3RL);
h4R=refpropm('h','t',Tev+273.15,'p',p3*100,'ammonia','water',[csi1 1-csi1])/1000;%i valori di saturazione al punto 4 coincidono con quelli del punto 3 quindi user� gli stessi
x4R=(h4R-h3RL)/(h3RV-h3RL);
m4=Qev/(h4R-h3R);   %kg/s
h5R=refpropm('h','t',Tass+273.15,'p',p3*100,'ammonia','water',[csi5 1-csi5])/1000;
m7=m4*(csi1-csi5)/(csi5-csi8);
m5=m4+m7;
h6R=h5R; %sii trascura l'incremento entalpico fornito dalla pompa
T6R=refpropm('t','h',h6R*1000,'p',p1*100,'ammonia','water',[csi5 1-csi5])-273.15;
Qass=-m5*h5R+m4*h4R+m7*h8;
Qco=m4*(h1-h2);
Qgv=m4*h1+m7*h8-m5*h6R;




%% SCAMBIATORE
% del punto 8' a valle del rigeneratore conosco pressione, temperatura (che
% per ipotesi � uguale a 6 e la concentrazione. Calcolo l'entalpia.

h8pR=refpropm('h','t',T6R+273.15,'p',p1*100,'ammonia','water',[csi8 1-csi8])/1000;
h6pR=((f-1)/f)*(h8-h8pR)+h6R;

%calcolo il cop con scambiatore al variare della pressione EV. Siccome non
%variano le concentrazioni nei 3 rami, la f (frazione di ricircolo) sar�
%invariata. Anche il range di pressione ammissibile all'evaporatore sar�
%invariato perch� i punti 3 e 5 non risentono della presenza o meno
%dell'evaporatore. 
% for i=1:length(p3var);
Qassp=-m5*h5R+m4*h4R+m7*h8pR;
Qgvp=m4*h1+m7*h8-m5*h6pR;
COPp=Qev/Qgvp;
% con lo scambiatore sia il calore all'assorbitore che quello al generatore
% sono diminuiti. Ne consegue un aumento del COP.

%% DISEGNO GRAFICO
for i=1:length(csi)
    HVCO(i)=refpropm('h','p',p1*100,'q',1,'ammonia','water',[csi(i) 1-csi(i)])/1000;
    HLCO(i)=refpropm('h','p',p1*100,'q',0,'ammonia','water',[csi(i) 1-csi(i)])/1000;
    HVEV(i)=refpropm('h','p',p3*100,'q',1,'ammonia','water',[csi(i) 1-csi(i)])/1000;
    HLEV(i)=refpropm('h','p',p3*100,'q',0,'ammonia','water',[csi(i) 1-csi(i)])/1000;
end
csiv=linspace(0.1,1,20);
for i=1:length(csiv)
    hev(i)=refpropm('h','t',Tev+273.15,'p',p3*100,'ammonia','water',[csiv(i) 1-csiv(i)])/1000;
end
csiass=linspace(0.,1,20);
for i=1:length(csiass)
    hass(i)=refpropm('h','t',Tass+273.15,'p',p3*100,'ammonia','water',[csiass(i) 1-csiass(i)])/1000;
end
for i=1:length(csiass)
    hco(i)=refpropm('h','t',Tco+273.15,'p',p1*100,'ammonia','water',[csiass(i) 1-csiass(i)])/1000;
end
for i=1:length(csiass)
    hgv(i)=refpropm('h','t',Tge+273.15,'p',p1*100,'ammonia','water',[csiass(i) 1-csiass(i)])/1000;
end
csiboh=0.97;
% [liq vap]=refpropm('x','t',Tass+273.15,'q',1,'ammonia','water');
hliq=refpropm('h','p',p3*100,'q',1,'ammonia','water',[csiboh 1-csiboh])/1000;
figure(1)
plot(csi,HVCO,'r',csi,HLCO,'r','linewidth',1);
text([0.5 0.5],[HVCO(length(csi)/2) HLCO(length(csi)/2)],'CO','color','red','Fontsize',14);
hold on
plot(csi,HVEV,'b',csi,HLEV,'b','linewidth',1);
text([0.25 0.25],[HVEV(length(csi)/4)-100 HLEV(length(csi)/4)],'EV','color','blue','Fontsize',14);
hold on
plot(csi1,h1,'ko');
text(csi1+0.01,h1+50,'1','Fontsize',12,'fontWeight','bold');
hold on
plot(csi1,h2,'ko');
text(csi1+0.01,h2+50,'2\equiv3','Fontsize',12,'fontWeight','bold');
hold on
plot(csi1,h4R,'ko');
text(csi1+0.01,h4R+50,'4','Fontsize',12,'fontWeight','bold');
hold on
plot(csi8,h8,'ko');
text(csi8+0.01,h8+50,'7\equiv8','Fontsize',12,'fontWeight','bold');
hold on
plot(csi5,h5R,'ko');
text(csi5+0.01,h5R+50,'5\equiv6','Fontsize',12,'fontWeight','bold');
hold on
plot(csi8,h8pR,'ko');
text(csi8+0.01,h8pR+50,'8p','Fontsize',12,'fontWeight','bold');
hold on
plot(csi5,h6pR,'ko');
text(csi5+0.01,h6pR+50,'6p','Fontsize',12,'fontWeight','bold');
hold on
plot(csiv,hev,'--b');
text(0.9,1000,'Temp EV','Fontsize',9);
hold on
plot(csiass,hass,'--g');
text(0.75,1000,'Temp ASS','Fontsize',9);
hold on
plot(csiass,hco,'--k');
text(0.96,1000,'Temp CO','Fontsize',9);
hold on
plot(csiass,hgv,'--r');
text(0.62,1000,'Temp GV','Fontsize',9);
hold on
plot([csi8 csi8],[h8 -500],'-.k');
text(csi8,-575,'\xi_P','Fontsize',12,'horizontalalignment','center');
hold on
plot([csi5 csi5],[h6pR -500],'-.k');
text(csi5,-575,'\xi_R','Fontsize',12,'horizontalalignment','center');
hold on
plot([csi1 csi1],[h1 -500],'-.k');
text(csi1,-575,'\xi_V','Fontsize',12,'horizontalalignment','center');
grid on
title('Schema');
xlabel('\xi','fontsize',20,'fontWeight','bold');
ylabel('Entalpia [kJ/kg]','fontsize',20,'fontWeight','bold');


%% PLOT GRAFICO csi-P
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




