function intcon = get_behavConsistency(resp_matrix,image_indices)

% if no specific image indices are provided -- choose all
if(isempty(image_indices))
    image_indices = true(size(resp_matrix,1),1);
end
% generate all possible combinations
C = nchoosek(1:size(resp_matrix,2),round(size(resp_matrix,2)/2));
% initialize internal consistency (reliability) 
intcon = nan(size(C,1),1);

for i = 1:size(C,1)
    split_half1 = C(i,:);
    split_half2 = setdiff(1:size(resp_matrix,2),C(i,:));
    intcon(i) = spearmanBrownCorrection_splithalf(corr(nanmean(resp_matrix(image_indices,split_half1),2), nanmean(resp_matrix(image_indices,split_half2),2), 'type','Kendall'));
end
intcon = nanmean(intcon);
end