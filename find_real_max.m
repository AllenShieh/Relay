function real_max = find_real_max();

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
