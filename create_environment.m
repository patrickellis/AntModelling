function create_environment(size)

%function that populates the global data structure representing
%environmental information

%ENV_DATA is a data structure containing information about the model
   %environment
   %    ENV_DATA.shape - shape of environment - FIXED AS SQUARE
   %    ENV_DATA.units - FIXED AS KM
   %    ENV_DATA.bm_size - length of environment edge in km
   %    ENV_DATA.food is  a bm_size x bm_size array containing distribution
   %    of food

global ENV_DATA PARAM

test = size;
if size < 25
    size = 200;
end
ENV_DATA.foragers = 0;
ENV_DATA.seekers = 0;
ENV_DATA.shape='square';
ENV_DATA.units='millimetres';
ENV_DATA.num_colonies = 1;
ENV_DATA.bm_size=size;
ENV_DATA.food=floor(zeros(300,200));        %distribute food in km x km squares 
ENV_DATA.pheromone_grid = zeros(size,size,ENV_DATA.num_colonies);
ENV_DATA.P_A = zeros(size,size,ENV_DATA.num_colonies);
ENV_DATA.P_B = zeros(size,size,ENV_DATA.num_colonies);

ENV_DATA.dx = 0.1;
ENV_DATA.dy = ENV_DATA.dx;
ENV_DATA.D = 1;
ENV_DATA.NX_STEPS = 200; %floor(ENV_DATA.bm_size/ENV_DATA.dx);
ENV_DATA.NY_STEPS = 300; %floor(ENV_DATA.bm_size/ENV_DATA.dy);
ENV_DATA.u0 = zeros(ENV_DATA.NX_STEPS,ENV_DATA.NY_STEPS);
ENV_DATA.U_FIELD_VARIABLE = zeros(ENV_DATA.NX_STEPS,ENV_DATA.NY_STEPS);
ENV_DATA.U_FIELD_VARIABLE_B = zeros(ENV_DATA.NX_STEPS,ENV_DATA.NY_STEPS);
ENV_DATA.returned = 0;

ENV_DATA.centerX = 175;
ENV_DATA.centerY = 100;
ENV_DATA.radius = 25;


[x,y] = meshgrid(1:200, 1:300);
if test == 1
    % one food source
    isinside = (x - 100).^2 + (y - 200).^2 <= 25^2;
    ENV_DATA.food(isinside) = ENV_DATA.food(isinside) + 200;
    
    ENV_DATA.food1x = 100;
    ENV_DATA.food1y = 200;
    PARAM.F_COLONY = [100,100];
    ENV_DATA.food1r = 25;
    ENV_DATA.food2x = 1000;
    ENV_DATA.food2y = 1000;
    ENV_DATA.food2r = 2500;
elseif test == 2
    % two food sources
    % same size, same distance
    isinside = (x - 50).^2 + (y - 150).^2 <= 25^2;
    ENV_DATA.food(isinside) = ENV_DATA.food(isinside) + 200;

    isinside = (x - 150).^2 + (y - 50).^2 <= 25^2;
    ENV_DATA.food(isinside) = ENV_DATA.food(isinside) + 200;

    ENV_DATA.food1x = 50;
    ENV_DATA.food1y = 150;
    ENV_DATA.food1r = 25;
    ENV_DATA.food2x = 150;
    ENV_DATA.food2y = 50;
    ENV_DATA.food2r = 25;
elseif test == 3
    % two food sources
    % one small and one medium, same distance
    isinside = (x - 50).^2 + (y - 150).^2 <= 25^2;
    ENV_DATA.food(isinside) = ENV_DATA.food(isinside) + 200;

    isinside = (x - 150).^2 + (y - 50).^2 <= 38^2;
    ENV_DATA.food(isinside) = ENV_DATA.food(isinside) + 200;

    ENV_DATA.food1x = 50;
    ENV_DATA.food1y = 150;
    ENV_DATA.food1r = 25;
    ENV_DATA.food2x = 150;
    ENV_DATA.food2y = 50;
    ENV_DATA.food2r = 38;
elseif test == 4
    % two food sources
    % one small and one big, same distance
    isinside = (x - 50).^2 + (y - 150).^2 <= 25^2;
    ENV_DATA.food(isinside) = ENV_DATA.food(isinside) + 200;

    isinside = (x - 150).^2 + (y - 50).^2 <= 50^2;
    ENV_DATA.food(isinside) = ENV_DATA.food(isinside) + 200;

    ENV_DATA.food1x = 50;
    ENV_DATA.food1y = 150;
    ENV_DATA.food1r = 25;
    ENV_DATA.food2x = 150;
    ENV_DATA.food2y = 50;
    ENV_DATA.food2r = 50;
elseif test == 5
    % two food sources
    % same size, one far and one medium
    isinside = (x - 50).^2 + (y - 150).^2 <= 25^2;
    ENV_DATA.food(isinside) = ENV_DATA.food(isinside) + 200;

    isinside = (x - 100).^2 + (y - 50).^2 <= 25^2;
    ENV_DATA.food(isinside) = ENV_DATA.food(isinside) + 200;

    ENV_DATA.food1x = 50;
    ENV_DATA.food1y = 150;
    ENV_DATA.food1r = 25;
    ENV_DATA.food2x = 100;
    ENV_DATA.food2y = 50;
    ENV_DATA.food2r = 25;
elseif test == 6
    % two food sources
    % same size, one far and one close
    isinside = (x - 50).^2 + (y - 150).^2 <= 25^2;
    ENV_DATA.food(isinside) = ENV_DATA.food(isinside) + 200;

    isinside = (x - 50).^2 + (y - 50).^2 <= 25^2;
    ENV_DATA.food(isinside) = ENV_DATA.food(isinside) + 200;

    ENV_DATA.food1x = 50;
    ENV_DATA.food1y = 150;
    ENV_DATA.food1r = 25;
    ENV_DATA.food2x = 50;
    ENV_DATA.food2y = 50;
    ENV_DATA.food2r = 25;
elseif test == 7
    % two food sources
    % one small and one medium, one far and one medium
    % LARGE MEDIUM, SMALL FAR
    isinside = (x - 50).^2 + (y - 150).^2 <= 25^2;
    ENV_DATA.food(isinside) = ENV_DATA.food(isinside) + 200;

    isinside = (x - 100).^2 + (y - 50).^2 <= 50^2;
    ENV_DATA.food(isinside) = ENV_DATA.food(isinside) + 200;

    ENV_DATA.food1x = 50;
    ENV_DATA.food1y = 150;
    ENV_DATA.food1r = 25;
    ENV_DATA.food2x = 100;
    ENV_DATA.food2y = 50;
    ENV_DATA.food2r = 50;
elseif test == 8
    % two food sources
    % one small and one large, one far and one close
    % LARGE CLOSE, SMALL FAR
    isinside = (x - 50).^2 + (y - 150).^2 <= 25^2;
    ENV_DATA.food(isinside) = ENV_DATA.food(isinside) + 200;

    isinside = (x - 50).^2 + (y - 50).^2 <= 50^2;
    ENV_DATA.food(isinside) = ENV_DATA.food(isinside) + 200;

    ENV_DATA.food1x = 50;
    ENV_DATA.food1y = 150;
    ENV_DATA.food1r = 25;
    ENV_DATA.food2x = 50;
    ENV_DATA.food2y = 50;
    ENV_DATA.food2r = 50;
elseif test == 9
    % two food sources
    % one small and one medium, one far and one medium
    % LARGE FAR, SMALL MEDIUM
    isinside = (x - 50).^2 + (y - 150).^2 <= 38^2;
    ENV_DATA.food(isinside) = ENV_DATA.food(isinside) + 200;

    isinside = (x - 100).^2 + (y - 50).^2 <= 25^2;
    ENV_DATA.food(isinside) = ENV_DATA.food(isinside) + 200;

    ENV_DATA.food1x = 50;
    ENV_DATA.food1y = 150;
    ENV_DATA.food1r = 38;
    ENV_DATA.food2x = 100;
    ENV_DATA.food2y = 50;
    ENV_DATA.food2r = 25;
elseif test == 10
    % two food sources
    % one small and one large, one far and one close
    % LARGE FAR, SMALL CLOSE
    isinside = (x - 50).^2 + (y - 150).^2 <= 50^2;
    ENV_DATA.food(isinside) = ENV_DATA.food(isinside) + 200;

    isinside = (x - 50).^2 + (y - 50).^2 <= 25^2;
    ENV_DATA.food(isinside) = ENV_DATA.food(isinside) + 200;

    ENV_DATA.food1x = 50;
    ENV_DATA.food1y = 150;
    ENV_DATA.food1r = 50;
    ENV_DATA.food2x = 50;
    ENV_DATA.food2y = 50;
    ENV_DATA.food2r = 25;
else
    ENV_DATA.centerX = 175;
    ENV_DATA.centerY = 175;
    ENV_DATA.radius = 25;
    isinside = (x - ENV_DATA.centerX).^2 + (y - ENV_DATA.centerY).^2 <= ENV_DATA.radius^2;
    ENV_DATA.food(isinside) = ENV_DATA.food(isinside) + 200;

    ENV_DATA.food1x = 175;
    ENV_DATA.food1y = 175;
    ENV_DATA.food1r = 25;
    ENV_DATA.food2x = 175;
    ENV_DATA.food2y = 175;
    ENV_DATA.food2r = 25;
end

imshow(ENV_DATA.food,[]); axis xy;
%ONLY FOR INITIAL SETUP

