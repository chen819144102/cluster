clc;
clear;
close all;

benchname = 2;
    switch benchname
        case 1
           FileName = 'features';   
         case 2
           FileName = 'xnewStats-singleCore-a15-mica-bbench_new';
    end
fprintf(strcat('Import data: Input APP: ', FileName,'\n'));    
rawData = importdata(strcat(pwd, '/', FileName, '.txt'));
[row, raw_colum] = size(rawData);
new_rawData = rawData(:,1:255);

%--*******************MICA Data Preprocessing: normalized*************************************************--%
norlizedData_MICA = mapminmax(new_rawData')';  %Normalized according to the dimensions
aaa = find(isnan(norlizedData_MICA));
norlizedData_MICA(aaa) = 0;

%--******************* Clustering Process*************************************************--%
[keyPointsNum, represenParagraphsIdx, IDX] = som_kemans_processing(normalizedData_MICA);

represenParagraphs_normalized = normalizedData(represenParagraphsIdx,:);
represenParagraphs = rawData(represenParagraphsIdx,:);
ipc_represenParagraphs = rawData(represenParagraphsIdx,raw_colum-1);

%*************************third part: Output and Error processing***********************************%
classParagraphsNum = [];
classInstNum = [];
% typ=[];
% typ_raw=[];
% ipc_typ=[];
for t=1:keyPointsNum
     eval(['class_idx', num2str(t), ' = find(IDX==', num2str(t),');'])
     eval(['class_normalized', num2str(t), ' = normalizedData(class_idx', num2str(t),',:);'])
     eval(['class_raw', num2str(t), ' = new_rawData(class_idx', num2str(t),',:);'])
     %classified data according to the index existing in each cluster
       
     eval(['num',num2str(t),' = length(class_idx',num2str(t),');'])
     eval(['classParagraphsNum = [classParagraphsNum; num', num2str(t),'];']) 
     %save the number of each class
     eval(['cInstNum', num2str(t), ' = rawData(class_idx',num2str(t),',raw_colum);'])
     eval(['classInstNum = [classInstNum; sum(cInstNum', num2str(t),')];']) 
%      eval(['ctr_nor', num2str(t),'=mean(class_',num2str(t),',1);'])
     %normalized center 
%      eval(['ctr_raw', num2str(t),'=mean(class_raw',num2str(t),',1);'])
     %raw center
     eval(['ipc', num2str(t), ' = rawData(class_idx',num2str(t),',raw_colum-1);'])
%      eval(['ipc_ctr', num2str(t),'=mean(ipc',num2str(t),',1);'])
%    ipc of center
%      eval(['typ = [typ; ctr_nor', num2str(t),'];'])
%       eval(['typ_raw = [typ_raw; ctr_raw', num2str(t),'];'])
%      eval(['ipc_typ = [ipc_typ; ipc_ctr', num2str(t),'];'])
end

sum_typ = sum(abs(typ),2);    %sum of all dimensions' values at typical points 
sum_num = sum(classParagraphsNum,1);    %the number of data 

  totalWeightedErr=[];
  weightedErr_class=[];
  class_err=0;
  ipc_total=0;
for t = 1:keyPointsNum
     eval(['absoluteErrOfCtrAndPoint', num2str(t), ' = abs(class_normalized',num2str(t),'-repmat(represenParagraphs_normalized(t,:),classParagraphsNum(t),1));'])
   %absolute error of dimensions between each point with center in a class
     eval(['ipc_p2c', num2str(t), '=abs(ipc',num2str(t),'-repmat(ipc_typ(t),classParagraphsNum(t),1));'])
%absolute error of ipc between each point with center in a class
     eval(['aveAbsoluteErr(t,:) =mean(absoluteErrOfCtrAndPoint', num2str(t),',1);'])  
     %average value of absolute error of dimensions in a class
     eval(['ipc_av(t) =mean(ipc_p2c', num2str(t),',1)/ipc_typ(t);']) 
 %average value of relative error of ipc in a class
     weightedErr_class(t,:) = aveAbsoluteErr(t,:)/sum_typ(t);
 %save weighted error of dimensions in a class
     totalWeightedErr(t)= sum(weightedErr_class(t,:)); 
 %save weighted average of a class with mix of all dimensions
     class_err = class_err+totalWeightedErr(t)*classInstNum(t)/sum(classInstNum);
  %save weighted average of all class with mix of all dimensions   
     ipc_total = ipc_total+ipc_av(t)*classInstNum(t)/sum(classInstNum);
 %save weighted average of all classes' ipc  
end

weighted_class_num = floor(keyPointsNum*0.1);
[sortNum,sortClassIdx] = sort(classInstNum,'descend');
weighted_typClass = typ_raw(sortClassIdx(1:weighted_class_num,:),:);

%*************************save important data***********************************%
save('cluster.mat')

%save data in TXT format
getTxt('representativeParagraphs.txt',represenParagraphs);
getTxt('represenParagraphsIdx.txt',represenParagraphsIdx);
getTxt('classInstNum.txt',classInstNum);
getTxt('classParagraphsNum.txt',classParagraphsNum);
getTxt('weighted_typ_point.txt',weighted_typClass);