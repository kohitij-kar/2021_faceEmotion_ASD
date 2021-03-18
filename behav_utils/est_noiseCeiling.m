function [ns, ns_err, raw_corr] = est_noiseCeiling(ctrl,asd,diff_val)

% lets create all combinations of selecting 5 out of 15 subjects 
C = nchoosek(1:15,5);

nrBS = min([300, size(C,1)]); % whatever is smaller 300 or #combinations
raw_corr= nan(nrBS,1);
intcon_ctrl= nan(nrBS,1);
intcon_asd= nan(nrBS,1);
corr_type = 'Kendall';
del = nan(size(ctrl,1),nrBS);
num = nan(nrBS,1);
for i = 1:nrBS 
    l1 = C(i,:);
    l2 = setdiff(1:15,l1);
    del(:,i) = abs(nanmean(ctrl(:,l1),2)- nanmean(asd(:,l1),2));
    ll = del(:,i)>diff_val;
    num(i)= sum(ll);
    
    if(num(i)>5)
    
        raw_corr(i) = corr(nanmean(ctrl(ll,l2),2),nanmean(asd(ll,l2),2), 'type', corr_type);
        con_ctrl = nan(50,1);
        con_asd = nan(50,1);
        
        for j = 1:50
            sh1_loc = randsample(l2,5,false);
            sh2_loc = setdiff(l2,sh1_loc); 
            con_ctrl(j) = spearmanBrownCorrection_splithalf(corr(nanmean(ctrl(ll,sh1_loc),2),nanmean(ctrl(ll,sh2_loc),2), 'type', corr_type));
            con_asd(j) = spearmanBrownCorrection_splithalf(corr(nanmean(asd(ll,sh1_loc),2),nanmean(asd(ll,sh2_loc),2), 'type', corr_type));
        end
        
        intcon_ctrl(i) = nanmean(con_ctrl);
        intcon_asd(i) = nanmean(con_asd);
        
    end
end 
ns = nanmean(sqrt(intcon_ctrl.*intcon_ctrl));
ns_err = mad(sqrt(intcon_ctrl.*intcon_asd));