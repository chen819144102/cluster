function [micaTxtFileName, micaData] = micaDataRead(micaDataDir)
% This file is to read MICA data from directory saving tracing data %
% Returns MICA paragraphs' file name and MICA data %
%Don't modify this file casually %

% micaDataDir = 'D:\HW_new\HW_test\micaTest\';
% Follow above form, and don't forget the '\' in the end
txtFile = dir([micaDataDir,'*.txt']);

micaTxtFileName = [];
micaData = [];
for i = 1:length(txtFile)
    micaTxtFileName = [micaTxtFileName; txtFile(i).name];
    fileName = [micaDataDir, txtFile(i).name];
	rowData = dlmread(fileName);
	micaData = [micaData; rowData];
end
%save('micaData.mat')