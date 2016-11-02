clear all
close all
clc

%% Piano csi-T: curva di ebollizione, fissata la pressione

% La pressione con cui si costruirà il diagramma
p=1; % [bar]
csi_a=linspace(0,1); % faccio variare la concentrazione del fluido più volatile (Ammoniaca) tra 0 e 1
for i=1:length(csi_a) % scorre il vettore concentrazione
    
    % Valuto la temperatura di incipiente ebollizione, fissata la pressione (1 bar) e la concentrazione della miscela
    T_l(i)=refpropm('T','p',p*100,'q',0,'ammonia','water',[csi_a(i) 1-csi_a(i)])-273.15; % [°C]
        
end

% Sul piano concentrazione-Temperatura, disegno la curva di ebollizione, fissata la pressione (1 bar)
figure('name','piano csi-T')
set(gca,'fontsize', 16, 'fontweight', 'bold','FontName','Times')
plot(csi_a,T_l,'LineWidth',2.5,'Color','b') % Disegno la curva di ebollizione, fissata la pressione (1 bar)
% Descrizione degli assi cartesinai e modifica dello stile
xlabel('\xi [-]','FontWeight','bold','FontSize',16,'FontName','Times');
ylabel('Temperatura [°C]','FontWeight','bold','FontSize',16,'FontName','Times');
title(strcat('Diagramma T - \xi a p=', num2str(p),'bar'),'FontWeight','bold','FontSize',16,'FontName','Times')
% Creazione della legenda
leg1=legend('curva di ebollizione','Location','NorthEast');
set(leg1,'FontWeight','bold','FontSize',16,'FontName','Times')
grid on
box on

%% Piano csi-T: curva di ebollizione e curva di condensazione, fissata la pressione

% La pressione con cui si costruirà il diagramma
p=1; % [bar]
csi_a=linspace(0,1); % faccio variare la concentrazione del fluido più volatile (Ammoniaca) tra 0 e 1
for i=1:length(csi_a) % scorre il vettore concentrazione
    
    % Valuto la temperatura di incipiente ebollizione, fissata la pressione (1 bar) e la concentrazione della miscela
    T_l(i)=refpropm('T','p',p*100,'q',0,'ammonia','water',[csi_a(i) 1-csi_a(i)])-273.15; % [°C]
    
    % Valuto la temperatura di fine ebollizione, fissata la pressione (1 bar) e la concentrazione della miscela
    T_v(i)=refpropm('T','p',p*100,'q',1,'ammonia','water',[csi_a(i) 1-csi_a(i)])-273.15; % [°C]
        
end

% Sul piano concentrazione-Temperatura, disegno la curva di ebollizione e la curva di condensazione, fissata la pressione (1 bar)
figure('name','piano csi-T')
set(gca,'fontsize', 16, 'fontweight', 'bold','FontName','Times')
plot(csi_a,T_l,'LineWidth',2.5,'Color','b') % Disegno la curva di ebollizione, fissata la pressione (1 bar)
hold on
plot(csi_a,T_v,'LineWidth',2.5,'Color','r') % Disegno la curva di condensazione, fissata la pressione (1 bar)
% Descrizione degli assi cartesinai e modifica dello stile
xlabel('\xi [-]','FontWeight','bold','FontSize',16,'FontName','Times');
ylabel('Temperatura [°C]','FontWeight','bold','FontSize',16,'FontName','Times');
title(strcat('Diagramma T - \xi a p=', num2str(p),'bar'),'FontWeight','bold','FontSize',16,'FontName','Times')
% Creazione della legenda
leg1=legend('curva di ebollizione','curva di condensazione','Location','NorthEast');
set(leg1,'FontWeight','bold','FontSize',16,'FontName','Times')
grid on
box on


%% Piano csi-h: curva di ebollizione e curva di condensazione, fissata la pressione

% La pressione con cui si costruirà il diagramma
p=1; % [bar]
csi_a=linspace(0,1); % faccio variare la concentrazione del fluido più volatile (Ammoniaca) tra 0 e 1
for i=1:length(csi_a)
    
    % Valuto l'entalpia del liquido satuto, fissata la pressione (1 bar) e la concentrazione della miscela
    h_l(i)=refpropm('h','p',p*100,'q',0,'ammonia','water',[csi_a(i) 1-csi_a(i)])/1000; % [kJ/kg]
    
    % Valuto l'entalpia del liquido satuto, fissata la pressione (1 bar) e la concentrazione della miscela
    h_v(i)=refpropm('h','p',p*100,'q',1,'ammonia','water',[csi_a(i) 1-csi_a(i)])/1000; % [kJ/kg]
    
end

% Sul piano concentrazione-entalpia, disegno la curva di ebollizione e la curva di condensazione, fissata la pressione (1 bar)
figure('name','piano csi-h')
set(gca,'fontsize', 16, 'fontweight', 'bold','FontName','Times')
plot(csi_a,h_l,'LineWidth',2.5,'Color','b') % Disegno la curva di ebollizione, fissata la pressione (1 bar)
hold on
plot(csi_a,h_v,'LineWidth',2.5,'Color','r') % Disegno la curva di ebollizione, fissata la pressione (1 bar)
% Descrizione degli assi cartesinai e modifica dello stile
xlabel('\xi [-]','FontWeight','bold','FontSize',16,'FontName','Times');
ylabel('Entalpia [kJ/kg]','FontWeight','bold','FontSize',16,'FontName','Times');
title(strcat('Diagramma h - \xi a p=', num2str(p),'bar'),'FontWeight','bold','FontSize',16,'FontName','Times')
% Creazione della legenda
leg1=legend('curva di ebollizione','curva di condensazione','Location','NorthEast');
set(leg1,'FontWeight','bold','FontSize',16,'FontName','Times')
grid on
box on

%% Piano csi-h con isoterma, fissata la pressione

% La temperatura con cui si costruirà il diagramma
T=64; %[°C]
% La pressione con cui si costruirà il diagramma
p=1; % [bar]

csi_a=linspace(0,1); % faccio variare la concentrazione del fluido più volatile (Ammoniaca) tra 0 e 1

for i=1:length(csi_a)
    h_T(i)=refpropm('h','T',T+273.15,'p',p*100,'ammonia','water',[csi_a(i) 1-csi_a(i)])/1000;
end

figure('name','piano csi-h con isoterma')
set(gca,'fontsize', 16, 'fontweight', 'bold','FontName','Times')
plot(csi_a,h_T,'LineWidth',2.5,'Color','k')
hold on
plot(csi_a,h_l,'LineWidth',2.5,'Color','b')
plot(csi_a,h_v,'LineWidth',2.5,'Color','r')
% Descrizione degli assi cartesinai e modifica dello stile
xlabel('\xi [-]','FontWeight','bold','FontSize',16,'FontName','Times');
ylabel('Entalpia [kJ/kg]','FontWeight','bold','FontSize',16,'FontName','Times');
title(strcat('Diagramma h - \xi a p=', num2str(p),'bar'),'FontWeight','bold','FontSize',16,'FontName','Times')
% Creazione della legenda
leg1=legend(strcat('Isoterma T=', num2str(T),'°C'),'curva di ebollizione','curva di condensazione','Location','NorthEast');
set(leg1,'FontWeight','bold','FontSize',16,'FontName','Times')
grid on
box on

% Vettore di colori per effettuare i plot
colori='mgbrkcy';

% Le pressioni con cui valutiamo la lente T-csi
P=[1 5 10 20];

% Vettore che spazia tutte le concentrazioni di ammoniaca
csi_a=linspace(0,1,50);

%% Diagramma T-csi, al variare della pressione

for z=1:length(P) % scorre le pressioni
    for i=1:length(csi_a) % scorre le concentrazioni di ammoniaca
        % Calcolo curva di ebollizione
        Tl(z,i)=refpropm('T','p',P(z)*100,'q',0,'ammonia','water',[csi_a(i) 1-csi_a(i)])-273.15;
        % Calcolo curva di condensazione
        Tv(z,i)=refpropm('T','p',P(z)*100,'q',1,'ammonia','water',[csi_a(i) 1-csi_a(i)])-273.15;
    end
    % Ad ogni valore di pressione viene plottata la curva del liquido,
    % avendo cura di cambiare il colore, grazie al vettore definito in
    % partenza
    plot(csi_a,Tl(z,:),'Color',colori(z),'linewidth',2.5)
    hold on
    % Crea una stringa con il valore di pressione attuale. La funzione
    % num2str converte valori numerici in stringhe e la funzione strcat
    % concatena i caratteri in una stringa
    st=strcat('P = ',num2str(P(z)),' bar');
    % Converte la stringa in una cella e le incolonna progressivamente
    s(z)=cellstr(st);
end
% Creazione di una legenda
legend(s,'Location','Best','FontName','Times','FontSize',16,'FontWeight','Bold')
% Plot della curva di condensazione
for z=1:length(P)
plot(csi_a,Tv(z,:),'Color',colori(z),'linewidth',2.5)
end
% Descrizione degli assi cartesiani e modifica dello stile
xlabel('\xi ammoniaca','FontName','Times','FontSize',16,'FontWeight','Bold')
ylabel('Temperatura [°C]','FontName','Times','FontSize',16,'FontWeight','Bold')
title('Diagramma T-\xi','FontName','Times','FontSize',16,'FontWeight','Bold')
set(gca,'FontName','Times','FontSize',16,'FontWeight','Bold')
grid on
box on


%% Diagramma h-csi, al variare della pressione
for z=1:length(P) % scorre le pressioni
    for i=1:length(csi_a) % scorre le concentrazioni di ammoniaca
        % Calcolo curva di ebollizione
        hl(z,i)=refpropm('h','p',P(z)*100,'q',0,'ammonia','water',[csi_a(i) 1-csi_a(i)])/1000;
        % Calcolo curva di condensazione
        hv(z,i)=refpropm('h','p',P(z)*100,'q',1,'ammonia','water',[csi_a(i) 1-csi_a(i)])/1000;
    end
    % Ad ogni valore di pressione viene plottata la curva del liquido,
    % avendo cura di cambiare il colore, grazie al vettore definito in
    % partenza
    plot(csi_a,hl(z,:),'Color',colori(z),'linewidth',2.5)
    hold on
    % Crea una stringa con il valore di pressione attuale. La funzione
    % num2str converte valori numerici in stringhe e la funzione strcat
    % concatena i caratteri in una stringa
    st=strcat('P = ',num2str(P(z)),' bar');
    % Converte la stringa in una cella e le incolonna progressivamente
    s(z)=cellstr(st);
end
% Creazione di una legenda
legend(s,'Location','Best','FontName','Times','FontSize',16,'FontWeight','Bold')
% Plot della curva di condensazione
for z=1:length(P)
plot(csi_a,hv(z,:),'Color',colori(z),'linewidth',2.5)
end
% Descrizione degli assi cartesiani e modifica dello stile
xlabel('\xi ammoniaca','FontName','Times','FontSize',16,'FontWeight','Bold')
ylabel('Entalpia specifica [kJ/kg]','FontName','Times','FontSize',16,'FontWeight','Bold')
title('Diagramma h-\xi','FontName','Times','FontSize',16,'FontWeight','Bold')
set(gca,'FontName','Times','FontSize',16,'FontWeight','Bold')
grid on
box on


%% Diagramma p-csi, fissata la temperatura  
% Vettore di colori per effettuare i plot
colori='mg';
% La temperatura con cui si costruirà il diagramma
T=[32 105]; % °C
% Vettore che spazia tutte le concentrazioni di ammoniaca
csi_a=linspace(0,1,50);
for z=1:length(T) % scorre le pressioni
 for i=1:length(csi_a) % scorre le concentrazioni di ammoniaca
        % Calcolo curva di ebollizione
        Pl(z,i)=refpropm('P','T',T(z)+273,'q',0,'ammonia','water',[csi_a(i) 1-csi_a(i)])/100;
        % Calcolo curva di condensazione
        Pv(z,i)=refpropm('P','T',T(z)+273,'q',1,'ammonia','water',[csi_a(i) 1-csi_a(i)])/100;
 end
 % Ad ogni valore della temperatura viene plottata la curva del liquido, avendo cura di cambiare
 % il colore, grazie al vettore definito in partenza
 semilogy(csi_a,Pl(z,:),'Color',colori(z),'linewidth',2.5)
 hold on
 % Crea una stringa con il valore di pressione attuale. La funzione num2str converte valori numerici
 % in stringhe e la funzione strcat concatena i caratteri in una stringa
 st=strcat('T = ',num2str(T(z)),' °C');
 % Converte la stringa in una cella e le incolonna progressivamente
 s(z)=cellstr(st);
end
% Creazione di una legenda
legend(s,'Location','SouthEast','FontName','Times','FontSize',16,'FontWeight','Bold')
% Plot in scala semilogaritmica (asse y) delle curve del vapore
for z=1:length(T)
semilogy(csi_a,Pv(z,:),'Color',colori(z),'linewidth',2.5)
end
% Descrizione degli assi cartesiani e modifica dello stile
xlabel('\xi ammoniaca','FontName','Times','FontSize',16,'FontWeight','Bold')
ylabel('Pressione [bar]','FontName','Times','FontSize',16,'FontWeight','Bold')
title(strcat('Diagramma P-\xi al variare della T'),'FontName','Times','FontSize',16,'FontWeight','Bold')
set(gca,'FontName','Times','FontSize',16,'FontWeight','Bold')
grid on
box on


%% Diagramma P-T a varie concentrazioni
% Vettore di colori per effettuare i plot
colori=[0 0 0;1 0 0;0 1 1;0 1 0;.5 .5 1;1 1 0;.8 .8 .8;1 .5 1;.9 .75 0;0 .5 0;1 0 1];
% Valori di concentrazione dell'ammoniaca con le quali si construirà il diagramma
csi_am=0:0.10:1;
% Vettore di temperatura
P=linspace(0.6,20,200);
for z=1:length(csi_am)
    for i=1:length(P)
        % Curve di saturazione, nota la pressione e la concentrazione
        Tl_sat(z,i)=refpropm('T','P',P(i)*100,'q',0,'ammonia','water',[csi_am(z) 1-csi_am(z)])-273.15;
    end
   % Ad ogni valore di concentrazione viene plottata la curva di saturazione del liquido,
    % avendo cura di cambiare il colore, grazie al vettore definito in partenza
    semilogy(Tl_sat(z,:),P,'Color',colori(z,:),'linewidth',2.5);
    hold on
    % Crea una stringa con il valore di concentrazione attuale. La funzione num2str converte valori 
    % numerici in stringhe e la funzione strcat concatena i caratteri in una stringa
    st=strcat('\xi = ',num2str(csi_am(z)));
    % Converte la stringa in una cella e le incolonna progressivamente
    s(z)=cellstr(st);
end
% Creazione di una legenda
legend(s,'Location','Best','FontName','Times','FontSize',16,'FontWeight','Bold')
% Descrizione degli assi cartesiani e modifica dello stile
xlabel('Temperatura [°C]','FontName','Times','FontSize',16,'FontWeight','Bold')
ylabel('Pressione [bar]','FontName','Times','FontSize',16,'FontWeight','Bold')
title('Diagramma P-T','FontName','Times','FontSize',16,'FontWeight','Bold')
ylim([.6 20])
set(gca,'FontName','Times','FontSize',16,'FontWeight','Bold')
grid on
box on
