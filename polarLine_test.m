rho1 = 40;        
rho2 = 40;                %rho is changing the lenghth of the line,
theta1 = pi/2;              %theta the direction...not sure how exactly
theta2 = pi;
                          %theta is distance around the cirle, rho the
                          %length
rho=[rho1 rho2];          
theta=[theta1 theta2];
polarplot(theta,rho);