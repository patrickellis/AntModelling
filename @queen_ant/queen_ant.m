classdef queen_ant < ant          %declares worker ant object as a subclass of an ant
    properties         %define ant properties (parameters) 
        speed;
        maxspeed;
        activity; %are they exploring randomly or following a trail/ isReturningHome (boolean)/ isForaging
        patch_ahead; %number of patches ahead scanned for pheromones
        field_of_view; 
        drop_size; %strength of dropped pheromone trail
        w; %represents the direction of motion of the ant (vector)
    end
    methods                         %all additional member functions associated with this class are included as separate mfiles in the @ant folder. 
        function [agt,klld]=die(agt,cn)
            [agt,klld] = die@ant(agt,cn)
        end
        function a=queen_ant(varargin) %constructor method for ant  - assigns values to ant properties
                % f=ant(age,food,pos....)
                %age; %Age 
                %food; - amount of food that fox has eaten %Energy level/food level 
                %pos; - vector containg x,y, co-ords  %physical location
                %speed;
                %maxspeed;
                %activity; %are they exploring randomly or following a trail/ isReturningHome (boolean)/ isForaging
                %carrying; % IsCarryingFood (boolean) / Amount of food being carried
                %sex; %male or female
                %colony; %colony of origin/bearing from home
                %patch_ahead; %number of patches ahead scanned for pheromones
                %field_of_view; 
                %drop_size; %strength of dropped pheromone trail

                %Modified by Elliott Clarke on 12/03/2020

            switch nargin                     %Use switch statement with nargin,varargin contructs to overload constructor methods
                case 0                        %create default object
                    a.age=[];			
                    a.food=[];
                    a.pos=[];
                    a.speed=[];
                    a.maxspeed = [];
                    a.activity = []; %are they exploring randomly or following a trail/ isReturningHome (boolean)/ isForaging
                    a.carrying = []; % IsCarryingFood (boolean) / Amount of food being carried
                    a.sex = []; %male or female
                    a.colony = []; 
                    a.patch_ahead = []; %number of patches ahead which is scanned for pheromones
                    a.field_of_view = []; %ant field of view parameter
                    a.drop_size = []; % strength of pheromone trail left when returning to the nest with food
                    a.w = [] % 
                    
                case 1                         %input is already an ant, so just return!
                    if (isa(varargin{1},'queen_ant'))		
                        a=varargin{1};
                    else
                        error('Input argument is not an worker ant')
                    end
                case 13                          %create a new fox (currently the only constructor method used)
                    a.age=varargin{1};               %age of fox object in number of iterations
                    a.food=varargin{2};              %current food content (arbitrary units)
                    a.pos=varargin{3};               %current position in Cartesian co-ords [x y]
                    a.speed=varargin{4};             %number of kilometres fox can migrate in 1 day
                    a.maxspeed = varargin{5};
                    a.activity = varargin{6}; %are they exploring randomly or following a trail/ isReturningHome (boolean)/ isForaging
                    a.carrying = varargin{7}; % IsCarryingFood (boolean) / Amount of food being carried
                    a.sex = varargin{8}; %male or female
                    a.colony =  varargin{9}; 
                    a.patch_ahead = varargin{10};
                    a.field_of_view = varargin{11};
                    a.drop_size = varargin{12};
                    a.w = varargin{13};
                    
                otherwise
                    error('Invalid no. of input arguments for an ant')
            end
        end
    end
end