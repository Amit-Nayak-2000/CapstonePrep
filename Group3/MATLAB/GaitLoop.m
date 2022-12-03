function [SupSFArr,AntSFArr,PosSFArr,InfSFArr,T1SFArr,T2SFArr,VtSFArr,VcSFArr, BLSPSFArr, BLSASFArr, BLIASFArr, BLIPSFArr, BNSPFArr, BNSAFArr, BNIAFArr, BNIPFArr, percentage, biokneemoment, newkneemoment, totalPE, ICRx, ICRy, BSA, BIA, BSP, BIP, OA_KAM, new_KAM, healthy_KAM] = GaitLoop(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, ZF, SF, mass, verticaloffset, app)
%Gait Loop Function
%Loops through the gait cycle for initial calculations of critical safety
%factors and other data.
%Input: Brace Objects, Patient Dimensions
%Outputs: Critical Safety Factor arrays, Contribution of Brace Arrays,
%Bearing Specific Arrays

%Parse Winters Data
WinterData = Parse_Winter_Data("Winter_Appendix_data_fixed.xlsx");
%Kinematics of thigh and calf
kinematicsdata = WinterData{3};
%Kinetics of thigh and calf (specifically knee moment)
rxnforcedata = WinterData{5};

startframe = 28; %Heel Contact Right
endframe = 96; %Just Before next Heel Contact Right

%Arrays to store critical safety factors at each frame in gait cycle. 
%Links
SupSFArr = zeros(1 ,endframe - startframe + 1);
AntSFArr = zeros(1 ,endframe - startframe + 1);
PosSFArr = zeros(1 ,endframe - startframe + 1);
InfSFArr = zeros(1 ,endframe - startframe + 1);

%Springs
T1SFArr = zeros(1 ,endframe - startframe + 1);
T2SFArr = zeros(1 ,endframe - startframe + 1);

%Straps
VtSFArr = zeros(1 ,endframe - startframe + 1);
VcSFArr = zeros(1 ,endframe - startframe + 1);

%Bolts
BLSPSFArr = zeros(1 ,endframe - startframe + 1);
BLSASFArr = zeros(1 ,endframe - startframe + 1);
BLIASFArr = zeros(1 ,endframe - startframe + 1);
BLIPSFArr = zeros(1 ,endframe - startframe + 1); 

%Bearing Force Arrays (Will be used to calculate average force)
BNSPFArr = zeros(1 ,endframe - startframe + 1); 
BNSAFArr = zeros(1 ,endframe - startframe + 1); 
BNIAFArr = zeros(1 ,endframe - startframe + 1); 
BNIPFArr = zeros(1 ,endframe - startframe + 1);

%Bearing angle arrays (Will be used to calculate range of motion of
%bearings).
BNthetaSP = zeros(1 ,endframe - startframe + 1); 
BNthetaSA = zeros(1 ,endframe - startframe + 1); 
BNthetaIA = zeros(1 ,endframe - startframe + 1); 
BNthetaIP = zeros(1 ,endframe - startframe + 1);

%Contribution Arrays
percentage = zeros(1, endframe - startframe + 1);
%Biological Moment
biokneemoment = zeros(1, endframe - startframe + 1);
%Torque on Knee joint from calf frame of reference.
TorqueOnCalf = zeros(1, endframe - startframe + 1);
%Potential energy of brace
totalPE = zeros(1, endframe - startframe + 1);
%modified knee moment
newkneemoment = zeros(1, endframe - startframe + 1);
%Instantanous centre of rotation
ICRx = zeros(1, endframe - startframe + 1);
ICRy = zeros(1, endframe - startframe + 1);
OA_KAM = zeros(1, endframe - startframe + 1);
new_KAM = zeros(1, endframe - startframe + 1);
healthy_KAM = zeros(1, endframe - startframe + 1);
% percentagegait = zeros(1, endframe - startframe + 1);

syms Da Dp;

%Loop through the gait cycle
for i=startframe:endframe
    %index to store safety factor in arrays
    dataindex = i - startframe + 1;
    
    %If frame 29, use frame 30 due to singularity bug. 
    if(i == 29)
        %Obtain biological kinematics of calf and thigh.
        kincalf = [kinematicsdata(i+1,16), kinematicsdata(i+1,17), kinematicsdata(i+1,18), 0, 0, 0; 
                   kinematicsdata(i+1,19), kinematicsdata(i+1,20), kinematicsdata(i+1,21), 0, 0, 0;
                   0, 0, 0, kinematicsdata(i+1,13), kinematicsdata(i+1,14), kinematicsdata(i+1,15);];

        kinthigh = [kinematicsdata(i+1,26), kinematicsdata(i+1,27), kinematicsdata(i+1,28), 0, 0, 0; 
                   kinematicsdata(i+1,29), kinematicsdata(i+1,30), kinematicsdata(i+1,31), 0, 0, 0;
                   0, 0, 0, kinematicsdata(i+1,23), kinematicsdata(i+1,24), kinematicsdata(i+1,25);];
    else
        %Obtain biological kinematics of calf and thigh.
        kincalf = [kinematicsdata(i,16), kinematicsdata(i,17), kinematicsdata(i,18), 0, 0, 0; 
                   kinematicsdata(i,19), kinematicsdata(i,20), kinematicsdata(i,21), 0, 0, 0;
                   0, 0, 0, kinematicsdata(i,13), kinematicsdata(i,14), kinematicsdata(i,15);];

        kinthigh = [kinematicsdata(i,26), kinematicsdata(i,27), kinematicsdata(i,28), 0, 0, 0; 
                   kinematicsdata(i,29), kinematicsdata(i,30), kinematicsdata(i,31), 0, 0, 0;
                   0, 0, 0, kinematicsdata(i,23), kinematicsdata(i,24), kinematicsdata(i,25);];
    end
    
    %calculate kinematics of brace
    Kinematic_Modelling(S,In,P,A,kinthigh,kincalf, thighlength, calflength, T1, T2, verticaloffset);

    %calculate forces in saggital plane
    Kinetic_Saggital(S,In,P,A,T1,T2);
    %calculate forces in frontal plane
    Kinetic_Frontal(S,In,P,ZF,i,mass);
    
    %calculate stresses and safety factors of components
    StressCalculations(S, In, A, P, T1, T2, VT, VC, Blt, Brng, SF, ZF);
    
    %Put critical safety factors in critical safety factor arrays
    %Links
    SupSFArr(dataindex) = SF.SF_sup;
    AntSFArr(dataindex) = SF.SF_ant;
    PosSFArr(dataindex) = SF.SF_pos;
    InfSFArr(dataindex) = SF.SF_inf;
    
    %Torsional Springs
    T1SFArr(dataindex) = SF.SF_TS1;
    T2SFArr(dataindex) = SF.SF_TS2;
    
    %Velcro Straps
    VtSFArr(dataindex) = SF.SF_VT;
    VcSFArr(dataindex) = SF.SF_VC;
    
    %bolts
    BLSPSFArr(dataindex) = SF.SF_BoltSP;
    BLSASFArr(dataindex) = SF.SF_BoltSA;
    BLIASFArr(dataindex) = SF.SF_BoltIA;
    BLIPSFArr(dataindex) = SF.SF_BoltIP;

    %Bearings (Put radial force in arrays for eventual avg force
    %computation).
    BNSPFArr(dataindex) = norm(S.F_sp);
    BNSAFArr(dataindex) = norm(S.F_sa);
    BNIAFArr(dataindex) = norm(In.F_ia);
    BNIPFArr(dataindex) = norm(In.F_ip);
    
    %Store bearing angles for the purpose of calculating correction factor
    %in bearing force calculation
    [BNthetaSA(dataindex) ,BNthetaIP(dataindex), BNthetaIA(dataindex), BNthetaSP(dataindex)] = GetBearingAngles(S, A, In, P);
    
    %% Saggital Brace Contribution Calculations
    %bio knee moment is col 15 in Winter's Data
    biokneemoment(dataindex) = rxnforcedata(i, 15);
    %Scale biological moment according to user mass.
    biokneemoment(dataindex) = biokneemoment(dataindex)*(mass / 56.7);
    BraceMass = 2*(S.m + A.m + In.m + P.m);
    %Scaling factor to include brace mass.
    NonDimFactor = (mass + BraceMass) / mass;

    %multiplied by 2 since both sides of the knee
    %Normal force exerted by the brace multiplied by the moment arm.
    TorqueOnCalf(dataindex) =  -2*(In.H4 + In.offset)*In.F_cn;
    totalPE(dataindex) = 2*(T1.K*(T1.theta-T1.theta0)^2 + T2.K*(T2.theta-T2.theta0)^2);
    
    %New knee moment is the biological moment subtracted by the torque on
    %knee (obtained from sum of moments, See Report).
    newkneemoment(dataindex) = NonDimFactor*biokneemoment(dataindex) - TorqueOnCalf(dataindex);
    
    %Percentage array (For plotting).
    percentage(dataindex) = ((i - startframe + 1)/(endframe - startframe + 1)) * 100;
    compstring = strcat(num2str(percentage(dataindex)), "% of gait cycle completed.");
    app.TextArea.Value = compstring;
    drawnow;
    
    
    %% ICR Calculations
    %Calculation of Instantaneous Centre of Rotation (See Report)
    ICR1 = Da*cosd(A.theta) + Dp*cosd(P.theta)+S.L*cosd(S.theta) == 0;
    ICR2 = Da*sind(A.theta) + Dp*sind(P.theta)+S.L*sind(S.theta) == 0;

    ICRsoln = solve([ICR1, ICR2], [Da, Dp]);

    ICRx(dataindex) = double(ICRsoln.Da*cosd(A.theta));
    ICRy(dataindex) = double(ICRsoln.Da*sind(A.theta));
    
    %% Frontal Calculations Storage
    OA_KAM(dataindex) = ZF.OA_KAM;
    new_KAM(dataindex) = ZF.Mk;
    healthy_KAM(dataindex) = ZF.M_targ;

end

    %Bearing Range of Motion after looping through gait cycle
    BSA = abs(max(BNthetaSA) -  min(BNthetaSA));
    BIA = abs(max(BNthetaIA) -  min(BNthetaIA));
    BSP = abs(max(BNthetaSP) -  min(BNthetaSP));
    BIP = abs(max(BNthetaIP) -  min(BNthetaIP));

end

