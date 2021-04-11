function [left_A,left_B,right_A, right_B] = pheromone(agt)

function int = nonzero(i)
        if i == 0
            int = 1;
        elseif i > 200
            int = 200;
        else int = i;
            
        if(~isreal(i))
            disp("ITS COMPLEX");
        end
        if(~isinteger(i))
            disp("ITS NOT AN INTEGER");   
            disp("IT IS...:");
            disp(class(i));
            disp(i);
        
        end
        end
end
    function int = convert(x)
       int = uint8(round(x));
    end
global PARAM ENV_DATA 
c_x = ENV_DATA.food1x;
c_y = ENV_DATA.food1y;
food = [c_x,c_y];
a_length = PARAM.ANTANNAE_LENGTH;
u_A = ENV_DATA.U_FIELD_VARIABLE;
u_B = ENV_DATA.U_FIELD_VARIABLE_B;

a_angle = 0.524; %30 deg in radians
pos = agt.pos;
x = (pos(1));
y = (pos(2));
angle_existing = deg2rad(agt.w);
left_x = (x + a_length * cos(angle_existing+a_angle));
left_x = convert(left_x);
left_x = nonzero(left_x);



left_y = (y + a_length * sin(angle_existing+a_angle));
left_y = convert(left_y);
left_y = nonzero(left_y);


left_A = u_A((left_x),(left_y));
left_B = u_B((left_x),(left_y));

%disp("ROUND(LEFT_X)=");
%disp(round(left_x));

%disp("ROUND(LEFT_Y)=");
%disp(round(left_y));
right_x = (x + a_length * cos(angle_existing-a_angle));
right_x = convert(right_x);
right_x = nonzero(right_x);


right_y = (y + a_length * sin(angle_existing-a_angle));
right_y = convert(right_y);

right_y = nonzero(right_y);

right_A = u_A(round(right_x),(round(right_y)));
right_B = u_B(round(right_x),round(right_y));

%left_c = [left_A, left_B];
%right_c = [right_A,right_B];
if left_B > right_B
    %disp("FUCK YES LEFT B LESS THAN RIGHT B");
end

if right_B > left_B
    %disp("fuck yes right B less than left B")
end
posl = [left_x,left_y];
posl = double(posl);

posr = [right_x,right_y];
posr = double(posr);
dir_veclx = food(1) - posl(1);
dir_vecly = food(2) - posl(2);
dir_vecrx = food(1) - posr(1);
dir_vecry = food(2) - posr(2);


magl =  sqrt(dir_veclx.^2 + dir_vecly.^2);
magr =  sqrt(dir_vecrx.^2 + dir_vecry.^2);  

    
end