function getTxt(txtName,matName)
%save data in TXT format
fid=fopen(txtName,'wt');
[m,n]=size(matName);
for i=1:m
    for j=1:n
        if isnumeric(matName(i,j))
            if j==n 
                fprintf(fid,'%g\n',matName(i,j));
            else
                fprintf(fid,'%g\t',matName(i,j));
            end
        else
             if j==n 
                fprintf(fid,'%s\n',matName(i,j));
            else
                fprintf(fid,'%s',matName(i,j));
             end      
        end
    end
end
fclose(fid);
