function[] = firingPlots(upSpikeCount,leftSpikeCount,downSpikeCount,rightSpikeCount)

    %% Finalize FR Table
    
for u = 1:length(upSpikeCount)
    
    upSpikeCount(u).BeforeTotal = sum(upSpikeCount(u).UpBefore);
    upSpikeCount(u).DuringTotal = sum(upSpikeCount(u).UpDuring);
    upSpikeCount(u).AfterTotal = sum(upSpikeCount(u).UpAfter);
    
    leftSpikeCount(u).BeforeTotal = sum(leftSpikeCount(u).LeftBefore);
    leftSpikeCount(u).DuringTotal = sum(leftSpikeCount(u).LeftDuring);
    leftSpikeCount(u).AfterTotal = sum(leftSpikeCount(u).LeftAfter);
    
    downSpikeCount(u).BeforeTotal = sum(downSpikeCount(u).DownBefore);
    downSpikeCount(u).DuringTotal = sum(downSpikeCount(u).DownDuring);
    downSpikeCount(u).AfterTotal = sum(downSpikeCount(u).DownAfter);
    
    rightSpikeCount(u).BeforeTotal = sum(rightSpikeCount(u).RightBefore);
    rightSpikeCount(u).DuringTotal = sum(rightSpikeCount(u).RightDuring);
    rightSpikeCount(u).AfterTotal = sum(rightSpikeCount(u).RightAfter);
end

%% Plot PDs

for u = 1:length(upSpikeCount)
    
    figure    
    
    title1 = ['Lando', 'RightCuneate', ' Electrode' num2str(upSpikeCount(u).Electrode), ' Unit ', num2str(upSpikeCount(u).Unit)];
    suptitle(title1)
  
    thetaUp = pi/2;           %setting these to draw connecting lines
    thetaLeft = pi;           %on the plots
    thetaDown = 3*pi/2;
    thetaRight = 0;
    
    %PD Before Target Onset
    subplot(1,2,2)
    polarplot([pi/2,pi/2],[upSpikeCount(u).BeforeTotal,upSpikeCount(u).BeforeTotal],'MarkerSize',10)
    hold on
    polarplot([pi,pi],[leftSpikeCount(u).BeforeTotal,leftSpikeCount(u).BeforeTotal],'MarkerSize',10)
    polarplot([3*pi/2,3*pi/2],[downSpikeCount(u).BeforeTotal,downSpikeCount(u).BeforeTotal],'MarkerSize',10)
    polarplot([0,0],[rightSpikeCount(u).BeforeTotal,rightSpikeCount(u).BeforeTotal],'MarkerSize',10)
    %title('Before Target')
    
    rhoUp = upSpikeCount(u).BeforeTotal;
    rhoLeft = leftSpikeCount(u).BeforeTotal;
    rhoDown = downSpikeCount(u).BeforeTotal;
    rhoRight = rightSpikeCount(u).BeforeTotal;
    
    theta = [thetaUp thetaLeft];
    rho = [rhoUp rhoLeft];
    polarplot(theta,rho,'b');
    
    theta = [thetaLeft thetaDown];
    rho = [rhoLeft rhoDown];
    polarplot(theta,rho,'b');
    
    theta = [thetaDown thetaRight];
    rho = [rhoDown rhoRight];
    polarplot(theta,rho,'b');
    
    theta = [thetaRight thetaUp];
    rho = [rhoRight rhoUp];
    polarplot(theta,rho,'b');
    
    set(gca,'ThetaTickLabel',[],'RTickLabel',[]);
    
 
    %PD During Delay Period
    subplot(1,2,2)
    polarplot([pi/2,pi/2],[upSpikeCount(u).DuringTotal,upSpikeCount(u).DuringTotal])
    hold on
    polarplot([pi,pi],[leftSpikeCount(u).DuringTotal,leftSpikeCount(u).DuringTotal])
    polarplot([3*pi/2,3*pi/2],[downSpikeCount(u).DuringTotal,downSpikeCount(u).DuringTotal])
    polarplot([0,0],[rightSpikeCount(u).DuringTotal,rightSpikeCount(u).DuringTotal])
    %title('During Delay')
    
    rhoUp = upSpikeCount(u).DuringTotal;
    rhoLeft = leftSpikeCount(u).DuringTotal;
    rhoDown = downSpikeCount(u).DuringTotal;
    rhoRight = rightSpikeCount(u).DuringTotal;
    
    theta = [thetaUp thetaLeft];
    rho = [rhoUp rhoLeft];
    polarplot(theta,rho,'y');
    
    theta = [thetaLeft thetaDown];
    rho = [rhoLeft rhoDown];
    polarplot(theta,rho,'y');
    
    theta = [thetaDown thetaRight];
    rho = [rhoDown rhoRight];
    polarplot(theta,rho,'y');
    
    theta = [thetaRight thetaUp];
    rho = [rhoRight rhoUp];
    polarplot(theta,rho,'y');
    
    %set(gca,'ThetaTickLabel',[],'RTickLabel',[]);
    
    %PD After Go Cue
    subplot(1,2,2)
    polarplot([pi/2,pi/2],[upSpikeCount(u).AfterTotal,upSpikeCount(u).AfterTotal])
    hold on
    polarplot([pi,pi],[leftSpikeCount(u).AfterTotal,leftSpikeCount(u).AfterTotal])
    polarplot([3*pi/2,3*pi/2],[downSpikeCount(u).AfterTotal,downSpikeCount(u).AfterTotal])
    polarplot([0,0],[rightSpikeCount(u).AfterTotal,rightSpikeCount(u).AfterTotal])
    %title('After Go Cue')
    
    rhoUp = upSpikeCount(u).AfterTotal;
    rhoLeft = leftSpikeCount(u).AfterTotal;
    rhoDown = downSpikeCount(u).AfterTotal;
    rhoRight = rightSpikeCount(u).AfterTotal;
    
    theta = [thetaUp thetaLeft];
    rho = [rhoUp rhoLeft];
    polarplot(theta,rho,'r');
    
    theta = [thetaLeft thetaDown];
    rho = [rhoLeft rhoDown];
    polarplot(theta,rho,'r');
    
    theta = [thetaDown thetaRight];
    rho = [rhoDown rhoRight];
    polarplot(theta,rho,'r');
    
    theta = [thetaRight thetaUp];
    rho = [rhoRight rhoUp];
    polarplot(theta,rho,'r');
    
    %title('PDs');
    
%     Blegend = string('Before');
%     Blegend.Color = 'b';
    %legend;
    %set(gca,'ThetaTickLabel',[],'RTickLabel',[]);
    
    %Histogram Combining All Trials
%     bda = [upSpikeCount(u).BeforeTotal+leftSpikeCount(u).BeforeTotal+downSpikeCount(u).BeforeTotal+rightSpikeCount(u).BeforeTotal upSpikeCount(u).DuringTotal+leftSpikeCount(u).DuringTotal+downSpikeCount(u).DuringTotal+rightSpikeCount(u).DuringTotal upSpikeCount(u).AfterTotal+leftSpikeCount(u).AfterTotal+downSpikeCount(u).AfterTotal+rightSpikeCount(u).AfterTotal];
%     subplot(1,2,1)
%     bar(bda)
%     timepd = {'Before';'During';'After'};
%     set(gca,'xticklabel',timepd);
%     title('All Trials')
    beforeAvg = mean(mean(upSpikeCount(u).UpBefore(1,:))+mean(leftSpikeCount(u).LeftBefore(1,:))+mean(downSpikeCount(u).DownBefore(1,:))+mean(rightSpikeCount(u).RightBefore(1,:)));
    duringAvg = mean(mean(upSpikeCount(u).UpDuring(1,:))+mean(leftSpikeCount(u).LeftDuring(1,:))+mean(downSpikeCount(u).DownDuring(1,:))+mean(rightSpikeCount(u).RightDuring(1,:)));
    afterAvg = mean(mean(upSpikeCount(u).UpAfter(1,:))+mean(leftSpikeCount(u).LeftAfter(1,:))+mean(downSpikeCount(u).DownAfter(1,:))+mean(rightSpikeCount(u).RightAfter(1,:)));
    
    beforeVar = sqrt((var(upSpikeCount(u).UpBefore(1,:)).^2)+(var(leftSpikeCount(u).LeftBefore(1,:)).^2)+(var(downSpikeCount(u).DownBefore(1,:)).^2)+(var(rightSpikeCount(u).RightBefore(1,:)).^2));
    duringVar = sqrt((var(upSpikeCount(u).UpDuring(1,:)).^2)+(var(leftSpikeCount(u).LeftDuring(1,:)).^2)+(var(downSpikeCount(u).DownDuring(1,:)).^2)+(var(rightSpikeCount(u).RightDuring(1,:)).^2));
    afterVar = sqrt((var(upSpikeCount(u).UpAfter(1,:)).^2)+(var(leftSpikeCount(u).LeftAfter(1,:)).^2)+(var(downSpikeCount(u).DownAfter(1,:)).^2)+(var(rightSpikeCount(u).RightAfter(1,:)).^2));
    
    bda = [beforeAvg duringAvg afterAvg];
    bdaVar = [beforeVar duringVar afterVar];
    subplot(1,2,1);
    bar(bda)
    hold on
    errorbar(bda,bdaVar,'.');
    timepd = {'Before';'During';'After'};
    set(gca,'xticklabel',timepd);
    %title('Avg Spikes per Trial');
end
end