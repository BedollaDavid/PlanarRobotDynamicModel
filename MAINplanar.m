clc, clear, close all
% CODE MODE
usarSym=~true; % For SYMBOLIC mode use 'true', for NUMERIC Mode use 'false' or '~true'
% SYMBOLIC mode will generate the matrices (M, C, G) for M*Qdd + C*Qd + G = tau
% NUMERIC mode will show a 3D plot of the robot with buttons to manipulate

n=3; % n DOF planar Robot (max 4)
% Initializing physical parameters (numeric or symbolic)
if usarSym
syms L1 L2 L3 L4 real %Link length
syms g real % gravity term
syms m1 m2 m3 m4 real  % Link mass
syms lc1 lc2 lc3 lc4 real  % Link center of mass
syms Izz1 Izz2 Izz3 Izz4 real % Moment of inertia
syms q1 q2 q3 q4 dq1 dq2 dq3 dq4 real % position and velocity
else
L1=0.34; L2=0.3; L3=0.3;  L4=0.3;
g=9.81;
m1=3; m2=2; m3=1; m4=0.5;
lc1=0.0983;  lc2=0.0229; lc3=0.0229; lc4=0.0229;
Izz1=0.0229; Izz2=0.0229; Izz3=0.0229; Izz4=0.0229;
q1=0; q2=0; q3=0; q4=0;
dq1=0; dq2=0; dq3=0; dq4=0;
end

% Arranging physical parameters for each joint
    i=1; % Joint index
    m(i)=m1; % Link mass
    rc(i,:) = [lc1-L1 0 0]; % Link center of mass
    I(:,:,i)=[0 0 0;
	      0 0 0;
              0 0 Izz1]; % Moment of inertia
    G(i)=1; J(i)=0; B(i)=0; % G = gear ratio,  J = Motor inertia, B = viscous friction 
    
    i=2;
    m(i)=m2;
    rc(i,:) = [lc2-L2 0 0];
    I(:,:,i)=[0 0 0;
	      0 0 0;
              0 0 Izz2];
    G(i)=1; J(i)=0; B(i)=0;

    i=3;
    m(i)=m3;
    rc(i,:) = [lc3-L3 0 0];
    I(:,:,i)=[0 0 0;
	      0 0 0;
              0 0 Izz3];
    G(i)=1; J(i)=0; B(i)=0;
    
    i=4;
    m(i)=m4;
    rc(i,:) = [lc4-L4 0 0];
    I(:,:,i)=[0 0 0;
	      0 0 0;
              0 0 Izz4];
    G(i)=1; J(i)=0; B(i)=0;

% Modified Denavit-Hartenberg for PLANAR ROBOT
             %theta   d   a  alfa
L(1) = Link([0        0   L1 0],'Modified'); L(1).offset=-pi/2;
L(2) = Link([0        0   L2 0],'Modified');
L(3) = Link([0        0   L3 0],'Modified');
L(4) = Link([0        0   L4 0],'Modified');

% Assigning physical parameters to each Link
for i=1:length(L)
    L(i).m=m(i);
    L(i).r=rc(i,:);
    L(i).I=I(:,:,i);
    L(i).G=G(i);
    L(i).Jm=J(i);
    L(i).B=B(i);
end


planar = SerialLink(L(1:n), 'name', 'Planar'); %generar robot hasta el grado "n"
                       %alpha-1 a-1 d theta
planar.base = [1 0 0 0; 0 0 -1 0; 0 1 0 0; 0 0 0 1]; %cambio de base de referencia

planar.gravity=[0;0;-g]; %gravedad en direccion z

q=[q1 q2 q3 q4 ]; %vector de posicion
dq=[dq1 dq2 dq3 dq4]; %vector de velocidades

if usarSym
% GENERAMOS PAR GRAVITACIONAL
disp('Working on G matrix...')
G=planar.gravload(q(1:n)); %Gravitational Force
printMatrix(G,'G','txt','',false,'% Gravitational Force Vector')

%GENERAMOS MATRIZ DE INERTIA
disp('trabajando en M...')
M=planar.inertia(q(1:n)); %Inertia Matrix
printMatrix(M,'M','txt','',false,'% Inertia Matrix')

%GENERAMOS MATRIZ DE CORIOLIS
disp('trabajando en C...')
C=planar.coriolis([q(1:n) dq(1:n)]); %Coriolis Matrix
printMatrix(C,'C','txt','',false,'% Coriolis Matrix')
end

if ~usarSym
    teach(planar)
    xlabel('X (m)')
    ylabel('Y (m)')
    zlabel('Z (m)')
end
