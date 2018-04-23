function force_angle = getIsoRWAngles(targets)

force_angle(1) = atan2d(targets(1,1),targets(1,2));  %angle between start (0,0) and target 1

for i = 1:length(targets)-1
   
   t1x = targets(i,1);
   t2x = targets(i+1,1);          %angle between previous target and current one
   t1y = targets(i,2);
   t2y = targets(i+1,2);
   
   force_angle(i+1) = atan2d((t2y - t1y),(t2x - t1x));
end