classdef VelcroBuckle < handle
    %VELCROBUCKLE object
    
    properties
        slot_w %Velcro Slot Width
        slot_h %Velcro Slot Height
        t %thickness
        height %height of buckle
        hole_D=0.0034; %diameter of rivet holes
        attach_w=0.018; %width of attachment portion
    end
    
    methods
        
        %Method to output dimensions of objects.
        function outputDimensions(obj)
            fileID = fopen('../Solidworks/Equations/velcro_buckle.txt','w');
                fprintf(fileID,'"slot_w"=%.6f\n', obj.slot_w);
                fprintf(fileID,'"slot_h"=%.6f\n', obj.slot_h);
                fprintf(fileID,'"t"=%.6f\n', obj.t);
                fprintf(fileID,'"height"=%.6f\n', obj.height);
                fprintf(fileID,'"hole_D"=%.6f\n', obj.hole_D);
                fprintf(fileID,'"attach_w"=%.6f\n', obj.attach_w);
                fclose(fileID);
        end
    end
end

