classdef SafetyFactor < handle
    %SAFETYFACTOR
    %Contains all safety factors resulting from stress calculations
    
    properties
        % Superior Link
        sigma_sx
        sigma_s1y
        sigma_s2y
        sigma_s3y
        sigma_sbend1
        sigma_sbend2
        sigma_srupture
        tau_s1
        tau_s2
        tau_s3
        buckling_s
        
        % Inferior Link
        sigma_ix
        sigma_i1y
        sigma_i2y
        sigma_i3y
        sigma_ibend1
        sigma_ibend2
        sigma_irupture
        tau_i1
        tau_i2
        tau_i3
        buckling_i
        
        % Anterior Link
        sigma_a1y
        sigma_a2y
        sigma_abend
        sigma_arupture1
        sigma_arupture2
        tau_a1
        tau_a2
        buckling_a
        
        % Posterior Link
        sigma_p1y
        sigma_p2y
        sigma_pbend
        sigma_prupture1
        sigma_prupture2
        tau_p1
        tau_p2
        buckling_p

        % Velcro
        tau_vt
        tau_vc
        
        % Springs
        sigma_spring1
        sigma_spring2
        fatigue_spring1
        fatigue_spring2
        
        % Bolts
        tau_sa 
        tau_sp 
        tau_ia 
        tau_ip

        % Bearings
        sigma_bearingsa
        sigma_bearingsp
        sigma_bearingia
        sigma_bearingip
        
        %critical safety factors of each object 
        %This is the minimum safety factor of all safety factors of each
        %object (critical method of failure). 
        SF_sup
        SF_ant
        SF_pos
        SF_inf
        SF_VT
        SF_VC
        SF_TS1
        SF_TS2
        SF_BoltSA
        SF_BoltSP
        SF_BoltIA
        SF_BoltIP

        
    end
    
    methods
        %Method to intialize inner diameter and outer diameter of bearing.
        %Not used?
        function obj = initBearing(obj, SC_sigma_sx, SC_sigma_s1y, SC_sigma_s2y, SC_sigma_s3y, SC_sigma_sbend1, SC_sigma_sbend2, SC_sigma_srupture, SC_tau_s1, SC_tau_s2, SC_tau_s3, SC_buckling_s, SC_sigma_ix, SC_sigma_i1y, SC_sigma_i2y, SC_sigma_i3y, SC_sigma_ibend1, SC_sigma_ibend2, SC_sigma_irupture, SC_tau_i1, SC_tau_i2, SC_tau_i3, SC_buckling_i, SC_sigma_a1y, SC_sigma_a2y, SC_sigma_abend, SC_sigma_arupture1, SC_sigma_arupture2, SC_tau_a1, SC_tau_a2, SC_buckling_a, SC_sigma_p1y, SC_sigma_p2y, SC_sigma_pbend, SC_sigma_prupture1, SC_sigma_prupture2, SC_tau_p1, SC_tau_p2, SC_buckling_p, SC_tau_vt, SC_tau_vc, SC_sigma_spring1, SC_sigma_spring2, SC_fatigue_spring1, SC_fatigue_spring2, SC_tau_sa, SC_tau_sp, SC_tau_ia, SC_tau_ip, SC_sigma_bearingsa, SC_sigma_bearingsp, SC_sigma_bearingia, SC_sigma_bearingip)
            sigma_sx = SC_sigma_sx
            sigma_s1y = SC_sigma_s1y;
            sigma_s2y = SC_sigma_s2y;
            sigma_s3y = SC_sigma_s3y;
            sigma_sbend1 = SC_sigma_sbend1;
            sigma_sbend2 = SC_sigma_sbend2;
            sigma_srupture = SC_sigma_srupture;
            tau_s1 = SC_tau_s1;
            tau_s2 = SC_tau_s2;
            tau_s3 = SC_tau_s3;
            buckling_s = SC_buckling_s;
            
            sigma_ix = SC_sigma_ix;
            sigma_i1y = SC_sigma_i1y;
            sigma_i2y = SC_sigma_i2y;
            sigma_i3y = SC_sigma_i3y;
            sigma_ibend1 = SC_sigma_ibend1;
            sigma_ibend2 = SC_sigma_ibend2;
            sigma_irupture = SC_sigma_irupture;
            tau_i1 = SC_tau_i1;
            tau_i2 = SC_tau_i2;
            tau_i3 = SC_tau_i3;
            buckling_i = SC_buckling_i;
            
            sigma_a1y = SC_sigma_a1y;
            sigma_a2y = SC_sigma_a2y;
            sigma_abend = SC_sigma_abend;
            sigma_arupture1 = SC_sigma_arupture1;
            sigma_arupture2 = SC_sigma_arupture2;
            tau_a1 = SC_tau_a1;
            tau_a2 = SC_tau_a2;
            buckling_a = SC_buckling_a;
            
            sigma_p1y = SC_sigma_p1y;
            sigma_p2y = SC_sigma_p2y;
            sigma_pbend = SC_sigma_pbend;
            sigma_prupture1 = SC_sigma_prupture1;
            sigma_prupture2 = SC_sigma_prupture2;
            tau_p1 = SC_tau_p1;
            tau_p2 = SC_tau_p2;
            buckling_p = SC_buckling_p;
            
            tau_vt = SC_tau_vt;
            tau_vc = SC_tau_vc;
            
            sigma_spring1 = SC_sigma_spring1;
            sigma_spring2 = SC_sigma_spring2;
            fatigue_spring1 = SC_fatigue_spring1;
            fatigue_spring2 = SC_fatigue_spring2;
            
            tau_sa = SC_tau_sa;
            tau_sp = SC_tau_sp;
            tau_ia = SC_tau_ia;
            tau_ip = SC_tau_ip;
            
            sigma_bearingsa = SC_sigma_bearingsa;
            sigma_bearingsp = SC_sigma_bearingsp;
            sigma_bearingia = SC_sigma_bearingia;
            sigma_bearingip = SC_sigma_bearingip;
            
        end
         
    end
    
end