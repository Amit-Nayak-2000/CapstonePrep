classdef Z_forces < handle
    %Z forces 
    %Contains data for the forces acting in the z direction
    
    properties
        F_tz    %Brace force on the thigh
        F_cz    %Brace force on the calf
        F_kz    %Brace force on the knee
        OA_KAM  %Biological knee adduction moment
        Mk      %Brace corrected knee adduction moment
        M_targ  %Healthy knee adduction moment (our target)
        
    end
end