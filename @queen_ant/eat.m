
function [agt,eaten]=eat(agt,cn)

%eating function for class FOX
%agt=fox object
%cn - current agent number
%eaten = 1 if fox successfully finds a rabbit, =0 otherwise

%SUMMARY OF FOX EAT RULE
%Fox calculates distance to all rabbits
%Fox identifies nearest rabbits(s)
%If more than one equidistant within search radius, one is randomly picked
%Probability of fox killing rabbit =1 - distance of rabbit/speed of fox
%If probability > rand, fox moves to rabbit location and rabbit is
%killed
%If fox does not kill rabbit, it's food is decremented by one unit

%GLOBAL VARIABLES
%N_IT is current iteration number
%IT_STATS is data structure containing statistics on model at each
%iteration (no. agents etc)
%MESSAGES is a data structure containing information that agents need to
%broadcast to each other
   %    MESSAGES.atype - n x 1 array listing the type of each agent in the model
   %    (1=rabbit, 2-fox, 3=dead agent)
   %    MESSAGES.pos - list of every agent position in [x y]
   %    MESSAGE.dead - n x1 array containing ones for agents that have died
   %    in the current iteration
   


global  IT_STATS N_IT MESSAGES ENV_DATA


pos=agt.pos;                        %extract current position 
cfood=agt.food;                     %get current agent food level
spd=agt.speed;                      %fox migration speed in units per iteration - this is equal to the food search radius
hungry=1;
eaten=0;
carrying = agt.carrying;

food = ENV_DATA.food;



[i,j] = find(food);
disp(size(food));
%disp(i)
%disp(j)
dist = sqrt((i(:,1)-pos(:,1)).^2+(j(:,1)-pos(:,2)).^2);
[d,ind] = min(dist);
num_nearest = length(ind);

if num_nearest > 1
    s = round(rand*(num_nearest-1))+1;
    d = d(s);
    ind = ind(s);
end

disp('size(ind): ');
disp(size(ind))
disp('i(ind): ');
disp(i(ind))
disp('j(ind): ');
disp(j(ind))
    
if d < spd&length(ind)>0
    nx = i(ind);
    ny = j(ind);
    npos = [nx ny];
    agt.pos=npos;
    IT_STATS.eaten(N_IT+1)=IT_STATS.eaten(N_IT+1)+1;
    agt.carrying = 10;
    eaten=1;
    agt.age=agt.age + 1;
end
%disp(i(ind))
%disp(j(ind))
%disp(size(dist))
%disp(d)
%disp(ind)

%if hungry==1
%    agt.food=cfood-1;     %if no food, then reduce agent food by one unit
    
end


   
