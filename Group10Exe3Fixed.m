% 23+22+21+20+19+18+17+16+15+14+13+12+11+10+9+8+7+6+5+4+3+2+1 = 276

clear;
clc;
close all;

data = importdata("SeoulBike.xlsx");  
data = data.data;

data(7225:7241,:)=[];

epoxes = [0 0 0 0];
hours = 24;

for i=1:length(data)
    epoxes(data(i,11))= epoxes(data(i,11)) +1; 
end
xeimonas = epoxes(1);

winter = data(1:epoxes(1),:);
spring = data(epoxes(1)+1:epoxes(1)+epoxes(2),:);
summer = data(epoxes(1)+epoxes(2)+1:epoxes(1)+epoxes(2)+epoxes(3),:);
autumn = data(epoxes(1)+epoxes(2)+epoxes(3)+1:epoxes(1)+epoxes(2)+epoxes(3)+epoxes(4),:); 

n_win = length(winter);
n_spr = length(spring);
n_sum = length(summer);
n_aut = length(autumn);

W= zeros(n_win/hours , hours); %Bikes per hour se stiles ton xeimona
Sp= zeros(n_spr/hours , hours); %Bikes per hour se stiles tin anixi
Su= zeros(n_sum/hours , hours); %Bikes per hour se stiles to kalokairi
A= zeros(n_aut/hours , hours); %Bikes per hour se stiles to fthinoporo
    
    %    j=1;
    % for i=1:n
    %    X (j,data(i,2) +1)= data(i,1);
    %    if mod(i,24)==0
    %         j=j+ 1;
    %     end
    % end

   
    j=1;
    for i=1:n_win
       W (j,winter(i,2) +1)= winter(i,1);
       if mod(i,hours)==0
            j=j+ 1;
        end
    end

    j=1;
    for i=1:n_spr
       Sp(j,spring(i,2) +1)= spring(i,1);
       if mod(i,hours)==0
            j=j+ 1;
        end
    end

    j=1;
    for i=1:n_sum
       Su(j,summer(i,2) +1)= summer(i,1);
       if mod(i,hours)==0
            j=j+ 1;
        end
    end

    j=1;
    for i=1:n_aut
        A(j,autumn(i,2) +1)= autumn(i,1);
       if mod(i,hours)==0
            j=j+ 1;
        end
    end

 df = zeros(276,90);

 days_win = n_win/hours;
 days_spr = n_spr/hours;
 days_sum = n_sum/hours;
 days_aut = n_aut/hours;
 

for day=1:days_win
cnt=1;

    for i=1:hours
        for j=(i+1):hours
            df(cnt,day) = (W(day,i) - W(day,j));
            cnt = cnt+1;
        end
    end
end

for i=1:276
        mesi_diafora(i)=mean(df(i,:));
        [h(i),~,~,~] = ttest(df(i,:));
end

mesi_diafora = squareform(mesi_diafora);
h = squareform(h);
        
        figure;
        colormap(jet);
        imagesc(mesi_diafora);
        colorbar; % Προσθήκη χρωματικής γραμμής για αντιστοίχιση των τιμών
        title('Hour'); % Προσθήκη τίτλου και ετικέτας στον άξονα y
        ylabel('Hour');
        colorbar;        % Εμφάνιση χάρτη χρωμάτω


        figure;
        colormap(jet);
        imagesc(h);
        colorbar; % Προσθήκη χρωματικής γραμμής για αντιστοίχιση των τιμών
        title('Hour'); % Προσθήκη τίτλου και ετικέτας στον άξονα y
        ylabel('Hour');
        colorbar;        % Εμφάνιση χάρτη χρωμάτω

   
