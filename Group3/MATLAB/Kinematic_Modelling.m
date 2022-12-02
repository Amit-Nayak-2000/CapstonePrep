function [] = Kinematic_Modelling(Superior,Inferior,Posterior,Anterior,KinThigh,KinCalf,thighlength, calflength, T1, T2, verticaloffset)
%KINEMATIC_MODELLING 
%
%Inverse kinematics will be used to get angular positions, velocities, and
%accelerations of the Anterior and Posterior links.
%
%Forward kinematics will be used to get the linear position, velocities and
%accelerations of the Anterior and Posterior links. 

%KinThigh and KinCalf are matrices of position, velocity and acceleration
%from Winter's Data.

%% Start of inverse kinematics
%assign biological theta/omega/alpha to superior and inferior links.
Superior.theta = KinThigh(3,4) - 90;
Inferior.theta = KinCalf(3,4) - 90;

Superior.omega(3) = KinThigh(3,5);
Inferior.omega(3) = KinCalf(3,5);

Superior.alpha(3) = KinThigh(3,6);
Inferior.alpha(3) = KinCalf(3,6);

%For the vectors in the inverse kinematics: 1 is superior, 2 is anterior, 3
%is inferior, 4 is posterior.

%Symbolic Vars
syms SpL SW ST SA AL AT IL IW IT IA PL PT  

%assign values to symbolics
SpL = Superior.L;
AL = Anterior.L;
IL = Inferior.L;
PL = Posterior.L;
ST = Superior.theta;
IT = Inferior.theta;
IW = Inferior.omega(3);
SW = Superior.omega(3);
IA = Inferior.alpha(3);
SA = Superior.alpha(3);

%Angular Position Calculations (Anterior and Posterior links)
%The following expressions were obtained from Matlab's built in system of
%equation solver. See report for inverse kinematic equations (loop closure).
pt1 = -(360*atan((4*(AL*IL*tan((pi*IT)/360) + IL*PL*tan((pi*IT)/360) + AL*SpL*tan((pi*ST)/360) + PL*SpL*tan((pi*ST)/360) + AL*IL*tan((pi*IT)/360)*tan((pi*ST)/360)^2 + AL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360) + IL*PL*tan((pi*IT)/360)*tan((pi*ST)/360)^2 + PL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360)))/(AL^2 + IL^2 - PL^2 + SpL^2 + AL^2*tan((pi*IT)/360)^2 + IL^2*tan((pi*IT)/360)^2 + AL^2*tan((pi*ST)/360)^2 - PL^2*tan((pi*IT)/360)^2 + IL^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*IT)/360)^2 - PL^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*ST)/360)^2 - 2*AL*IL - 2*AL*SpL + 2*IL*SpL + AL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + IL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - PL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*AL*IL*tan((pi*IT)/360)^2 - 2*AL*IL*tan((pi*ST)/360)^2 - 2*AL*SpL*tan((pi*IT)/360)^2 - 2*IL*SpL*tan((pi*IT)/360)^2 + 2*AL*SpL*tan((pi*ST)/360)^2 - 2*IL*SpL*tan((pi*ST)/360)^2 + 2*AL*IL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*AL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*IL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 8*IL*SpL*tan((pi*IT)/360)*tan((pi*ST)/360)) - (4*IL*PL*tan((pi*IT)/360) - ((IL^2 - AL^2 - PL^2 + SpL^2 - AL^2*tan((pi*IT)/360)^2 + IL^2*tan((pi*IT)/360)^2 - AL^2*tan((pi*ST)/360)^2 - PL^2*tan((pi*IT)/360)^2 + IL^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*IT)/360)^2 - PL^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*ST)/360)^2 + 2*AL*PL + 2*IL*SpL - AL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + IL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - PL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*AL*PL*tan((pi*IT)/360)^2 + 2*AL*PL*tan((pi*ST)/360)^2 - 2*IL*SpL*tan((pi*IT)/360)^2 - 2*IL*SpL*tan((pi*ST)/360)^2 + 2*AL*PL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*IL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 8*IL*SpL*tan((pi*IT)/360)*tan((pi*ST)/360))*(AL^2 - IL^2 + PL^2 - SpL^2 + AL^2*tan((pi*IT)/360)^2 - IL^2*tan((pi*IT)/360)^2 + AL^2*tan((pi*ST)/360)^2 + PL^2*tan((pi*IT)/360)^2 - IL^2*tan((pi*ST)/360)^2 - SpL^2*tan((pi*IT)/360)^2 + PL^2*tan((pi*ST)/360)^2 - SpL^2*tan((pi*ST)/360)^2 + 2*AL*PL - 2*IL*SpL + AL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - IL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + PL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - SpL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*AL*PL*tan((pi*IT)/360)^2 + 2*AL*PL*tan((pi*ST)/360)^2 + 2*IL*SpL*tan((pi*IT)/360)^2 + 2*IL*SpL*tan((pi*ST)/360)^2 + 2*AL*PL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - 2*IL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - 8*IL*SpL*tan((pi*IT)/360)*tan((pi*ST)/360)))^(1/2) + 4*PL*SpL*tan((pi*ST)/360) + 4*IL*PL*tan((pi*IT)/360)*tan((pi*ST)/360)^2 + 4*PL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360))/(AL^2 + IL^2 - PL^2 + SpL^2 + AL^2*tan((pi*IT)/360)^2 + IL^2*tan((pi*IT)/360)^2 + AL^2*tan((pi*ST)/360)^2 - PL^2*tan((pi*IT)/360)^2 + IL^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*IT)/360)^2 - PL^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*ST)/360)^2 - 2*AL*IL - 2*AL*SpL + 2*IL*SpL + AL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + IL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - PL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*AL*IL*tan((pi*IT)/360)^2 - 2*AL*IL*tan((pi*ST)/360)^2 - 2*AL*SpL*tan((pi*IT)/360)^2 - 2*IL*SpL*tan((pi*IT)/360)^2 + 2*AL*SpL*tan((pi*ST)/360)^2 - 2*IL*SpL*tan((pi*ST)/360)^2 + 2*AL*IL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*AL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*IL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 8*IL*SpL*tan((pi*IT)/360)*tan((pi*ST)/360))))/pi;

pt2 = (360*atan((((IL^2 - AL^2 - PL^2 + SpL^2 - AL^2*tan((pi*IT)/360)^2 + IL^2*tan((pi*IT)/360)^2 - AL^2*tan((pi*ST)/360)^2 - PL^2*tan((pi*IT)/360)^2 + IL^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*IT)/360)^2 - PL^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*ST)/360)^2 + 2*AL*PL + 2*IL*SpL - AL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + IL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - PL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*AL*PL*tan((pi*IT)/360)^2 + 2*AL*PL*tan((pi*ST)/360)^2 - 2*IL*SpL*tan((pi*IT)/360)^2 - 2*IL*SpL*tan((pi*ST)/360)^2 + 2*AL*PL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*IL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 8*IL*SpL*tan((pi*IT)/360)*tan((pi*ST)/360))*(AL^2 - IL^2 + PL^2 - SpL^2 + AL^2*tan((pi*IT)/360)^2 - IL^2*tan((pi*IT)/360)^2 + AL^2*tan((pi*ST)/360)^2 + PL^2*tan((pi*IT)/360)^2 - IL^2*tan((pi*ST)/360)^2 - SpL^2*tan((pi*IT)/360)^2 + PL^2*tan((pi*ST)/360)^2 - SpL^2*tan((pi*ST)/360)^2 + 2*AL*PL - 2*IL*SpL + AL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - IL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + PL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - SpL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*AL*PL*tan((pi*IT)/360)^2 + 2*AL*PL*tan((pi*ST)/360)^2 + 2*IL*SpL*tan((pi*IT)/360)^2 + 2*IL*SpL*tan((pi*ST)/360)^2 + 2*AL*PL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - 2*IL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - 8*IL*SpL*tan((pi*IT)/360)*tan((pi*ST)/360)))^(1/2) + 4*IL*PL*tan((pi*IT)/360) + 4*PL*SpL*tan((pi*ST)/360) + 4*IL*PL*tan((pi*IT)/360)*tan((pi*ST)/360)^2 + 4*PL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360))/(AL^2 + IL^2 - PL^2 + SpL^2 + AL^2*tan((pi*IT)/360)^2 + IL^2*tan((pi*IT)/360)^2 + AL^2*tan((pi*ST)/360)^2 - PL^2*tan((pi*IT)/360)^2 + IL^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*IT)/360)^2 - PL^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*ST)/360)^2 - 2*AL*IL - 2*AL*SpL + 2*IL*SpL + AL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + IL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - PL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*AL*IL*tan((pi*IT)/360)^2 - 2*AL*IL*tan((pi*ST)/360)^2 - 2*AL*SpL*tan((pi*IT)/360)^2 - 2*IL*SpL*tan((pi*IT)/360)^2 + 2*AL*SpL*tan((pi*ST)/360)^2 - 2*IL*SpL*tan((pi*ST)/360)^2 + 2*AL*IL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*AL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*IL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 8*IL*SpL*tan((pi*IT)/360)*tan((pi*ST)/360)) - (4*(AL*IL*tan((pi*IT)/360) + IL*PL*tan((pi*IT)/360) + AL*SpL*tan((pi*ST)/360) + PL*SpL*tan((pi*ST)/360) + AL*IL*tan((pi*IT)/360)*tan((pi*ST)/360)^2 + AL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360) + IL*PL*tan((pi*IT)/360)*tan((pi*ST)/360)^2 + PL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360)))/(AL^2 + IL^2 - PL^2 + SpL^2 + AL^2*tan((pi*IT)/360)^2 + IL^2*tan((pi*IT)/360)^2 + AL^2*tan((pi*ST)/360)^2 - PL^2*tan((pi*IT)/360)^2 + IL^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*IT)/360)^2 - PL^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*ST)/360)^2 - 2*AL*IL - 2*AL*SpL + 2*IL*SpL + AL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + IL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - PL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*AL*IL*tan((pi*IT)/360)^2 - 2*AL*IL*tan((pi*ST)/360)^2 - 2*AL*SpL*tan((pi*IT)/360)^2 - 2*IL*SpL*tan((pi*IT)/360)^2 + 2*AL*SpL*tan((pi*ST)/360)^2 - 2*IL*SpL*tan((pi*ST)/360)^2 + 2*AL*IL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*AL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*IL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 8*IL*SpL*tan((pi*IT)/360)*tan((pi*ST)/360))))/pi;

pt3 = -(360*atan((4*IL*PL*tan((pi*IT)/360) - ((IL^2 - AL^2 - PL^2 + SpL^2 - AL^2*tan((pi*IT)/360)^2 + IL^2*tan((pi*IT)/360)^2 - AL^2*tan((pi*ST)/360)^2 - PL^2*tan((pi*IT)/360)^2 + IL^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*IT)/360)^2 - PL^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*ST)/360)^2 + 2*AL*PL + 2*IL*SpL - AL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + IL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - PL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*AL*PL*tan((pi*IT)/360)^2 + 2*AL*PL*tan((pi*ST)/360)^2 - 2*IL*SpL*tan((pi*IT)/360)^2 - 2*IL*SpL*tan((pi*ST)/360)^2 + 2*AL*PL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*IL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 8*IL*SpL*tan((pi*IT)/360)*tan((pi*ST)/360))*(AL^2 - IL^2 + PL^2 - SpL^2 + AL^2*tan((pi*IT)/360)^2 - IL^2*tan((pi*IT)/360)^2 + AL^2*tan((pi*ST)/360)^2 + PL^2*tan((pi*IT)/360)^2 - IL^2*tan((pi*ST)/360)^2 - SpL^2*tan((pi*IT)/360)^2 + PL^2*tan((pi*ST)/360)^2 - SpL^2*tan((pi*ST)/360)^2 + 2*AL*PL - 2*IL*SpL + AL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - IL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + PL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - SpL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*AL*PL*tan((pi*IT)/360)^2 + 2*AL*PL*tan((pi*ST)/360)^2 + 2*IL*SpL*tan((pi*IT)/360)^2 + 2*IL*SpL*tan((pi*ST)/360)^2 + 2*AL*PL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - 2*IL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - 8*IL*SpL*tan((pi*IT)/360)*tan((pi*ST)/360)))^(1/2) + 4*PL*SpL*tan((pi*ST)/360) + 4*IL*PL*tan((pi*IT)/360)*tan((pi*ST)/360)^2 + 4*PL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360))/(IL^2 - AL^2 - 2*PL*SpL + PL^2 + SpL^2 - AL^2*tan((pi*IT)/360)^2 + IL^2*tan((pi*IT)/360)^2 - AL^2*tan((pi*ST)/360)^2 + PL^2*tan((pi*IT)/360)^2 + IL^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*IT)/360)^2 + PL^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*ST)/360)^2 - 2*IL*PL + 2*IL*SpL - AL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + IL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + PL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*IL*PL*tan((pi*IT)/360)^2 - 2*IL*SpL*tan((pi*IT)/360)^2 - 2*IL*PL*tan((pi*ST)/360)^2 - 2*PL*SpL*tan((pi*IT)/360)^2 - 2*IL*SpL*tan((pi*ST)/360)^2 + 2*PL*SpL*tan((pi*ST)/360)^2 + 2*IL*PL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*IL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*PL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 8*IL*SpL*tan((pi*IT)/360)*tan((pi*ST)/360))))/pi;

pt4 = -(360*atan((((IL^2 - AL^2 - PL^2 + SpL^2 - AL^2*tan((pi*IT)/360)^2 + IL^2*tan((pi*IT)/360)^2 - AL^2*tan((pi*ST)/360)^2 - PL^2*tan((pi*IT)/360)^2 + IL^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*IT)/360)^2 - PL^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*ST)/360)^2 + 2*AL*PL + 2*IL*SpL - AL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + IL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - PL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*AL*PL*tan((pi*IT)/360)^2 + 2*AL*PL*tan((pi*ST)/360)^2 - 2*IL*SpL*tan((pi*IT)/360)^2 - 2*IL*SpL*tan((pi*ST)/360)^2 + 2*AL*PL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*IL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 8*IL*SpL*tan((pi*IT)/360)*tan((pi*ST)/360))*(AL^2 - IL^2 + PL^2 - SpL^2 + AL^2*tan((pi*IT)/360)^2 - IL^2*tan((pi*IT)/360)^2 + AL^2*tan((pi*ST)/360)^2 + PL^2*tan((pi*IT)/360)^2 - IL^2*tan((pi*ST)/360)^2 - SpL^2*tan((pi*IT)/360)^2 + PL^2*tan((pi*ST)/360)^2 - SpL^2*tan((pi*ST)/360)^2 + 2*AL*PL - 2*IL*SpL + AL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - IL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + PL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - SpL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*AL*PL*tan((pi*IT)/360)^2 + 2*AL*PL*tan((pi*ST)/360)^2 + 2*IL*SpL*tan((pi*IT)/360)^2 + 2*IL*SpL*tan((pi*ST)/360)^2 + 2*AL*PL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - 2*IL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 - 8*IL*SpL*tan((pi*IT)/360)*tan((pi*ST)/360)))^(1/2) + 4*IL*PL*tan((pi*IT)/360) + 4*PL*SpL*tan((pi*ST)/360) + 4*IL*PL*tan((pi*IT)/360)*tan((pi*ST)/360)^2 + 4*PL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360))/(IL^2 - AL^2 - 2*PL*SpL + PL^2 + SpL^2 - AL^2*tan((pi*IT)/360)^2 + IL^2*tan((pi*IT)/360)^2 - AL^2*tan((pi*ST)/360)^2 + PL^2*tan((pi*IT)/360)^2 + IL^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*IT)/360)^2 + PL^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*ST)/360)^2 - 2*IL*PL + 2*IL*SpL - AL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + IL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + PL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + SpL^2*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*IL*PL*tan((pi*IT)/360)^2 - 2*IL*SpL*tan((pi*IT)/360)^2 - 2*IL*PL*tan((pi*ST)/360)^2 - 2*PL*SpL*tan((pi*IT)/360)^2 - 2*IL*SpL*tan((pi*ST)/360)^2 + 2*PL*SpL*tan((pi*ST)/360)^2 + 2*IL*PL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*IL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 2*PL*SpL*tan((pi*IT)/360)^2*tan((pi*ST)/360)^2 + 8*IL*SpL*tan((pi*IT)/360)*tan((pi*ST)/360))))/pi;

%anterior originally 2, posterior originally 4
Anterior.theta = pt2; 
Posterior.theta = pt4; 

%logic to swap angles when nessecary
if(Anterior.theta < 180 && Anterior.theta > 0)
    Anterior.theta = pt1;
    Posterior.theta = pt3;
end
    
%Calculate Spring Angles
[T1.theta, T2.theta] = GetSpringAngles(Superior, Anterior, Inferior, Posterior);
PT = Posterior.theta;
AT = Anterior.theta;

%Angular Velocity (Anterior and Posterior links)
%The following expressions were obtained from Matlab's built in system of
%equation solver. See report for inverse kinematic equations (loop closure)
Anterior.omega(3) = -(IL*IW*cos((pi*IT)/180)*sin((pi*PT)/180) - IL*IW*cos((pi*PT)/180)*sin((pi*IT)/180) - SW*SpL*cos((pi*PT)/180)*sin((pi*ST)/180) + SW*SpL*cos((pi*ST)/180)*sin((pi*PT)/180))/(AL*(cos((pi*AT)/180)*sin((pi*PT)/180) - cos((pi*PT)/180)*sin((pi*AT)/180)));

Posterior.omega(3) = -(IL*IW*cos((pi*AT)/180)*sin((pi*IT)/180) - IL*IW*cos((pi*IT)/180)*sin((pi*AT)/180) + SW*SpL*cos((pi*AT)/180)*sin((pi*ST)/180) - SW*SpL*sin((pi*AT)/180)*cos((pi*ST)/180))/(PL*(cos((pi*AT)/180)*sin((pi*PT)/180) - cos((pi*PT)/180)*sin((pi*AT)/180)));

w_a = Anterior.omega(3);
w_p = Posterior.omega(3);

%Angular Acceleration
%The following expressions were obtained from Matlab's built in system of
%equation solver. See report for inverse kinematic equations (loop closure)
Anterior.alpha(3) = (PL*w_p^2*cos((pi*PT)/180)^2 + PL*w_p^2*sin((pi*PT)/180)^2 + IL*IW^2*cos((pi*IT)/180)*cos((pi*PT)/180) + AL*w_a^2*cos((pi*AT)/180)*cos((pi*PT)/180) + SW^2*SpL*cos((pi*PT)/180)*cos((pi*ST)/180) + IL*IW^2*sin((pi*IT)/180)*sin((pi*PT)/180) + AL*w_a^2*sin((pi*AT)/180)*sin((pi*PT)/180) + SW^2*SpL*sin((pi*PT)/180)*sin((pi*ST)/180) - IA*IL*cos((pi*IT)/180)*sin((pi*PT)/180) + IA*IL*cos((pi*PT)/180)*sin((pi*IT)/180) + SA*SpL*cos((pi*PT)/180)*sin((pi*ST)/180) - SA*SpL*cos((pi*ST)/180)*sin((pi*PT)/180))/(AL*(cos((pi*AT)/180)*sin((pi*PT)/180) - cos((pi*PT)/180)*sin((pi*AT)/180)));

Posterior.alpha(3) = -(AL*w_a^2*cos((pi*AT)/180)^2 + AL*w_a^2*sin((pi*AT)/180)^2 + IL*IW^2*cos((pi*AT)/180)*cos((pi*IT)/180) + SW^2*SpL*cos((pi*AT)/180)*cos((pi*ST)/180) + IL*IW^2*sin((pi*AT)/180)*sin((pi*IT)/180) + PL*w_p^2*cos((pi*AT)/180)*cos((pi*PT)/180) + SW^2*SpL*sin((pi*AT)/180)*sin((pi*ST)/180) + PL*w_p^2*sin((pi*AT)/180)*sin((pi*PT)/180) + IA*IL*cos((pi*AT)/180)*sin((pi*IT)/180) - IA*IL*cos((pi*IT)/180)*sin((pi*AT)/180) + SA*SpL*cos((pi*AT)/180)*sin((pi*ST)/180) - SA*SpL*sin((pi*AT)/180)*cos((pi*ST)/180))/(PL*(cos((pi*AT)/180)*sin((pi*PT)/180) - cos((pi*PT)/180)*sin((pi*AT)/180)));

%% End of inverse kinematics
%% Start of forward kinematics
%Now that thetas for each link are computed, can calculate individual COMs and Position Vectors.
Superior = calculateCOM(Superior, thighlength);
Anterior = calculateCOM(Anterior);
Inferior = calculateCOM(Inferior, calflength, verticaloffset);
Posterior = calculateCOM(Posterior);


%KinThigh and KinCalf are matrices.
%1st col is position, 2nd col is velocity, 3rd col is acceleration. 

%Superior Link:
%calculate aboslute position
Superior.com_abs = KinThigh(:, 1) + Superior.com;
%calculate linear velocity
Superior.v = KinThigh(:, 2) + cross(Superior.omega, Superior.com);
%calculate linear acceleration
Superior.a = KinThigh(:, 3) + cross(Superior.alpha, Superior.com) + cross(Superior.omega, cross(Superior.omega, Superior.com));

%Joint between Superior and Anterior Links:
SA = Superior.com_abs + Superior.rsa;
vSA = Superior.v + cross(Superior.omega, Superior.rsa);
aSA = Superior.a + cross(Superior.alpha, Superior.rsa) + cross(Superior.omega, cross(Superior.omega, Superior.rsa));

%Anterior Link:
Anterior.com_abs = SA + Anterior.rsa;
Anterior.v = vSA + cross(Anterior.omega, Anterior.rsa);
Anterior.a = aSA + cross(Anterior.alpha, Anterior.rsa) + cross(Anterior.omega, cross(Anterior.omega, Anterior.rsa));

%Joint between Superior and Posterior Links:
SP = Superior.com_abs + Superior.rsp;
vSP = Superior.v + cross(Superior.omega, Superior.rsp);
aSP = Superior.a + cross(Superior.alpha, Superior.rsp) + cross(Superior.omega, cross(Superior.omega, Superior.rsp));

%Posterior Link:
Posterior.com_abs = SP + Posterior.rsp;
Posterior.v = vSP + cross(Posterior.omega, Posterior.rsp);
Posterior.a = aSP + cross(Posterior.alpha, Posterior.rsp) + cross(Posterior.omega, cross(Posterior.omega, Posterior.rsp));

%Inferior Link:
%calculate aboslute position
Inferior.com_abs = KinCalf(:, 1) + Inferior.com;
%calculate linear velocity
Inferior.v = KinCalf(:, 2) + cross(Inferior.omega, Inferior.com);
%calculate linear acceleration
Inferior.a = KinCalf(:, 3) + cross(Inferior.alpha, Inferior.com) + cross(Inferior.omega, cross(Inferior.omega, Inferior.com));

%% End of forward kinematics
end
