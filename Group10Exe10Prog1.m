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

for i=epoxes(1):-1:1 % μειώνεται κατά ένα κάθε φορά μέχρι να φτάσει στο 1
    if winter(i,12) == 1
        winter(i,:)=[];
    end
end

n_win = length(winter);
pmax = 4;


for h=0:hours-1
      Y = NaN(pmax*n_win/24 , 1);
      X = NaN(pmax*n_win/24 ,8);
    
   % space = [];
    temp = h-1;
    cnt = 1;
    
    if h-pmax >=0
        space = h - pmax : 1 : h -1 ;
    else
        space = 23 + h - pmax +1 : 1 : 23;
        space = [space 0:1:h-1];
    end

    for i=1:n_win
        if ismember (winter(i,2) , space) % true αν winter() υπάρχει μέσα στο space 
            Y(cnt) = winter(i,1);
            X(cnt,:) = winter(i,3:10);
            cnt = cnt +1 ; 
        end
    end

    % τώρα με τα δεδομένα μου θα φτιάξω τα μοντέλλα 
    %RIDGE
    TSS = sum((Y-mean(Y)).^2);
    
    b_RIDGE = ridge(Y,X,1,0);
    yfit_RIDGE = [ones(pmax*n_win/24,1) X ] * b_RIDGE; 
    res_RIDGE = yfit_RIDGE - Y;     % Calculate residuals
    RSS_RIDGE = sum(res_RIDGE.^2);
    rsquared_RIDGE(h+1) = 1 - RSS_RIDGE/TSS;
    
    
    d=2; %dimension reduction
    [~,~,Xscores,Yscores,b_PLS] = plsregress(X,Y,d);
    yfit_PLS = [ones(pmax*n_win/24,1) X ] * b_PLS; 
    res_PLS = yfit_PLS - Y;     % Calculate residuals
    RSSPLS = sum(res_PLS.^2);
    rsquaredPLS(h+1) = 1 - RSSPLS/TSS;


end


% νομιζω κατάλαβα. αν π.χ p=2 και t=5 
% θα πάρω όλα bikes ωρων 3-5 και θα υπολογισω το μοντελο 
% που μέσα το ενα χ3 π.χ θα ειναι η ώρα και μετά στο μοντέλαο που θα βρω θα αντικαταστήσβ
% πάνω την ωρα

    
        




