function create_params(size)

%set up breeding, migration and starvation threshold parameters. These
%are all completely made up!

%PARAM - structure containing values of all parameters governing agent
%behaviour for the current simulation

global PARAM
    PARAM.N = 200; %NUMBER OF ANTS
    PARAM.R_SPD=2;         %speed of movement - units per itn (rabbit)
    PARAM.A_SPD=8.4;      %8.3   
    PARAM.F_COLONY=[100,50];         %colony location
    PARAM.R_BRDFQ=10;      %breeding frequency - iterations
    PARAM.F_BRDFQ=20;
    PARAM.R_MINFOOD=0;      %minimum food threshold before agent dies 
    PARAM.F_MINFOOD=0;
    PARAM.R_FOODBRD=10;     %minimum food threshold for breeding
    PARAM.F_FOODBRD=10;
    PARAM.R_MAXAGE=50;      %maximum age allowed 
    PARAM.F_MAXAGE=50;
    PARAM.A_LENGTH=2.1;     %2.1mm (reference gives a range of 2-15)
    PARAM.A_SPATIAL_STEP_SIZE=4.2; % 2 * body length of ant
    PARAM.ANGLE_RANDOM_MOVEMENT = 15;
    %DIFFUSION CONSTANTS
    PARAM.DIFF_A = 1; %1mm^2/s 
    PARAM.DIFF_B = 5; %5mm^2/s
    %DECAY OF PHEROMONES
    PARAM.DEC_A = 200; %seconds
    PARAM.DEC_B = 100; 
    PARAM.M = 0.1; %amount of pheromone deposited in one deposition(g)
    PARAM.C_THRESH = 10^(-11); % grams, minimum detectable pheromone amount
    PARAM.C_MIN = 10^(-2); % grams, decrease in randomness of equation (10)
    PARAM.T_A = 80; % how long pheromones are deposited for
    PARAM.T_B = 80; % (TIME STEPS)
    PARAM.MULTI = 0.1; %multiplicator in numeric computation of pheromone field
    PARAM.ANTANNAE_LENGTH = 0.7; %1/3 body length
    PARAM.SIGMA = 1.0991; %standard deviation of random directional change
    %PHEROMONE MATRIX DENSITY
    PARAM.DX = 1;
    PARAM.DY = 1;
    PARAM.NX = floor(size/PARAM.DX);
    PARAM.NY = floor(size/PARAM.DY);
    PARAM.DX2 = PARAM.DX^2;
    PARAM.DY2 = PARAM.DY^2;
    PARAM.DT = PARAM.DX2 * PARAM.DY2 / (2 * PARAM.DIFF_A * (PARAM.DX2 + PARAM.DY2));
    PARAM.U0 = zeros(PARAM.NX,PARAM.NY);
    PARAM.U = zeros(PARAM.NX,PARAM.NY);
    PARAM.R = 0.5; %RADIUS OF DROPPED pheromone IN (mm)
    
    