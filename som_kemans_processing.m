function [keyPointsNum, represenParagraphsIdx, IDX] = som_kemans_processing(normalizedData, dimensionX, dimensionY)
% This function is to deal with cluster processing, including SOM and KMeans %
% Don't modify this file casually %

%--*******************first part: SOM*************************************************--%
x = normalizedData';

%         dimensionX = 1;
%         dimensionY = 2; 
        somClusteringNum = dimensionX * dimensionY;
        fprintf(strcat('SOM: Clustering into',32, num2str(somClusteringNum), ' clusters\n'));
        dimension = [dimensionX dimensionY];
        % Note: selforgmap(dimensions,coverSteps,initNeighbor,topologyFcn,distanceFcn)
        net = selforgmap(dimension);
        [net,tr] = train(net,x);        % Train the Network
        somTrainResult = net(x);                     % Test the Network
        weight = sum(somTrainResult,2);   %each row of weight represents size of the according cluster
        weight(find(weight == 0), :) = []; 
        % clustering the input entries
        z = [];
        for i = 1:length(somTrainResult)
            z(:,i) = find(somTrainResult(:,i)==1);   %each colum of z saves the index of  cluster
        end
        
        kmeansInitialCenterIdx = [];
%         figure();               % for center of every cluster
       % fprintf(straw_columat('som clustering: Picking up characterization of ',32, num2str(somClusteringNum), ' key points and saved\n'));
        for t = 1 : dimensionX * dimensionY
               eval(['a', num2str(t), '= find(z==', num2str(t),');'])
               %save the index of new_rawData classified into the cluster
               eval(['ay', num2str(t), '= normalizedData(a', num2str(t),', :);'])  
               eval(['atemp = size(ay', num2str(t),', 1);'])
               if atemp > 0
                   eval(['[IDX_sokm, C_sokm, Sumd_sokm, D_sokm] = kmeans(ay', num2str(t),', 1);'])
                   [W, DI] = sort(D_sokm);
                   eval(['aindex = a', num2str(t), '(DI(1,:));'])
                  % eval(['apoint', num2str(t), '= normalizedData(aindex, :);'])
                   %eval(['kmeansInitialCenterIdx = [kmeansInitialCenterIdx; aindex', num2str(t),'];'])
                   kmeansInitialCenterIdx = [kmeansInitialCenterIdx; aindex];
               end
%                modified end
        end

  %--********************second part: kmeans*********************************--%
[keyPointsNum,~] = size(kmeansInitialCenterIdx);
fprintf(strcat('kmeans clustering: Picking up ',32, num2str(keyPointsNum), ' representative key paragraphs\n'));
kmeansInitialCentre = normalizedData(kmeansInitialCenterIdx,:);

[IDX, C, SUMD, D]=kmeans(normalizedData,keyPointsNum,'Start',kmeansInitialCentre);
[sortDist,sortIdx]=sort(D);
represenParagraphsIdx = sortIdx(1,:);
% represenParagraphs_normalized = normalizedData(represenParagraphsIdx,:);
% represenParagraphs = new_rawData(represenParagraphsIdx,:);
% ipc_represenParagraphs = rawData(represenParagraphsIdx,raw_colum-1);

