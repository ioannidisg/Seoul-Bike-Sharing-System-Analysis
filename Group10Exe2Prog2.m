close all; % TO PIO SOSTO
clear;
clc;

data = importdata("SeoulBike.xlsx");
data = data.data;

seasons={'Winter','Spring','Summer' ,'Autumn'};
epoxes = [0 0 0 0]; %kathe thesi antistixi se ena counter gia ta dedomena pou exo se kathe epoxi
hours = 24;         %thesi 1 antistixi ston xeimona pou i timi tou season einai 1 klp

data(7225:7241,:)=[];

for i=1:length(data)
    epoxes(data(i,11))= epoxes(data(i,11)) +1; 
end

W = data(1:epoxes(1),1);

for i=1:epoxes(1)
    Bikes_Win(i) = data(i,1); %W = data(1:epoxes(1),1); ***αυτο πολύ καλύτερο και δεν θέλω ούτε for
end

for i= epoxes(1)+1 : epoxes(1) + epoxes(2)
    Bikes_Spr(i-epoxes(1)) = data(i,1);
end

for i= epoxes(1)+epoxes(2)+1 : epoxes(1) + epoxes(2)+epoxes(3)
    Bikes_Sum(i-epoxes(1)-epoxes(2)) = data(i,1);
end

for i= epoxes(1)+epoxes(2)+epoxes(3)+1 : epoxes(1) + epoxes(2)+epoxes(3)+epoxes(4)
    Bikes_Aut(i-epoxes(1)-epoxes(2)-epoxes(3)) = data(i,1);
end

Bikes_Win = Bikes_Win'; % ουτε αυτό θα χρειαζόταν αν γινόταν με τον πάνω τρόπο ***
Bikes_Spr = Bikes_Spr';
Bikes_Sum = Bikes_Sum';
Bikes_Aut = Bikes_Aut';

% [countsWin, edgesWin] = histcounts(Bikes_Win);
% [countsSpr, ~] = histcounts(Bikes_Spr, edgesWin); % Δημιουργία ιστόγραμματος του B με τα ίδια bins


M = 100;

for j=1:M 
    samples = 100 ;

    Bikes_Sum_Sample = datasample (Bikes_Sum , samples ,'Replace', false) ;
    Bikes_Aut_Sample = datasample (Bikes_Aut , samples,'Replace', false ) ;    
    
    [~,edges] = histcounts([Bikes_Sum_Sample, Bikes_Aut_Sample]); 
    Expected = histcounts(Bikes_Sum_Sample,edges);
     
    alpha = 0.05;
    [h1(j), p1(j), ~] = chi2gof(Bikes_Aut_Sample, 'Edges', edges, 'Expected',Expected , 'Alpha', alpha);
   
   
end

fprintf('Ποσοστό που δεν διαφέρει η κατανομή Winter-Spring: %0.4f.%% \n',  length (find( h1 == 0 )) );



% % Δημιουργία τυχαίων δεδομένων που ακολουθούν ομοιόμορφη κατανομή
% data = rand(100, 1);
% 
% % Εφαρμογή του τεστ χι-τετραγωνικής για ομοιόμορφη κατανομή
% [h, p] = chi2gof(data, 'cdf', @unifcdf);
% 
% fprintf('h (υποθέσεως H0 απόρριψη): %d\n', h);
% fprintf('p-τιμή: %f\n', p);
% 
% 
% a = 0;
% b = 1;
% pd = makedist('Uniform', 'lower', a, 'upper', b);
% 
% [h, p] = chi2gof(data, 'cdf', pd);
% fprintf('p-value: %f\n', p);

