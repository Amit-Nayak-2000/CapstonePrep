function [] = IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, ZF, SF, mass, frame, verticaloffset)
%Essentially GaitLoop.m but for an individual frame.
%Used to recheck/recalculate a frame's Safety Factor

%Parse Winters Data
WinterData = Parse_Winter_Data("Winter_Appendix_data_fixed.xlsx");
kinematicsdata = WinterData{3};

startframe = frame; %Frame to check
endframe = frame; 

%Loop through the gait cycle
for i=startframe:endframe

    %Singularity at Frame 29 Bug Fix
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
    
    %calculate kinematics
    Kinematic_Modelling(S,In,P,A,kinthigh,kincalf, thighlength, calflength, T1, T2, verticaloffset);

    %calculate saggital forces
    Kinetic_Saggital(S,In,P,A,T1,T2);
    %calculate frontal forces
    Kinetic_Frontal(S,In,P,ZF,i,mass);
    
    %Re-calculate Safety Factors
    StressCalculations(S, In, A, P, T1, T2, VT, VC, Blt, Brng, SF);

    
end

end

