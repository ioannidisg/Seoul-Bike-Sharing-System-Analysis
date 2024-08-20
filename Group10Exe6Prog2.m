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
xeimonas = epoxes(1);

data = data(1:xeimonas,:);

  n= length(data);

  bikes= zeros(n/hours , hours); %Bikes per hour se stiles
  tempr= zeros(n/hours , hours); %tempr per hour se stiles

    j=1;
    for i=1:n
       bikes (j,data(i,2) +1)= data(i,1);
       tempr (j,data(i,2)+1) = data (i,3);
       if mod(i,hours)==0
            j=j+ 1;
       end
    end
    
    MIC= zeros(24,1);
    GMIC= zeros(24,1);
    L=1000;
    %k=sqrt(length(bikes)/5);
    alpha = 0.05;
    
    for i=1:24
        k = length(histcounts(bikes(:,i)));

        I = MutualInformationXY(bikes(:,i),tempr(:,i),fix(k));
        MIC(i) = I/log10(k) ;
        GMIC(i) = -0.5.*log10(1-(corr(bikes(:,i),tempr(:,i)))^2)./log10(k); 

        lowlim = round((alpha/2)*L);
        upplim = round((1-alpha/2)*L);
     
       temp_perm_MIC = NaN*ones(L+1,1);
       temp_perm_MIC(1) = MIC(i);

       temp_perm_GMIC = NaN*ones(L+1,1);
       temp_perm_GMIC(1) = MIC(i);
        
        for j=1:L
            l =length(bikes(:,i));
            temp_bikes = bikes(randperm(l),i);
            I = MutualInformationXY(temp_bikes,tempr(:,i),fix(k));
            temp_perm_MIC(j+1) = I/log10(k) ;
            temp_perm_GMIC(j+1) = -0.5*log10(1-(corr(temp_bikes,tempr(:,i)))^2)/log10(k) ;
        end

        temp_perm_MIC_sorted = sort(temp_perm_MIC(2:end));
        temp_perm_GMIC_sorted = sort(temp_perm_GMIC(2:end));

        lower_bound_M = temp_perm_MIC_sorted(lowlim);
        upper_bound_M = temp_perm_MIC_sorted(upplim);
        lower_bound_G = temp_perm_GMIC_sorted(lowlim);
        upper_bound_G = temp_perm_GMIC_sorted(upplim);        

    if temp_perm_MIC(1) < lower_bound_M || temp_perm_MIC(1) > upper_bound_M
        h_MIC(i) = 1;
        str_M = "MIC-->No reject" ;
    else
        h_MIC(i) = 0;
        str_M = "MIC-->Reject" ;
    end

    if temp_perm_GMIC(1) < lower_bound_G || temp_perm_GMIC(1) > upper_bound_G
        h_GMIC(i) = 1;
        str_G = "GMIC-->No reject" ; 
    else
        h_GMIC(i) = 0;
        str_G = "GMIC-->Reject" ;
    end
    
    figure(i);
    scatter(bikes(:,i),tempr(:,i));

    result_text = sprintf('MIC=%.3f, GMIC=%.3f ,%s ,%s', MIC(i), GMIC(i) , str_M ,str_G);
    annotation('textbox', [0.15, 0.82, 0.8, 0.1], 'String', result_text, 'FitBoxToText', 'on', 'EdgeColor', 'none');

    end
    

    
   % t0 = temp_perm_MIC((hours-2)./(1-r0^2));
   % t = r.*sqrt((hours-2)./(1-r.^2));
   % t = sort(t(2:L+1));
   % tl = t(lowlim); 
   % tu = t(upplim);
   % cnt = length(find(t(1)-tl<0 | t(1)-tu>0));
   % fprintf('percentage of rejection using t-statistic=%1.4f%% \n',100*cnt/24);
   % 
   % for i=1:5
   %      figure(i);
   %      scatter(bikes(:,i),tempr(:,i));
   % end

