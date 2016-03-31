function [time,quality] = local_update()

%clear all
%close all
%clc

load test.mat

Xn = T;
[n1,n2,n3] = size(Xn);
X = Xn;

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

Q = zeros(size(Xn));
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
sx = n1-1;
sy = 2;
sz = 2;

t1 = clock;
% while(s!=p)
s_c = 0;
while(~(px==sx && py==sy && pz==sz))
    if(abs(px-sx)<=1 && abs(py-sy)<=1 && abs(pz-sz)<=1) 
        break;
    end
    s_c = s_c+1;
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
        
% use the sample
    diff = X(sx,sy,sz)-Q(sx,sy,sz);
    Q(sx,sy,sz)=X(sx,sy,sz);
    Q(sx+1,sy,sz)=X(sx+1,sy,sz)+diff;
    Q(sx-1,sy,sz)=X(sx-1,sy,sz)+diff;
    Q(sx,sy+1,sz)=X(sx,sy+1,sz)+diff;
    Q(sx,sy-1,sz)=X(sx,sy-1,sz)+diff;
    Q(sx,sy,sz+1)=X(sx,sy,sz+1)+diff;
    Q(sx,sy,sz-1)=X(sx,sy,sz-1)+diff;

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
    %fprintf('current:%d %d %d\nanother p:%d %d %d\n',sx,sy,sz,px,py,pz);
end
t2 = clock;
time = etime(t2,t1)+s_c;
%fprintf('%f\n', etime(t2,t1)+s_c);
quality = Xn(px,py,pz);
%% result
% output p
%fprintf('local:%d %d %d value:%f\n',px,py,pz,Xn(px,py,pz));