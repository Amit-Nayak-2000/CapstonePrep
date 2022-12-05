classdef Bolt < handle
    %BOLT
    %Contains essential properties of bolt.
    %Dimensions, Material Properties
    
    properties
        %Geometric Properties (m)
        L %Length of bolt
        D %Diameter of bolt     
        L_thread %Threaded portion of the bolt 
        Ls %For rivet only - used for different superior config
        
        %Material Properties
        E = 193e9; % Elastic modulus of 304 stainless steel (Pa)
        SU = 505e6; %Ultimate Tensile Strength of 304 stainless steel (Pa)
        SY = 215e6; %Yield Strength of 304 stainless steel (Pa) 
    end
    
    methods
        %Method to intialize the diameter of bolt. 
        function obj = initBolt(obj, diameter)
            obj.D = diameter;
        end
        
        function outputDimensions(obj, type)
            %type 1 is link spring bolt
            %type 2 is superior-anterior bolt
            %type 3 is superior-posterior bolt
            %type 4 is inferior-anterior bolt
            %type 5 is inferior-posterior bolt
            %type 6 is housing cover bolts
            %type 7 is velcro rivet bolts
            
            if(type == 1)
                fileID = fopen('../Solidworks/Equations/link_spring_bolt.txt','w');
                fprintf(fileID,'"diam_head"=%.6f\n', 0.0056);
                fprintf(fileID,'"L_head"=%.6f\n', 0.00165);
                fprintf(fileID,'"L"=%.6f\n',obj.L);
                fprintf(fileID,'"diam_thread"=%.6f\n',obj.D);
                fprintf(fileID,'"pitch"=%.6f\n', 0.0005);
                fclose(fileID); 
                
                
            elseif(type == 2)
                fileID = fopen('../Solidworks/Equations/SA_bolt.txt','w');
                fprintf(fileID,'"diam_head"=%.6f\n', 0.0055);
                fprintf(fileID,'"L_head"=%.6f\n', 0.002);
                fprintf(fileID,'"L"=%.6f\n',obj.L);
                fprintf(fileID,'"L_thread"=%.6f\n',obj.L_thread);
                fprintf(fileID,'"diam_thread"=%.6f\n',obj.D);
                fprintf(fileID,'"pitch"=%.6f\n', 0.0005);
                fclose(fileID); 
                
            
            elseif(type == 3)
                fileID = fopen('../Solidworks/Equations/SP_bolt.txt','w');
                fprintf(fileID,'"diam_head"=%.6f\n', 0.0055);
                fprintf(fileID,'"L_head"=%.6f\n', 0.002);
                fprintf(fileID,'"L"=%.6f\n',obj.L);
                fprintf(fileID,'"L_thread"=%.6f\n',obj.L_thread);
                fprintf(fileID,'"diam_thread"=%.6f\n',obj.D);
                fprintf(fileID,'"pitch"=%.6f\n', 0.0005);
                fclose(fileID); 
                
            elseif(type == 4)
                fileID = fopen('../Solidworks/Equations/IA_bolt.txt','w');
                fprintf(fileID,'"diam_head"=%.6f\n', 0.0055);
                fprintf(fileID,'"L_head"=%.6f\n', 0.002);
                fprintf(fileID,'"L"=%.6f\n',obj.L);
                fprintf(fileID,'"L_thread"=%.6f\n',obj.L_thread);
                fprintf(fileID,'"diam_thread"=%.6f\n',obj.D);
                fprintf(fileID,'"pitch"=%.6f\n', 0.0005);
                fclose(fileID); 
                
            elseif(type==5)
                fileID = fopen('../Solidworks/Equations/IP_bolt.txt','w');
                fprintf(fileID,'"diam_head"=%.6f\n', 0.0055);
                fprintf(fileID,'"L_head"=%.6f\n', 0.002);
                fprintf(fileID,'"L"=%.6f\n',obj.L);
                fprintf(fileID,'"L_thread"=%.6f\n',obj.L_thread);
                fprintf(fileID,'"diam_thread"=%.6f\n',obj.D);
                fprintf(fileID,'"pitch"=%.6f\n', 0.0005);
                fclose(fileID); 
                
            elseif(type==6)
                fileID = fopen('../Solidworks/Equations/cover_bolt.txt','w');
                fprintf(fileID,'"diam_head"=%.6f\n', 0.0038);
                fprintf(fileID,'"L_head"=%.6f\n', 0.002);
                fprintf(fileID,'"L"=%.6f\n',obj.L);
                fprintf(fileID,'"diam_thread"=%.6f\n',obj.D);
                fprintf(fileID,'"pitch"=%.6f\n', 0.0005);
                fclose(fileID);
            else
                fileID = fopen('../Solidworks/Equations/rivet.txt','w');
                fprintf(fileID,'"d"=%.6f\n',obj.D);
                fprintf(fileID,'"L"=%.6f\n', obj.L);
                fprintf(fileID,'"Ls"=%.6f\n', obj.Ls);
                fclose(fileID);
            end
            
            
            
        end
         
    end
end