%% BENDER 2D
% This is a fast code to trace a ray in 2D via PseudoBending (check
% Nolet 2010)
%% INPUTS
%% S & R
load Model.txt % Load Velocity Model
SOURCE = [10 45]; %Source Position
RECEIVER = [80 0]; %Receiver Position
% Model Differentials
dx=10; %Delta X
dz=5;  %Delta Z
dray=0.025; % Porcentage to change ray
dr=20; %Node in ray

%% Creat the models needed for the computation
[iModelX,iModelZ,iModelS,xmin,xmax,zmin,zmax,F] = GetModels(Model,dx,dz);

%% Bend ray
[ray0,T0] = RayBender(SOURCE,RECEIVER,dz,dray,dr,F); % Call the ray bender function

%% Figures
h=pcolor(iModelX',iModelZ',Model);
set(gca,'Ydir','reverse')
set(h, 'EdgeColor', 'none');
colormap(flipud(jet))
colorbar
xlim([xmin xmax])
ylim([zmin zmax])
hold on
plot(SOURCE(1),SOURCE(2),'ok','MarkerFaceColor','r','MarkerSize',7.5)
plot(RECEIVER(1),RECEIVER(2),'vk','MarkerFaceColor','w','MarkerSize',7.5)
plot(ray0(:,1),ray0(:,2),'-k','LineWidth', 0.5)

%% FUNCTIONS

%% FIX INPUT DATA

function [iModelX,iModelZ,iModelS,xmin,xmax,zmin,zmax,F] = GetModels(Model,dx,dz)
% Slowness Model
ModelS=1./Model;% Compute slowness
% Coodinates 
vx=0:dx:(size(Model,2)-1)*dx; % Vector of X coordinates
vz=(0:dz:(size(Model,1)-1)*dz)'; % Vector of Z coordinates
ModelX=repmat(vx,size(Model,1),1); % Matrix of X coordinates
ModelZ=repmat(vz,1,size(Model,2)); % Matriz of Z coordinates
%Transposed matrix for later
iModelS=ModelS';
iModelX=ModelX';
iModelZ=ModelZ';
zmax=max(vz); % Z max
zmin=min(vz); % Z min
xmax=max(vx); % X max
xmin=min(vx); % X min
F=griddedInterpolant(iModelX,iModelZ,iModelS); % Grid data
end

%% RAY BENDER: Pseudobending method for fast ray tracing
function [ray0,T0] = RayBender(SOURCE,RECEIVER,dz,dray,dr,F)
%RayBender Bend the Ray Paths little by little
%Initial linear ray
ray0=[SOURCE(1):(RECEIVER(1)-SOURCE(1))/dr:RECEIVER(1);SOURCE(2):(RECEIVER(2)-SOURCE(2))/dr:RECEIVER(2)]';
% Time of initial ray
T0=GetTime(ray0,F); %T
movedz=dz*dray;
NCC=0;
while NCC<dr-1
    NCC=0;
    for j=2:dr
        
        %Bend a point of the ray up and down
        %Also get the travel time of each test
        rayz1(:,1)=[ray0(1:j-1,2); ray0(j,2)+movedz; ray0(j+1:end,2)];
        %rayz1(rayz1>zmax)=zmax;
        %rayz1(rayz1<zmin)=zmin;
        T1=GetTime([ray0(:,1) rayz1],F);
        rayz2(:,1)=[ray0(1:j-1,2); ray0(j,2)-movedz; ray0(j+1:end,2)];
        %rayz2(rayz2>zmax)=zmax;
        %rayz2(rayz2<zmin)=zmin;
        T2=GetTime([ray0(:,1) rayz2],F);
        
        if T1<T0 && T1<T2 % If RAY 1 is the solution
            ray0=[ray0(:,1) rayz1];
            T0=T1;
        elseif T2<T0 && T2<T1 % If RAY 2 is the solution
            ray0=[ray0(:,1) rayz1];
            T0=T2;
        else
            NCC=NCC+1; % Keep Count of NO CHANGES 
        end
       
    end
end
end

%% GET TIME FUNCTION
function [T0] = GetTime(ray0,F)
%function [T0] = GetTime(ray0,dr,F)
%GetTime computes time along the raypath

Snodes = F(ray0(:,1), ray0(:,2)); % Slowness values at nodes
B=mean([Snodes(1:end-1)';Snodes(2:end)']); % Mean velocities
C=sqrt((diff(ray0(:,1)).*diff(ray0(:,1)))+(diff(ray0(:,2)).*diff(ray0(:,2)))); % Distances between nodes
T0=B*C; %Total Time
end

