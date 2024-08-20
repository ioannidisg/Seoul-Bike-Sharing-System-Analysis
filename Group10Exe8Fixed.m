clc;
clear;
close all;

data = importdata("SeoulBike.xlsx");   
data = data.data;

data(7225:7241,:)=[];

hours = 24;
epoxes = [0 0 0 0];

for i=1:length(data)
    epoxes(data(i,11))= epoxes(data(i,11)) +1; 
end

winter = data(1:epoxes(1),:);
spring = data(epoxes(1)+1:epoxes(1)+epoxes(2),:);
% summer = data(epoxes(1)+epoxes(2)+1:epoxes(1)+epoxes(2)+epoxes(3),:);
% autumn = data(epoxes(1)+epoxes(2)+epoxes(3)+1:epoxes(1)+epoxes(2)+epoxes(3)+epoxes(4),:); 

  n_win = length(winter);
  n_spr = length(spring);
  % n_sum = length(summer);
  % n_aut = length(autumn);

  W_bikes = zeros(n_win/hours , hours); %Bikes per hour se stiles ton xeimona
  Sp_bikes= zeros(n_spr/hours , hours); %Bikes per hour se stiles tin anixi
  W_tempr = zeros(n_win/hours , hours); %Bikes per hour se stiles ton xeimona
  Sp_tempr= zeros(n_spr/hours , hours); %Bikes per hour se stiles tin anixi


       j=1;
    for i=1:n_win
       W_bikes(j,winter(i,2) +1) = winter(i,1);
       W_tempr(j,winter(i,2) +1) = winter(i,3);
       if mod(i,hours)==0
            j=j+ 1;
        end
    end

     j=1;
    for i=1:n_spr
       Sp_bikes(j,spring(i,2) +1) = spring(i,1);
       Sp_tempr(j,spring(i,2) +1) = spring(i,3);
       if mod(i,hours)==0
            j=j+ 1;
        end
    end

   
    model1 = fitlm(W_tempr(:,1) , W_bikes(:,1));
    adjR2(1)=model1.Rsquared.Adjusted;
    
    model2 = fitlm(Sp_tempr(:,1) , Sp_bikes(:,1));
    adjR2(2)=model2.Rsquared.Adjusted;
      
     
   
    a=0.05;
    B=1000;


     dmx = adjR2(1)-adjR2(2);
     boot = NaN(B,1);

     for iB=1:B
        rV = unidrnd(n_win/hours,n_spr/hours,1);
        
        BIKES_all = [W_bikes(:,1); Sp_bikes(:,1)]; % πρεπει [W_bikes(:,1); W_Spr(:,1)];
        TEMPR_all = [W_tempr(:,1); Sp_tempr(:,1)]; % ιδιο με spr

        BIKES_W = BIKES_all(rV(1:n_win/hours));
        BIKES_Sp = BIKES_all(rV(n_win/hours+1:n_spr/hours));

        TEMPR_W =  TEMPR_all(rV(1:n_win/hours));
        TEMPR_Sp = TEMPR_all(rV(n_win/hours+1:n_spr/hours));

        model1 = fitlm(TEMPR_W,BIKES_W);
        model2 = fitlm(TEMPR_Sp,BIKES_Sp);

        boot(iB) = model1.Rsquared.Adjusted - model2.Rsquared.Adjusted;
    end

    allAdjR2 = [dmx; boot];
    [~,idAdjR2] = sort(allAdjR2);
    rank = find(idAdjR2 == 1);

    if rank > 0.5*(B+1)
        pval = 2*(1-rank/(B+1));
    else
        pval = 2*rank/(B+1);
    end
    
    fprintf('Probability of rejection of equal adjR2 (bootstrap) = %1.3f %%\n',100*pval); 

   
    
