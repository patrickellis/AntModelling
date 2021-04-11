function [agt]=migrate(agt,cn)
%migration functions for class FOX
%agt=fox object
%cn - current agent number

%SUMMARY OF FOX MIGRATE RULE
%If a fox has not eaten, it will pick a random migration direction
%If it will leave the edge of the model, the direction is incremented by 45
%degrees at it will try again (up to 8 times)
%modified by D Walker 11/4/08

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
spd=agt.speed;   %fos migration speed in units per iteration - this is equal to the food search radius
pos=agt.pos;     %extract current position 
colony = PARAM.F_COLONY
%x = colony(1,:)
mig=0;
cnt=1;
dir=rand*2*pi;              %fox has been unable to find food, so chooses a random direction to move in
isNotCarrying = (agt.carrying == 0);
%todo:
% search pheromone grid within 180 degree (FIELD_OF_VIEW) cone 
% if trail present, follow it

food = ENV_DATA.food;
pGrid = ENV_DATA.pheromone_grid;
% change so that patch ahead really is patch ahead and doesnt work in both
% directions
limitxlow = agt.patch_ahead;
limitylow = agt.patch_ahead;
limitxhigh = agt.patch_ahead;
limityhigh = agt.patch_ahead;



%[i,j] = find(pGrid(floor(pos(1))-limitxlow:floor(pos(1)+limitxhigh):floor(pos(2)+limityhigh),floor(pos(2)-agt.patch_ahead):floor(pos(2)+agt.patch_ahead)));
[i,j] = find(food);
dist = 100;
 % ? = Rho
% ? = Xi
% ? = Tao
% ? = sigma
if (N_IT == 1) % if this is the first iteration, initialise agt.w
    while mig==0&cnt<=8
        angular_deviation = normrnd(0,1.0991);
        dir=rand*2*pi
        
        npos(1)=pos(1)+spd*cos(dir);
        npos(2)=pos(2)+spd*sin(dir);
        %store this in agent later
        
        agt.w = sqrt(npos(1).^2-npos(2).^2);
        if npos(1)<bm&npos(2)<bm&npos(1)>=1&npos(2)>=1   %check that white_cell has not left edge of model - correct if so.
           mig=1;
        end
        cnt = cnt+1;
        dir = dir+(pi/4);
    end



c = 1;


v2 = pheromone_concentration;

sig = 1.0991;


%disp(angular_deviation);
 
    

elseif 48<1
    if i
        agt.activity = "foraging - following trail";
        dist = sqrt((i(:,1)-pos(:,1)).^2+(j(:,1)-pos(:,2)).^2);
        % for now, follow the closest pheromone trail in sight, change to
        % follow strongest
        [d,ind] = min(dist);
        num_nearest = length(ind);
        if num_nearest > 1
            s = round(rand*(num_nearest-1))+1;
            d = d(s);
            ind = ind(s);
        end
        if d < spd&length(dist)>0
            nx=i(ind)
            ny=j(ind)
            npos = [nx ny]
            agt.pos = npos 

        elseif d > spd
            dir_vec = [i(ind),j(ind)]-pos
            mag_vec = sqrt(dir_vec(1).^2+ dir_vec(2).^2);
            dir_vec = dir_vec / mag_vec * spd;
            npos(1) = pos(1)+dir_vec(1)
            npos(2) = pos(2)+dir_vec(2)
            disp(npos);
            mig=1;
        end
    else 
        while mig==0&cnt<=8        %fox has up to 8 attempts to migrate (without leaving the edge of the model)
        npos(1)=pos(1)+spd*cos(dir);        %new x co-ordinate
        npos(2)=pos(2)+spd*sin(dir);        %new y co-ordinate
        if npos(1)<bm&npos(2)<bm&npos(1)>=1&npos(2)>=1   %check that fox has not left edge of model - correct if so.
           mig=1;
        end
        cnt=cnt+1;
        dir=dir+(pi/4);         %if migration not successful, then increment direction by 45 degrees and try again
        end
    end
    
elseif isNotCarrying
    agt.activity = "foraging";
    while mig==0&cnt<=8
        sig = 1.0991;
        w = agt.w + normrnd(0,sig);
        disp(['agt.w size: ']);
        disp([size(agt.w)])
        disp(['w.size: '])
        disp(size(w));
        disp('w: ');
        disp(w);
        npos(1) = pos(1) + PARAM.A_SPATIAL_STEP_SIZE * cos(w);
        npos(2) = pos(2) + PARAM.A_SPATIAL_STEP_SIZE * sin(w);
        if npos(1)<bm&npos(2)<bm&npos(1)>=1&npos(2)>=1   %check that fox has not left edge of model - correct if so.
           mig=1;
           agt.w = w ;
        end
        cnt=cnt+1;
        %agt.w = agt.w + 1/8 * pi ;
    end
    
    
    
elseif ~isNotCarrying
    %%to-do - use alternate random movement system here as well. This is
    %%the only way to show emergent behaviour otherwise we would instantly
    %%form the shortest path in pheromones
    agt.activity = "returning to colony";
    %CALCULATE ROUTE BACK TO COLONY AND MOVE TOWARDS IT
    dir_vec = colony - pos;
    mag_vec = sqrt(dir_vec(1).^2 + dir_vec(2).^2);
    dir_vec = dir_vec / mag_vec * spd;
    npos(1)=pos(1)+dir_vec(1);
    npos(2)=pos(2)+dir_vec(2);
    %disp(npos);
    mig=1;
    % ALTER PHEROMONE LEVELS ON GROUND
    x = floor(pos(1))
    y = floor(pos(2))
    %ENV_DATA.pheromone_grid(x,y) = ENV_DATA.pheromone_grid(x,y) + agt.drop_size;
    % NOTE THE BELOW CODE WILL FAIL FOR EDGE CASES, PLEASE ADJUST
    %ENV_DATA.pheromone_grid(x+1,y) = ENV_DATA.pheromone_grid(x+1,y) + agt.drop_size/2;
    %ENV_DATA.pheromone_grid(x-1,y) = ENV_DATA.pheromone_grid(x-1,y) + agt.drop_size/2;
    %ENV_DATA.pheromone_grid(x,y+1) = ENV_DATA.pheromone_grid(x,y+1) + agt.drop_size/2;
    %ENV_DATA.pheromone_grid(x,y-1) = ENV_DATA.pheromone_grid(x,y-1) + agt.drop_size/2;
    %ENV_DATA.pheromone_grid(x+1,y+1) = ENV_DATA.pheromone_grid(x+1,y+1) + agt.drop_size/3;
    %ENV_DATA.pheromone_grid(x-1,y+1) = ENV_DATA.pheromone_grid(x-1,y+1) + agt.drop_size/3;
    %ENV_DATA.pheromone_grid(x-1,y-1) = ENV_DATA.pheromone_grid(x-1,y-1) + agt.drop_size/3;
    %ENV_DATA.pheromone_grid(x+1,y-1) = ENV_DATA.pheromone_grid(x+1,y-1) + agt.drop_size/3;
    if (mag_vec < 4)
        mig = 0;
        agt.pos=PARAM.F_COLONY;
        agt.carrying = 0;
        agt.activity = "foraging";
        %ADD CODE TO ALTER COLONY FOOD LEVEL HERE
    end
end
    function v = pheromone_concentration
        v = 2;
    end
if mig==1
    agt.pos=npos;                    %update agent memory
    IT_STATS.mig(N_IT+1)=IT_STATS.mig(N_IT+1)+1;    %update model statistics
end

end
    
   
