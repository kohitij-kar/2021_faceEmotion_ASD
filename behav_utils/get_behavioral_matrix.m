
function resp_matrix = get_behavioral_matrix(varargin)
%%
p = inputParser;
p.addParameter('behavior',[],@istable);
p.addParameter('condition',[],@isstr);
p.parse(varargin{:});
%%
Tbl = p.Results.behavior;
condition=p.Results.condition;
%%
% choose only indices for the specific condition
loc = strcmp(Tbl.Condition,(condition));

% choose only subjects who ran the specific condition
sub = Tbl.Subj_idx(loc);
subjects = unique(sub); % unique subjects
nrSubjects = numel(subjects); % number of subjects

% choose only stimulus ID for the specific condition
stim = Tbl.Stimulus(loc);
stimtypes = unique(stim);
nrStims = numel(stimtypes);

% choose only face ID for the specific condition
face = Tbl.FaceID(loc);
faceid = unique(face);
nrFaces = numel(faceid);

%initialize response matrix
resp_matrix = nan(nrStims,nrFaces, nrSubjects);

% separate out relevant data matrix
data = Tbl(loc,:);

%% Make the data matrix
for i = 1:nrStims % stimulus levels <happiness indices>
    for k = 1:nrFaces % facial identities
        for j = 1:nrSubjects % individual subjects
            % choose correct indices
            ll_sub=sub==subjects(j)...
                & face==faceid(k)...
                & stim ==stimtypes(i);
            responses = data.Response(ll_sub);
            responses(responses==0)=nan; % '0' means the subject didn't respond; so removing it
            resp_matrix(i,k,j) = nanmean(responses);
        end
    end
end

%% convert the 3D matrix to image-level 2D matrix
% resp_matrix = reshape(resp_matrix,[],size(resp_matrix,3));
end

