function ecolab(size,nf,nsteps,fmode,outImages)

%ECO_LAB  agent-based predator-prey model, developed for
%demonstration purposes only for University of Sheffield module
%COM3001/6006/6009

%AUTHOR Dawn Walker d.c.walker@sheffield.ac.uk
%Created April 2008

%ecolab(size,nr,nf,nsteps)
%size = size of model environmnet in km (sugested value for plotting
%purposes =50)
%nr - initial number of rabbit agents
%nf - initial number of fox agents
%nsteps - number of iterations required

%definition of global variables:
%N_IT - current iteration number
%IT_STATS  -  is data structure containing statistics on model at each
%iteration (number of agents etc). iniitialised in initialise_results.m
%ENV_DATA - data structure representing the environment (initialised in
%create_environment.m)

    %clear any global variables/ close figures from previous simulations
    clear global
    close all

    global N_IT IT_STATS ENV_DATA CONTROL_DATA PARAM

    if nargin == 4
        fmode=true;
        outImages=false;
    elseif nargin == 5
        outImages=false;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %MODEL INITIALISATION
    create_control;                     %sets up the parameters to control fmode (speed up the code during experimental testing
    create_params(size);                      %sets the parameters for this simulation
    create_environment(size);           %creates environment data structure, given an environment size
    random_selection(1);                %randomises random number sequence (NOT agent order). If input=0, then simulation should be identical to previous for same initial values
    [agent]=create_agents(nf);       %create nr rabbit and nf fox agents and places them in a cell array called 'agents'
   
    create_messages(nf,agent);       %sets up the initial message lists
    initialise_results(nf,nsteps);   %initilaises structure for storing results
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %MODEL EXECUTION

    
    for n_it=1:nsteps                   %the main execution loop
        
            
        N_IT=n_it;
        [agent,n,foragers,seekers]=agnt_solve(agent);     %the function which calls the rules
         %disp(agent(1));s
        %f = foragers(:, ~any(foragers,2),: );
        %foragers = f;
        %if length(seekers) > 2
            
         %   s = seekers(any(seekers,2),:);
        %    seekers = s;
        %end
        %disp('########FORAGERS##############');
        %disp(foragers);
        %disp('##############################');
        %disp('########SEEKERS###############');
        %disp(seekers);
        %disp('##############################');
        %pheromone_diff(foragers,seekers);
        cur_foragers = 0;
        cur_seekers = 0;
        for x = 1:length(foragers)
            if foragers(x,1) == 0 
                if foragers(x,2)==0
                    cur_foragers = cur_foragers + 1;
                end
            end
            if seekers(x,1) == 0
                if seekers(x,2)==0
                    cur_seekers = cur_seekers +1;
                end 
            end
        end
        IT_STATS.tot_r(n_it) = ENV_DATA.foragers;%cur_foragers;
        IT_STATS.tot_f(n_it) = ENV_DATA.seekers;%cur_seekers;
        nr=IT_STATS.tot_f;
        nf = IT_STATS.tot_r;
        %subplot(3,1,1),plot((1:N_IT+1),nf(1:N_IT+1),col{1});
        
        u = diffusion(foragers);
        u_B = diffusion_B(seekers);
        %apply decay/evaporation term to pheromone
        u = u * 99/100;
        u_B = u_B * 49/50;
        
        nx=200;
        ny=300;
        vis=0.1;                         %Diffusion coefficient/viscocity
        dt=0.5; 
        figure(1);
        clf;
        subplot(2,1,1);
        colormap(gca,'default');
       
        %u = ENV_DATA.U_FIELD_VARIABLE;
        dx=200/(nx-1);                     %Width of space step(x)
        dy=300/(ny-1);                     %Width of space step(y)
        x=0:dx:200;                        %Range of x(0,2) and specifying the grid points
        y=0:dy:300;                        %Range of y(0,2) and specifying the grid points
        %figure(1);
        h=surf(x,y,u','EdgeColor','interp');       %plotting the field variable
        shading interp
        axis ([0 200 0 200 0 0.5])
        axis equal
        title({['Pheromone A plot'];['time (\itt) = ',num2str(n_it*dt)]})
        xlabel('Spatial co-ordinate (x) \rightarrow')
        ylabel('{\leftarrow} Spatial co-ordinate (y)')
        zlabel('Transport property profile (u) \rightarrow')
        view(3);
        %c = colorbar;
        %set(h, [0 1])
        shading interp
        zlim([0 1]);
        %light
        %lighting gouraud
        subplot(2,1,2);
        h=surf(x,y,u_B','EdgeColor','interp');       %plotting the field variable
        %shading interp
        
        axis ([0 200 0 200 0 0.5])
        axis equal
        colormap(gca,'summer');
        
        title({'Pheromone B plot'})
        xlabel('Spatial co-ordinate (x) \rightarrow')
        ylabel('{\leftarrow} Spatial co-ordinate (y)')
        zlabel('Transport property profile (u) \rightarrow')
        set(gcf,'Position',[100 100 1000 1000]);

        %% plot circle for food
        C = [100,175];
        r = 25.;


        
        hold on
        th = 0:pi/50:2*pi;
        if ENV_DATA.food1x <= ENV_DATA.bm_size
            xunit = ENV_DATA.food1r *cos(th) + ENV_DATA.food1x;
            yunit = ENV_DATA.food1r * sin(th) + ENV_DATA.food1y;
            h = plot(xunit,yunit,'Color','y');
        end
        if ENV_DATA.food2x <= ENV_DATA.bm_size
            th = 0:pi/50:2*pi;
            xunit = ENV_DATA.food2r *cos(th) + ENV_DATA.food2x;
            yunit = ENV_DATA.food2r * sin(th) + ENV_DATA.food2y;
            h = plot(xunit,yunit,'Color','y');
        end
        hold off
        
       
        drawnow; 

        refreshdata(h);
        figure(2);
        clf;
        %subplot(2,1,1),plot((1:N_IT+1),nr(1:N_IT+1),'-r'); 
        %subplot(2,1,2),
        plot((1:N_IT),nf(1:N_IT),'b-',(1:N_IT),nr(1:N_IT),'r');
        %axis([0 100 0 100])
        title('Number of active foragers and nest seekers')
        xlabel('Iteration')
        ylabel('Number of ants')
        set(gcf,'Position',[1500 100 500 500]);
        %IT_STATS.area(:,1) = IT_STATS.tot_r;
        % IT_STATS.area(:,2) = IT_STATS.tot_f;
        %t = IT_STATS.area;
        %area(1:N_IT+1,t(1:N_IT+1));%(nf(1:N_IT+1),nr(1:N_IT+1)));
    %(nr(1:N_IT+1))
        %plot_results(agent,nsteps,fmode,outImages); %updates results figures and structures
        %mov(n_it)=getframe(fig3);
        if n<=0                          %if no more agents, then stop simulation
            break
            disp('General convergence criteria satisfied - no agents left alive! > ');
        end
        if fmode == true                                       % if fastmode is used ...
           for test_l=1 : 5                                    % this checks the total number agents and adjusts the CONTROL_DATA.fmode_display_every variable accoringly to help prevent extreme slowdown
               if n > CONTROL_DATA.fmode_control(1,test_l)     % CONTROL_DATA.fmode_control contains an array of thresholds for agent numbers and associated fmode_display_every values
                   CONTROL_DATA.fmode_display_every = CONTROL_DATA.fmode_control(2,test_l);
               end
           end
            if IT_STATS.tot_f(n_it) == 0             %fastmode convergence - all rabbits eaten - all foxes will now die
                disp('Fast mode convergence criteria satisfied - no ants left alive')
                break
            end  
        end
        if 1== 2%ENV_DATA.returned >= n/10
            for a = 1:n
                cur = agent{a};
                cur.pos = PARAM.F_COLONY;
                cur.activity = "foraging";
                cur.carrying = 0;
            end
            ENV_DATA.returned = -300000;
        end
       
        
    end
eval(['save results_nf_' num2str(nf) '.mat IT_STATS ENV_DATA' ]);
clear global
end
