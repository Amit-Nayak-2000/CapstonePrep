classdef TorsionalSpring < handle
    %TORSIONALSPRING 
    %Helical Torsional Spring
    %Contains geometric, material and torque information about spring.
    
    properties
        theta0 %Resting angle 
        beta
        C %Spring Index
        d %Coil Diameter (m)
        D %Mean Diameter (m)
        E = 68.9e9; % Elastic modulus of Aluminium 1060-O (Pa)
        SU = 55e6; %Ultimate Tensile Strength of Aluminium 1060-O (Pa)
        SY = 17e6; %Yield Strength of Aluminium 1060-O (Pa)
        Nb %body turns
        Na %Active turns
        K %Spring Rate (Nm/deg kg)
        theta %Deflection of Spring (deg)
        l1 %length to standoff/moment arm (Superior/Inferior link) (m)
        l2 %length to standoff/moment arm (Anterior/Posterior link) (m)
        height %height of coils
        loop_diam = 0.005; %mean diameter of attachment loops
        L_arm_main %main arm length (superior/inferior)
        L_arm_sub %sub arm length (anterior/posterior)
        
        Torque = [0;0;0]; %(Nm)
    end
    
    methods
        %Method to intialize spring rate and lengths. 
        %called after GetInitKinematics
        function obj = initSpring(obj, mass, mainlink, sublink)
            obj.K = 5*0.0022*mass; %Multiply constant by mass to obtain spring rate per individual.
            obj.l1 = 0.4*mainlink.L; %Length of Spring Arms
            obj.l2 = 0.4*mainlink.L;
            obj.beta = 180 - obj.theta0; %Beta Angle
            obj.Nb = 4 + (obj.beta / 360); %Body Coils
            obj.D = 5.85E-03; %Mean Diameter
            obj.Na = obj.Nb + ((obj.l1 + obj.l2)/(3*pi*obj.D)); %Number of Active Coils
            obj.d = ((obj.K*64*obj.D*obj.Na)/obj.E)^(0.25); %Coil Diameter based on other params
            obj.C = obj.D/obj.d; %Spring Index
        end
        
        %Method to update spring during parametrization loop 
        function obj = updateSpring(obj)
            %Update NA after Nb was modulated
            obj.Na = obj.Nb + ((obj.l1 + obj.l2)/(3*pi*obj.D));
            %Update coil diameter, K and D are kept constant.
            obj.d = ((obj.K*64*obj.D*obj.Na)/obj.E)^(0.25);
            %Update Spring index
            obj.C = obj.D/obj.d;
        end
        
        %method to output dimensions to .txt files.
        function outputDimensions(obj, springnum)
            if(springnum == 1)
                %Superior-Anterior Spring
                fileID = fopen('../Solidworks/Equations/spring_sa.txt','w');
            else
                %Inferior-Posterior Spring
                fileID = fopen('../Solidworks/Equations/spring_ip.txt','w');
            end
            
            fprintf(fileID,'"D_coil"=%.6f\n',obj.D);
            fprintf(fileID,'"d_wire"=%.6f\n',obj.d);
            fprintf(fileID,'"Nb"=%.6f\n',obj.Nb);
            
            if(springnum == 1)
                fprintf(fileID,'"l_s_arm"=%.6f\n',obj.L_arm_main);
                fprintf(fileID,'"l_a_arm"=%.6f\n',obj.L_arm_sub);
            else
                fprintf(fileID,'"l_i_arm"=%.6f\n',obj.L_arm_main);
                fprintf(fileID,'"l_p_arm"=%.6f\n',obj.L_arm_sub);
            end
            
            fprintf(fileID,'"loop_diam"=%.6f\n',obj.loop_diam);
            fprintf(fileID,'"height"=%.6f\n',obj.height);
            
            fclose(fileID); 
        end
        
        
    end
end

