function [deviation,noise] = correlated_walk(agt)
global PARAM
hasFood = (agt.carrying==0);
pos = agt.pos;
w = agt.w;
[con_LA, con_LB,con_RA,con_RB] = pheromone(agt);
deviation = 0;
noise = 1;
ph_density = 1;

alpha = PARAM.C_MIN;

D_A = abs((con_LA-con_RA)/(con_LA+con_RA));
D_B = abs((con_LB-con_RB)/(con_LB+con_RB));

if agt.activity == "foraging"
    %if con_LB > 0.001 || con_RB > 0.001
        
            if D_B > alpha

                if con_RB > con_LB %D_B > alpha
                    ph_density = PARAM.C_THRESH/con_RB;
                    %disp("fuck yeah migrating towards highest conc migratory boi");
                    deviation = -30;
                end
                if con_RB < con_LB %D_B > alpha
                    %disp("fuck yeah migrating towards highest conc..B");
                    ph_density = PARAM.C_THRESH/con_LB;
                    deviation = 30;
                end
            else
                deviation =0;
            end
        %end
    
    
    
elseif agt.activity == "nest searching"
    if D_A > alpha
        if con_RA > con_LA %D_A > alpha
            %disp("fuck yeah migrating towards highest conc nesty searchy boi");
            deviation = -30;
        elseif con_RA < con_LA %D_A > alpha
            %disp("fuck yeah migrating towards highest conc also nesty searchy");
            deviation = 30;
        else 
            deviation = 0;
        end
    end
end

if ph_density < noise
    noise = ph_density;
end

end
        
%w_new = agt.w + pheromone(agt) +