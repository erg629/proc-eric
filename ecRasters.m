%%Borrowing large chunks of the visData function with mods for separation
%%of directions...if I can get PDs to work again

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [ ] = visData( trial_data, params )
%
%   Function to visualize data. Plots in two-column format, where one column
% is a 2-D position plot (and, optionally, a 3-D PCA trajectory plot), and
% the second column is a stack of time-varying signals (e.g. continuous
% data, spike rasters, PCA dimensions, etc).
%
% NOTE: needs some tweaking to fix the positions etc
%
% INPUTS:
%   Trial_data : struct array where each element is a trial.
%
%   params     : parameter struct
%     .trials      : (vector) trial indices to plot
%                       Note: must be specified unless a single trial is passed in
%     .signals     : (cell array) fieldnames of continuous signals to plot (Default to {'vel,'acc'})
%     .target_direction : the angular direction of the target on that trial
%     .idx_EVENT        : bin index of trial events. There can be many of these.
%                       Common ones include: target_on, go_cue, movement_on, peak_speed, reward
%     .continuous-data  : any number of binned continuous signals (e.g. 'pos','vel','acc','force')
%     .ARRAY_spikes     : contains an array [# neurons, # time bins]
%                       Each element is a count of binned spikes. ARRAY is currently 'M1' and/or 'PMd'
%     .ARRAY_pca       : (if needed) contains an array [# dimensions, # pca time bins]
%
% PCA-specific Parameters (should generalize this functionality more later)
%     .plot_pca   : (bool) whether to add PCA data to figure (Default to false, requires _pca field in trial_data)
%                    NOTE: adds pca_dims dimensions to time plots, and adds first 3 dimensions as trajectory plot
%                       To plot only trajectory, pass in empty pca_dims parameter
%     .pca_dims   : (vector) list of PCA dims to plot
%     .pca_array  : (string) name of array to plot for PCA ('M1','PMd', or 'Both')
% NOTE: There are a lot more parameters hard-coded at the top of the function
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ ] = visData( trial_data, params )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULT PARAMETERS
trials_to_plot    =   1;
plot_signals      =   {'vel'};
plot_pca          =   false;
pca_dims          =   1:3;
pca_array         =   '';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   These are parameters that are less likely to change but can still be
%   overwritten as an input parameter (not documented in help call though)
pos_offset        =   [0, 0]; % offset to zero position
target_size       =   2; % target size in cm
target_distance   =   8; % distance of outer targets in cm
event_db          =   { ...
    'idx_trial_start', 'strt'; ...
    'idx_startTime',   'strt'; ...
    'idx_target_on',   'tgt'; ... % list of possible field names for events and a shorthand name
    'idx_tgtOnTime',   'tgt'; ...         % add any new events here
    'idx_go_cue',      'go'; ...
    'idx_goCueTime',   'go'; ...
    'idx_movement_on', 'mv'; ...
    'idx_peak_speed',  'pk'; ...
    'idx_reward',      'rw'; ...
    'idx_trial_end',   'end'; ...
    'idx_endTime',     'end'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% These are a lot of parameters for plotting
%   Presumably we won't change these but just in case you can
pos_range          =   [-9,9];   % range for 2-D position plot axes
font_size          =   12;       % default font size
line_width         =   2;        % standard line width
dot_width          =   3;        % standard width for dot markers
event_symbol       =   'o';      % standard symbol for event markers
pos_cols           =   2;        % how many columns for position plot
time_cols          =   3;        % how many columns for time-variable plots
kin_rows           =   3;        % how many rows for kinematic plots
event_rows         =   1;        % how many rows for event markers
traj_rows          =   3;        % how many rows for time-varying trajectory plots
spike_rows         =   4;        % how many rows for spike markers
pos_location       =   'right'; % if position plot is on 'left' or 'right'
trial_event_colors =   parula(size(event_db,1)); % use default matlab colors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin > 1, assignParams(who,params); else params = struct(); end% overwrite parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% bin_size     =   trial_data(1).bin_size; %bin size of data in s
if ~isfield(params,'trials') && length(trial_data) > 1
    error('No trials specified.');
end
% check for foolish inputs
if max(trials_to_plot) > length(trial_data)
    error('Requested too many trials.');
end

if isempty(pca_array) && plot_pca
    disp('WARNING: No PCA array provided. Skipping PCA plots.');
    plot_pca = false;
end

num_trials_to_plot = length(trials_to_plot);

% If PCA plotting is desired, checks that data exists and params provided
if plot_pca && ~isfield(trial_data,[pca_array '_pca'])
    error('PCA data not present in trial_data.');
end

% allow for a variable number of arrays and events
%   assumes each array has a field named ARRAY_spikes
fn = fieldnames(trial_data);
arrays = fn(cellfun(@(x) ~isempty(regexp(x,'_spikes','ONCE')),fn));
num_arrays = length(arrays);
events = fn(cellfun(@(x) ~isempty(regexp(x,'idx_','ONCE')),fn));
clear fn;

% find how many rows are needed
num_rows = length(plot_signals)*kin_rows + event_rows + num_arrays*spike_rows;
if plot_pca, num_rows=num_rows+length(pca_dims)*traj_rows; end

num_cols = pos_cols + time_cols;
% use this to partition the subplot space
subplot_grid = repmat((0:num_rows-1)'*num_cols,1,num_cols) + repmat(1:num_cols,num_rows,1);

% some variables to position the columns
switch lower(pos_location)
    case 'left'
        pos_start = 0;
        time_start = pos_cols;
    case 'right'
        time_start = 0;
        pos_start = time_cols;
end

% add 2D or 3D PCA trajectory plot below position plot
if plot_pca
    pos_rows_max = floor(num_rows/2);
else
    pos_rows_max = num_rows;
end


% Loop through trials and plot
for tr_idx = 1:num_trials_to_plot % tr_idx is a dummy variable; useful if you're skipping trials
    trial = trials_to_plot(tr_idx); % Use tr_num from here down
    
    % check to make sure events aren't empty
    idx = true(1,length(events));
    for iEvent = 1:length(events)
        if isempty(trial_data(trial).(events{iEvent}))
            idx(iEvent) = false;
        end
    end
    events = events(idx); clear idx;
    
    % Make new figure
    figure('units','normalized','outerposition',[0.1 0 .85 1]);
    
       %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plot spiking rasters
    row_tally = 0;
    for iArray = 2
        set(gca,'XTickLabels',[]);
        subplot(num_rows,num_cols, ...
            reshape(subplot_grid(row_tally+1:row_tally+spike_rows,time_start+1:time_start+time_cols)',1,(num_cols-pos_cols)*spike_rows ));
        imagesc(trial_data(trial).(arrays{iArray})');
        axis([1 size(trial_data(trial).pos,1) 0 size(trial_data(trial).([arrays{iArray}]),2)]);
        set(gca,'Box','off','TickDir','out','FontSize',font_size);
        ylabel(arrays{iArray}(1:end-7),'FontSize',font_size);
        row_tally = row_tally + spike_rows;
    end
    hold on
    trialstart=21;
    trialend=217
    y=get(gca,'ylim');
    plot([trialstart trialstart],y, 'w');
    plot([trialend trialend],y,'w');
    xlabel('Time (bins)','FontSize',font_size);
end

end
%%%% so it seems this is only plotting the first trial...ok for now %%%%
