function newData = traceDimensions(new_rawData)

InstAll=sum(new_rawData(:,1:14),2);
cPathLength=sum(new_rawData(:,15:55),2);
depGraphDistAll=sum(new_rawData(:,56:85),2);
RegReadAll=sum(new_rawData(:,[86,88]),2);
RegWriteAll=sum(new_rawData(:,[87,89,90]),2);
fetchReuseDistAll=sum(new_rawData(:,91:101),2);
fetchAddrDistAll=sum(new_rawData(:,102:112),2);
ldGlobalReuseDistAll=sum(new_rawData(:,113:125),2);
ldLocalReuseDistAll=sum(new_rawData(:,126:138),2);
stGlobalReuseDistAll=sum(new_rawData(:,139:151),2);
stLocalReuseDistAll=sum(new_rawData(:,152:164),2);
ldGlobalAddrDistAll=sum(new_rawData(:,165:181),2);
ldLocalAddrDistAll=sum(new_rawData(:,182:198),2);
stGlobalAddrDistAll=sum(new_rawData(:,199:215),2);
stLocalAddrDistAll=sum(new_rawData(:,216:232),2);
branchesAll=sum(new_rawData(:,233:236),2);
BasicBlockAll=sum(new_rawData(:,237:251),2);
addrBranchesAll=sum(new_rawData(:,252:266),2);
serialBlockSizeAll=sum(new_rawData(:,267:281),2);

%newData are MICA data rates in relative MICA modules
newData(:,1:14)=new_rawData(:,1:14)./repmat(InstAll,1,14);
newData(:,15:55)=new_rawData(:,15:55)./repmat(cPathLength,1,41);
newData(:,56:85)=new_rawData(:,56:85)./repmat(depGraphDistAll,1,30);
newData(:,86)=RegReadAll./(RegReadAll+RegWriteAll);
newData(:,87)=RegWriteAll./(RegReadAll+RegWriteAll);
newData(:,88:98)=new_rawData(:,91:101)./repmat(fetchReuseDistAll,1,10);
newData(:,98:108)=new_rawData(:,102:112)./repmat(fetchAddrDistAll,1,10);
newData(:,109:121)=new_rawData(:,113:125)./repmat(ldGlobalReuseDistAll,1,12);
newData(:,122:134)=new_rawData(:,126:138)./repmat(ldLocalReuseDistAll,1,12);
newData(:,135:147)=new_rawData(:,139:151)./repmat(stGlobalReuseDistAll,1,12);
newData(:,148:160)=new_rawData(:,152:164)./repmat(stLocalReuseDistAll,1,12);
newData(:,161:177)=new_rawData(:,165:181)./repmat(ldGlobalAddrDistAll,1,12);
newData(:,178:194)=new_rawData(:,182:198)./repmat(ldLocalAddrDistAll,1,12);
newData(:,195:211)=new_rawData(:,199:215)./repmat(stGlobalAddrDistAll,1,12);
newData(:,212:228)=new_rawData(:,216:232)./repmat(stLocalAddrDistAll,1,12);
newData(:,229)=new_rawData(:,233)./branchesAll;     %fwBranch
newData(:,230)=new_rawData(:,234)./branchesAll;     %bwBranch
newData(:,231)=new_rawData(:,235)./branchesAll;     %notTakenBranch
newData(:,232)=new_rawData(:,236)./branchesAll;     %takenChanged
newData(:,233:247)=new_rawData(:,237:251)./repmat(BasicBlockAll,1,15);
newData(:,248:262)=new_rawData(:,252:266)./repmat(addrBranchesAll,1,15);
newData(:,263:277)=new_rawData(:,267:281)./repmat(serialBlockSizeAll,1,15);

aan=find(isnan(newData));
newData(aan)=0;