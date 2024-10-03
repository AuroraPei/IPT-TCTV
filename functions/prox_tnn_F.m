function [X,tnn,trank] = prox_tnn_F(M,rho)
    [n1,n2,n3] = size(M);
    X = zeros(n1,n2,n3);
    Y = fft(M,[],3);
    tnn = 0;
    trank = 0;

    halfn3 = ceil((n3+1)/2);
    for i = 1 : halfn3
        [U,S,V] = svd(Y(:,:,i),'econ');  
        S = diag(S);
        S = max(S-rho,0);
        r = sum(S > 0);
        S = S(1:r);
        X(:,:,i) = U(:,1:r)*diag(S)*V(:,1:r)';    
        tnn = tnn+sum(S);  
        trank = max(trank,r); 
    end

    for i = halfn3+1 : n3
        X(:,:,i) = conj(X(:,:,n3-i+2));
        [U,S,V] = svd(X(:,:,i),'econ');  
        S = diag(S);
        tnn = tnn+sum(S); 
    end

    tnn = tnn/n3; 
    X = ifft(X,[],3);
end

