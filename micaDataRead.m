function micaDataRead(micaDataDir)
%micaDataDir = 'D:\Documents\MATLAB\clusters\tobuy_result\mica\';
txtFile = dir([micaDataDir,'*.txt']);

micaData = [];
for i = 1:length(txtFile)
	fileName = [micaDataDir, txtFile(i).name];
	rowData = dlmread(fileName);
	micaData = [micaData;rowData];
end
save('micaData.mat')