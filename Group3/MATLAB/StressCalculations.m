function [] = StressCalculations(S, I, A, P, TS1, TS2, VT, VC, Bolt, Bearing, SF, ZF)
% calculates stresses related to S link
% inputs: (Part Objects)
% output: [Calculated Safety Factors (SF object)]

% description: calculates axial, bending, shear, rupture, stresses and the 
% corresponding saftey factor of all the components (superior, 
% inferior, anterior, posterior,torsional springs, velcro, bolts, bearings)

%% Symbolic Variables
% constants
g = 9.81;

%% Superior Link

% SYMBOLS
% longitudinal forces
syms F_tt F_tn F_scomxlong F_scomylong F_saxlong F_saylong
syms F_spxlong F_spylong F_sspring1
% stresses
syms sigma_sx sigma_s1y sigma_s2y sigma_s3y sigma_sbend1 sigma_sbend2
syms tau_s1 tau_s2 tau_s3 sigma_srupture moment_s1 moment_s2 
% second moment of area
syms J_s A_s1 A_s2 A_s3 y_s1 y_s2 y_s3 y_sbar I_s1 I_s2 I_s3 

% LONGITUDINAL FORCE CALCULATIONS
F_tt = -S.F_t(1)*sind(S.theta) + S.F_t(2)*cosd(S.theta);
F_tn = S.F_t(1)*cosd(S.theta) + S.F_t(2)*sind(S.theta);
F_scomxlong = S.m*S.a(1)*cosd(S.theta) + S.m*S.a(2)*sind(S.theta) - S.m*g*sind(S.theta); 
F_scomylong = -S.m*S.a(1)*sind(S.theta) + S.m*S.a(2)*cosd(S.theta) - S.m*g*cosd(S.theta);
F_saxlong = S.F_sa(1)*cosd(S.theta) + S.F_sa(2)*sind(S.theta);
F_saylong = -S.F_sa(1)*sind(S.theta) + S.F_sa(2)*cosd(S.theta);
F_spxlong = S.F_sp(1)*cosd(S.theta) + S.F_sp(2)*sind(S.theta);
F_spylong = -S.F_sp(1)*sind(S.theta) + S.F_sp(2)*cosd(S.theta);
F_sspring1 = -TS1.Torque(3)*0.4*S.L;

% SECOND MOMENT OF AREA
A_s1 = S.B1*S.H1;
A_s2 = 0.5*(S.B1 + S.B2)*(S.H2 - S.H1);
A_s3 = S.B2*(S.H4 - S.H2);
y_s1 = S.H1/2;
y_s2 = ((S.H4 - S.H2)*((2*S.B2 + S.B1)/(S.B2 + S.B1)))/3;
y_s3 = S.H2 + ((S.H4 - S.H2)/2);
I_s1 = S.B1*(S.H1)^3;
I_s2 = (S.H2 - S.H1)*(S.B2 - S.B1)*(S.B2^2 + 7*S.B1^2)/48;
I_s3 = S.B2*(S.H4-S.H2)^3/12;
y_sbar = (A_s1*y_s1 + A_s2*y_s2 + A_s3*y_s3)/(A_s1 + A_s2 + A_s1);
J_s = (I_s1 + A_s1*(y_sbar - y_s1)^2) + (I_s2 + A_s2*(y_sbar - y_s2)^2) + (I_s3 + A_s3*(y_sbar - y_s3)^2);

% STRESS CALCULATIONS
% along x long
if abs(F_tn) > abs(F_scomxlong + F_saxlong + F_spxlong)
    sigma_sx = F_tn/((S.H4-S.H3)*S.T);
else
    sigma_sx = (F_scomxlong + F_saxlong + F_spxlong)/((S.H4-S.H3)*S.T);
end

% along y long and rupture
if abs(F_tt + F_scomylong) > abs(F_saylong + F_spylong + F_sspring1)
    sigma_s1y = (F_tt + F_scomylong)/(S.B1*S.T);
    sigma_srupture = (F_tt + F_scomylong)/(S.B1*S.T - 2*Bearing.OD*S.T);
else
    sigma_s1y = (F_saylong + F_spylong + F_sspring1)/(S.B1*S.T);
    sigma_srupture = (F_saylong + F_spylong + F_sspring1)/(S.B1*S.T - 2*Bearing.OD*S.T);
end

if abs(F_tt) > abs(F_scomylong + F_saylong + F_spylong + F_sspring1)
    sigma_s2y = F_tt / (S.B2*S.T);
    sigma_s3y = F_tt / (S.B3*S.T);
else
    sigma_s2y = (F_scomylong + F_saylong + F_spylong + F_sspring1) / (S.B2*S.T);
    sigma_s3y = (F_scomylong + F_saylong + F_spylong + F_sspring1) / (S.B3*S.T);
end

% bending
moment_s1 = S.I*S.alpha(3) + (S.B3/2)*F_tt - (S.B3/2 - S.B2/2)*(F_scomylong + F_saylong + F_spylong + F_sspring1);
moment_s2 = S.I*S.alpha(3) - (S.L/2)*F_saylong - (S.H4 - S.com(2) - S.H1/2)*F_saxlong - (S.L/2)*F_spylong + (S.H4 - S.com(2) - S.H1/2)*F_spxlong + ((S.L/2)-0.4*S.L)*F_sspring1 - S.com(2)*F_tn;

sigma_sbend11 = -moment_s1*((S.H4-S.H3)/2) / ((S.B3*(S.H4-S.H3)^3)/12);
sigma_sbend12 = moment_s1*((S.H4-S.H3)/2) / ((S.B3*(S.H4-S.H3)^3)/12);
sigma_sbend2 = -moment_s2 * y_sbar / J_s;

sigma_szbend1 = ((ZF.OA_KAM - ZF.Mk)*((S.B3/2) + S.T) /( (S.B2*S.T^3) / 12 ));
sigma_szbend2 = -((ZF.OA_KAM - ZF.Mk)*((S.B3/2) + S.T) /( (S.B2*S.T^3) / 12 ));

sigma_s2y_q1 = sigma_s2y + sigma_sbend11 + sigma_szbend1;
sigma_s2y_q2 = sigma_s2y + sigma_sbend11 + sigma_szbend2;
sigma_s2y_q3 = sigma_s2y + sigma_sbend12 + sigma_szbend1;
sigma_s2y_q4 = sigma_s2y + sigma_sbend12 + sigma_szbend2;

sigma_s2y = max([abs(sigma_s2y_q1), abs(sigma_s2y_q2), abs(sigma_s2y_q3), abs(sigma_s2y_q4)]);

% shear
if abs(F_tn + F_scomxlong) > abs(F_saxlong + F_spxlong)
    tau_s1 = (F_tn + F_scomxlong)/(S.B1*S.T);
else
    tau_s1 = (F_saxlong + F_spxlong)/(S.B1*S.T);
end

if abs(F_tn) > abs(F_scomxlong + F_saxlong + F_spxlong)
    tau_s2 = (F_tn)/(S.B2*S.T);
    tau_s3 = (F_tn)/(S.B3*S.T);
else
    tau_s2 = (F_scomxlong + F_saxlong + F_spxlong)/(S.B2*S.T);
    tau_s3 = (F_scomxlong + F_saxlong + F_spxlong)/(S.B3*S.T);
end

% SAFETY FACTOR CALCULATIONS
%changed the numerators
SF.sigma_sx = S.SY/sigma_sx;
SF.sigma_s1y = S.SY/sigma_s1y;
SF.sigma_s2y = S.SY/sigma_s2y;
SF.sigma_s3y = S.SY/sigma_s3y;
SF.sigma_sbend1 = S.SY/sigma_sbend11;
SF.sigma_sbend2 = S.SY/sigma_sbend2;
SF.sigma_srupture = S.SY/sigma_srupture;
SF.tau_s1 = S.SSY/tau_s1;
SF.tau_s2 = S.SSY/tau_s2;
SF.tau_s3 = S.SSY/tau_s3;
SF.buckling_s = -1*((pi^2*S.E*S.B2*S.T^3)/(12*(S.H3-S.H2)^2)) / ((sigma_s1y)*S.B2*S.T);
SF.frontalbending_s = S.SY / ( (ZF.OA_KAM - ZF.Mk)*((S.B3/2) + S.T) /( (S.B2*S.T^3) / 12 )  );
%% Inferior Link

% SYMBOLS
% longitudinal forces
syms F_ct F_cn F_icomxlong F_icomylong F_iaxlong F_iaylong
syms F_ipxlong F_ipylong F_ispring2
% stresses
syms sigma_ix sigma_i1y sigma_i2y sigma_i3y sigma_ibend1 sigma_ibend2
syms tau_i1 tau_i2 tau_i3 sigma_irupture moment_i1 moment_i2 J_i
% second moment of area
syms J_i A_i1 A_i2 A_i3 y_i1 y_i2 y_i3 y_ibar I_i1 I_i2 I_i3 

% LONGITUDINAL FORCE CALCULATIONS
F_ct = -I.F_c(1)*sind(I.theta) + I.F_c(2)*cosd(I.theta);
F_cn = I.F_c(1)*cosd(I.theta) + I.F_c(2)*sind(I.theta);
F_icomxlong = I.m*I.a(1)*cosd(I.theta) + I.m*I.a(2)*sind(I.theta) - I.m*g*sind(I.theta); 
F_icomylong = -I.m*I.a(1)*sind(I.theta) + I.m*I.a(2)*cosd(I.theta) - I.m*g*cosd(I.theta);
F_iaxlong = I.F_ia(1)*cosd(I.theta) + I.F_ia(2)*sind(I.theta);
F_iaylong = -I.F_ia(1)*sind(I.theta) + I.F_ia(2)*cosd(I.theta);
F_ipxlong = I.F_ip(1)*cosd(I.theta) + I.F_ip(2)*sind(I.theta);
F_ipylong = -I.F_ip(1)*sind(I.theta) + I.F_ip(2)*cosd(I.theta);
F_ispring2 = -TS2.Torque(3)*0.4*I.L;

% SECOND MOMENT OF AREA
A_i1 = I.B1*I.H1;
A_i2 = 0.5*(I.B1 + I.B2)*(I.H2 - I.H1);
A_i3 = I.B2*(I.H4 - I.H2);
y_i1 = I.H1/2;
y_i2 = ((I.H4 - I.H2)*((2*I.B2 + I.B1)/(I.B2 + I.B1)))/3;
y_i3 = I.H2 + ((I.H4 - I.H2)/2);
I_i1 = I.B1*(I.H1)^3;
I_i2 = (I.H2 - I.H1)*(I.B2 - I.B1)*(I.B2^2 + 7*I.B1^2)/48;
I_i3 = I.B2*(I.H4-I.H2)^3/12;
y_ibar = (A_i1*y_i1 + A_i2*y_i2 + A_i3*y_i3)/(A_i1 + A_i2 + A_i1);
J_i = (I_i1 + A_i1*(y_ibar - y_i1)^2) + (I_i2 + A_i2*(y_ibar - y_i2)^2) + (I_i3 + A_i3*(y_ibar - y_i3)^2);

% STRESS CALCULATIONS
% along x long
if abs(F_cn)>abs(F_icomxlong + F_iaxlong + F_ipxlong)
    sigma_ix = F_cn/((I.H4-I.H3)*I.T);
else
    sigma_ix = (F_icomxlong + F_iaxlong + F_ipxlong)/((I.H4-I.H3)*I.T);
end

% along y long
if abs(F_ct + F_icomylong)>abs(F_iaylong + F_ipylong + F_ispring2)
    sigma_i1y = (F_ct + F_icomylong)/(I.B1*I.T);
    sigma_irupture = (F_ct + F_icomylong)/(I.B1*I.T - 2*Bearing.OD*I.T);
else
    sigma_i1y = (F_iaylong + F_ipylong + F_ispring2)/(I.B1*I.T);
    sigma_irupture = (F_iaylong + F_ipylong + F_ispring2)/(I.B1*I.T - 2*Bearing.OD*I.T);
end

if abs(F_ct)>abs(F_icomylong + F_iaylong + F_ipylong + F_ispring2)
    sigma_i2y = F_ct / (I.B2*I.T);
    sigma_i3y = F_ct / (I.B3*I.T);
else
    sigma_i2y = (F_icomylong + F_iaylong + F_ipylong + F_ispring2) / (I.B2*I.T);
    sigma_i3y = (F_icomylong + F_iaylong + F_ipylong + F_ispring2) / (I.B3*I.T);
end

% bending
moment_i1 = I.I*I.alpha(3) + (I.B3/2)*F_ct - (I.B3/2 - I.B2/2)*(F_icomylong + F_iaylong + F_ipylong + F_ispring2);
moment_i2 = I.I*I.alpha(3) - (I.L/2)*F_iaylong - (I.H4 - I.com(2) - I.H1/2)*F_iaxlong + (I.L/2)*F_ipylong - (I.H4 - I.com(2) - I.H1/2)*F_ipxlong + ((I.L/2)-0.4*I.L)*F_ispring2 + I.com(2)*F_cn;

sigma_ibend11 = -moment_i1*((I.H4-I.H3)/2) / ((I.B3*(I.H4-I.H3)^3)/12);
sigma_ibend12 = moment_i1*((I.H4-I.H3)/2) / ((I.B3*(I.H4-I.H3)^3)/12);
sigma_ibend2 = -moment_i2 * y_ibar / J_i;

sigma_izbend1 = ((ZF.OA_KAM - ZF.Mk)*((I.B3/2) + I.T) /( (I.B2*I.T^3) / 12 ));
sigma_izbend2 = -((ZF.OA_KAM - ZF.Mk)*((I.B3/2) + I.T) /( (I.B2*I.T^3) / 12 ));

sigma_i2y_q1 = sigma_i2y + sigma_ibend11 + sigma_izbend1;
sigma_i2y_q2 = sigma_i2y + sigma_ibend11 + sigma_izbend2;
sigma_i2y_q3 = sigma_i2y + sigma_ibend12 + sigma_izbend1;
sigma_i2y_q4 = sigma_i2y + sigma_ibend12 + sigma_izbend2;

sigma_i2y = max([abs(sigma_i2y_q1), abs(sigma_i2y_q2), abs(sigma_i2y_q3), abs(sigma_i2y_q4)]);

% shear
if abs(F_cn + F_icomxlong) > abs(F_iaxlong + F_ipxlong)
    tau_i1 = (F_cn + F_icomxlong)/(I.B1*I.T);
else
    tau_i1 = (F_iaxlong + F_ipxlong)/(I.B1*I.T);
end

if abs(F_cn) > abs(F_icomxlong + F_iaxlong + F_ipxlong)
    tau_i2 = (F_cn)/(I.B2*I.T);
    tau_i3 = (F_cn)/(I.B3*I.T);
else
    tau_i2 = (F_icomxlong + F_iaxlong + F_ipxlong)/(I.B2*I.T);
    tau_i3 = (F_icomxlong + F_iaxlong + F_ipxlong)/(I.B3*I.T);
end

% SAFETY FACTOR CALCULATIONS
SF.sigma_ix = I.SY/sigma_ix;
SF.sigma_i1y = I.SY/sigma_i1y;
SF.sigma_i2y = I.SY/sigma_i2y;
SF.sigma_i3y = I.SY/sigma_i3y;
SF.sigma_ibend1 = I.SY/sigma_ibend11;
SF.sigma_ibend2 = I.SY/sigma_ibend2;
SF.sigma_irupture = I.SY/sigma_irupture;
SF.tau_i1 = I.SSY/tau_i1;
SF.tau_i2 = I.SSY/tau_i2;
SF.tau_i3 = I.SSY/tau_i3;
SF.buckling_i = -1*((pi^2*I.E*I.B2*I.T^3)/(12*(I.H3-I.H2)^2)) / ((sigma_i1y)*I.B2*I.T);
SF.frontalbending_i = I.SY / ( (ZF.OA_KAM - ZF.Mk)*((I.B3/2) + I.T) /( (I.B2*I.T^3) / 12 )  );
%% Anterior Link

% SYMBOLS
% longitudinal forces
syms F_acomxlong F_acomylong F_asxlong F_asylong F_aixlong F_aiylong F_aspring1 moment_a J_a
% stresses
syms sigma_a1y sigma_a2y sigma_abend tau_a1 tau_a2 sigma_arupture1 sigma_arupture2

% LONGITUDINAL FORCE CALCULATIONS
F_acomxlong = -A.m*A.a(1)*sind(A.theta) + A.m*A.a(2)*cosd(A.theta) - A.m*g*cosd(A.theta);
F_acomylong = -A.m*A.a(1)*cosd(A.theta) - A.m*A.a(2)*sind(A.theta) + A.m*g*sind(A.theta);
F_asxlong = -A.F_sa(1)*sind(A.theta) + A.F_sa(2)*cosd(A.theta);
F_asylong = -A.F_sa(1)*cosd(A.theta) - A.F_sa(2)*sind(A.theta);
F_aixlong = -A.F_ia(1)*sind(A.theta) + A.F_ia(2)*cosd(A.theta);
F_aiylong = -A.F_ia(1)*cosd(A.theta) - A.F_ia(2)*sind(A.theta);
F_aspring1 = -1*F_sspring1;

% STRESS CALCULATIONS
% along y long and rupture
if abs(F_asylong) > abs(F_acomylong + F_aiylong)
    sigma_a1y = (F_asylong)/(A.B*A.T);
    sigma_arupture1 = (F_asylong)/(A.B*A.T - Bearing.OD*A.T);
else
    sigma_a1y = (F_acomylong + F_aiylong)/(A.B*A.T);
    sigma_arupture1 = (F_acomylong + F_aiylong)/(A.B*A.T - Bearing.OD*A.T);
end

if abs(F_asylong + F_acomylong) > abs(F_aiylong)
    sigma_a2y = (F_asylong + F_acomylong)/(A.B*A.T);
    sigma_arupture2 = (F_asylong + F_acomylong)/(A.B*A.T - Bearing.OD*A.T);
else
    sigma_a2y = (F_aiylong)/(A.B*A.T);
    sigma_arupture2 = (F_aiylong)/(A.B*A.T - Bearing.OD*A.T);
end

% bending
moment_a = -(A.L/2)*F_asxlong - (A.L/2-0.4*S.L)*F_aspring1 + (A.L/2)*F_aixlong + A.I*A.alpha(3);
sigma_abend = -moment_a * (A.L/2) / A.I;

% shear
if abs(F_asxlong) > abs(F_acomxlong + F_aixlong)
    tau_a1 = (F_asxlong)/(A.B*A.T);
else
    tau_a1 = (F_acomxlong + F_aixlong)/(A.B*A.T);
end

if abs(F_asxlong + F_acomxlong) > abs(F_aixlong)
    tau_a2 = (F_asxlong + F_acomxlong)/(A.B*A.T);
else
    tau_a2 = (F_aixlong)/(A.B*A.T);
end

% SAFETY FACTOR CALCULATIONS
SF.sigma_a1y = A.SY/sigma_a1y;
SF.sigma_a2y = A.SY/sigma_a2y;
SF.sigma_abend = A.SY/sigma_abend;
SF.sigma_arupture1 = A.SY/sigma_arupture1;
SF.sigma_arupture2 = A.SY/sigma_arupture2;
SF.tau_a1 = A.SSY/tau_a1;
SF.tau_a2 = A.SSY/tau_a2;
SF.buckling_a = -1*((pi^2*A.E*A.B*A.T^3)/(12*A.L^2)) / ((sigma_a1y)*A.B*A.T);

%% Posterior Link

% SYMBOLS
% longitudinal forces
syms F_pcomxlong F_pcomylong F_psxlong F_psylong F_pixlong F_piylong F_pspring2 moment_p J_p
% stresses
syms sigma_p1y sigma_p2y sigma_pbend tau_p1 tau_p2 sigma_prupture1 sigma_prupture2

% LONGITUDINAL FORCE CALCULATIONS
F_pcomxlong = P.m*P.a(1)*sind(P.theta) - P.m*P.a(2)*cosd(P.theta) + P.m*g*cosd(P.theta);
F_pcomylong = P.m*P.a(1)*cosd(P.theta) + P.m*P.a(2)*sind(P.theta) - P.m*g*sind(P.theta);
F_psxlong = P.F_sp(1)*sind(P.theta) - P.F_sp(2)*cosd(P.theta);
F_psylong = P.F_sp(1)*cosd(P.theta) + P.F_sp(2)*sind(P.theta);
F_pixlong = P.F_ip(1)*sind(P.theta) - P.F_ip(2)*cosd(P.theta);
F_piylong = P.F_ip(1)*cosd(P.theta) + P.F_ip(2)*sind(P.theta);
F_pspring2 = -1*F_ispring2;

% STRESS CALCULATIONS
% along y long and rupture
if abs(F_psylong) > abs(F_pcomylong + F_piylong)
    sigma_p1y = (F_psylong)/(P.B*P.T);
    sigma_prupture1 = (F_psylong)/(P.B*P.T - Bearing.OD*P.T);
else
    sigma_p1y = (F_pcomylong + F_piylong)/(P.B*P.T);
    sigma_prupture1 = (F_pcomylong + F_piylong)/(P.B*P.T - Bearing.OD*P.T);
end

if abs(F_psylong + F_pcomylong) > abs(F_piylong)
    sigma_p2y = (F_psylong + F_pcomylong)/(P.B*P.T);
    sigma_prupture2 = (F_psylong + F_pcomylong)/(P.B*P.T - Bearing.OD*P.T);
else
    sigma_p2y = (F_piylong)/(P.B*P.T);
    sigma_prupture2 = (F_piylong)/(P.B*P.T - Bearing.OD*P.T);
end

% bending
moment_p = -(P.L/2)*F_psxlong + (P.L/2-0.4*I.L)*F_pspring2 + (P.L/2)*F_pixlong + P.I*P.alpha(3);
sigma_pbend = -moment_p * (P.L/2) / P.I;

% shear
if abs(F_psxlong) > abs(F_pcomxlong + F_pixlong)
    tau_p1 = (F_psxlong)/(P.B*P.T);
else
    tau_p1 = (F_pcomxlong + F_pixlong)/(P.B*P.T);
end

if abs(F_psxlong + F_pcomxlong) > abs(F_pixlong)
    tau_p2 = (F_psxlong + F_pcomxlong)/(P.B*P.T);
else
    tau_p2 = (F_pixlong)/(P.B*P.T);
end

% SAFETY FACTOR CALCULATIONS
SF.sigma_p1y = P.SY/sigma_p1y;
SF.sigma_p2y = P.SY/sigma_p2y;
SF.sigma_pbend = P.SY/sigma_pbend;
SF.sigma_prupture1 = P.SY/sigma_prupture1;
SF.sigma_prupture2 = P.SY/sigma_prupture2;
SF.tau_p1 = P.SSY/tau_p1;
SF.tau_p2 = P.SSY/tau_p2;
SF.buckling_p = -1*((pi^2*P.E*P.B*P.T^3)/(12*P.L^2)) / ((sigma_p1y)*P.B*P.T);

%% Velcro

% SYMBOLS
syms tau_vt tau_vc

% STRESS CALCULATIONS
tau_vt = F_tn / (VT.L * VT.W);
tau_vc = F_cn / (VC.L * VC.W);

% SAFETY FACTOR CALCULATIONS
SF.tau_vt = VT.G/tau_vt;
SF.tau_vc = VC.G/tau_vc;

%% Springs

% SYMBOLS
syms K sigma_spring1 sigma_spring2 sr_spring1 sr_spring2

% STRESS CORRECTION FACTOR
K = (4*TS1.C^2 - TS1.C - 1) / (4*TS1.C*(TS1.C-1));

% STRESS CALCULATION
sigma_spring1 = (K*32*abs(F_sspring1)*0.4*S.L) / (pi*TS1.d^3);
sigma_spring2 = (K*32*abs(F_ispring2)*0.4*I.L) / (pi*TS2.d^3);
sr_spring1 = (0.5*0.60*TS1.SU) / (1-(0.5*0.6)^2); % change 0.6 (shot-peened) to 0.5 (not shot-peened) if necessary
sr_spring2 = (0.5*0.60*TS2.SU) / (1-(0.5*0.6)^2); % change 0.6 (shot-peened) to 0.5 (not shot-peened) if necessary

% SAFETY FACTOR CALCULATIONS
SF.sigma_spring1 = TS1.SY/sigma_spring1;
SF.sigma_spring2 = TS2.SY/sigma_spring2;
SF.fatigue_spring1 = sr_spring1/sigma_spring1;
SF.fatigue_spring2 = sr_spring2/sigma_spring2;

%% Bolts

% SYMBOLS
syms tau_sa tau_sp tau_ia tau_ip

% STRESS CALCULATIONS
tau_sa = (4*norm(S.F_sa))/pi*Bolt.D;
tau_sp = (4*norm(S.F_sp))/pi*Bolt.D;
tau_ia = (4*norm(I.F_ia))/pi*Bolt.D;
tau_ip = (4*norm(I.F_ip))/pi*Bolt.D;

% SAFETY FACTOR CALCULATIONS
SF.tau_sa = 0.58*Bolt.SY/tau_sa; 
SF.tau_sp = 0.58*Bolt.SY/tau_sp; 
SF.tau_ia = 0.58*Bolt.SY/tau_ia; 
SF.tau_ip = 0.58*Bolt.SY/tau_ip; 

%% Bearings

% SYMBOLS
% syms L_10sa L_10sp L_10ia L_10ip C_sa C_sp C_ia C_ip 


% ALLOWABLE FORCE CALCULATION
% L_10sa = (Bearing.C_10 / norm(S.F_sa))^3;
% L_10sp = (Bearing.C_10 / norm(S.F_sp))^3;
% L_10ia = (Bearing.C_10 / norm(I.F_ia))^3;
% L_10ip = (Bearing.C_10 / norm(I.F_ip))^3;
% 
% C_sa = norm(S.F_sa) * (Bearing.L / L_10sa)^(1/3);
% C_sp = norm(S.F_sp) * (Bearing.L / L_10sp)^(1/3);
% C_ia = norm(I.F_ia) * (Bearing.L / L_10ia)^(1/3);
% C_ip = norm(I.F_ip) * (Bearing.L / L_10ip)^(1/3);
% 
% % SAFETY FACTOR CALCULATION
% SF.sigma_bearingsa = Bearing.C_10 / C_sa;
% SF.sigma_bearingsp = Bearing.C_10 / C_sp;
% SF.sigma_bearingia = Bearing.C_10 / C_ia;
% SF.sigma_bearingip = Bearing.C_10 / C_ip;

%% Obtain the minimum safety factor (critical) from all safety factors for each obj.
Superiorarr = [abs(SF.sigma_sx), abs(SF.sigma_s1y), abs(SF.sigma_s2y), abs(SF.sigma_s3y), abs(SF.sigma_sbend1), abs(SF.sigma_sbend2), abs(SF.sigma_srupture), abs(SF.tau_s1), abs(SF.tau_s2), abs(SF.tau_s3), abs(SF.frontalbending_s)];
if(SF.buckling_s > 0)
    Superiorarr(end + 1) = SF.buckling_s;
end

SF.SF_sup = min(Superiorarr);

Inferiorarr = [abs(SF.sigma_ix), abs(SF.sigma_i1y), abs(SF.sigma_i2y), abs(SF.sigma_i3y), abs(SF.sigma_ibend1), abs(SF.sigma_ibend2), abs(SF.sigma_irupture), abs(SF.tau_i1), abs(SF.tau_i2), abs(SF.tau_i3), abs(SF.frontalbending_i)];
if(SF.buckling_i > 0)
    Inferiorarr(end + 1) = SF.buckling_i;
end

SF.SF_inf = min(Inferiorarr);

Anteriorarr = [abs(SF.sigma_a1y), abs(SF.sigma_a2y), abs(SF.sigma_abend), abs(SF.sigma_arupture1), abs(SF.sigma_arupture2), abs(SF.tau_a1), abs(SF.tau_a2)];
if(SF.buckling_a > 0)
    Anteriorarr(end + 1) = SF.buckling_a;
end

SF.SF_ant = min(Anteriorarr);

Posteriorarr = [abs(SF.sigma_p1y), abs(SF.sigma_p2y), abs(SF.sigma_pbend), abs(SF.sigma_prupture1), abs(SF.sigma_prupture2), abs(SF.tau_p1), abs(SF.tau_p2)];
if(SF.buckling_p > 0)
    Posteriorarr(end + 1) = SF.buckling_p;
end

SF.SF_pos = min(Posteriorarr);
    
%Individual Safety Factors (for velcro)
SF.SF_VT = abs(SF.tau_vt);
SF.SF_VC = abs(SF.tau_vc);

%Obtain Critical Safety Factor for torsional springs
SF.SF_TS1 = min([abs(SF.sigma_spring1), abs(SF.fatigue_spring1)]);
SF.SF_TS2 = min([abs(SF.sigma_spring2), abs(SF.fatigue_spring2)]);

%Safety Factors for bolts
SF.SF_BoltSA = abs(SF.tau_sa);
SF.SF_BoltSP = abs(SF.tau_sp);
SF.SF_BoltIA = abs(SF.tau_ia);
SF.SF_BoltIP = abs(SF.tau_ip);




end

