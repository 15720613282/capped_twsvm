function [w1,b1,noise_b1] = capped_train1(c,d,C1,C2,ker) %c是正类，d是负类,a是


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

H1=H'*F*H+C1*eye(ca+1);
 Z=-C2*(H1\(G'*v2));
 r=size(Z,1);
    w1=Z(1:r-1,1);
    b1=Z(r,1);
 fval2=1/2*(H*Z)'*F*(H*Z)+C2*v2'*(e2+G*Z)+C1*(norm(w1)^2+b1^2);



fval1=0;
iter1=0;
iter2=0;
fv= fval2;
smallval=1e-4; 
%while abs(fval2-fval1)>0.05 && iter1<100 ||iter1==0
 %   fval1=fval2;
%     r=size(Z,1);
%     w1=Z(1:r-1,1);
%     b1=Z(r,1);
    %calculate v2
    J=mean(abs(e2+d*w1+e2*b1));
    for i=1:rb
        if abs(1+d(i,:)*w1+b1)>=J
           v2(i,1)=1e-4;
        else
           v2(i,1)=1; 
        end
    end
    
    noise_b1=max(abs(c*w1+e1*b1));
    for i=1:ra
         if abs(c(i,:)*w1+b1)<noise_b1
          F(i,i)=1/sqrt((c(i,:)*w1+b1)^2+smallval);
        else
          F(i,i)=smallval; 
        end
    end
    H1=H'*F*H+C1*eye(ca+1);
    Z=-C2*(H1\(G'*v2));
      r=size(Z,1);
    w1=Z(1:r-1,1);
     b1=Z(r,1);

    fval2=1/2*(H*Z)'*F*(H*Z)+C2*v2'*(e2+G*Z)+C1*(norm(w1)^2+b1^2);
    
   fv=[fv;fval2];
 iter1=iter1+1;
%end


%fv
%fval2=e2'*alpha-1/2*alpha'*Q*alpha;
%fprintf(1,'\n==============================================');






end








