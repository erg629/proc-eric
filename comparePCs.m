function [ fh ] = comparePCs( td, col1, col2, params )


    space1 = 'cuneate';
    space2 = 'cuneate';
    
    if nargin > 3, assignParams(who,params); end % overwrite defaults
    fh = figure;
    hold on
    
    for i = 2:length(td)      %This one just compares the first 2 cuneate PCs     something is making an artifact in 
                              %to see if there is directional separation          these plots...is it the (:,col1) indicator?
        if strcmp(td(i).reach_dir(2),'up')
            scatter(td(i).([space1, '_pca'])(:,col1),td(i).([space2, '_pca'])(:,col2),3,'r','filled')

        elseif strcmp(td(i).reach_dir(2),'down')
            scatter(td(i).([space1, '_pca'])(:,col1),td(i).([space2, '_pca'])(:,col2),3,'g','filled')

        elseif strcmp(td(i).reach_dir(2),'left')
            scatter(td(i).([space1, '_pca'])(:,col1),td(i).([space2, '_pca'])(:,col2),3,'b','filled')

        elseif strcmp(td(i).reach_dir(2),'right')
            scatter(td(i).([space1, '_pca'])(:,col1),td(i).([space2, '_pca'])(:,col2),3,'y','filled')

        end    

    end

end

