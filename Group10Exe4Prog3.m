clear;
clc;
close all;

data = importdata("SeoulBike.xlsx");   %3601-3623 delete
data = data.data;

data(7225:7241,:)=[];
data(7177:7200,:)=[];
data(7009:7080,:)=[];
data(6121:6144,:)=[];
data(4441:4464,:)=[];
data(4081:4104,:)=[];
data(3601:3624,:)=[];
data(2161:2184,:)=[];
data(1825:1896,:)=[];
data(721:768, :) = [];
data(553:600,:) = [];
data(505:528,:) = [];

epoxes = [0 0 0 0];

for i=1:length(data)
    epoxes(data(i,11))= epoxes(data(i,11)) +1; 
end

winter = data (1:epoxes(1), : );
autumn = data ( epoxes(1) + epoxes(2) +1 : epoxes(1) + epoxes(2) + epoxes(3),:);

n1 = length(winter);
n2 = length(autumn);

W= zeros(n1/24 , 24);
A= zeros(n2/24 , 24);

    j=1;
    for i=1:n1
       W(j,winter(i,2) +1)= winter(i,1);
       if mod(i,24)==0
            j=j+ 1;
        end
    end

    j=1;
    for i=1:n2
       A(j,autumn(i,2) +1)= autumn(i,1);
       if mod(i,24)==0
            j=j+ 1;
        end
    end
    
    B = 1000;
    for i=1:24
        a=0.05; % 95% διάστημα εμπιστοσύνης 
        k1 = floor((B+1)*a/2); %  floor-round
        k2 = B + 1 - k1;
        boots_win = bootstrp(B,@mean,W(:,i));
        boots_aut = bootstrp(B,@mean,A(:,i));
        Z=boots_win-boots_aut;
        Z=sort(Z);
        ci_boot(i,:) = [Z(k1) , Z(k2)];

        if  ci_boot(i,1) > mean(Z) || ci_boot(i,2) < mean(Z)
            disp(['Στατιστικά σημαντική διαφορά στην ώρα ' num2str(i)]);
        end

    end

   
    figure;
    plot(ci_boot(:,1),"b");
    hold on;
    plot(ci_boot(:,2),"r");
    legend("Lower lim" ,"Upper lim")
    xlabel('Hours');
    ylabel(' Limit');
 
    
   

 









