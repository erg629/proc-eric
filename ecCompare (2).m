%%My early attempt to find out something about efference copy in cuneate...we'll see how this goes

load('Lando_CODelay_20170903_1_CDS_sorted2')

params.event_list = {'startTime';'tgtOnTime';'tgtDir'};
td = parseFileByTrial(cds, params); %creates the initial trial_data struct from cds
td = getMoveOnsetAndPeak(td); %adds move onset time to struct
cuneateUnits= cds.units(strcmp({cds.units.array}, 'RightCuneate') & [cds.units.ID] >0 & [cds.units.ID]<255);
params.trials = {td.trial_id};
unitsToPlot = [1:length(cuneateUnits)];

 run('LandoAnalysis');   
% cuneatePds = ex.bin.pdData.velDir(21:44);
% %for i = 1:length(cuneatePds);
%  %   if cuneatePds(i) < 0
%   %  cuneatePds(i) = cuneatePds(i)+2*pi;
%    % end
% %end
% pdRange(:,1) = cuneatePds-.1666667;   %30deg range on either side of pd
% pdRange(:,2) = cuneatePds+.1666667;   %that target can fall within
%for i = 1:length(pdRange);
 %   if pdRange(i,1) < 0;                            %not sure if this is
  %      pdRange(i,1) = pdRange(i,1) + 2*pi;         %necessary yet.
   % end                                             %Also changes if you
    %if pdRange(i,2) < 0;                            %fix cuneatePDs first
     %   pdRange(i,2) = pdRange(i,2) + 2*pi;
   % end
%end

%%sorting trials
targets = td(~isnan([td.tgtDir])); %still a struct, just removes NaNs
rightTarg = targets([targets.tgtDir] == 0);
upTarg = targets([targets.tgtDir] == 90);
leftTarg = targets([targets.tgtDir] ==180);
downTarg = targets([targets.tgtDir] ==270);


%%establishing time ranges, want from start-target and target-mvmt


%%trying here to only analyze units with pds in the direction specified
%IncUnit = ();
% for i = 1:length(pd);
%     if ~isnan(pd(i));
%         if pd(i)>pdRange(i,1) & pd(i)<pdRange(i,2);
%            % IncUnit(j)  probably don't need to make a whole different var
    

%%Creating a struct with the cuneate units, pds, and list of trials with a
%%target direction in the range of its pd. Might do in a seperate script
%for i = 1:length(cuneatePds);
 %   TunedUnits(i).chan = cuneateUnits(i).chan;
  %  TunedUnits(i).ID = cuneateUnits(i).ID;
   % TunedUnits(i).pd = cuneatePds(i);
%end

%%borrowing raster plot creation from visData. Make separate ones for each direction

