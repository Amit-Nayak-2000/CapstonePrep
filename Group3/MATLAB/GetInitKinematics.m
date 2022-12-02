function [offset] = GetInitKinematics(Superior,Inferior,Anterior,Posterior, T1, T2)
%GETINITKINEMATICS 
%Getting vertical distance between Superior and Inferior Links at 0 deg
%flexion.
%Also getting spring angles for when user is standing straight (0
%deflection point for springs).

%Setting Superior and Posterior angles to 0 (standing straight)
syms theta_a theta_p
%Loop Closure Equation
r1 = [Superior.L*cosd(0); Superior.L*sind(0)];
r2 = [Anterior.L*cosd(theta_a); Anterior.L*sind(theta_a)];
r3 = [Inferior.L*cosd(0); Inferior.L*sind(0)];
r4 = [Posterior.L*cosd(theta_p); Posterior.L*sind(theta_p)];

positioneqn = r1 + r2 + r3 + r4 == 0;
thetas = solve(positioneqn, [theta_a theta_p]);

pt1 = double(thetas.theta_a(1,1));
pt2 = double(thetas.theta_a(2,1));
pt3 = double(thetas.theta_p(1,1));
pt4 = double(thetas.theta_p(2,1));

%Initial Angles for Anterior and Posterior Links
Anterior.theta0 = pt1;
Posterior.theta0 = pt4;

T1.theta0 = 180 - pt1 ; %assign initial angles to springs
T2.theta0 = 180 - pt4;

offsettheta = pt4;

%vertical offset
offset = abs(Posterior.L*sind(offsettheta));
end

