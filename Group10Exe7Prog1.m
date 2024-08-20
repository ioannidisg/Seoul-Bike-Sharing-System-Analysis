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
   
 exponential = @ (b,x)( b(1)*exp(b(2)*x) );   
 [l,~] = size(bikes);
   
 for h=1:hours
    linearModel = fitlm(tempr(:,h ) , bikes(:,h));
    adjR2(h,1)=linearModel.Rsquared.Adjusted;
    
    bikes_Trans1 = log(bikes(:,h));
    regressionModel = fitlm(tempr(:,h),bikes_Trans1);
    b_exp = regressionModel.Coefficients.Estimate;
    b_exp = b_exp(:,1);
   % b_exp(1) = exp(b_exp(1));
    pred = exponential(b_exp,tempr(:,1));
    e_exp = bikes(:,h)-pred;
    adjR2(h,2) =1-((l-1)/(l-2))*(sum(e_exp.^2))/(sum((bikes(:,h)-mean(bikes(:,h))).^2));
  
    TEMPR = [ones(l,1)  tempr(:,h)  tempr(:,h).^2];
    [b_p2,~,~,~,~] = regress(bikes(:,h),TEMPR);
    pred_p2 = TEMPR*b_p2;
    e_p2 = bikes(:,h) - pred_p2 ;
    adjR2(h,3) =1-((l-1)/(l-(2+1)))*(sum(e_p2.^2))/(sum((bikes(:,h)-mean(bikes(:,h))).^2));

    
    TEMPR = [ones(l,1) tempr(:,h) tempr(:,h).^2 tempr(:,h).^3];
    [b_p3,~,~,~,~] = regress(bikes(:,h),TEMPR);
    pred_p3 = TEMPR*b_p3;
    e_p3 = bikes(:,h) - pred_p3 ;
    adjR2(h,4) =1-((l-1)/(l-(3+1)))*(sum(e_p3.^2))/(sum((bikes(:,h)-mean(bikes(:,h))).^2));

    TEMPR = [ones(l,1) 3.^(tempr(:,h)) tempr(:,h).^2 3.^(tempr(:,h)).^3 ];
    [b_p3,~,~,~,~] = regress(bikes(:,h),TEMPR);
    pred_p3 = TEMPR*b_p3;
    e_p3 = bikes(:,h) - pred_p3 ;
    adjR2(h,5) =1-((l-1)/(l-(3+1)))*(sum(e_p3.^2))/(sum((bikes(:,h)-mean(bikes(:,h))).^2));
       
    b=polyfit(tempr(:,h),bikes(:,h),2);
    temp_pred = polyval(b,tempr(:,h));
    e = bikes(:,h) - temp_pred;
    
    yV=bikes(:,h);
    my=mean(bikes(:,h));
    x = sum(e.^2) / (sum( (bikes(:,h)-mean(bikes(:,h)).^2)));
    adjR2(h,3) =1-((l-1)/(l-(2+1)))*(sum(e.^2))/(sum((yV-my).^2));


    b=polyfit(tempr(:,h),bikes(:,h),3);
    temp_pred = polyval(b,tempr(:,h));
    e = bikes(:,h) - temp_pred;
    
    yV=bikes(:,h);
    my=mean(bikes(:,h));
    x = sum(e.^2) / (sum( (bikes(:,h)-mean(bikes(:,h)).^2)));
    adjR2(h,4) =1-((l-1)/(l-(3+1)))*(sum(e.^2))/(sum((yV-my).^2));

 end
    

    
