function [rows_j, cols_i] = IndexToCoordinates (index, n_rows)
    cols_i=floor(index/n_rows);
    rows_j=index-n_rows*(cols_i);
    cols_i=cols_i+1;
end