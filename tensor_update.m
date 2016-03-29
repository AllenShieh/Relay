function [time,quality] = tensor_update()

%clear all
%close all
%clc

%% Initialization
addpath('tSVD','proxFunctions','solvers');
load test.mat

%normalize = max(T(:));
normalize = 1;
Xn = T/normalize; 				% original data
X = Xn;
[n1,n2,n3] = size(Xn);
Q_sample = zeros(size(Xn)); 	% sampled locatoin
Q_chosen = zeros(size(Xn));     % chosen location
for i=1:n1
    for j=1:n2
        for k=1:n3
            Q_chosen(i,j,k)=1;
        end
    end
end
Q = zeros(size(Xn)); 			% quality tensor
%Q_result = [n1,n2,n3];          % actual quality tensor

p = 1;                        % random chosen probability
alpha = 1;
maxItr = 100;
rho = 0.01;
myNorm = 'tSVD_1';

% rule out the area obstructed by the building
bx = (n1*3/4);
by = (n2/4);
% original data considering the building
Xn = rule_out(bx,by,n1,n2,n3,Xn);
% find the real max
real_max = 0;
rx=0;
ry=0;
rz=0;
for i=1:n1
    for j=1:n2
        for k=1:n3
            if(Xn(i,j,k)>real_max)
                real_max=Xn(i,j,k);
                rx=i;
                ry=j;
                rz=k;
            end
        end
    end
end

% initial Q
for i=1:n1
    for j=1:n2
        for k=1:n3
            Q(i,j,k)=(100-20*log(sqrt(i^2+j^2+k^2)))*(100-20*log(sqrt((i-n1-1)^2+(j-n2-1)^2+(k-n3-1)^2)));
        end
    end
end
normalize = max(Q(:));
Q = Q/normalize;
Q_result = rule_out(bx,by,n1,n2,n3,Q);

% get the initial optimal point o
qmax = 0;
px = 0;
py = 0;
pz = 0;
for i=1:n1
    for j=1:n2
        for k=1:n3
            if(Q_result(i,j,k)>qmax)
                qmax=Q_result(i,j,k);
                px=i;
                py=j;
                pz=k;
            end
        end
    end
end
%fprintf('%d %d %d %f\n',px,py,pz, Q_result(px,py,pz));

% set the start point s
sx = n1;
sy = 1;
sz = 1;

%% completion and update
t1 = clock;
% while(s!=p)
c = 0;
s_c = 0;
while(~(px==sx && py==sy && pz==sz))
% update Q_sample
    c = c+1;
    fprintf('start point:%d %d %d\n',sx,sy,sz);
    Q_sample(sx,sy,sz) = 1;
    while(~(px==sx && py==sy && pz==sz))
        if(sx<px)
            sx = sx+1;
        elseif(sx>px)
            sx = sx-1;
        elseif(sy<py)
            sy = sy+1;
        elseif(sy>py)
            sy = sy-1;
        elseif(sz<pz)
            sz = sz+1;
        elseif(sz>pz)
            sz = sz-1;
        end
        Q_sample(sx,sy,sz) = 1;
        s_c = s_c+1;
    end            
    %chosen = randperm(n1*n2*n3,round(p*n1*n2*n3));
    %Q_sample(chosen) = 1;
    A = diag(sparse(double(Q_chosen(:))));
	sample = A * Q(:);
% use the sample
    for i=1:n1
        for j=1:n2
            for k=1:n3
                if(Q_sample(i,j,k)==1)
                    sample(i+(j-1)*n1+(k-1)*n1*n2)=X(i,j,k);
                end
            end
        end
    end
% update Q with samples
	Q = tensor_cpl_admm(A,sample,rho,alpha,[n1,n2,n3],maxItr,myNorm,0);
    Q = reshape(Q, [n1, n2, n3]);
% s = p
    sx = px;
    sy = py;
    sz = pz;
    fprintf('arrive at:%d %d %d value:%f\n',px,py,pz,Xn(px,py,pz));
% find the optimal p
    Q_result = rule_out(bx,by,n1,n2,n3,Q);
    qmax = 0;
    for i=1:n1
        for j=1:n2
            for k=1:n3
                if(Q_result(i,j,k)>qmax)
                    qmax=Q_result(i,j,k);
                    px=i;
                    py=j;
                    pz=k;
                end
            end
        end
    end
    fprintf('flying process %d done\n\n',c);
end
t2 = clock;
time = etime(t2,t1)+s_c;
fprintf('%f\n', time);
quality = Xn(px,py,pz);
%% result
% output p
fprintf('predict position:%d %d %d value:%f\nreal position:%d %d %d real value:%f\n',px,py,pz,Xn(px,py,pz),rx,ry,rz,real_max);