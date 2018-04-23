function fh1 = unitRaster3D(trialData, params)

%Borrowed a lot from Chris' unitRaster function. Params will be defined in
%the call function. Right now the xBound doesn't extend to trial end time

xBound = [-.3, .3];
yMax = 40;
array ='area2';
align= 'otLeave';
neuron =1;
if nargin > 1, assignParams(who,params); end % overwrite parameters

reach = sort3Dreaches(trialData);   %sorts by target direction

electrode = trialData(1).area2_unit_guide(neuron,1);
unit = trialData(1).area2_unit_guide(neuron,2);

figure
hold on

for targ = 1:length(reach)     %this will make separate rasters for each direction rather than all in one
    
    reachDir = reach(targ);
    count=0;
    numTrials = length(reachDir{1});
   
    
    switch reachDir{1}(1).target_direction
        case 0
            subplot(4,5,15)
        case pi/4
            subplot(4,5,9)
        case pi/2
            subplot(4,5,3)
            title([trialData(1).monkey,'_ ',params.array,'_ ',(sprintf('Electrode%i',electrode)),'_ ',(sprintf('Unit%i',unit)),'(',params.epoch,',',params.movem,')'])
        case 3*pi/4
            subplot(4,5,7)
        case pi
            subplot(4,5,11)
        case -3*pi/4
            subplot(4,5,17)
        case -pi/4
            subplot(4,5,19)
    end
    
    hold on
    
    for trialNum = 1:length(reachDir{1})
        
        count =count +1;
        trial = reachDir{1}(trialNum);
        alignStart = trial.bin_size * (trial.(['idx_',align])-trial.idx_startTime);
        spikes = trial.([array,'_ts']){neuron} - alignStart;
        spikes = spikes(spikes>xBound(1) & spikes<xBound(2));
        for spike = 1:length(spikes)
            plot([spikes(spike), spikes(spike)], [count*yMax/numTrials, (count+.8)*yMax/numTrials], 'k');
        end
    end
    xlim(xBound);
    ylim([0, yMax]);
    plot([0,0],[0,yMax],'g')
end
hold on
end
