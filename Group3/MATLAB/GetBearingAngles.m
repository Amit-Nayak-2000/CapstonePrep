function [Theta1,Theta2, Theta3, Theta4] = GetBearingAngles(Superior, Anterior, Inferior, Posterior)
%Inputs: Link Objects
%Outputs: Angles of bearing (used for range of motion calculation of
%bearings).
%Outputs: Theta1 is SA, Theta2 is IP, Theta3 is IA, Theta4 is SP
%Uses Linear Algebra Identity to compute angle between vectors.

%this vector is negative so both vectors have the same tail.
vector1 = [-Superior.L*cosd(Superior.theta); -Superior.L*sind(Superior.theta); 0];
vector2 = [Anterior.L*cosd(Anterior.theta); Anterior.L*sind(Anterior.theta); 0];

Theta1 = atan2d(norm(cross(vector1,vector2)), dot(vector1,vector2));


%this vector is negative so both vectors have the same tail.
vector3 = [-Inferior.L*cosd(Inferior.theta); -Inferior.L*sind(Inferior.theta); 0];
vector4 = [Posterior.L*cosd(Posterior.theta); Posterior.L*sind(Posterior.theta); 0];

Theta2 = atan2d(norm(cross(vector3,vector4)), dot(vector3,vector4));


%this vector is negative so both vectors have the same tail.
vector5 = [-Anterior.L*cosd(Anterior.theta); -Anterior.L*sind(Anterior.theta); 0];
vector6 = [Inferior.L*cosd(Inferior.theta); Inferior.L*sind(Inferior.theta); 0];

Theta3 = atan2d(norm(cross(vector5,vector6)), dot(vector5,vector6));


vector7 = [Superior.L*cosd(Superior.theta); Superior.L*sind(Superior.theta); 0];
%this vector is negative so both vectors have the same tail.
vector8 = [-Posterior.L*cosd(Posterior.theta); -Posterior.L*sind(Posterior.theta); 0];

Theta4 = atan2d(norm(cross(vector7,vector8)), dot(vector7,vector8));


end
