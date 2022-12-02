classdef Velcro < handle
    %VELCRO
    %Contains essential properties of velcro
    %Dimensions, Material Properties
    
    properties
        %Geometric Properties (m)
        L %Length of velcro
        W %Width of velcro
        Loop_D %Velcro loop diameter
        t %velcro thickness
        fold_back_L %Length of velcro folded back on itself
        
        %Physical Properties
        G = 96526.6 % Shear strength of velcro (Pa)
        
    end
    
    methods
        %Method to intialize inner diameter and outer diameter of velcro. 
        function obj = initVelcro(obj, length, width)
            obj.L = length; 
            obj.W = width;
        end
         
        function outputDimensions(obj, type)
            %type 1 is Thigh Velcro
            %type 2 is Calf Velcro
            
            if(type == 1)
                fileID = fopen('../Solidworks/Equations/velcro_thigh.txt','w');
                fprintf(fileID,'"L"=%.6f\n', obj.L);
                fprintf(fileID,'"w"=%.6f\n', obj.W);
                fprintf(fileID,'"Loop_D"=%.6f\n', obj.Loop_D);
                fprintf(fileID,'"t"=%.6f\n', obj.t);
                fprintf(fileID,'"fold_back_L"=%.6f\n', obj.fold_back_L);
                fclose(fileID); 
                
            
            else
                fileID = fopen('../Solidworks/Equations/velcro_calf.txt','w');
                fprintf(fileID,'"L"=%.6f\n', obj.L);
                fprintf(fileID,'"w"=%.6f\n', obj.W);
                fprintf(fileID,'"Loop_D"=%.6f\n', obj.Loop_D);
                fprintf(fileID,'"t"=%.6f\n', obj.t);
                fprintf(fileID,'"fold_back_L"=%.6f\n', obj.fold_back_L);
                fclose(fileID); 
                 
            end  
        end
    end
end