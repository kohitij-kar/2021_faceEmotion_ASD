function intcon = get_internalConsistency(rates_sh1, rates_sh2,image_ind, time, timeLimits)

valid_ind = time>=timeLimits(1) & time<=timeLimits(2);
r_sh1 = nanmean(rates_sh1(:,:,:,valid_ind),4);
r_sh2 = nanmean(rates_sh2(:,:,:,valid_ind),4);

% if no image indices are provided choose all images
if(isempty(image_ind))
    image_ind = true(size(rates_sh1,1),1);
end

intcon = nan(442,100);
for i = 1:442
    for j = 1:100
        intcon(i,j) = spearmanBrownCorrection_splithalf(corr(nanmean(r_sh1(image_ind,i,j),3),...
            nanmean(r_sh2(image_ind,i,j),3),'type','Pearson'));
        
    end
end
intcon = nanmean(intcon,2); % mean across repetitions
end

