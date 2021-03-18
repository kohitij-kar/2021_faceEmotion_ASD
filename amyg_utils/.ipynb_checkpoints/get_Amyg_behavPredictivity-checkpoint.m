function[consis_ctrl,consis_asd] = get_Amyg_behavPredictivity(varargin)

p = inputParser;
p.addParameter('neural_rates',[], @isnumeric);
p.addParameter('time_base',-1000:250:2000,@isnumeric);
p.addParameter('timelimit',[0 500],@isnumeric);
p.addParameter('happy_labels',[],@isnumeric);
p.addParameter('ctrl_behavior',[],@isnumeric);
p.addParameter('asd_behavior',[],@isnumeric);
p.addParameter('difference_level',0,@isnumeric);
p.addParameter('valid_neural_ind', [],@islogical);

p.parse(varargin{:});

rates = p.Results.neural_rates;
time = p.Results.time_base;
timeLim = p.Results.timelimit;
ctrl = p.Results.ctrl_behavior;
asd= p.Results.asd_behavior;
diff_level = p.Results.difference_level;
neu_ind = p.Results.valid_neural_ind;
happy_labels = p.Results.happy_labels;
%%

features = zscore(nanmean(rates(:,neu_ind,time>=timeLim(1)&time<=timeLim(2)),3),[],2)';
%disp(size(features))
neural_predictions = get_neuralTestPredictions('neu_features', features, 'happy_values',happy_labels);
behavioral_diff = abs(nanmean(ctrl,2)-nanmean(asd,2));
valid_ind = behavioral_diff>=diff_level; % all images
consis_ctrl = corr(neural_predictions(valid_ind,:),nanmean(ctrl(valid_ind,:),2), 'type', 'Kendall')./sqrt(get_behavConsistency(ctrl,valid_ind));
consis_asd = corr(neural_predictions(valid_ind,:),nanmean(asd(valid_ind,:),2), 'type', 'Kendall')./sqrt(get_behavConsistency(asd,valid_ind));
end


