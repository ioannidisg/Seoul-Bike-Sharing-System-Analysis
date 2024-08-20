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
n_win = length(winter);

for i=epoxes(1):-1:1 % μειώνεται κατά ένα κάθε φορά μέχρι να φτάσει στο 1
    if winter(i,12) == 1
        winter(i,:)=[];
    end
end

n_win = length(winter);
   
    s_aks=20;

    for h=1:hours
        Y = zeros(n_win/hours,1);
        cnt=1;

        for i=1:n_win
            if( winter(i,2)+1 == h )
                Y(cnt) = winter(i,1);
                X(cnt,:) = winter(i,3:10);
                cnt=cnt+1;
            end 
        end
        
        s_ekm = length(X)-s_aks;

        model = fitlm( X(1:s_ekm,:) , Y(1:s_ekm,:) );
        b = model.Coefficients.Estimate;
        x_reg = [ones(20,1) X(s_ekm+1:end,:)] ;
        predictions_1a(:,h) = x_reg *(b);

        [b_step_1,~,~,s_model,stats] = stepwisefit( X(1:s_ekm,:) , Y(1:s_ekm,:));
        b0 = stats.intercept;
        bStepwise_1 = [b0; b_step_1(s_model)];
        x_reg_step = [ones(s_aks,1) X(s_ekm+1:end,s_model)];
        predictions_step_1(:,h) = x_reg_step * bStepwise_1;
        
    end

    all_predictions=[];
    all_predictions_step=[];

    for i=1:hours
        all_predictions = [all_predictions ;predictions_1a(:,h)];
        all_predictions_step = [ all_predictions_step ; predictions_step_1(:,h) ];
    end
     

     mu = mean(winter(s_ekm*24+1:end));
     e_step = winter((s_ekm*24)+1:end,1)-all_predictions_step;
     k1 = sum(s_model);
     adjR2_step =1-((s_aks*24-1)/(s_aks*24-(k1+1)))*(sum(e_step.^2))/(sum((winter(s_ekm*24+1:end)-mu).^2)) ;
    
    
     eV = winter((s_ekm*24)+1:end,1)-all_predictions;
     R2 = 1-(sum(eV.^2))/(sum((winter((s_ekm*24)+1:end)-mu).^2));
     adjR2 = 1-((s_aks*24-1)/(s_aks*24-2)) * (sum(eV.^2))/(sum((winter(s_ekm*24+1:end)-mu).^2)) ;


    %for i=1:n_win
        Y = winter(:,1);
        X = winter(:,2:10);
   % end
    
    s_aks_2 = s_aks*24;
    s_ekm_2 = s_ekm*24;

    model_a2 = fitlm(X(1:s_ekm_2,:),Y(1:s_ekm_2));
    b_a2 = model_a2.Coefficients.Estimate;
    x_reg_a2 = [ones(s_aks_2,1) X(s_ekm_2+1:end,:)] ;
    predictions_2a = x_reg_a2 *(b_a2);
    
    mu = mean(Y(s_ekm+1:end));
    eV = Y(s_ekm_2+1:end)-predictions_2a;
    R2_2a = 1-(sum(eV.^2))/(sum((Y(s_ekm_2+1:end)-mu).^2));
    adjR2_2a = 1-((s_aks_2-1)/(s_aks_2-2)) * (sum(eV.^2))/(sum((Y(s_ekm_2+1:end)-mu).^2)) ;

    [b_step_2,~,~,s_model_2,stats] = stepwisefit( X(1:s_ekm_2,:) , Y(1:s_ekm_2,:));
    b0_2 = stats.intercept;
    bStepwise_2 = [b0_2 ; b_step_2(s_model_2)];
    x_reg_step_2 = [ones(s_aks_2,1) X(s_ekm_2+1:end,s_model_2)];
    predictions_step_2 = x_reg_step_2 * bStepwise_2;
    
    e_step_2 = Y(s_ekm_2+1:end)-predictions_step_2;
    k1_2 = sum(s_model);
    adjR2_step_2 =1-((s_aks_2-1)/(s_aks_2-(k1_2+1)))*(sum(e_step_2.^2))/(sum((Y(s_ekm_2+1:end)-mu).^2)) ;

