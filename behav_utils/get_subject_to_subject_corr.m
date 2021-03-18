function intcon = get_subject_to_subject_corr(resp_matrix,image_indices)

% if no specific image indices are provided -- choose all
if(isempty(image_indices))
    image_indices = true(size(resp_matrix,1),1);
end
% generate all possible combinations
C = nchoosek(1:size(resp_matrix,2),2);
% initialize internal consistency (reliability) 
intcon = nan(size(C,1),1);

for i = 1:size(C,1)
    sub1 = C(i,1);
    sub2 = C(i,2);
    intcon(i) = corr(resp_matrix(image_indices,sub1), resp_matrix(image_indices,sub2), 'type','Kendall');
end
end