function u = diffusion(positions)
% Simulating the 2-D Diffusion equation by the Finite Difference
...Method 
% Numerical scheme used is a first order upwind in time and a second
...order central difference in space (Implicit and Explicit)

%%
%Specifying parameters
global N_IT ENV_DATA

    function setU(u_val)
        ENV_DATA.U_FIELD_VARIABLE = u_val;
    end
        
nx=ENV_DATA.NX_STEPS;                           %Number of steps in space(x_range)
ny=ENV_DATA.NY_STEPS;                           %Number of steps in space(y_range)       
nt=25;                           %Number of time steps 
dt=0.5;                         %Width of each time step
dx=200/(nx-1);                     %Width of space step(x_range)
dy=300/(ny-1);                     %Width of space step(y_range)
x_range=0:dx:200;                        %Range of x_range(0,2) and specifying the grid points
y_range=0:dy:300;                        %Range of y_range(0,2) and specifying the grid points
u=ENV_DATA.U_FIELD_VARIABLE;                  %Preallocating u
un=zeros(nx,ny);                 %Preallocating un
vis=1;                         %Diffusion coefficient/viscocity
UW=0;                            %x_range=0 Dirichlet B.C 
UE=0;                            %x_range=L Dirichlet B.C 
US=0;                            %y_range=0 Dirichlet B.C 
UN=0;                            %y_range=L Dirichlet B.C 
UnW=0;                           %x_range=0 Neumann B.C (du/dn=UnW)
UnE=0;                           %x_range=L Neumann B.C (du/dn=UnE)
UnS=0;                           %y_range=0 Neumann B.C (du/dn=UnS)
UnN=0;                           %y_range=L Neumann B.C (du/dn=UnN)
%positions = [1,2;3,4;5,6];
%%
%Initial Conditions
np = length(positions);

npos = zeros(np,4);
n_it=N_IT ;
% if n_it > 1
%     u = ENV_DATA.u;
%     un = ENV_DATA.u0;
% end
if length(positions) >1 
    for k=1:np
        xp = floor(positions(k,1));
        yp = floor(positions(k,2));
        x_up = xp + 1;
        y_up = yp + 1;
        npos(k,1)= xp;
        npos(k,2)= x_up;
        npos(k,3)= yp;
        npos(k,4) = y_up;
    end

    %ONLY FOR INITIAL SETUP
    for i=1:nx
        for j=1:ny
            for p=1:np

                if ((npos(p,3)<=y_range(j))&&(y_range(j)<=npos(p,4))&&(npos(p,1)<=x_range(i))&&(x_range(i)<=npos(p,2)))
               % if ((10<=y_range(j))&&(y_range(j)<=1.5)&&(1<=x_range(i))&&(x_range(i)<=1.5))

                    u(i,j)=u(i,j)+0.1; %drop size pheromone
                %else
                  %  u(i,j)=0;
                end
           % end
            end
        end
    end
end
un = u;
%%
%B.C vector
bc=zeros(nx-2,ny-2);
bc(1,:)=UW/dx^2; bc(nx-2,:)=UE/dx^2;  %Dirichlet B.Cs
bc(:,1)=US/dy^2; bc(:,ny-2)=UN/dy^2;  %Dirichlet B.Cs
%bc(1,:)=-UnW/dx; bc(nx-2,:)=UnE/dx;  %Neumann B.Cs
%bc(:,1)=-UnS/dy; bc(:,nx-2)=UnN/dy;  %Neumann B.Cs
%B.Cs at the corners:
bc(1,1)=UW/dx^2+US/dy^2; bc(nx-2,1)=UE/dx^2+US/dy^2;
bc(1,ny-2)=UW/dx^2+UN/dy^2; bc(nx-2,ny-2)=UE/dx^2+UN/dy^2;
bc=vis*dt*bc;

%Calculating the coefficient matrix for the implicit scheme
Ex=sparse(2:nx-2,1:nx-3,1,nx-2,nx-2);
Ax=Ex+Ex'-2*speye(nx-2);        %Dirichlet B.Cs
%Ax(1,1)=-1; Ax(nx-2,nx-2)=-1;  %Neumann B.Cs
Ey=sparse(2:ny-2,1:ny-3,1,ny-2,ny-2);
Ay=Ey+Ey'-2*speye(ny-2);        %Dirichlet B.Cs
%Ay(1,1)=-1; Ay(ny-2,ny-2)=-1;  %Neumann B.Cs
A=kron(Ay/dy^2,speye(nx-2))+kron(speye(ny-2),Ax/dx^2);
D=speye((nx-2)*(ny-2))-vis*dt*A;

%%
%Calculating the field variable for each time step
i=2:nx-1;
j=2:ny-1;
% for it=0:nt
%     clf;
      un=u;
%     h=surf(x_range,y_range,u','EdgeColor','none');       %plotting the field variable
%     shading interp
%     axis ([0 200 0 200 0 0.5])
%     title({['2-D Diffusion with {\nu} = ',num2str(vis)];['time (\itt) = ',num2str(it*dt)]})
%     xlabel('Spatial co-ordinate (x_range) \rightarrow')
%     ylabel('{\leftarrow} Spatial co-ordinate (y_range)')
%     zlabel('Transport property profile (u) \rightarrow')
%     %view(3);
%     drawnow; 
%     refreshdata(h);
%     %Uncomment as necessary
%     %Implicit method:
     U=un;U(1,:)=[];U(end,:)=[];U(:,1)=[];U(:,end)=[];
     U=reshape(U+bc,[],1);
     U=D\U;
     U=reshape(U,nx-2,ny-2);
     u(2:nx-1,2:ny-1)=U;
     %Boundary conditions
     %Dirichlet:
     u(1,:)=UW;
     u(nx,:)=UE;
     u(:,1)=US;
     u(:,ny)=UN;
     setU(u);
    %Neumann:
    %u(1,:)=u(2,:)-UnW*dx;
    %u(nx,:)=u(nx-1,:)+UnE*dx;
    %u(:,1)=u(:,2)-UnS*dy;
    %u(:,ny)=u(:,ny-1)+UnN*dy;
    %}
    %Explicit method:
    %{
    u(i,j)=un(i,j)+(vis*dt*(un(i+1,j)-2*un(i,j)+un(i-1,j))/(dx*dx))+(vis*dt*(un(i,j+1)-2*un(i,j)+un(i,j-1))/(dy*dy));
    %Boundary conditions
    %Dirichlet:
    u(1,:)=UW;
    u(nx,:)=UE;
    u(:,1)=US;
    u(:,ny)=UN;
    %Neumann:
    %u(1,:)=u(2,:)-UnW*dx;
    %u(nx,:)=u(nx-1,:)+UnE*dx;
    %u(:,1)=u(:,2)-UnS*dy;
    %u(:,ny)=u(:,ny-1)+UnN*dy;
    %}
% end
%disp("heres the sum bitch");
%disp(sum(u,'all'));
end