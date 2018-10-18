function [w2,b2,noise_b2] = capped_train2(c,d,C3,C4,ker) %c是正类，d是负类,a是


D1=eye(size(c,1));
D2=eye(size(d,1));
[ra,ca]=size(c);
[rb,cb]=size(d);
e1=ones(ra,1);
e2=ones(rb,1);

if strcmp(ker.type,'lin')
        H=[c,e1];
        G=[d,e2];
    else
        X=[c;d];
        H=[kernelfun(c,ker,X),e1];
        G=[kernelfun(d,ker,X),e2];
         c=kernelfun(c,ker,X);
        d=kernelfun(d,ker,X);
end
    

       
    
%初始化
D=eye(rb);%损失A
F=eye(ra);%正则化A
R=D;%正则化B
S=F;%损失B


v2=e2;
v1=e1;





fval1=0;
iter1=0;
iter2=0;
fv= fval2;
smallval=1e-4; 





G1=G'*R*G+C3*eye(cb+1);
 Z2=C4*(G1\(H'*v1));
  r2=size(Z2,1);
    w2=Z2(1:r2-1,1);
    b2=Z2(r2,1);


fval3=0;
fval4=1/2*(G*Z2)'*R*(G*Z2)+C4*v1'*(e1+H*Z2)+C3*(norm(w2)^2+b2^2);


% while abs(fval4-fval3)>0.05 && iter2<100 ||iter2==0
%     fval3=fval4;
%     r2=size(Z2,1);
%     w2=Z2(1:r2-1,1);
%     b2=Z2(r2,1);
    J2=mean(abs(e1-c*w2-e1*b2));
    for i=1:ra
       if abs(1-c(i,:)*w2-e1*b2)>=J2
           v1(i,1)=1e-4;
       else
           v1(i,1)=1;
       end
    end
    
    noise_b2=max(abs(d*w2+e2*b2));
    for i=1:rb
         if abs(d(i,:)*w2+b2)<noise_b2
            R(i,i)=1/sqrt((d(i,:)*w2+b2)^2+smallval);           
             
         else
            R(i,i)=smallval;  
          end
    
    end
    G1=G'*R*G+C3*eye(cb+1);
    Z2=C4*(G1\(H'*v1));
     r2=size(Z2,1);
    w2=Z2(1:r2-1,1);
    b2=Z2(r2,1);
    fval4=1/2*(G*Z2)'*R*(G*Z2)+C4*v1'*(e1+H*Z2)+C3*(norm(w2)^2+b2^2);
   
   
 iter2=iter2+1;
%end


end








