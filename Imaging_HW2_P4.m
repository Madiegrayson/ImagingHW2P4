%Imaging HW - Question 4 
%Information Gain
%ref: textbook pg 55-56

%Load images
IntensityImage = niftiread('ICBMlores.nii.gz');
LabelImage     = niftiread('ICBMGMWMCSFlores.nii.gz');
%Extract non-background data
labelmask = LabelImage(:);
intensitydata = IntensityImage(:);
labelsubset = labelmask(labelmask>0);
intensitysubset =  intensitydata(labelmask>0);

%Sort the intensity values
Initial = [sum(labelsubset == 1), sum(labelsubset == 2), sum(labelsubset == 3)];
pdfInitial = 1/sum(Initial)* Initial;
EntropyBefore = -sum(pdfInitial .*log(pdfInitial));

[isort, sortindex] = sort(intensitysubset,'ascend');
lsort = labelsubset(sortindex);
 
IGmax = -inf;
threshold = 1;

intensitymin = round(min(intensitysubset));
intensitymax = round(max(intensitysubset));

for i = intensitymin:intensitymax
    threshold = i;
    R = isort(isort >= threshold);
    L = isort(isort < threshold);
    Rlabel = lsort(length(L)+1:end);
    Llabel = lsort(1:length(L));

    GREYCSF = [sum(Llabel == 1), sum(Llabel == 2), sum(Llabel == 3)];
    WHITE = [sum(Rlabel == 1), sum(Rlabel == 2), sum(Rlabel == 3)];
    
    % verify split
    % verify = sum(GREYCSF)+ sum(WHITE)- sum(Initial);

    %Compute max information gain/intensity threshold and store in the maxInformationGain/intensityMaxInformationGain variables
    % compute discrete probabilities
    pdfGREYCSF = 1/sum(GREYCSF)* GREYCSF;
    pdfWHITE = 1/sum(WHITE)* WHITE;

    % compute the entropy after the split
    EntropyGREYCSF = -sum(pdfGREYCSF .*log(pdfGREYCSF ));
    EntropyWHITE = -sum(pdfWHITE .*log(pdfWHITE ));
    % each split is normalized the number of entries
    EntropyAfter = sum(GREYCSF)/ sum(Initial) * EntropyGREYCSF + ...
    sum(WHITE)/ sum(Initial) * EntropyWHITE;

    % information gain is the change in entropy
    InformationGain = EntropyBefore - EntropyAfter;

    if InformationGain>IGmax
        IGmax = InformationGain;
        maxthreshold = i;
    end
end

intensityMaxInformationGain = maxthreshold;
maxInformationGain = IGmax;

