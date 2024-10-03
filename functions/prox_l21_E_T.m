function [E] = prox_l21_E_T(X,beta)
    dim = size(X); 
    A = sqrt(sum(X.^2,1));
    A(A==0) = beta;
    B = (A-beta)./A;
    Ratio = (A>beta).*B;  
    for k=1:dim(3)
        E(:,:,k) = X(:,:,k)*diag(Ratio(:,:,k)); 
    end
end