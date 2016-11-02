function h =function_h(Tev,Pass,x1,ref,ass)

x=0:0.1:1; 	%concentrazione

for i=1:length(x)
    [Tl(i) HL(i)]=refpropm('TH','P',Pass,'Q',0,ref,ass,[x(i) 1-x(i)]);
    [Tv(i) HV(i)] =refpropm('TH','P',Pass,'Q',1,ref,ass,[x(i) 1-x(i)]);
end

xl=interp1(Tl,x,Tev);		%interpola la curva Tl,x per ottenere i valori di xl nei punti Tev.
hl=interp1(Tl,HL,Tev);		%queste sono curve che hanno sulle ascisse le temperature e le concentrazioni sulle oridnate
hv=interp1(Tv,HV,Tev);		%Per questo può ottenere le concentrazioni dalla temperature: perchè gli assi sono invertiti.
xv=interp1(Tv,x,Tev);


h=(x1-xl)/(xv-xl)*(hv-hl)+hl;

if x1>xv
    disp('uscita evap vapore surriscaldato')
    h=hv;
    
end
