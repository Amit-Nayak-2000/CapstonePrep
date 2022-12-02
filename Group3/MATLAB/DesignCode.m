function [percentage, biokneemoment, newkneemoment, totalPE, ICRx, ICRy, Parts, SafetyFactors, OA_KAM, new_KAM, healthy_KAM] = DesignCode(mass,height,thighdiameter,calfdiameter, app)
%Design Code
%Inputs: User mass, height, thigh and calf diameter
%Outputs: Safety Factors of all components, Moment Contribution in Saggital Plane,
%Biological Knee Momemt, Potential Energy througout gait cycle, Brace
%Offloading Contribution in Frontal Plane, ICR position of knee joint
%through gait cycle. 


%Thigh/Calf Length from Winters Segment Model
thighlength = (0.530 - 0.285)*height;
calflength = (0.285 - 0.0039)*height;

%Instantiate Objects
S = SuperiorLink;
A = AnteriorLink;
In = InferiorLink;
P = PosteriorLink;
T1 = TorsionalSpring;
T2 = TorsionalSpring;
ZF = Z_forces;
VT = Velcro;
VC = Velcro;
V_buck = VelcroBuckle;
Blt = Bolt;
Brng = Bearing;
SF = SafetyFactor;
Stoff1 = washerstandoff;
Stoff2 = washerstandoff;
Stoff3 = washerstandoff;
Wash = washerstandoff;
N1 = Fastener;
N2 = Fastener;
Hbase = Housing;
Hcover = Housing;
V_buck = VelcroBuckle;

%Initialize dimensions based on Mass and Height
Init_System(mass, height, S, In, P, A, T1, T2,VT,VC,Blt,Brng, thighdiameter, calfdiameter);
%Initialize Torsional Springs:
verticaloffset = GetInitKinematics(S, In, A, P, T1, T2);
T1 = initSpring(T1, mass, S, A);
T2 = initSpring(T2, mass, In, P);

%Parametrization Of Components:

%loop through the gait cycle and obtain critical safety factors for each
%frame.
app.TextArea.Value = "Computing initial calculations through gait cycle. We thank you for your patience.";
drawnow;
[SupSFArr,AntSFArr,PosSFArr,InfSFArr,T1SFArr,T2SFArr,VtSFArr,VcSFArr, BLSPSFArr, BLSASFArr, BLIASFArr, BLIPSFArr,  BNSPFArr, BNSAFArr, BNIAFArr, BNIPFArr, percentage, biokneemoment, newkneemoment, totalPE, ICRx, ICRy, BSA, BIA, BSP, BIP, OA_KAM, new_KAM, healthy_KAM] = GaitLoop(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, verticaloffset, app);


%% Superior Link Parametrization
app.TextArea.Value = "Optimizing Superior Link (1/8 components)";
drawnow;
%Flag if superior link is satisfied WRT Safety Factor Range.
SuperiorSatisfied = 0;
%Obtain Minimum Critical SF of gaitcycle & index of occurance.
[MinSup, SupIndex] = min(SupSFArr);
while(SuperiorSatisfied == 0)
    if(MinSup > 4)
        %decrease thickness of link.
        if(S.T > 0.0039)
            S.T = 0.9*S.T;
        else
            S.B2 = 0.75*S.B2;
        end
        %recalculate inertial properties of link
        S = calculate_inertial_props(S);
        %update SF for critical frame
        IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, SupIndex+27, verticaloffset);
        MinSup = SF.SF_sup;
    elseif(MinSup < 2)
        %increase thickness and B2 of link.
        S.B2 = 1.15*S.B2;
        S.T = 1.15*S.T;
        %recalculate inertial properties
        S = calculate_inertial_props(S);
        %update SF for critical frame
        IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, SupIndex+27, verticaloffset);
        MinSup = SF.SF_sup;
    else
        %Superior Min SF is satisfied.
        SuperiorSatisfied = 1;
    end

end


%% Inferior Link Parametrization
app.TextArea.Value = "Optimizing Inferior Link (2/8 components)";
drawnow;
%Flag if inferior link is satisfied WRT Safety Factor Range.
InferiorSatisfied = 0;
%Obtain Minimum Critical SF of gaitcycle & index of occurance.
[MinInf, InfIndex] = min(InfSFArr);
while(InferiorSatisfied == 0)
    if(MinInf > 4)
        %decrease thickness of link if possible, else decrease B2.
        if(In.T > 0.0039)
            In.T = 0.9*In.T;
        else
            In.B2 = 0.9*In.B2;
        end
        %recalculate inertial properties
        In = calculate_inertial_props(In);
        %update SF for critical frame
        IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, InfIndex+27, verticaloffset);
        MinInf = SF.SF_inf;
    elseif(MinInf < 2)
        %increase thickness and B2 of link.
        In.B2 = 1.15*In.B2;
        In.T = 1.15*In.T;
        %recalculate inertial properties
        In = calculate_inertial_props(In);
        %update SF for critical frame
        IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, InfIndex+27, verticaloffset);
        MinInf = SF.SF_inf;
    else
        %Inferior Min SF is satisfied.
        InferiorSatisfied = 1;
    end
end
    
%% Anterior Link Parametrization
app.TextArea.Value = "Optimizing Anterior Link (3/8 components)";
drawnow;
%Flag if anterior link is satisfied WRT Safety Factor Range.
AnteriorSatisfied = 0;
%obtain minimum SF & index thru gait cycle.
[MinAnt, AntIndex] = min(AntSFArr);
while(AnteriorSatisfied == 0)
    if(MinAnt > 4)
        %decrease width of link.
        A.B = 0.75*A.B;
        %recalculate inertial properties
        A = calculate_inertial_props(A);
        %update SF for critical frame
        IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, AntIndex+27, verticaloffset);
        MinAnt = SF.SF_ant;
    elseif(MinAnt < 2)
        %increase width of link.
        if(A.B<0.6*A.H)
            A.B = 1.5*A.B;
        elseif(A.B<0.85*A.H)
            A.B=1.15*A.B;
        else
            A.T = 1.2*A.T;
        end
        %recalculate inertial properties
        A = calculate_inertial_props(A);
        %update SF for critical frame
        IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, AntIndex+27, verticaloffset);
        MinAnt = SF.SF_ant;
    else
        %Inferior Min SF is satisfied.
        AnteriorSatisfied = 1;
    end
end
    
%% Posterior Link Parametrization
app.TextArea.Value = "Optimizing Posterior Link (4/8 components)";
drawnow;
%Flag if posterior link is satisfied WRT Safety Factor Range.
PosteriorSatisfied = 0;
%obtain minimum SF & index thru gait cycle.
[MinPos, PosIndex] = min(PosSFArr);
while(PosteriorSatisfied == 0)
    if(MinPos > 4)
        %decrease width of link.
        P.B = 0.75*P.B;
        %recalculate inertial properties
        P = calculate_inertial_props(P);
        %update SF for critical frame
        IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, PosIndex+27, verticaloffset);
        MinPos = SF.SF_pos;
    elseif(MinPos < 2)
        %increase width of link.
        if(P.B<0.6*P.H)
            P.B = 1.5*P.B;
        elseif(P.B<0.85*P.H)
            P.B=1.15*P.B;
        else
            P.T = 1.2*P.T;
        end
        %recalculate inertial properties
        P = calculate_inertial_props(P);
        %update SF for critical frame
        IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, PosIndex+27, verticaloffset);
        MinPos = SF.SF_pos;
    else
        %Inferior Min SF is satisfied.
        PosteriorSatisfied = 1;
    end
end


%% Thigh Velcro Parametrization
app.TextArea.Value = "Optimizing Thigh Velcro (5/8 components)";
drawnow;
%Flag if thigh velcro is satisfied WRT Safety Factor Range.
VTsatisfied = 0;
%Obtain Minimum Critical SF of gaitcycle & index of occurance.
[MinVT, VTIndex] = min(VtSFArr);
while(VTsatisfied == 0)
    if(MinVT > 4)
        %decrease length and width of velcro.
        VT.L = 0.95*VT.L;
        VT.W = 0.95*VT.W;
        %update SF for critical frame
        IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, VTIndex+27, verticaloffset);
        MinVT = SF.SF_VT;
    elseif(MinVT < 2)
        %increase length and width of link.
        VT.L = 1.15*VT.L;
        VT.W = 1.15*VT.W;
        %update SF for critical frame
        IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, VTIndex+27, verticaloffset);
        MinVT = SF.SF_VT;
    else
        %Thigh Velcro Min SF is satisfied.
        VTsatisfied = 1;
    end
end

%% Calf Velcro Parametrization
app.TextArea.Value = "Optimizing Calf Velcro (6/8 components)";
drawnow;
%Flag if calf velcro is satisfied WRT Safety Factor Range.
VCsatisfied = 0;
%Obtain Minimum Critical SF of gaitcycle & index of occurance.
[MinVC, VCIndex] = min(VcSFArr);
while(VCsatisfied == 0)
    if(MinVC > 4)
        %decrease length and width of velcro.
        VC.L = 0.95*VC.L;
        VC.W = 0.95*VC.W;
        %update SF for critical frame
        IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, VCIndex+27, verticaloffset);
        MinVC = SF.SF_VC;
    elseif(MinVC < 2)
        %increase length and width of velcro.
        VC.L = 1.15*VC.L;
        VC.W = 1.15*VC.W;
        %update SF for critical frame
        IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, VCIndex+27, verticaloffset);
        MinVC = SF.SF_VC;
    else
        %Calf Velcro Min SF is satisfied.
        VCsatisfied = 1;
    end
end

%% TS1 Parametrization
app.TextArea.Value = "Optimizing Torsional Spring 1 (7/8 components)";
drawnow;
%Flag if Torsional Spring 1 (SA) is satisfied WRT Safety Factor Range.
T1satisfied = 0;
%Obtain Minimum Critical SF of gaitcycle & index of occurance.
[MinT1, T1Index] = min(T1SFArr);
while(T1satisfied == 0)
    if(MinT1 > 4)
        %Design Constraint (can decrement number of body coils if it wont
        %end up with a Nb < 1).
        if(T1.Nb < 2)
            break;
        end
        %decrement Nb if possible.
        T1.Nb = T1.Nb - 1;
        %update Spring Dimensions based on Nb
        T1 = updateSpring(T1);
        %update SF for critical frame
        IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, T1Index+27, verticaloffset);
        MinT1 = SF.SF_TS1;
    elseif(MinT1 < 2)
        %increment Nb.
        T1.Nb = T1.Nb + 1;
        %update Spring parameters based on Nb
        T1 = updateSpring(T1);
        %update SF for critical frame
        IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, T1Index+27, verticaloffset);
        MinT1 = SF.SF_TS1;
    else
        %Torsional Spring 1 Min SF is satisfied.
        T1satisfied = 1;
    end
end


%% TS2 Parametrization
app.TextArea.Value = "Optimizing Torsional Spring 2 (8/8 components)";
drawnow;
%Flag if Torsional Spring 2 (IP) is satisfied WRT Safety Factor Range.
T2satisfied = 0;
%Obtain Minimum Critical SF of gaitcycle & index of occurance.
[MinT2, T2Index] = min(T2SFArr);
while(T2satisfied == 0)
    if(MinT2 > 4)
        %Design Constraint (can decrement body coils if it wont end up with
        %Nb < 1).
        if(T2.Nb < 2)
            break;
        end
        %decrement Nb if possible.
        T2.Nb = T2.Nb - 1;
        %update Spring parameters based on Nb
        T2 = updateSpring(T2);
        %update SF for critical frame
        IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, T2Index+27, verticaloffset);
        MinT2 = SF.SF_TS2;
    elseif(MinT2 < 2)
        %increment Nb.
        T2.Nb = T2.Nb + 1;
        %update Spring parameters based on Nb
        T2 = updateSpring(T2);
        %update SF for critical frame
        IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, T2Index+27, verticaloffset);
        MinT2 = SF.SF_TS2;
    else
        %Torsional Spring 2 Min SF is satisfied.
        T2satisfied = 1;
    end
end

%% Obtain Bolt Safety Factors and Bearing Life
%Bolt Minimum Safety Factors
MinBoltIA = min(BLIASFArr);
MinBoltIP = min(BLIPSFArr);
MinBoltSP = min(BLSPSFArr);
MinBoltSA = min(BLSASFArr);

%Bearing Life Calculation
%Average Force throughout gait cycle is used for this calculation.
%BSA, BSP, BIA and BIP are the full range of motion (in deg) of the
%bearings. These are used as a correction factor since bearings do not go
%through full revolutions in brace. 
avgSA = mean(BNSAFArr)*((BSA/2)/90)^(1/3);
avgSP = mean(BNSPFArr)*((BSP/2)/90)^(1/3);
avgIA = mean(BNIAFArr)*((BIA/2)/90)^(1/3);
avgIP = mean(BNIPFArr)*((BIP/2)/90)^(1/3);

%Calculation of bearing life (in millions of revolutions)
BearingSALife = Brng.L_10*(Brng.C_10/avgSA)^3;
BearingSPLife = Brng.L_10*(Brng.C_10/avgSP)^3;
BearingIALife = Brng.L_10*(Brng.C_10/avgIA)^3;
BearingIPLife = Brng.L_10*(Brng.C_10/avgIP)^3;

%Calculation of Final Brace Mass
FinalBraceMass = 2*(S.m + In.m + A.m + P.m);

%% OUTPUTS TO GUI/LogFile
%Array of part names and Safety Factors
Parts = ["Superior Link" "Inferior Link" "Anterior Link" "Posterior Link" "Velcro Thigh" "Velcro Calf" "Torsional Spring 1" "Torsional Spring 2"];
SafetyFactors = [MinSup MinInf MinAnt MinPos MinVT MinVC MinT1 MinT2];

%Output String for GUI
str1 = Parts(1) + ' Safety Factor: ' + num2str(SafetyFactors(1)) + '\n';
str2 = Parts(2) + ' Safety Factor: ' + num2str(SafetyFactors(2)) + '\n';
str3 = Parts(3) + ' Safety Factor: ' + num2str(SafetyFactors(3)) + '\n';
str4 = Parts(4) + ' Safety Factor: ' + num2str(SafetyFactors(4)) + '\n';
str5 = Parts(5) + ' Safety Factor: ' + num2str(SafetyFactors(5)) + '\n';
str6 = Parts(6) + ' Safety Factor: ' + num2str(SafetyFactors(6)) + '\n';
str7 = Parts(7) + ' Safety Factor: ' + num2str(SafetyFactors(7)) + '\n';
str8 = Parts(8) + ' Safety Factor: ' + num2str(SafetyFactors(8)) + '\n';
str9 = "Bearing SA Life (Million Revolutions): " + num2str(BearingSALife) + "\n";
str10 = "Bearing SP Life (Million Revolutions): " + num2str(BearingSPLife) + "\n";
str11 = "Bearing IA Life (Million Revolutions): " + num2str(BearingIALife) + "\n";
str12 = "Bearing IP Life (Million Revolutions): " + num2str(BearingIPLife) + "\n";
str13 = "Bolt SA Life Safety Factor: " + num2str(MinBoltSA) + "\n";
str14 = "Bolt SP Life Safety Factor: " + num2str(MinBoltSP) + "\n";
str15 = "Bolt IA Life Safety Factor: " + num2str(MinBoltIA) + "\n";
str16 = "Bolt IP Life Safety Factor: " + num2str(MinBoltIP) + "\n";

GUI_String = str1 + str2 + str3 + str4 + str5 + str6 + str7 + str8 + str9 + str10 + str11 + str12 + str13 + str14 + str15 + str16;
GUI_String = compose(GUI_String);
app.TextArea_sf.Value = GUI_String;
drawnow;

%Output Patient Data and Safety Factor of Compoments to Log File
fileID = fopen('../Log/group03_LOG.txt','w');
fprintf(fileID,'Patient Mass=%.3f\n',mass);
fprintf(fileID,'Patient Height=%.3f\n',height);
fprintf(fileID,'Patient Thigh Diameter=%.3f\n',thighdiameter);
fprintf(fileID,'Patient Calf Diameter=%.3f\n',calfdiameter);
fprintf(fileID,'Brace Mass=%.3f\n', FinalBraceMass);
fprintf(fileID,'Superior Link Safety Factor=%.3f\n', MinSup);
fprintf(fileID,'Inferior Link Safety Factor=%.3f\n', MinInf);
fprintf(fileID,'Anterior Link Safety Factor=%.3f\n', MinAnt);
fprintf(fileID,'Posterior Link Safety Factor=%.3f\n', MinPos);
fprintf(fileID,'Thigh Velcro Safety Factor=%.3f\n', MinVT);
fprintf(fileID,'Calf Velcro Safety Factor=%.3f\n', MinVC);
fprintf(fileID,'Torsional Spring (Superior-Anterior) Safety Factor=%.3f\n', MinT1);
fprintf(fileID,'Torsional Spring (Inferior-Posterior) Safety Factor=%.3f\n', MinT2);
fprintf(fileID,'Bearing SA Life (Million Revolutions)=%.3f\n', BearingSALife);
fprintf(fileID,'Bearing SP Life (Million Revolutions)=%.3f\n', BearingSPLife);
fprintf(fileID,'Bearing IA Life (Million Revolutions)=%.3f\n', BearingIALife);
fprintf(fileID,'Bearing IP Life (Million Revolutions)=%.3f\n', BearingIPLife);
fprintf(fileID,'Bolt SA Safety Factor=%.3f\n', MinBoltSA);
fprintf(fileID,'Bolt SP Safety Factor=%.3f\n', MinBoltSP);
fprintf(fileID,'Bolt IA Safety Factor=%.3f\n', MinBoltIA);
fprintf(fileID,'Bolt IP Safety Factor=%.3f\n', MinBoltIP);

fclose(fileID); 
%% SOLIDWORKS OUTPUTS
%Output solidworks global vars dimensions (txt files)

%Anterior link
A.springarmholepos = 0.4*A.L;
A.outputDimensions();

%Posterior Link
P.springarmholepos = 0.4*P.L;
P.outputDimensions();

%Superior Link
S.springarmholepos = 0.4*S.L;
S.H_holes = 0.5*(S.B1-S.L);
S.pad_t1 = 0.005;
S.pad_t2 = 2*S.pad_t1;
S.D_strap = S.B3+2*S.pad_t1;
%Superior parametirzation is continued later because housing and velcro
%parameters are needed for some parametrizing equations

%Inferior Link
In.springarmholepos = 0.4*In.L;
In.H_holes = 0.5*(In.B1-In.L);
In.pad_t1=S.pad_t1+0.5*(S.B3-In.B3);
In.pad_t2=2*In.pad_t1;
In.D_strap=S.D_strap+0.5*(S.T-In.T);
%Superior parametirzation is continued later because housing and velcro
%parameters are needed for some parametrizing equations

%Springs

T1.height=T1.d*T1.Nb*1.1;
T2.height=T2.d*T2.Nb*1.1;

if(T1.height>T2.height)
    T2.height=T1.height;
else
    T1.height=T2.height;
end

T1.L_arm_main=S.springarmholepos-0.5*T1.loop_diam*cosd(45);
T1.L_arm_sub=A.springarmholepos-0.5*T1.loop_diam*cosd(45);
T1.outputDimensions(1);

T2.L_arm_main=In.springarmholepos-0.5*T2.loop_diam*cosd(45);
T2.L_arm_sub=P.springarmholepos-0.5*T2.loop_diam*cosd(45);
T2.outputDimensions(2);


%standoff and washer
if(S.T>=In.T && T1.height>=T2.height)
    Stoff1.H=T1.height+2*T1.d;
    Stoff2.H=T1.height+0.5*(S.T-In.T)+2*T1.d;
    
elseif(S.T<In.T && T1.height>=T2.height)
    Stoff1.H=T1.height+0.5*(In.T-S.T)+2*T1.d;
    Stoff2.H=T1.height+2*T1.d;

elseif(S.T>=In.T && T1.height<T2.height)
    Stoff1.H=T2.height+2*T2.d;
    Stoff2.H=T2.height+0.5*(S.T-In.T)+2*T2.d;
    
else
    Stoff1.H=T2.height+0.5*(In.T-S.T)+2*T2.d;
    Stoff2.H=T2.height+2*T2.d;
end

Stoff1.ID=0.0032;
Stoff1.OD=0.0045;

Stoff1.outputDimensions(1);

Stoff2.ID=0.0032;
Stoff2.OD=0.0045;

Stoff2.outputDimensions(2);

Stoff3.ID=0.0032;
Stoff3.OD=0.0045;
Stoff3.H=T1.d+0.0005; %maybe come back and change this
Stoff3.outputDimensions(3);

Wash.ID=0.0032;
Wash.OD=0.006;
Wash.H=0.0006;
Wash.outputDimensions(4);

%Bearing
Brng.outputDimensions();

%Housing 

%Housing base
Hbase.stop_width = 0.005;
Hbase.height = S.H1-S.H_holes+A.H*abs(sind(A.theta0))-0.5*(A.H-A.L)+Hbase.stop_width;
Hbase.width = A.H+2*Hbase.stop_width+Hbase.gap+0.33*A.B;
%Hbase.width = Hbase.height + 2*Hbase.stop_width;
Hbase.inf_stop_x = Hbase.stop_width+A.L*abs(cosd(A.theta0))+0.5*(A.B)-In.L-0.5*(In.B1-In.L)+Hbase.gap-0.0005;
Hbase.superior_stop_x = Hbase.stop_width+Hbase.gap+0.5*A.B-0.5*(S.B1-S.L);
Hbase.superior_stop_angle = 180-atand((S.H2-S.H1)/(0.5*(S.B1-S.B2)));
Hbase.t1 = 0.005;
Hbase.t2 = A.T+P.T+S.T+2*Stoff1.H+0.0035;

if(Stoff1<=Stoff2)
    Hbase.t3 = P.T+Stoff1.H-0.001;
else
    Hbase.t3 = P.T+Stoff2.H-0.001;
end

Hbase.b1_x=Hbase.stop_width+Hbase.gap+0.5*A.B+S.L;
Hbase.b1_y=S.H1-S.H_holes+0.0015;
Hbase.bolt_dist=P.L;
Hbase.theta_p_init=180-P.theta0;
Hbase.bolt_hole_depth=Hbase.t1;
Hbase.cover_holes_diam=0.002;
Hbase.pad_t=0.005;

Hbase.outputDimensions(1);

%Housing cover
Hcover.stop_width=Hbase.stop_width;
Hcover.height=Hbase.height;
Hcover.width=Hbase.width;
Hcover.inf_stop_x=Hbase.inf_stop_x;
Hcover.superior_stop_x=Hbase.superior_stop_x;
Hcover.superior_stop_angle=Hbase.superior_stop_angle;
Hcover.t1=Hbase.t1;

if(Stoff1<=Stoff2)
    Hcover.t2 = A.T+Stoff1.H+0.0035-0.001;
else
    Hcover.t2 = A.T+Stoff2.H+0.0035-0.001;
end

Hcover.cover_holes_diam=0.0024;

Hcover.outputDimensions(2);

%Nut
%Link-spring nut
N1.thread_height=0.0018;
N1.outputDimensions(1);

%interlink nut
N2.height=0.004;
N2.thread_height=0.00333;
N2.outputDimensions(2);

%Bolt
Blt.D=0.003;

%Link-Spring bolt
if(A.T>P.T)
    Blt.L=(ceil((A.T+Wash.H+N1.thread_height)*1000)+1)/1000;
else
    Blt.L=(ceil((P.T+Wash.H+N1.thread_height)*1000)+1)/1000;
end

Blt.outputDimensions(1);

%SA bolt
Blt.L=(ceil((A.T+Stoff1.H+S.T+N2.height)*1000)+1)/1000;
if(Blt.L<0.012)
    Blt.L_thread=Blt.L;
else
    Blt.L_thread=0.012;
end
Blt.outputDimensions(2);

%SP bolt
Blt.L=(ceil((P.T+Stoff1.H+S.T+Hbase.t1)*1000))/1000;
if(Blt.L<0.012)
    Blt.L_thread=Blt.L;
else
    Blt.L_thread=0.012;
end
Blt.outputDimensions(3);

%IA bolt
Blt.L=(ceil((A.T+Stoff2.H+In.T+N2.height)*1000)+1)/1000;
if(Blt.L<0.012)
    Blt.L_thread=Blt.L;
else
    Blt.L_thread=0.012;
end
Blt.outputDimensions(4);

%IP bolt
Blt.L=(ceil((P.T+Stoff2.H+In.T+Hbase.t1)*1000))/1000;
if(Blt.L<0.012)
    Blt.L_thread=Blt.L;
else
    Blt.L_thread=0.012;
end
Blt.outputDimensions(5);

%Cover bolt
Blt.D=0.002;
Blt.L=(floor((Hbase.bolt_hole_depth+Hcover.t1)*1000))/1000;
Blt.outputDimensions(6);

%Velcro
%Thigh Velcro
VT.Loop_D=0.008;
VT.t=0.001;
VT.fold_back_L=0.5*VT.L;

VT.outputDimensions(1);

%Calf Velcro
VC.Loop_D=0.008;
VC.t=0.001;
VC.fold_back_L=0.5*VC.L;

VC.outputDimensions(2);

%Velcro Buckle
V_buck.slot_w=5*max([VT.t,VC.t]);
V_buck.slot_h=max([VT.W,VC.W])+0.002;
V_buck.t=0.004;
V_buck.height=V_buck.slot_h+2*V_buck.t;
V_buck.outputDimensions();


%Rivet
Blt.D=0.0032;
Blt.L=V_buck.t+max([S.T,In.T]);
Blt.outputDimensions(7);

%Superior link cont'd
S.clip_hole_y1=0.25*V_buck.slot_h;
S.clip_hole_dist=0.5*V_buck.slot_h;
S.unpad_L1=(2/3)*Hbase.width;
S.outputDimensions();

%Inferior link cont'd
In.clip_hole_y1=0.25*V_buck.slot_h;
In.clip_hole_dist=0.5*V_buck.slot_h;
In.unpad_L1=In.H2;
In.outputDimensions();


%Inferior link cont'd
In.clip_hole_y1=0.25*V_buck.slot_h;
In.clip_hole_dist=0.5*V_buck.slot_h;
In.unpad_L1=(2/3)*Hbase.width;
In.outputDimensions();

%% Final Output to Run Screen GUI

finalstring = "Parametrization Complete! See S.F Tab for detailed safety factors." + '\n' + 'Overall Safety Factor of Brace: ' + num2str(min(SafetyFactors)) + '\nMass of User: ' + num2str(mass) + ' kg\nHeight of User: ' + num2str(height) + ' m\nThigh Diameter: ' + num2str(thighdiameter*100) + ' cm\nCalf Diameter: ' + num2str(calfdiameter*100) + ' cm\nMass of Brace: ' + num2str(FinalBraceMass) + ' kg';
finalstring = compose(finalstring);
app.TextArea.Value = finalstring;
drawnow;
end

