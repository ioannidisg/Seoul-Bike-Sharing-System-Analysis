%Ioannidis Georgios 


clc;
clear;
close all;

data = importdata("SeoulBike.xlsx");   
data = data.data;

data(7225:7241,:)=[];

seasons={'Winter','Spring','Summer' ,'Autumn'};
epoxes = [0 0 0 0]; %kathe thesi antistixi se ena counter gia ta dedomena pou exo se kathe epoxi
hours = 24;         %thesi 1 antistixi ston xeimona pou i timi tou season einai 1 klp

for i=1:length(data)
    epoxes(data(i,11))= epoxes(data(i,11)) +1; 
end

%xorizo ta dedomena se epoxes
winter = data(1:epoxes(1),:);
spring = data(epoxes(1)+1:epoxes(1)+epoxes(2),:);
summer = data(epoxes(1)+epoxes(2)+1:epoxes(1)+epoxes(2)+epoxes(3),:);
autumn = data(epoxes(1)+epoxes(2)+epoxes(3)+1:epoxes(1)+epoxes(2)+epoxes(3)+epoxes(4),:); 

  n_win = length(winter); %posa dedomena exo se kathe epoxi to kano me length
  n_spr = length(spring); %etsi kano kai epalitheusi me epoxes(1...4)
  n_sum = length(summer);
  n_aut = length(autumn);

   
 katanomes = {'Normal'  , 'Logistic'  , 'Lognormal'   ,'Exponential' ,'Weibull','Gamma','Rayleigh','Kernel','Rician' ,'Extremevalue'}; 
    
    best_katanomi_win = 0; %arxikopoiisi tou index tis kaliteris katanomis 
    best_katanomi_spr = 0;
    best_katanomi_sum = 0;
    best_katanomi_aut = 0;
    a=0.05; %gia na theoriso oti prosarmozetai se kapoia katanomi prepei 
    % pvalue na einai > a

   
        best_win = 0;
        best_spr = 0;
        best_sum = 0;
        best_aut = 0;

        for i=1:length(katanomes) % gia ton elexo kathe katanomis pou evala na elexi
             pd_win = fitdist( winter(:,1) , katanomes{i} );
             pd_spr = fitdist( spring(:,1) , katanomes{i} );
             pd_sum = fitdist( summer(:,1) , katanomes{i} );
             pd_aut = fitdist( autumn(:,1) , katanomes{i} );
             
             %Tha elexo me tin ptimi poso prosarmozetai stin katanomi
             [~, p_win, ~] = chi2gof(winter(:,1) , "CDF" , pd_win); 
             [~, p_spr, ~] = chi2gof(spring(:,1) , "CDF" , pd_spr);
             [~, p_sum, ~] = chi2gof(summer(:,1) , "CDF" , pd_sum);
             [~, p_aut, ~] = chi2gof(autumn(:,1) , "CDF" , pd_aut);

             %etsi epilego tin megaliteri p timi gia kate epoxi
             if p_win > best_win && p_win>a  %otan einai poli mikro to p den prosarmozetai stin katanomi
                best_win = p_win;
                best_katanomi_win = i;
             end

              if p_spr > best_spr && p_spr>a
                best_spr = p_spr;
                best_katanomi_spr = i;
              end

             if p_sum > best_sum && p_sum>a
                best_sum = p_sum;
                best_katanomi_sum = i;
             end


             if p_aut > best_aut && p_aut>a
                best_aut = p_aut;
                best_katanomi_aut = i;
             end

        end         
    
      
     fprintf('Best distribution at %s : %s\n', seasons{1}, katanomes{best_katanomi_win} );
     fprintf('Best distribution at %s : %s\n', seasons{2}, katanomes{best_katanomi_spr} );
     fprintf('Best distribution at %s : %s\n', seasons{3}, katanomes{best_katanomi_sum} );
     fprintf('Best distribution at %s : %s\n', seasons{4}, katanomes{best_katanomi_aut} );

% Paratiro oti gia oles tis epoxes i katallili katanomi einai idia.

