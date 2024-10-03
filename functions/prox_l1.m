function x = prox_l1(T,param)
    x = max(0,T-param)+min(0,T+param); 
    x = max(x,0);
end

