function neural_predictions = get_neuralTestPredictions(varargin)

p =inputParser;
p.addParameter('ncomp',15,@isnumeric);
p.addParameter('folds',20,@isnumeric);
p.addParameter('neu_features',[],@isnumeric);
p.addParameter('happy_values',[],@isnumeric);
p.addParameter('num_iters',100,@isnumeric);
p.parse(varargin{:});

ncomp = p.Results.ncomp;
folds = p.Results.folds;
neu_features = p.Results.neu_features;
happy_values = p.Results.happy_values;
num_iters = p.Results.num_iters;

neural_predictions = nan(size(neu_features,2),num_iters);
options = statset('UseParallel',true);


for k = 1:num_iters
    %     disp(k);
    rng('shuffle');
    mf = neu_features;
    ind = crossvalind('Kfold',size(neu_features,2),folds);
    for i = 1:folds
        train_fe = happy_values(ind~=i);
        [~,~,~,~,beta] = plsregress(mf(:,ind~=i)',train_fe,ncomp, 'Options', options);
        neural_predictions(ind==i,k) = glmval(beta,mf(:,ind==i)','identity');
    end
end

end