function [] = Kinetic_Frontal(Superior,Inferior,Posterior,Z_forces,frame,mass)
%KINETIC MODELLING FRONTAL PLANE
%Inputs: Link objects
%Output: Updated force attributes within objects.

%This function uses newtonian mechanics to solve for forces on the links.

%Knowns: Masses, Moments of Inertia
%Unknowns: Forces between body and brace.

%Process: @ROHAN PLS
%Construct F = 0 for z axis and T = 3.3% body weight times height
%for x axis for each link. 

%Assume that the rotation about the y axis is negligible compared to the 
%rotation about the x and z axes. The program will be updated to calculate
%the y axis rotation if time allows.

%Combine all the equations of motion and solve for unknowns. 
%Symbolic variables will be assigned to unknowns initially. 
%% Symbolic Variables

syms F_tz F_cz F_kz
    
%% Parse KAM Data

KAM_Data = Parse_Winter_Data("KAM_data.xlsx");

OA_KAM_Data = KAM_Data{1};
Healthy_KAM_Data = KAM_Data{2};

[tf,row_OA] = ismember(frame,OA_KAM_Data(:,3));
[tf,row_healthy] = ismember(frame,Healthy_KAM_Data(:,3));

OA_KAM=mass*OA_KAM_Data(row_OA,2);
M_targ=mass*Healthy_KAM_Data(row_healthy,2);

%% Frontal Kinetic Calculations
%Calculating 2nd moments of area for knee and brace
Icort = 0.78*((pi*(Inferior.B3 - 2*Inferior.T)^4)/ 64);
Itrab = 0.22*((pi*(Inferior.B3 - 2*Inferior.T)^4)/ 64);
Ibrace = 2*(Inferior.T^3 * Inferior.B2 / 12);

%Calculating brace stresses with composite equation
sigma_b = (OA_KAM * Inferior.E * 0.5*Inferior.B3) / (Inferior.E *Ibrace  + Icort*18400E06  + Itrab*500E06);

%Mb is moment in the brace
Mb = sigma_b*Ibrace/(0.5*Inferior.B3);


F_tz = Mb/(Superior.H4*cosd(Superior.theta)...
    +0.5*Posterior.H*sind(Posterior.theta));
F_cz = Mb/(Inferior.H4*cosd(Inferior.theta)...
    + 0.5*Posterior.H*sind(Posterior.theta));
F_kz = -F_tz-F_cz;

%Brace force on thigh
Z_forces.F_tz=double(F_tz);

%Brace force on calf
Z_forces.F_cz=double(F_cz);

%Brace force on knee
Z_forces.F_kz=double(F_kz);

%Biological knee adduction moment
Z_forces.OA_KAM = OA_KAM;

%Brace corrected knee adduction moment
Z_forces.Mk = OA_KAM-Mb;

%Target Knee adduction moment
Z_forces.M_targ = M_targ;

end

