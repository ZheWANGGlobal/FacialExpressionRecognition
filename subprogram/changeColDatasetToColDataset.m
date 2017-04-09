function rowDataset = changeColDatasetToColDataset(ColDataset)
[h,d] = size(ColDataset);
rowDataset = [];
    for i=1:d
       acol =  ColDataset(:,i);
       aline = reshape(acol,1,h);
       rowDataset = [rowDataset;aline];
    end

end