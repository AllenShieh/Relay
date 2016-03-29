function M = rule_out(bx,by,n1,n2,n3,M)

for i=1:n1
    for j=1:n2
        if(j-i*by/bx>0 || j-i*(n2-by)/(n1-bx)-(n1*by-n2*bx)/(n1-bx)>0)
            for k=1:n3
                M(i,j,k) = 0;
            end
%        else
 %           for k=1:n3-1
  %              M(i,j,k) = M(i,j,k);
   %         end
        end
    end
end