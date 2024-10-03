%----- Correlted Total Viariation based Tensor Robust Principle Component Analysis -----%
function [B, T, obj, err, iter] = TCTV_TRPCA3_E_l21(M, opts)
%% default paremeters setting 
dim = size(M);  %n1 * n2 * n3 * ...

directions = 1:3;  
lambdaL    = 12;
betaL      = 3;
tol        = 1e-7; 
max_iter   = 500;  
rho        = 1.1;
mu         = 1e-4; 
max_mu     = 1e10;
DEBUG      = 1;    

if ~exist('opts', 'var')
    opts = [];
end   
if isfield(opts, 'transform');          transform          = opts.transform;          end
if isfield(opts, 'directions');         directions         = opts.directions;         end
if isfield(opts, 'lambdaL');            lambdaL            = opts.lambdaL/sqrt(3);    end
if isfield(opts, 'betaL');              betaL              = opts.betaL*sqrt(3);       end
if isfield(opts, 'tol');                tol                = opts.tol;                end
if isfield(opts, 'max_iter');           max_iter           = opts.max_iter;           end
if isfield(opts, 'rho');                rho                = opts.rho;                end
if isfield(opts, 'mu');                 mu                 = opts.mu;                 end
if isfield(opts, 'max_mu');             max_mu             = opts.max_mu;             end
if isfield(opts, 'DEBUG');              DEBUG             = opts.DEBUG;               end

lambda     = lambdaL/sqrt(prod(dim)/min(dim(1),dim(2)));    
beta = betaL/sqrt(min(dim(1),dim(2)));

%% variables initialization
B        = randn(dim);  
T        = zeros(dim);  
E        = zeros(dim); 
Y        = zeros(dim);  
for i = 1:3
    index        = directions(i);         
    G{index}     = porder_diff(B,index);  
    Gamma{index} = zeros(dim);            
end

%% FFT setting
C = zeros(dim);
for i = 1:3
    Eny = diff_element(dim,directions(i));  
    C   = C + Eny;  
end

%% main loop
iter = 0;
count = 0;  
while iter<max_iter
    iter = iter + 1;
    Bk = B; 
    Tk = T;  
    preT = sum(Tk(:)>0); 

    %% Update B -- solve TV by FFT 
	H = zeros(dim);    
    for i = 1:3
       index = directions(i);
       H = H + porder_diff_T(mu*G{index}-Gamma{index},index);  
    end
    B = real( ifftn( fftn( mu*(M-T-E)+Y+H)./(mu*(1+C)) ) );  %含噪声项E

    %% Update Gi -- proximal operator of TNN
    v3=porder_diff(B,3);
    v1=porder_diff(B,1);
    v2=porder_diff(B,2);

    for i = 1:3
        index = directions(i);
        [G{index},tnn_G{index}] = prox_tnn_F(porder_diff(B,index)+Gamma{index}/mu,1/(3*mu)); 
    end
    
    %% Update target T
	T = prox_l1(M-B-E+Y/mu, lambda/mu);
    
    %% Update strong edge component E
    E = prox_l21_E_T(M-B-T+Y/mu,beta/mu);     

    %% Stop criterion
    dY    = M-B-T-E;  
    err   = norm(dY(:))/norm(M(:)); 
    currT = sum(T(:)>0);

    if DEBUG
        if iter == 1 || mod(iter, 10) == 0  
            obj = sum(cell2mat(tnn_G))/3; 
            disp(['iter ' num2str(iter) ', mu=' num2str(mu) ...
                    ', preT=' num2str(preT) ', currT=' num2str(currT)... 
                      ', obj=' num2str(obj) ', err=' num2str(err)]); 
        end
    end

    if preT>0 && currT>0 && preT == currT
        count=count+1;    
    else
        count=0;
    end
    
    if err < tol || count>3   
        disp(['满足条件Iteration stop, err=' num2str(err) newline]);  
        break;  
    end
    %% Update mulipliers: Y, Gamma, and mu
    Y = Y+mu*dY;                
    for i = 1:3                 
        index = directions(i); 
        Gamma{index} = Gamma{index}+mu*(porder_diff(B,index)-G{index}); 
    mu = min(rho*mu,max_mu);   
end
end

