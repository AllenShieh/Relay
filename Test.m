function Test(n1,n2,n3)

%clear all
%close all
%clc

%n1 = 50;
%n2 = 50;
%n3 = 50;

T = [n1-1,n2-1,n3-1];
U = [n1-1,n2-1,n3-1];
V = [n1-1,n2-1,n3-1];
for i=1:n1-1
    for j=1:n2-1
        for k=1:n3-1            
            U(i,j,k)=20*log(sqrt(i^2+j^2+k^2));
            V(i,j,k)=20*log(sqrt((i-n1)^2+(j-n2)^2+(k-n3)^2));
            T(i,j,k)=(100-U(i,j,k))*(100-V(i,j,k));
            %T(i,j,k)=100-20*log(sqrt(i^2+j^2+k^2)+sqrt((i-n1)^2+(j-n2)^2+(k-n3)^2));
        end
    end
end
normalize = max(T(:));
T = T/normalize;
for i=1:n1-1
    for j=1:n2-1
        for k=1:n3-1
            T(i,j,k) = T(i,j,k)+normrnd(0,0.01,1);
        end
    end
end
normalize = max(T(:));
T = T/normalize;

m = 15;
n = 15;
A = [m-1,n-1];
for a=1:m-1
    for b=1:n-1
        A(a,b)=(100-20*log(sqrt(a^2+b^2)))*(100-20*log(sqrt((a-m)^2+(b-n)^2)))/1000;
    end
end

save('test.mat','T');