function [rows_j, cols_i,img_k] = IndexToCoordinates3D(index, nrows, ncols) % 402588
img_k= floor((index-1)/(nrows * ncols)) + 1;   
img_k2= (img_k-1)*(nrows * ncols);
cols_i = floor((index-img_k2-1)/nrows); 
rows_j = index - img_k2 - nrows*(cols_i);
cols_i = cols_i + 1;

end
