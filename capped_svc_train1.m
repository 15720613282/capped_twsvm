function [w1,w2,b1,b2,noise_c1,noise_c2] = capped_svc_train1(c,d,C1,C2,ratio1,ratio2,ker) %c是正类，d是负类,a是
D1=eye(size(c,1));
D2=eye(size(d,1));
[ra,ca]=size(c);
[rb,cb]=size(d);

e1=ones(ra,1);
e2=ones(rb,1);
v1=e2;
v2=e1;
%if strcmp(ker.type,'lin')
        H=[c,e1];
        G=[d,e2];
%     else
%         X=[c;d];
%         H=[kernelfun(c,ker,X),e1];
%         G=[kernelfun(d,ker,X),e2];
%          c=kernelfun(c,ker,X);
%         d=kernelfun(d,ker,X);
% end




       
    
%初始化
D=eye(rb);%损失A
F=eye(ra);%正则化A
R=D;%正则化B
S=F;%损失B



HH=H'*F*H;
H1=HH+1e-7*eye(size(HH));
Q=G*(H1\G')+1/C1*D;
Q=(Q+Q')/2;
%Q(Q<0.00001)=1e-5;

 alpha=qpSOR(Q,0.7,C1,0.05);
%[alpha,fval]=quadprog(-Q,e2,[],[],[],[],bud,[]);
Z=-(H1\G')*alpha;
    r=size(Z,1);
    w1=Z(1:r-1,1);
    b1=Z(r,1);
    

u1=e2+G*Z;
fval2=1/2*(H*Z)'*F*(H*Z)+C1/2*u1'*D*u1;

fval1=0;
iter1=0;
iter2=0;
fv=[];
fv=fval2;
smallval=1e-6; 
small=1e-5;
%while abs(fval2-fval1)>0.05 && iter1<35 ||iter1==0
 while abs(fval2-fval1)>0.001 && iter1<35 ||iter1==0

    fval1=fval2;
    nc=abs(c*w1+e1*b1);
    dist1=sqrt(nc.^2+smallval);   
    nc2=sort(dist1);
    cper=fix(ra*ratio1);
    noise_c1=nc2(end-cper,1);
    F1=1./dist1;
    nois= dist1>=noise_c1;
     F1(nois,1)=small;
     F=diag(F1);
     

     l1=e2+d*w1+e2*b1;
     rd=sqrt(l1.^2+smallval);
     
    loss1=mean(rd);
    D1=1./rd;
 
     nois2=rd>=loss1;
     D1(nois2,1)=small;
     D=diag(D1);
     
   
    
   HH=H'*F*H;
   H1=HH+1e-7*speye(size(HH));
   DD=(C1*D1).^-1;
   Q=G*(H1\G')+diag(DD);
   Q=(Q+Q')/2;
  % Q(Q<0.00001)=1e-5;
  
alpha=qpSOR(Q,0.7,C1,0.05);

    Z=-(H1\G')*alpha;
    r=size(Z,1);
    w1=Z(1:r-1,1);
    b1=Z(r,1);
   
 u1=e2+G*Z;
 fval2=1/2*(H*Z)'*F*(H*Z)+C1/2*u1'*D*u1;
   
   fv=[fv;fval2];
 iter1=iter1+1;
end




GG=G'*R*G;
G1=GG+1e-7*eye(size(GG));
P=H*(G1\H')+1/C2*S;
P=(P+P')/2;

alpha2=qpSOR(P,0.7,C2,0.05);
%[alpha2,fval]=quadprog(-P,e1,[],[],[],[],bud2,[]);
Z2=(G1\H')*alpha2;
    r2=size(Z2,1);
    w2=Z2(1:end-1,1);
    b2=Z2(r2,1);

u2=e1-H*Z2;
fval4=1/2*(G*Z2)'*R*(G*Z2)+C2/2*u2'*S*u2;
fval3=0;

%while abs(fval4-fval3)>0.05 && iter2<35 ||iter2==0
 while abs(fval4-fval3)>0.001 && iter2<35 ||iter2==0
    fval3=fval4;
     nr=abs(d*w2+e2*b2);
 
 
    dist2=sqrt(nr.^2+smallval);
    nr2=sort(dist2);
    cper=fix(rb*ratio2);
    noise_c2=nr2(end-cper,1);
    
 
    R1=1./dist2;
    nois3= dist2>=noise_c2;
    R1(nois3,1)=small;
     R=diag(R1);
    

     l2=e1-c*w2-e1*b2;
     rs=sqrt(l2.^2+smallval);
     
   
      S1=1./rs;
      loss2=mean(rs);
      nois4=rs>=loss2;
      S1(nois4,1)=small;
     S=diag(S1);
     
      
   GG=G'*R*G;
   G1=GG+1e-7*eye(size(GG));
   SS=(C2*S1).^-1;
   P=H*(G1\H')+diag(SS);
   P=(P+P')/2;
  
 alpha2=qpSOR(P,0.7,C2,0.05);
 %[alpha2,fval]=quadprog(-P,e1,[],[],[],[],bud2,[]);
 Z2=(G1\H')*alpha2;
    r2=size(Z2,1);
    w2=Z2(1:end-1,1);
    b2=Z2(r2,1);
    
   u2=e1-H*Z2;
fval4=1/2*(G*Z2)'*R*(G*Z2)+C2/2*u2'*S*u2;  
 iter2=iter2+1;
end


end








