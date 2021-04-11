function [agent]=create_agents(na)

 %creates the objects representing each agent
 
%agent - cell array containing list of objects representing agents
%nr - number of rabbits
%nf - number of foxes

%global parameters
%ENV_DATA - data structure representing the environment (initialised in
%create_environment.m)
%MESSAGES is a data structure containing information that agents need to
%broadcast to each other
%PARAM - structure containing values of all parameters governing agent
%behaviour for the current simulation
 
 global ENV_DATA MESSAGES PARAM 

colony = PARAM.F_COLONY;
bm_size=ENV_DATA.bm_size;     %generate random initial positions for rabbits
floc=(bm_size-1)*rand(na,2)+1;      %generate random initial positions for foxes
aloc = rand(na,2)+colony;



MESSAGES.pos=[aloc];


%generate all ant agents and record their positions in ENV_MAT_F
for a=1:na
    pos=aloc(a,:);
    %create fox agents with random ages between 0 and 10 days and random
    %food levels 20-40
    age=0;
    food=ceil(rand*20)+20;
    activity = "foraging"; %are they exploring randomly or following a trail/ isReturningHome (boolean)/ isForaging
    carrying = 0; % IsCarryingFood (boolean) / Amount of food being carried
    sex = "m";
    if(rand(2)>1); sex = "f"; end
    colony =  PARAM.F_COLONY; 
    patch_ahead = 10;
    field_of_view = 180;
    drop_size = 120;
    w = 0;
    direction = randi([1,4],1);
    
    agent{a}=worker_ant(age,food,pos,PARAM.A_SPD,PARAM.A_SPD,activity,carrying,sex,colony,patch_ahead,field_of_view,drop_size,w,direction);

end
                %patch_ahead; %number of patches ahead scanned for pheromones
                %field_of_view; 
                %drop_size; %strength of dropped pheromone trail