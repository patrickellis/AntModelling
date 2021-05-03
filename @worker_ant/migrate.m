function [agt]=migrate(agt,cn)
%migration functions for class FOX
%agt=fox object
%cn - current agent number

%SUMMARY OF FOX MIGRATE RULE
%If a fox has not eaten, it will pick a random migration direction
%If it will leave the edge of the model, the direction is incremented by 45
%degrees at it will try again (up to 8 times)


global IT_STATS N_IT ENV_DATA PARAM 

%% CORRECT FUNCTION FOR WORKER ANT %%%

%N_IT is current iteration number
%IT_STATS is data structure containing statistics on model at each
%iteration (no. agents etc)
%ENV_DATA is a data structure containing information about the model
%environment
   %    ENV_DATA.shape - shape of environment - FIXED AS SQUARE
   %    ENV_DATA.units - FIXED AS KM
   %    ENV_DATA.bm_size - length of environment edge in km
   %    ENV_DATA.food is  a bm_size x bm_size array containing distribution
   %    of food
     
  
bm=ENV_DATA.bm_size;   
spd=agt.speed;   %fos migration speed in units per iteration - this is equal to the food search radius
pos=agt.pos;     %extract current position 
colony = PARAM.F_COLONY;
mig=0;

%food = [ENV_DATA.centerY,ENV_DATA.centerX];

food = [ENV_DATA.food1x, ENV_DATA.food1y];
food2 = [ENV_DATA.food2x,ENV_DATA.food2y];
isNotCarrying = (agt.carrying == 0);
L = 4.2; %2 * PARAM.A_LENGTH;
cnt = 1;
[angular_deviation, noise] = correlated_walk(agt);
if agt.w > 360 || agt.w < 0
    while agt.w > 360 || agt.w < 0
        if agt.w > 360
            agt.w = agt.w - 360;
        end
        if agt.w < 0
            agt.w = agt.w + 360;
        end
    end
end

if (N_IT == 1) % if this is the first iteration, initialise agt.w
    while mig==0&cnt<=8
        %angular_deviation = normrnd(0,1.0991);
        angle = 360 * rand;
        radians_angle = angle * (pi / 180);
        npos(1) = pos(1) + L*cos(radians_angle);
        npos(2) = pos(2) + L*sin(radians_angle);
        if npos(1)<bm&npos(2)<bm+100&npos(1)>=1&npos(2)>=1   %check that white_cell has not left edge of model - correct if so.
           mig=1;
           agt.w = angle;
        end
        cnt = cnt+1;
        %dir = dir+(pi/4);
    end
end

bm_size = ENV_DATA.bm_size;
if isNotCarrying
    r2 = PARAM.R^2;
    NX = PARAM.NX;
    NY = PARAM.NY;
    U0 = PARAM.U0;
    M = PARAM.M;
    agt.activity = "foraging";
    mig = 0;
    ang_range = PARAM.ANGLE_RANDOM_MOVEMENT;
    prev_angle = agt.w;
    cnt = 1;
    
    while mig==0&cnt<=8
        
        angle = ang_range * normrnd(0,1); %DRAW ANGLE RANDOM NOISE FROM NORMAL DISTRIBUTION
        % literature review suggests that this noise should also depend on
        % perceived pheromone concentration ????
        angle = angle * noise;
        f1 = food(1);
        f2 = food(2);
        f1 = f1 + (bm_size/10)*(rand*2-1);
        f2 = f2 + (bm_size/10)*(rand*2-1);
        col_copy = food;
        col_copy(1) = f1;
        col_copy(2) = f2;
        dir_vec = col_copy - pos;
        mag_vec = sqrt(dir_vec(1).^2 + dir_vec(2).^2);
        dir_vec = dir_vec / mag_vec * L;
        
            
        angle_new = prev_angle + angular_deviation + angle;

        radians_angle = angle_new * (pi / 180);

       npos(1)=pos(1)+L*cos(radians_angle);
       npos(2)=pos(2)+L*sin(radians_angle);
        if mag_vec < 35
            npos(1)=pos(1)+dir_vec(1);
            npos(2)=pos(2)+dir_vec(2);
       
        end
        
        if npos(1)<bm&npos(2)<bm+100&npos(1)>=1&npos(2)>=1   %check that fox has not left edge of model - correct if so.
           mig=1;
           agt.w = angle_new;
        end
        f1 = food2(1);
        f2 = food2(2);
        f1 = f1 + (bm_size/10)*(rand*2-1);
        f2 = f2 + (bm_size/10)*(rand*2-1);
        col_copy = food2;
        col_copy(1) = f1;
        col_copy(2) = f2;
        dir_vec = col_copy - pos;
        mag_vec = sqrt(dir_vec(1).^2 + dir_vec(2).^2);
        dir_vec = dir_vec / mag_vec * L;
        if mag_vec < 35
            npos(1)=pos(1)+dir_vec(1);
            npos(2)=pos(2)+dir_vec(2);
        end
        if npos(1)<bm&npos(2)<bm+100&npos(1)>=1&npos(2)>=1   %check that fox has not left edge of model - correct if so.
           mig=1;
           agt.w = angle_new;
        end
        if cnt == 8 || mig == 1
            x = floor(pos(1));
            y = floor(pos(2));
            %%PHEROMONE UPDATE HERE
            %ENV_DATA.P_A(x,y) = ENV_DATA.P_A(x,y) + M;
            %if round(agt.pos(1))==x
            
            
        end
        displacement = 180 * normrnd(0,1); %DRAW ANGLE RANDOM NOISE FROM NORMAL DISTRIBUTION
        prev_angle = prev_angle + displacement;
        
        cnt=cnt+1;
        %agt.w = agt.w + 1/8 * pi ;
    end
end
    
    
if ~isNotCarrying
    mig =0;
    ang_range = PARAM.ANGLE_RANDOM_MOVEMENT;
    prev_angle = agt.w;
    cnt = 1;
    bm_size = ENV_DATA.bm_size;
    
        
        %agt.activity = "nest searching";
        
        c1 = colony(1);
        c2 = colony(2);
        c1 = c1 + (bm_size/10)*(rand*2-1);
        c2 = c2 + (bm_size/10)*(rand*2-1);
        col_copy = colony;
        col_copy(1) = c1;
        col_copy(2) = c2;
        dir_vec = col_copy - pos;
        mag_vec = sqrt(dir_vec(1).^2 + dir_vec(2).^2);
        dir_vec = dir_vec / mag_vec * L;
        
        while mig==0&cnt<=8
            angle = ang_range * normrnd(0,1); %DRAW ANGLE RANDOM NOISE FROM NORMAL DISTRIBUTION
        % literature review suggests that this noise should also depend on
        % perceived pheromone concentration ????
        angle = angle * noise;
       % if ~(agt.activity=="nest searching");
        %    prev_angle = prev_angle - 180; 
       % end
        angle_new = prev_angle + angular_deviation + angle;
        %angular_deviation = normrnd(0,1.0991);
                 radians_angle = angle_new * (pi / 180);
                npos(1) = pos(1) + L*cos(radians_angle);
                npos(2) = pos(2) + L*sin(radians_angle);
                
                if mag_vec < 35
                   npos(1)=pos(1)+dir_vec(1);
                   npos(2)=pos(2)+dir_vec(2);
                end
                if (mag_vec < 15)
            
                        agt.pos=PARAM.F_COLONY;
                        agt.carrying = 0;
                        agt.age = 0;
                        agt.activity = "foraging";
                        ENV_DATA.returned = ENV_DATA.returned + 1;

                        angle = ang_range * normrnd(0,1); %DRAW ANGLE RANDOM NOISE FROM NORMAL DISTRIBUTION
                        % literature review suggests that this noise should also depend on
                        % perceived pheromone concentration ????
                        prev_angle = 360 * rand;

                        [angular_deviation, noise] = correlated_walk(agt);
                        angle = angle * noise;
                        %angle = ang_range * normrnd(0,1); %DRAW ANGLE RANDOM NOISE FROM NORMAL DISTRIBUTION
                    % literature review suggests that this noise should also depend on
                    % perceived pheromone concentration ????

                         angle_new = prev_angle + angular_deviation + angle;

                        
                            radians_angle = angle_new * (pi / 180);
                            npos(1) = pos(1) + L*cos(radians_angle);
                            npos(2) = pos(2) + L*sin(radians_angle);
                            
                            mig=1;
                            agt.w = angle_new;
                           
                            
                      
                    %dir = dir+(pi/4);
                end
                if npos(1)<bm&npos(2)<bm+100&npos(1)>=1&npos(2)>=1   %check that white_cell has not left edge of model - correct if so.
                    if mig == 0
                       mig=1;
                       agt.w = angle_new;
                    end
                end
                cnt = cnt+1;
                displacement = 180 * normrnd(0,1); %DRAW ANGLE RANDOM NOISE FROM NORMAL DISTRIBUTION
                 prev_angle = prev_angle + displacement;
        end
        
       % angle = ang_range * (rand*2-1); %DRAW ANGLE RANDOM NOISE FROM NORMAL DISTRIBUTION
            % literature review suggests that this noise should also depend on
            % perceived pheromone concentration ????

        %angle_new = prev_angle + angular_deviation ; % + 180 to turn them around after findnig food?

        %radians_angle = angle_new * (pi / 180);

        %npos(1)=pos(1)+L*cos(radians_angle);
        %npos(2)=pos(2)+L*sin(radians_angle);
        
        
        
       
        if (mag_vec < 4.2)
            
            agt.pos=PARAM.F_COLONY;
            agt.carrying = 0;
            agt.age = 0;
            agt.activity = "foraging";
            ENV_DATA.returned = ENV_DATA.returned + 1;
            
            angle = ang_range * normrnd(0,1); %DRAW ANGLE RANDOM NOISE FROM NORMAL DISTRIBUTION
            % literature review suggests that this noise should also depend on
            % perceived pheromone concentration ????
            prev_angle = 360 * rand;
            
            [angular_deviation, noise] = correlated_walk(agt);
            angle = angle * noise;
            %angle = ang_range * normrnd(0,1); %DRAW ANGLE RANDOM NOISE FROM NORMAL DISTRIBUTION
        % literature review suggests that this noise should also depend on
        % perceived pheromone concentration ????
            
             angle_new = prev_angle + angular_deviation + angle;
             
            while mig==0&cnt<=8
        %angular_deviation = normrnd(0,1.0991);
                
                radians_angle = angle_new * (pi / 180);
                npos(1) = pos(1) + L*cos(radians_angle);
                npos(2) = pos(2) + L*sin(radians_angle);
                if npos(1)<bm&npos(2)<bm+100&npos(1)>=1&npos(2)>=1   %check that white_cell has not left edge of model - correct if so.
                   mig=1;
                   agt.w = angle_new;
                end
                cnt = cnt+1;
            end
        %dir = dir+(pi/4);
    end
        %ADD CODE TO ALTER COLONY FOOD LEVEL HERE
         end
        %if npos(1)<bm&npos(2)<bm&npos(1)>=1&npos(2)>=1   %check that fox has not left edge of model - correct if so.
        %   mig=1;
        %   agt.w = angle_new;
       % end
      
        


if mig==1
    agt.pos=npos;                    %update agent memory
    IT_STATS.mig(N_IT+1)=IT_STATS.mig(N_IT+1)+1;    %update model statistics
end

end
    
   
