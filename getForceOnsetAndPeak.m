%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function trial_data = getForceOnsetAndPeak(trial_data,min_ds)
%
%   This will find a time bin representing force onset and peak speed
%   Fleshing out the ideas laid out by Matt in getMoveOnsetAndPeak
%
% INPUTS:
%   trial_data : (struct) trial_data struct
%   params     : parameter struct
%     .which_method : (string) how to compute
%                           'peak' : uses acceleration and peak speed         not sure yet what methods I will have to use
%                           'thresh' : uses a basic velocity threshold
%                       Note: defaults to peak. In thresh, will not return
%                       a peak speed as a field.
%     .min_ds       : minimum diff(speed) to find movement onset
%     .s_thresh     : % speed threshold in cm/s (secondary method if first fails)
%
% OUTPUTS:
%   trial_data : same struct, with fields for:            right now finding no peak speed
%       idx_peak_force                                    and a whole lotta NaNs for movement on
%       idx_force_onset
%
% Written by Matt Perich. Updated Feb 2018.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function trial_data = getForceOnsetAndPeak(trial_data,params)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULT PARAMETERS
which_method  =  'peak';         %quite possible that none of these params
min_ds        =  0.3;            %will be useful in force calculation
s_thresh      =  7;
% these parameters aren't documented because I expect them to not need to
% change but you can overwrite them if you need to.
start_idx     =  'idx_goCueTime';
end_idx       =  'idx_endTime';
onset_name    =  'force_on';
peak_name     =  'peak_force';
if nargin > 1, assignParams(who,params); end % overwrite defaults
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% some pre-processing                                           
td = getSpeed(trial_data);                                          %likely unnecessary

for trial = 1:length(trial_data)
    % use velocity to find bin corresponding to movement onset, movement offset, and peak speed
    s = td(trial).speed;                                            %double with all speeds of each trial
    
    % find the time bins where the monkey may be moving
    move_inds = false(size(s));                                     %creates array of 0s same size as s
    move_inds(td(trial).(start_idx):td(trial).(end_idx)) = true;    %and makes everything at and after goCue 1
    
    [on_idx,peak_idx] = deal(NaN);                                  %creates these two vars, assigns NaN
    if strcmpi(which_method,'peak')
        ds = [0; diff(s)];                                          %starting with 0, difference between adjacent speeds
        dds = [0; diff(ds)];                                        %does it again...why?
        peaks = [dds(1:end-1)>0 & dds(2:end)<0; 0];                 %elements 1:50>0 and 2:51<0....?
        mvt_peak = find(peaks & (1:length(peaks))' > td(trial).(start_idx) & ds > min_ds & move_inds, 1, 'first');
                       %0s & 1s  %row #s of peaks entries
        if ~isempty(mvt_peak)
            thresh = ds(mvt_peak)/2; % Threshold is half max of acceleration peak
            on_idx = find(ds<thresh & (1:length(ds))'<mvt_peak & move_inds,1,'last');
            
            % check to make sure the numbers make sense
            if on_idx <= td(trial).(start_idx)
                % something is fishy. Fall back on threshold method
                on_idx = NaN;
            end
        end
        % peak is max velocity during movement
        temp = s; temp(~move_inds) = 0;
        [~,peak_idx] = max(temp);
    end
    
    if isempty(on_idx) || isnan(on_idx)
        on_idx = find(s > s_thresh & move_inds,1,'first');
        if isempty(on_idx) % usually means it never crosses threshold
            warning('Could not identify movement onset');
            on_idx = NaN;
        end
    end
    trial_data(trial).(['idx_' onset_name]) = on_idx;
    if strcmpi(which_method,'peak')
        trial_data(trial).(['idx_' peak_name]) = peak_idx;
    end
end

% restore logical order
trial_data = reorderTDfields(trial_data);

end