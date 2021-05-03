function [nagent,nn,pos_foragers,pos_seekers]=agnt_solve(agent)

global ENV_DATA PARAM
%sequence of functions called to apply agent rules to current agent population.
%%%%%%%%%%%%
%[nagent,nn]=agnt_solve(agent)
%%%%%%%%%%%
%agent - list of existing agent structures
%nagent - list of updated agent structures
%nn - total number of live agents at end of update

n=length(agent);    %current no. of agents
n_new=0;    %no. new agentsb
prev_n=n;   %remember current agent number at the start of this iteration
foragers = 0; %tally of current number of foraging ants
seekers = 0; %tally of current number of colony seeking ants
pos_foragers = zeros(n,2);
pos_seekers = zeros(n,2);
%execute existing agent update loop
if 0 == 1%ENV_DATA.returned >= n/10
        for a = 1:n
            cur = agent{a};
            cur.pos = PARAM.F_COLONY;
            cur.activity = "foraging";
            cur.carrying = 0;
            cur.age = 0;
            agent{a} = cur;
            
        end
       ENV_DATA.U_FIELD_VARIABLE = zeros(ENV_DATA.NX_STEPS,ENV_DATA.NY_STEPS);
       ENV_DATA.returned = -300000;
end
 
for cn=1:n
    
	curr=agent{cn};
    if isa(curr,'worker_ant')
        if curr.carrying == 0
            curr.activity="foraging";
            foragers = foragers + 1;
            
            
            [curr,eaten]=eat(curr,cn);               %eating rules (rabbits eat food, foxes eat rabbits)
            if eaten==0
                curr=migrate(curr,cn);              %if no food was eaten, then migrate in search of some
            end
            
                
            curr.age = curr.age + 1;
            
        else
            seekers = seekers + 1;
            pos_seekers(cn,:) = curr.pos;
            curr=migrate(curr,cn);
            curr.age = curr.age + 1;
        end
        %update position list
        
        [curr,klld]=die(curr,cn);                %death rule (from starvation or old age)
        
       agent{cn}=curr;                          %up date cell array with modified agent data structure
    end
end


for cn=1:n
    agt = agent{cn};
    if 1==1%isa(agt,'worker_ant')
        if agt.activity=="foraging"
            if agt.age < PARAM.T_A 
                
                pos_foragers(cn,:) = agt.pos;
            end
            
        elseif agt.activity=="nest searching"
            if agt.age < PARAM.T_B
                pos_seekers(cn,:) = agt.pos;
            end
        end
    end
end
no_zero = sum(pos_foragers~=0,2);
el = sum(no_zero~=0,1);

pos_foragers2 = zeros(el,2);
count = 1;
ENV_DATA.foragers = foragers;
ENV_DATA.seekers = seekers;
%spos_foragers = pos_foragers2;
disp('--------------------------------------')
temp_n=n+n_new; %new agent number (before accounting for agent deaths)
[nagent,nn]=update_messages(agent,prev_n,temp_n);   %function which update message list and 'kills off' dead agents.

