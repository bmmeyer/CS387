function thresh = get_youdin(X,Y,T)

[~,ind_max] = max(Y-X);
thresh = T(ind_max);

end