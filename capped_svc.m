function [w1,w2,b1,b2] = capped_svc(c,d,C1,C2,noise_c1,noise_c2,w1,w2,b1,b2,ker) %c是正类，d是负类,a是

D1=eye(size(c,1));
D2=eye(size(d,1));
[ra,ca]=size(c);
[rb,cb]=size(d);

e1=ones(ra,1);
e2=ones(rb,1);
v1=e2;
v2=e1;

   %核函数     
 %if strcmp(ker.type,'lin')
        H=[c,e1];
        G=[d,e2];
%     else
%         X=[c;d];
%         H=[kernelfun(c,ker,X),e1];
%         G=[kernelfun(d,ker,X),e2];
%         c=kernelfun(c,ker,X);
%         d=kernelfun(d,ker,X);
%  end


       
    
%初始化
D=eye(rb);%损失A
F=eye(ra);
R=D;
S=F;
fval1=0;
iter1=0;
iter2=0;

smallval=1e-6; 
small=1e-5;

    CF=abs(c*w1+e1*b1);  
    dist1=sqrt(CF.^2+smallval);
    F1=1./dist1;
    nois= dist1>=noise_c1;
    F1(nois,1)=small;
     F=diag(F1); 

l1=e2+d*w1+e2*b1;
sd=sqrt(l1.^2+smallval);
loss1=mean(sd);
D1=1./sd;

nois2= sd>=loss1;
D1(nois2,1)=small;
 D=diag(D1);
    
   HH=H'*F*H;
   H1=HH+1e-7*eye(size(HH));
   DD=(C1*D1).^-1;
   Q=G*(H1\G')+diag(DD);
   Q=(Q+Q')/2;
   
   
   alpha=qpSOR(Q,0.7,C1,0.05);
   
   Z=-(H1\G')*alpha;
    r=size(Z,1);
    w1=Z(1:r-1,1);
    b1=Z(r,1);
   
   u1=e2+G*Z;
fval2=1/2*(H*Z)'*F*(H*Z)+C1/2*u1'*D*u1;


fv=fval2;

%while abs(fval2-fval1)>0.05 && iter1<35 ||iter1==0
 while abs(fval2-fval1)>0.001 && iter1<35 ||iter1==0   
     fval1=fval2; 
     CF=abs(c*w1+e1*b1);
     dist1=sqrt(CF.^2+smallval);
     F1=1./dist1;
     
    nois= dist1>=noise_c1;
    F1(nois,1)=small;
     F=diag(F1); 

l1=e2+d*w1+e2*b1;
sd=sqrt(l1.^2+smallval);
loss1=mean(sd);
D1=1./sd;

nois2= sd>=loss1;
D1(nois2,1)=small;
 D=diag(D1);
    
   HH=H'*F*H;
   H1=HH+1e-7*eye(size(HH));
   DD=(C1*D1).^-1;
   Q=G*(H1\G')+diag(DD);
   Q=(Q+Q')/2;
   
   
   alpha=qpSOR(Q,0.7,C1,0.05);
   
    Z=-(H1\G')*alpha;
    r=size(Z,1);
    w1=Z(1:r-1,1);
    b1=Z(r,1);
    
    u1=e2+G*Z;
    fval2=1/2*(H*Z)'*F*(H*Z)+C1/2*u1'*D*u1;
 iter1=iter1+1;
end


CR=abs(d*w2+e2*b2);
dist2=sqrt(CR.^2+smallval);
R1=1./dist2;

nois3= dist2>=noise_c2;
R1(nois3,1)=small;
R=diag(R1);
  
 
l2=e1-c*w2-e1*b2;
sr=sqrt(l2.^2+smallval);
loss2=mean(sr);
S1=1./sr;
nois4=sr>=loss2;
S1(nois4,1)=small;
S=diag(S1);

   GG=G'*R*G;
   %G1=GG;
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




 fval3=0;
fv2=fval4;
% while abs(fval4-fval3)>0.05 && iter2<35 ||iter2==0
  while abs(fval4-fval3)>0.001 && iter2<35 ||iter2==0
     fval3=fval4;
     CR=abs(d*w2+e2*b2);
     dist2=sqrt(CR.^2+smallval);
     R1=1./dist2;
    nois3= dist2>=noise_c2;
    R(nois3,1)=small;
     R=diag(R1);
  
 
   l2=e1-c*w2-e1*b2;
   sr=sqrt(l2.^2+smallval);
   loss2=mean(sr);

   S1=1./sr;
   nois4= sr>=loss2;
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
  fv2=[fv2;fval4]; 
 iter2=iter2+1;
 end
 

end








