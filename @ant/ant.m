classdef (Abstract) ant           %declares ant object
    properties         %define ant properties (parameters) 
        age; %Age
        food; %Energy level/food level
        pos;%physical location   
        carrying; % IsCarryingFood (boolean) / Amount of food being carried
        sex; %male or female 
        colony; %colony of origin/bearing from home
    end
    methods                         %all additional member functions associated with this class are included as separate mfiles in the @ant folder. 
          
    end
end