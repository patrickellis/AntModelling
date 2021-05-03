function [agt]=migrate(agt,cn)
%migration functions for class FOX
%agt=fox object
%cn - current agent number

%SUMMARY OF FOX MIGRATE RULE
%If a fox has not eaten, it will pick a random migration direction
%If it will leave the edge of the model, the direction is incremented by 45
%degrees at it will try again (up to 8 times)


global IT_STATS N_IT ENV_DATA PARAM

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
spd=agt.speed;   
pos=agt.pos;     %extract current position 
colony = PARAM.F_COLONY;
mig=0;
cnt=1;
isNotCarrying = (agt.carrying == 0);

if (N_IT == 1) % if this is the first iteration, initialise agt.w
    while mig==0&&cnt<=8
        
        npos(1)=pos(1)+spd*cos(dir);
        npos(2)=pos(2)+spd*sin(dir);

        if npos(1)<bm&npos(2)<bm&npos(1)>=1&npos(2)>=1   %check that white_cell has not left edge of model - correct if so.
           agt.w = sqrt(npos(1)^2-npos(2)^2);
           mig=1;
        end
        cnt = cnt+1;
       
    end
    
elseif isNotCarrying
    agt.activity = "foraging";
    mig = 0;
    while mig==0&&cnt<=8
        sig = 1.0991;
        w = agt.w + normrnd(0,sig);
        %disp(['agt.w size: ']);
        %disp([size(agt.w)])
        %disp(['w.size: '])
        %disp(size(w));
        %disp('w: ');
        %disp(w);
        npos(1) = pos(1) + PARAM.A_SPATIAL_STEP_SIZE * cos(w);
        npos(2) = pos(2) + PARAM.A_SPATIAL_STEP_SIZE * sin(w);
        if npos(1)<bm&npos(2)<bm&npos(1)>=1&npos(2)>=1   %check that fox has not left edge of model - correct if so.
           mig=1;
           agt.w = w ;
        end
        if cnt == 8 || mig == 1
            x = floor(pos(1));
            y = floor(pos(2));
            %%PHEROMONE UPDATE HERE
            ENV_DATA.P_A(x,y) = ENV_DATA.P_A(x,y) + PARAM.M;
        end
        cnt=cnt+1;
        %agt.w = agt.w + 1/8 * pi ;
    end
    
    
    
elseif ~isNotCarrying
    agt.activity = "returning to colony";
    %CALCULATE ROUTE BACK TO COLONY AND MOVE TOWARDS IT
    dir_vec = colony - pos;
    mag_vec = sqrt(dir_vec(1)^2 + dir_vec(2)^2);
    dir_vec = dir_vec / mag_vec * spd;
    npos(1)=pos(1)+dir_vec(1);
    npos(2)=pos(2)+dir_vec(2);
    mig=1;
    x = floor(pos(1))
    y = floor(pos(2))
    ENV_DATA.P_B(x,y) = ENV_DATA.P_B(x,y) + PARAM.M;
    
    if (mag_vec < 4)
        mig = 0;
        agt.pos=PARAM.F_COLONY;
        agt.carrying = 0;
        agt.activity = "foraging";
        %ADD CODE TO ALTER COLONY FOOD LEVEL HERE
    end
    
end

if mig==1
    agt.pos=npos;                    %update agent memory
    IT_STATS.mig(N_IT+1)=IT_STATS.mig(N_IT+1)+1;    %update model statistics
end

end
    
   
