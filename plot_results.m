function plot_results(agent,nsteps,fmode,outImages)

    %Plots 2d patch images of agents onto background 
    %%%%%%%%%%%
    %plot_results(agent,nr,nf)
    %%%%%%%%%%%
    %agent - current list of agent structures
    %nr -  no. rabbits
    %nf -  no. rabbits

    % Modified by D Walker 3/4/08

    global N_IT IT_STATS ENV_DATA MESSAGES CONTROL_DATA
    %declare variables that can be seen by all functions
    %N_IT is current iteration number
    %ENV_DATA - data structure representing the environment (initialised in
    %create_environment.m)
    %IT_STATS is data structure containing statistics on model at each
    %iteration (no. agents etc)
    %MESSAGES is a data structure containing information that agents need to
    %broadcast to each other

    %write results to the screen
    nf=IT_STATS.tot_f;
    disp(strcat('Iteration = ',num2str(N_IT)))
    disp(strcat('No. new ants = ',num2str(IT_STATS.div_f(N_IT+1))))
    disp(strcat('No. agents migrating = ',num2str(IT_STATS.mig(N_IT+1))))
    disp(strcat('No. ants dying = ',num2str(IT_STATS.died_f(N_IT+1))))

    %plot line graphs of agent numbers and remaining food
    if (fmode==false) || (N_IT==nsteps) || ((fmode==true) && (rem(N_IT , CONTROL_DATA.fmode_display_every)==0))
        
        %Plotting takes time so fmode has been introduced to only plot every n=CONTROL_DATA.fmode_display_every iterations
        %This value increases with the number of agents (see ecolab.m L57-61) as plotting more agents takes longer. 
        %fmode can be turned off in the command line - see ecolab documentation

        col{1}='r-';                   %set up colours that will represent different cell types red for rabbits, blue for foxes
  

        tot_food=IT_STATS.tfood;       %total food remaining
        n=nf(N_IT+1);             %current agent number
        f2=figure(2);
        set(f2,'Units','Normalized');
        set(f2,'Position',[0.5 0.5 0.45 0.4]);

        subplot(3,1,1),cla
        subplot(3,1,1),plot((1:N_IT+1),nf(1:N_IT+1),col{1});
        subplot(3,1,1),axis([0 nsteps 0 1.1*max(nf)]);
        subplot(3,1,1),cla
        subplot(3,1,2),plot((1:N_IT+1),tot_food(1:N_IT+1),'m-');
        subplot(3,1,2),axis([0 nsteps 0 tot_food(1)]);
        subplot(3,1,1),title('No. live ants');
        subplot(3,1,2),title('Total food');
        drawnow

        %create plot of agent locations. 
        f3=figure(3);

        bm=ENV_DATA.bm_size;   
        typ=MESSAGES.atype;
        clf                             %clear previous plot
        set(f3,'Units','Normalized');
        set(f3,'Position',[0.05 0.05 0.66 0.66]);
        v=(1:bm);
        [X,Y]=meshgrid(v);
        
      
        map = hsv(200);
        map = map(65:170,:);
        H=zeros(bm,bm);    
        
        colormap(map);
        Z=ENV_DATA.food;             %heights (Z coords)
        hs2 =surf(Y,X,H,Z); 
        set(hs2,'SpecularExponent',1);       %sets up lighting
        set(hs2,'SpecularStrength',0.1);
        hold on
        
        %Z = ENV_DATA.pheromone_grid;
        %hs = surf(Y,X,H,Z,'FaceAlpha',0.5);   
        %set(hs,'SpecularExponent',1);       %sets up lighting
        %set(hs,'SpecularStrength',0.1);
        
        %hold on
        
        for cn=1:length(agent)                          %cycle through each agent in turn
            if typ(cn)>0                                %only plot live agents
                pos=get(agent{cn},'pos');               %extract current position    
                if isa(agent{cn},'ant')              %choose plot colour depending on agent type
                    ro=plot(pos(1),pos(2),'r*');
                end
            end
        end
        %no pheromone range: 
        h=findobj(gcf,'type','surface');			%Once all cells are plotted, set up perspective, lighting etc.
        set(h,'edgecolor','black');
        lighting flat
        h=findobj(gcf,'type','surface');
        set(h,'linewidth',0.1)
        set(h,'specularstrength',0.2)
        axis off
        axis equal
        set(gcf,'color',[1 1 1]);

        uicontrol('Style','pushbutton',...
                  'String','PAUSE',...
                  'Position',[20 20 60 20], ...
                  'Callback', 'global ENV_DATA; ENV_DATA.pause=true; display(ENV_DATA.pause); clear ENV_DATA;'); 

        while CONTROL_DATA.pause==true    % pause/resume functionality - allows pan and zoom during pause...
            pan on
            axis off
            title(['Iteration no.= ' num2str(N_IT) '.  No. agents = ' num2str(n)]);
            text(-2.6, 7.7, 'PAUSED', 'Color', 'r');
            drawnow
            uicontrol('Style','pushbutton',...
                      'String','ZOOM IN',...
                      'Position',[100 20 60 20],...
                      'Callback','if camva <= 1;return;else;camva(camva-1);end');
            uicontrol('Style','pushbutton',...
                      'String','ZOOM OUT',...
                      'Position',[180 20 60 20],...
                      'Callback','if camva >= 179;return;else;camva(camva+1);end');

            uicontrol('Style','pushbutton',...
                      'String','RESUME',...
                      'Position',[20 20 60 20], ...
                      'Callback', 'global ENV_DATA; ENV_DATA.pause=false; clear ENV_DATA;'); 
        end
        title(['Iteration no.= ' num2str(N_IT) '.  No. agents = ' num2str(n)]);
        axis off
        drawnow 
        if outImages==true  %this outputs images if outImage parameter set to true!!
            if fmode==true; %this warning is to show not all iterations are being output if fmode=true!
                    disp('WARNING*** fastmode set - To output all Images for a movie, set fmode to false(fast mode turned off) ');
            end 
            filenamejpg=[sprintf('%04d',N_IT)];
            eval(['print -djpeg90 agent_plot_' filenamejpg]); %print new jpeg to create movie later
        end
    end
end
