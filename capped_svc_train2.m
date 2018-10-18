function [w1,w2,b1,b2,noise_b1,noise_b2] = capped_svc_train2(c,d,C1,C2,C3,C4,ker) %c是正类，d是负类,a是


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
    



% H=[c e1];
% G=[d e2];

% H=[k1 e1];
% G=[k2 e2];

       
    
%初始化
D=eye(rb);%损失A
F=eye(ra);%正则化A
R=D;%正则化B
S=F;%损失B
CC_a=D*ones(rb,1);
CC_b=F*ones(ra,1);
D2=ones(rb,1);
D3=ones(ra,1);

v2=e2;
v1=e1;

H1=H'*F*H+1e-7*eye(ca+1);
 Z=-C2*(H1\(G'*v2));
 r=size(Z,1);
    w1=Z(1:r-1,1);
    b1=Z(r,1);
 fval2=1/2*(H*Z)'*F*(H*Z)+C1*v2'*(e2+G*Z);
%Z=-(H1\(G'*v2));
%fval2=1/2*(H*Z)'*F*(H*Z)+v2'*(e2+G*Z);



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
    %J=mean(abs(e2'+w1'*k2'+e2'*b1));
    for i=1:rb
        if abs(1+d(i,:)*w1+b1)>=J
         %if abs(1+w1'*k2(i,:)'+b1)>=J
           v2(i,1)=1e-4;
        else
           v2(i,1)=1; 
        end
    end
    
    noise_b1=max(abs(c*w1+e1*b1));
    %J1=abs(w1'*c'+e1'*b1);
    %sort(J1,'descend');
    %CJ1=J1(5);
    %CJ1=mean(abs(w1'*k1'+e1'*b1));
    for i=1:ra
         if abs(c(i,:)*w1+b1)<noise_b1
          F(i,i)=1/sqrt((c(i,:)*w1+b1)^2+smallval);
           %F(i,i)=1/abs(c(i,:)*w1+b1);
        else
          F(i,i)=smallval; 
        end
    end
    H1=H'*F*H+1e-7*eye(ca+1);
    Z=-C1*(H1\(G'*v2));
      r=size(Z,1);
    w1=Z(1:r-1,1);
     b1=Z(r,1);

    fval2=1/2*(H*Z)'*F*(H*Z)+C1*v2'*(e2+G*Z);
    %Z=-(H1\(G'*v2));
    %fval2=1/2*(H*Z)'*F*(H*Z)+v2'*(e2+G*Z);
%     r=size(Z,1);
%     w1=Z(1:r-1,1);
%     b1=Z(r,1);
   fv=[fv;fval2];
 iter1=iter1+1;
%end


%fv
%fval2=e2'*alpha-1/2*alpha'*Q*alpha;
%fprintf(1,'\n==============================================');




G1=G'*R*G+1e-7*eye(cb+1);
 Z2=C2*(G1\(H'*v1));
  r2=size(Z2,1);
    w2=Z2(1:r2-1,1);
    b2=Z2(r2,1);


fval3=0;
fval4=1/2*(G*Z2)'*R*(G*Z2)+C2*v1'*(e1+H*Z2);
%fval4=1/2*(G*Z2)'*R*(G*Z2)+v1'*(e1+H*Z2);


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
    
   %J2=abs(w2'*d'+e2'*b2);
    %sort(J2,'descend');
    %CJ2=J2(5);
    noise_b2=max(abs(d*w2+e2*b2));
    for i=1:rb
         if abs(d(i,:)*w2+b2)<noise_b2
            R(i,i)=1/sqrt((d(i,:)*w2+b2)^2+smallval);           
             %R(i,i)=1/abs(d(i,:)*w2+b2);
         else
            R(i,i)=smallval;  
          end
    
    end
    G1=G'*R*G+1e-7*eye(cb+1);
    Z2=C2*(G1\(H'*v1));
    %Z2=-(G1\(H'*v1));
     r2=size(Z2,1);
    w2=Z2(1:r2-1,1);
    b2=Z2(r2,1);
    fval4=1/2*(G*Z2)'*R*(G*Z2)+C2*v1'*(e1+H*Z2);
    %fval4=1/2*(G*Z2)'*R*(G*Z2)+v1'*(e1+H*Z2);
   
   
 iter2=iter2+1;
%end


end








