clear; %winter automn annotate
clc;
close all;

data = importdata("SeoulBike.xlsx");   %3601-3623 delete
data = data.data;

data(7225:7241,:)=[];

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

        dmx = W(i) - A(i); % dmx = mu_W(i) - mu_S(i);
        vardxt = (W(i)^2*(n1-1)+A(i)^2*(n2-1)) / (n1+n2-2);
        sddxt = sqrt(vardxt);
        tsample = dmx / (sddxt * sqrt(1/n1+1/n2));
        pvaldmxM(i,1) = 2*(1-tcdf(abs(tsample),n1+n2-2));        

        a=0.05; % 95% διάστημα εμπιστοσύνης 
        k1 = floor((B+1)*a/2); %  floor-round
        k2 = B + 1 - k1;
        boots_win = bootstrp(B,@mean,W(:,i));
        boots_aut = bootstrp(B,@mean,A(:,i));
        Z=boots_win-boots_aut;
        Z=sort(Z);
        ci_boot(i,:) = [Z(k1) , Z(k2)];

          alldmxV = [dmx; Z];
          [~,idmxV] = sort(alldmxV);
          rankdmx0 = find(idmxV == 1);


        if  ci_boot(i,1) > mean(Z) || ci_boot(i,2) < mean(Z)
            disp(['Στατιστικά σημαντική διαφορά στην ώρα ' num2str(i)]);
        end

         if rankdmx0 > 0.5*(B+1)
            pvaldmxM(i,1) = 2*(1-rankdmx0/(B+1));
         else
            pvaldmxM(i,1) = 2*rankdmx0/(B+1);
         end

    end
   
    
    figure;
    plot(ci_boot(:,1),"b");
    hold on;
    plot(ci_boot(:,2),"r");
    legend("Lower lim" ,"Upper lim")
    xlabel('Hours');
    ylabel(' Limit');

    probability_rejection = 100 * sum(pvaldmxM(:,1) < a) / 24;
    result_text = sprintf('Probability of rejection (alpha=%.3f), p=%.3f%%', a, probability_rejection);
    annotation('textbox', [0.15, 0.2, 0.8, 0.1], 'String', result_text, 'FitBoxToText', 'on', 'EdgeColor', 'none');
 
    
    fprintf('Probability of rejection of equal mean at alpha=%1.3f, bootstrap = %1.3f \n',...
    a,100*sum(pvaldmxM(:,1)<a)/24); 

 









