classdef Housing < handle
    %HOUSING Class
    %Holds Dimensions of housing for 4-bar Hinge. 
    
    properties
        width %the following attributes are housing dimesion parameters
        height
        stop_width
        inf_stop_x
        superior_stop_x
        superior_stop_angle
        t1
        t2
        t3
        bolt_hole_size=0.003;
        b1_x
        b1_y
        bolt_dist
        theta_p_init
        bolt_hole_depth
        pitch=0.0005;
        cover_holes_diam
        cover_holes_depth=0.004;
        cover_hole_pitch=0.0004;
        gap=0.0045;
        pad_t
    end
    
    methods
        function outputDimensions(obj,type)
            %Method to output Housing Dimensions
            %type 1 is housing base
            %type 2 is housing cover
            if(type == 1)
                fileID = fopen('../Solidworks/Equations/housing_base_new.txt','w');
                
                fprintf(fileID,'"width"=%.6f\n', obj.width);
                fprintf(fileID,'"height"=%.6f\n', obj.height);
                fprintf(fileID,'"stop_width"=%.6f\n', obj.stop_width);
                fprintf(fileID,'"inf_stop_x"=%.6f\n', obj.inf_stop_x);
                fprintf(fileID,'"superior_stop_x"=%.6f\n', obj.superior_stop_x);
                fprintf(fileID,'"superior_stop_angle"=%.6f\n', obj.superior_stop_angle);
                fprintf(fileID,'"t1"=%.6f\n', obj.t1);
                fprintf(fileID,'"t2"=%.6f\n', obj.t2);
                fprintf(fileID,'"t3"=%.6f\n', obj.t3);
                fprintf(fileID,'"bolt_hole_size"=%.6f\n', obj.bolt_hole_size);
                fprintf(fileID,'"b1_x"=%.6f\n', obj.b1_x);
                fprintf(fileID,'"b1_y"=%.6f\n', obj.b1_y);
                fprintf(fileID,'"bolt_dist"=%.6f\n', obj.bolt_dist);
                fprintf(fileID,'"theta_p_init"=%.6f\n', obj.theta_p_init);
                fprintf(fileID,'"bolt_hole_depth"=%.6f\n', obj.bolt_hole_depth);
                fprintf(fileID,'"pitch"=%.6f\n', obj.pitch);
                fprintf(fileID,'"cover_holes_diam"=%.6f\n', obj.cover_holes_diam);
                fprintf(fileID,'"cover_holes_depth"=%.6f\n', obj.cover_holes_depth);
                fprintf(fileID,'"cover_hole_pitch"=%.6f\n', obj.cover_hole_pitch);
                fprintf(fileID,'"pad_t"=%.6f\n', obj.pad_t);
                fclose(fileID); 
                
            else
                fileID = fopen('../Solidworks/Equations/housing_cover_new.txt','w');
                
                fprintf(fileID,'"width"=%.6f\n', obj.width);
                fprintf(fileID,'"height"=%.6f\n', obj.height);
                fprintf(fileID,'"stop_width"=%.6f\n', obj.stop_width);
                fprintf(fileID,'"inf_stop_x"=%.6f\n', obj.inf_stop_x);
                fprintf(fileID,'"superior_stop_x"=%.6f\n', obj.superior_stop_x);
                fprintf(fileID,'"superior_stop_angle"=%.6f\n', obj.superior_stop_angle);
                fprintf(fileID,'"t1"=%.6f\n', obj.t1);
                fprintf(fileID,'"t2"=%.6f\n', obj.t2);
                fprintf(fileID,'"cover_holes_diam"=%.6f\n', obj.cover_holes_diam);
                fprintf(fileID,'"cover_holes_depth"=%.6f\n', obj.cover_holes_depth);
                fprintf(fileID,'"cover_hole_pitch"=%.6f\n', obj.cover_hole_pitch);
                fclose(fileID); 
            end
            
        end
    end
end

