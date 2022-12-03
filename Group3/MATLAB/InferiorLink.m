classdef InferiorLink < handle
    %INFERIORLINK 
    %Contains essential properties of link.
    %Dimensions, Material Properties, Position, Velocities, Acclerations
    %and Forces. 
    
    properties
        %Geometric Dimensions of Link (m)
        B1 % For B1 to H4, refer to definition of dimension figure in report
        B2
        B3 %Contact point distance
        L
        H1
        H2
        H3
        H4
        T %Thickness
        bolt_hole_diam %Hole Diameter of Bolts
        springarmholepos %Position of Spring Arm Hole
        springarmholemaxd =0.006; %head diameter of bolt
        springarmholemind=0.0034; %threaded portion diameter of bolt
        armholeheadheight=0.00165; %height of bolt head
        H_holes % hole position from end of link
        D_strap %Diameter of the metal contact strap
        clip_hole_D=0.0034; %velcro rivet hole diameter
        clip_hole_y1 %y distance to rivet hole
        clip_hole_dist %distance between 2 rivet holes
        pad_t1 %padding thickness
        pad_t2 %NOT USED FOR NOW
        unpad_L1 %portion of link covered by housing (not padded)
        
        %Physical Properties
        m % Mass (kg)
        rho = 2710; %Density of Aluminium 1100-H16 (kg/m^3)
        I % Moment of inertia (kg m^2)
        E = 68.9e9; % Elastic modulus of Aluminium 1100-H16 (Pa)
        SU = 130e6; %Ultimate Tensile Strength of Aluminium 1100-H16 (Pa)
        SY = 115e6; %Yield Strength of Aluminium 1100-H16 (Pa)
        SSY = 0.55*115e6; %Shear Yield Strength of Aluminium 1100-H16 (Pa)
        G = 26e9; %Shear modulus of Aluminium 1100-H16 (Pa)
        
        
        %Dynamical Properties
        %position vectors units are (m)
        %vector for centre of mass with respect to calf (initially 0)
        com = [0;0;0];
        %vector for centre of mass absolute (initially 0)
        com_abs = [0;0;0];
        %vector from centre of mass to anterior joint (IA)
        ria = [0;0;0];
        %vector from centre of mass to posterior joint (IP)
        rip = [0;0;0];
        %vector from centre of mass to calf contact point for sum of moments
        ric = [0;0;0];
        theta %Angle with respect to horizontal-x (deg)
        %omega and alpha initially set to 0, but will have values in k.
        omega  = [0;0;0]; %Angular Velocity (rad/s)
        alpha  = [0;0;0]; %Angular acceleration (rad/s^2)
        %v and a are initially set to 0, but will have values in i and j.
        v = [0;0;0]; %Linear Velocity (m/s)
        a = [0;0;0]; %Linear Acceleration (m/s^2)
        
        offset; %offset from femoral condyles
        
        %Force Vectors
        F_c = [0;0;0]; %(N)
        F_ip = [0;0;0]; %(N)
        F_ia = [0;0;0]; %(N)
        
        %file names
        file

        %Forces for Interface with Calf
        F_cn %normal calf force
        F_ct %tangential calf force
        
    end
    
    methods
        
        %Method to calculate COM and position vectors.
        function obj = calculateCOM(obj, calflength, vertcomponent)
            obj.offset = vertcomponent;
            %vertcomponent is offset from femoral condyle
            
            %COM Calculation:
            A(1) = obj.B1*obj.H1;
            A(2) = 0.5 * (obj.B1 + obj.B2) * (obj.H2 - obj.H1);
            A(3) = obj.B2 * (obj.H3 - obj.H2);
            A(4) = obj.B3 * (obj.H4 - obj.H3);
            
            x(1) = obj.B2 / 2;
            x(2) = obj.B2 / 2;
            x(3) = obj.B2 / 2;
            x(4) = obj.B3 / 2;
            
            y(1) = obj.H4 - (obj.H1 / 2);
            y(2) = (obj.H4 - obj.H2) - (obj.H2 - obj.H1) * (1/3) * ( (2*obj.B2 + obj.B1) / (obj.B2 + obj.B1));
            y(3) = (obj.H4 - obj.H3) + ((obj.H3 - obj.H2) / 2);
            y(4) = (obj.H4 - obj.H3) / 2;
            
            Xnum = 0;
            Xdenom = 0;
            Ynum = 0;
            Ydenom = 0;
            
            for i=1:4
                Xnum = Xnum + x(i)*A(i);
                
                Ynum = Ynum + y(i)*A(i);
                
                Xdenom = Xdenom + A(i);
                
                Ydenom = Ydenom + A(i);
            end
            
            Xcom = Xnum / Xdenom; %sum of X(i)A(i) / sum of A(i)
            Ycom = Ynum / Ydenom; %sum of Y(i)A(i) / sum of A(i)
            
            comx = -(Xcom - obj.B2/2)*cosd(obj.theta) - (0.433*calflength -(obj.H4-Ycom) - vertcomponent)*sind(obj.theta);
            comy = -(Xcom - obj.B2/2)*sind(obj.theta) + (0.433*calflength -(obj.H4-Ycom) - vertcomponent)*cosd(obj.theta);
            
            obj.com = [comx; comy; 0];
            
            %rip and ria calculations
            ry = abs(abs(obj.H4) - abs(Ycom) - abs(obj.H1 / 2)); % y component
            rxa = abs(abs(obj.B2 / 2) + abs(obj.L / 2) - abs(Xcom)); % x component to joint IA.
            rxp = abs(abs(obj.B2 / 2) - abs(obj.L / 2) - abs(Xcom)); % x component to joint IP, need abs val since signs are handled below.
            
            obj.ria = [-ry*sind(obj.theta) - rxa*cosd(obj.theta); ry*cosd(obj.theta) - rxa*sind(obj.theta); 0];
            obj.rip = [-ry*sind(obj.theta) + rxp*cosd(obj.theta); ry*cosd(obj.theta) + rxp*sind(obj.theta); 0];
            
            %ric calculation
            obj.ric = [abs(Ycom)*sind(obj.theta) - abs(obj.B3 - Xcom)*cosd(obj.theta); -abs(Ycom)*cosd(obj.theta) - abs(obj.B3 - Xcom)*sind(obj.theta); 0];
        end
        
        %Method to calculate mass and moment of inertia. 
        function obj = calculate_inertial_props(obj)
            A(1) = obj.B1*obj.H1;
            A(2) = 0.5 * (obj.B1 + obj.B2) * (obj.H2 - obj.H1);
            A(3) = obj.B2 * (obj.H3 - obj.H2);
            A(4) = obj.B3 * (obj.H4 - obj.H3);
            
            volume = obj.T*(A(1) + A(2) + A(3) + A(4));
            
            %mass = density * volume.
            obj.m = obj.rho*volume;
            
            %need these for distance between axes in parallel axis theorem.
            x(1) = obj.B2 / 2;
            x(2) = obj.B2 / 2;
            x(3) = obj.B2 / 2;
            x(4) = obj.B3 / 2;
            y(1) = obj.H4 - (obj.H1 / 2);
            y(2) = (obj.H4 - obj.H1) - (obj.H2 - obj.H1) * (1/3) * ( (2*obj.B2 + obj.B1) / (obj.B2 + obj.B1));
            y(3) = (obj.H4 - obj.H3) + ((obj.H3 - obj.H2) / 2);
            y(4) = (obj.H4 - obj.H3) / 2;
            
            %calculate individual axis 
            Xnum = 0;
            Xdenom = 0;
            Ynum = 0;
            Ydenom = 0;
            
            for i=1:4
                Xnum = Xnum + x(i)*A(i);
                
                Ynum = Ynum + y(i)*A(i);
                
                Xdenom = Xdenom + A(i);
                
                Ydenom = Ydenom + A(i);
            end
            
            Xcom = Xnum / Xdenom; %sum of X(i)A(i) / sum of A(i)
            Ycom = Ynum / Ydenom; %sum of Y(i)A(i) / sum of A(i)
            
            %masses of individual subdivisions
            M(1) = obj.rho*obj.T*A(1);
            M(2) = obj.rho*obj.T*A(2);
            M(3) = obj.rho*obj.T*A(3);
            M(4) = obj.rho*obj.T*A(4);
            
            %mass moment of inertias of individual objects
            I(1) = (1/12)*M(1)*(obj.B1^2 + obj.H1^2);
            
            I(3) = (1/12)*M(3)*(obj.B2^2 + (obj.H3 - obj.H2)^2);
            
            I(4) = (1/12)*M(4)*(obj.B3^2 + (obj.H4 - obj.H3)^2);
            
            %radius of gyration calculation for trapezoid
            a = obj.B2;
            b = obj.B1;
            h = obj.H2 - obj.H1;
            rtrap = (1/12)*sqrt(2*(16*h^2*a*b + 4*h^2*b^2 + 4*h^2*a^2 + 3*a^4 + 6*a^2*b^2 + 6*a^3*b + 6*a*b^3 + 3*b^4) / (a + b)^2);
            
            I(2) = M(2) * rtrap^2;
            
            %using parallel axis theorem: I = Icom_i + m_i*d_i^2
            Ifinal = 0.0;
            for i=1:4
                Ifinal = Ifinal + I(i) + M(i)*((Xcom - x(i))^2 + (Ycom - y(i))^2);
            end
            
            obj.I = Ifinal; %mass moment of inertia.
            
        end
        
        %Method to output dimesions to .txt files.
        function outputDimensions(obj)
            fileID = fopen('../Solidworks/Equations/inferior_link.txt','w');
            fprintf(fileID,'"B1"=%.6f\n',obj.B1);
            fprintf(fileID,'"B2"=%.6f\n',obj.B2);
            fprintf(fileID,'"B3"=%.6f\n',obj.B3);
            fprintf(fileID,'"L"=%.6f\n',obj.L);
            fprintf(fileID,'"H1"=%.6f\n',obj.H1);
            fprintf(fileID,'"H2"=%.6f\n',obj.H2);
            fprintf(fileID,'"H3"=%.6f\n',obj.H3);
            fprintf(fileID,'"H4"=%.6f\n',obj.H4);
            fprintf(fileID,'"T"=%.6f\n',obj.T);
            fprintf(fileID,'"bolt_hole_diameter"=%.6f\n', obj.bolt_hole_diam);
            fprintf(fileID,'"spring_arm_hole_pos"=%.6f\n', obj.springarmholepos);
            fprintf(fileID,'"spring_arm_hole_max_diam"=%.6f\n', obj.springarmholemaxd);
            fprintf(fileID,'"spring_arm_hole_min_diam"=%.6f\n', obj.springarmholemind);
            fprintf(fileID,'"arm_hole_head_height"=%.6f\n', obj.armholeheadheight);
            fprintf(fileID,'"H_holes"=%.6f\n', obj.H_holes);
            fprintf(fileID,'"D_strap"=%.6f\n', obj.D_strap);
            fprintf(fileID,'"clip_hole_D"=%.6f\n', obj.clip_hole_D);
            fprintf(fileID,'"clip_hole_y1"=%.6f\n', obj.clip_hole_y1);
            fprintf(fileID,'"clip_hole_dist"=%.6f\n', obj.clip_hole_dist);
            fprintf(fileID,'"pad_t1"=%.6f\n', obj.pad_t1);
            fprintf(fileID,'"pad_t2"=%.6f\n', obj.pad_t2);
            fprintf(fileID,'"unpad_L1"=%.6f\n', obj.unpad_L1);
            fclose(fileID); 
        end
    end
end

