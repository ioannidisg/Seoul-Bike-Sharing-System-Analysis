%Ioannidis Georgios

clc;
clear;
close all;

data = importdata("SeoulBike.xlsx");   
data = data.data;

data(7225:7241,:)=[];

hours = 24;
epoxes = [0 0 0 0];

for i=1:length(data)
    epoxes(data(i,11))= epoxes(data(i,11)) +1;  % Edo metro poses meres exei kathe epoxi
end

% xorizo ta dedomena se 4 pinakes ena gia kathe epoxi
winter = data(1:epoxes(1),:); 
spring = data(epoxes(1)+1:epoxes(1)+epoxes(2),:);
summer = data(epoxes(1)+epoxes(2)+1:epoxes(1)+epoxes(2)+epoxes(3),:);
autumn = data(epoxes(1)+epoxes(2)+epoxes(3)+1:epoxes(1)+epoxes(2)+epoxes(3)+epoxes(4),:); 

n_win = length(winter);
n_spr = length(spring);
n_sum = length(summer);
n_aut = length(autumn);

W_bikes= zeros(n_win/hours , hours); %Bikes per hour se stiles ton xeimona (mia stili gia kathe ora)
Sp_bikes= zeros(n_spr/hours , hours); %Bikes per hour se stiles tin anixi
Su_bikes= zeros(n_sum/hours , hours); %Bikes per hour se stiles to kalokairi
A_bikes= zeros(n_aut/hours , hours); %Bikes per hour se stiles to fthinoporo
W_tempr =zeros(n_win/hours , hours); % to idio gia thermokrasia
Sp_tempr = zeros(n_spr/hours , hours);
Su_tempr = zeros(n_sum/hours , hours);
A_tempr = zeros(n_aut/hours , hours);

    j=1;
    for i=1:n_win % xorizo ta podilata se ores(kathe stili kai ora)
       W_bikes (j,winter(i,2) +1)=  winter(i,1); %kano to idio gia ti thermokrasia
       W_tempr (j,winter(i,2)+1) = winter (i,3);
       if mod(i,hours)==0
            j=j+ 1;
        end
    end

    j=1; % Kano idia diadikasia gia kathe epoxi 
    for i=1:n_spr
       Sp_bikes(j,spring(i,2) +1)= spring(i,1);
       Sp_tempr(j,spring(i,2) +1)= spring(i,3);
       if mod(i,hours)==0
            j=j+ 1;
        end
    end

     j=1;
    for i=1:n_sum
       Su_bikes(j,summer(i,2) +1)= summer(i,1);
       Su_tempr(j,summer(i,2) +1)= summer(i,3);
       if mod(i,hours)==0
            j=j+ 1;
        end
    end

     j=1;
    for i=1:n_aut
        A_bikes(j,autumn(i,2) +1)= autumn(i,1);
        A_tempr(j,autumn(i,2) +1)= autumn(i,3);
       if mod(i,hours)==0
            j=j+ 1;
        end
    end
    
    alpha = 0.05;
    tcrit_win = tinv(1-alpha/2,n_win-2);
    tcrit_spr = tinv(1-alpha/2,n_spr-2);
    tcrit_sum = tinv(1-alpha/2,n_sum-2); 
    tcrit_aut = tinv(1-alpha/2,n_aut-2);
    
    fprintf('H MIDENIKI YPOTHESI (H0) EINAI OTI EXO MIDENIKI SISXETISI\n');
    
     sign_win = zeros(1,hours);  % Ston ena pinaka vazo tis statistika simantikes times
     non_sign_win =zeros(1,hours); % Ston allo tis oxi simantikes (sign apo significant)
     sign_spr = zeros(1,hours);
     non_sign_spr =zeros(1,hours);
     sign_sum = zeros(1,hours);
     non_sign_sum =zeros(1,hours);
     sign_aut = zeros(1,hours);
     non_sign_aut =zeros(1,hours);

     fprintf('===================================================================\n');
     fprintf('WINTER\n');
     
    for i=1:hours
       r_temp=corrcoef(W_bikes(:,i) , W_tempr(:,i) );
       r_win(i) = r_temp(1,2);

       % Elexos simantikotitas tou sinte. sisxetisis me statistiko-t    
       t_win = r_win(i)*sqrt((n_win-2)/(1-r_win(i)^2));
       if abs(t_win)>tcrit_win
         sign_win(i) = r_win(i);
         fprintf(' Hour: %d , abs(t-statistic)=%f > %f -> reject H0 \n',i-1,abs(t_win),tcrit_win);
       else
         non_sign_win = r_win(i);
         fprintf(' Hour: %d , abs(t-statistic)=%f > %f -> no reject H0 \n',i-1,abs(t_win),tcrit_win);
       end
    end
    % Deixno to apotelesmata meso bars
    figure;
    subplot(1,2,1)
    bar(sign_win);
    xlabel('hours');
    ylabel('r');
    title('Winter Significant');
    subplot(1,2,2)
    bar(non_sign_win);
    xlabel('hours');
    ylabel('r');
    title('Winter non Significant');

     fprintf('===================================================================\n');
     fprintf('SPRING\n');

  for i=1:hours
       r_temp=corrcoef(Sp_bikes(:,i) , Sp_tempr(:,i) );
       r_spr(i) = r_temp(1,2);

       % Elexos simantikotitas tou sinte. sisxetisis me statistiko-t    
       t_spr = r_spr(i)*sqrt((n_spr-2)/(1-r_spr(i)^2));
       if abs(t_spr)>tcrit_spr
         sign_spr(i) = r_spr(i);
         fprintf(' Hour: %d , abs(t-statistic)=%f > %f -> reject H0 \n',i-1,abs(t_spr),tcrit_spr);
       else
         non_sign_spr = r_spr(i);
         fprintf(' Hour: %d , abs(t-statistic)=%f > %f -> no reject H0 \n',i-1,abs(t_spr),tcrit_spr);
       end
  end

    figure;
    subplot(1,2,1)
    bar(sign_spr);
    xlabel('hours');
    ylabel('r');
    title('Spring Significant');
    subplot(1,2,2)
    bar(non_sign_spr);
     xlabel('hours');
    ylabel('r');
    title('Spring non Significant');

    
     fprintf('===================================================================\n');
     fprintf('SUMMER\n');

  for i=1:hours
       r_temp=corrcoef(Su_bikes(:,i) , Su_tempr(:,i) );
       r_sum(i) = r_temp(1,2);

       % Elexos simantikotitas tou sinte. sisxetisis me statistiko-t    
       t_sum = r_sum(i)*sqrt((n_sum-2)/(1-r_sum(i)^2));
       if abs(t_sum)>tcrit_sum
         sign_sum(i) = r_sum(i);
         fprintf(' Hour: %d , abs(t-statistic)=%f > %f -> reject H0 \n',i-1,abs(t_sum),tcrit_sum);
       else
         non_sign_sum(i) = r_sum(i);
         fprintf(' Hour: %d , abs(t-statistic)=%f > %f -> no reject H0 \n',i-1,abs(t_sum),tcrit_sum);
       end
  end


    figure;
    subplot(1,2,1)
    bar(sign_sum);
    xlabel('hours');
    ylabel('r');
    title('Summer Significant');
    subplot(1,2,2)
    bar(non_sign_sum);
    xlabel('hours');
    ylabel('r');
    title('Summer non Significant');


     fprintf('===================================================================\n');
     fprintf('AUTUMN\n');
     for i=1:hours
       r_temp=corrcoef(A_bikes(:,i) , A_tempr(:,i) );
       r_aut(i) = r_temp(1,2);

       % Elexos simantikotitas tou sinte. sisxetisis me statistiko-t    
       t_aut = r_aut(i)*sqrt((n_aut-2)/(1-r_aut(i)^2));
       if abs(t_aut)>tcrit_aut
         sign_aut(i) = r_aut(i);
         fprintf(' Hour: %d , abs(t-statistic)=%f > %f -> reject H0 \n',i-1,abs(t_aut),tcrit_aut);
       else
         non_sign_aut(i) = r_aut(i);
         fprintf(' Hour: %d , abs(t-statistic)=%f > %f -> no reject H0 \n',i-1,abs(t_aut),tcrit_aut);
       end
    end
    
    figure;
    subplot(1,2,1)
    bar(sign_aut);
    xlabel('hours');
    ylabel('r');
    title('Autumn Significant');
    subplot(1,2,2)
    bar(non_sign_aut);
     xlabel('hours');
    ylabel('r');
    title('Autumn non Significant');

 %{
   Paratiroume oti to kalokeri exei tis mikroteres times stis sisxetisis
  (poli mikres katholoy isxires) akoma kai tis ores pou oi sisxetisis epalitheoun 
  tin mideniki ipothesi (oti den iparxi sisxetisi). Episis einai i moni epoxi opou 
  exei arnitikes sisxetisis. 
  Gia tis ipolipes epoxes ipsiloteres sisxetisis vriskonte metaxi oron
  15-18 me to fthinoporo na exei mia ipsili sisxetisi tin ora 1. (Episis kai to
  kalokairi exei tis psiloteres sisxetisis metaksi ekinon ton oron omos
  poli mikres times). Oi psiloteres sisxetisis ton 3 epoxon exoyn times metaksi peripou 6.5-7 
  oi opoies den einai kai poli isxires omos metria isxires
  ** PROSOXI sta dedomena oi ores pou dinonte einai apo 0-23 eno stin apantisi apo 1-24
  Exo kani dld tin eksis antistixisi , 0->1 1->2 ... klp oste na mporoun na einai se ena array.
  Tha mporousame na to kanoume me fisher kai ci.
  %}