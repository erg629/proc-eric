function trial_data = getRWTargetDirection(trial_data,targets)

%%%%%%%%(currently super clunky) method of estimating reach%%%%%%%%%%%%%%%%
%%%%%%%%%%%direction in RW tasks. Called in PCA function%%%%%%%%%%%%%%%%%%%

%Up targets                  
x = (-10:10);                
y = 0.25.*x.^2;

ytop(1,1:21) = max(y);       %sets up the inpolygon funtion to determine
xx = [x,x];                  %if targets fall within the 'up' area
yy = [y,ytop];

for i = 1:length(targets)
    if inpolygon(targets(i,1),targets(i,2),xx,yy)
        trial_data(i).target_dir = 'up';
    end
end

%Down targets
y = -y;

ybot(1,1:21) = min(y);
yy = [ybot,y];

for i = 1:length(targets)
    if inpolygon(targets(i,1),targets(i,2),xx,yy)
        trial_data(i).target_dir = 'down';
    end
end

%Right targets
y = (-10:10);
x = 0.25.*y.^2;

xright(1,1:21) = max(x);
xx = [x,xright];
yy = [y,y];

for i = 1:length(targets)
    if inpolygon(targets(i,1),targets(i,2),xx,yy)
        trial_data(i).target_dir = 'right';
    end
end

%Left targets
x = -x;

xleft(1,1:21) = min(x);
xx = [xleft,x];

for i = 1:length(targets)
    if inpolygon(targets(i,1),targets(i,2),xx,yy)
        trial_data(i).target_dir = 'left';
    end
end


end