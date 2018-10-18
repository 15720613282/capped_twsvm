function [w1,w2,b1,b2,noise_c1,noise_c2] = capped_svc_train(c,d,C1,C2,ker) %c是正类，d是负类,a是

D1=eye(size(c,1));
D2=eye(size(d,1));
[ra,ca]=size(c);
[rb,cb]=size(d);

e1=ones(ra,1);
e2=ones(rb,1);

 %核函数
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


       
    
%初始化
D=eye(rb);%损失A
F=eye(ra);%正则化A
R=D;%正则化B
S=F;%损失B
CC_a=D*ones(rb,1);
CC_b=F*ones(ra,1);
D2=ones(rb,1);
D3=ones(ra,1);


GG=G'*D*G;
HH=H'*F*H;
ZH=C1*GG+1e-7*eye(size(GG))+HH+1e-7*eye(size(HH));
Z=-C1*ZH\(G'*D*e2);
fval2=C1*(G*Z+e2)'*D*(G*Z+e2)+(H*Z)'*F*(H*Z);
% H1=H'*F*H+1e-7*eye(ca+1);
% Q=G*(H1\G');
% Q=(Q+Q')/2;


 %alpha=qpSOR(Q,0.7,C1,0.05);

%  c1 = -ones(rb,1);  
% % %c1=-(e2'+e2'*D*G*(H1\G'));
%      vlb = zeros(rb,1);      % Set the bounds: alphas >= 0
%      vub = 2*ones(rb,1);     %                 alphas <= C
% %     vub=inf*ones(rb,1);
%   a=sparse(1,rb);
%       [res]=mskqpopt(Q,c1,a,[],[],vlb,vub,[],'minimize echo(0)');
%   alpha=res.sol.itr.xx;
%fval2=-e2'*alpha+1/2*alpha'*Q*alpha;

fval1=0;
iter1=0;
iter2=0;
fv=[];
fv=fval2;
smallval=0.0001; 
%F0=zeros(ra,ra);
while abs(fval2-fval1)>0.05 && iter1<100 ||iter1==0
    fval1=fval2;
    %Z=-H1\(G'*alpha);
    r=size(Z,1);
    w1=Z(1:r-1,1);
    b1=Z(r,1);
    noise_c1=max(abs(c*w1+e1*b1));
    %noise_b1=max(abs(e2+d*w1+e2*b1));
%      J1=abs(c*w1+e1*b1);
%      sort(J1,'descend');
%     
%     %把%的数据作为噪声
%     sumcount1=ceil(ra*0.05);
%     noise_c1=J1(sumcount1);
%     
    for i=1:ra
%         if norm((c(i,:)*w1+b1),2)<C1
%             F(i,i)=1/norm(c(i,:)*w1+b1,2);
        if abs(c(i,:)*w1+b1)<noise_c1
         % F(i,i)=1/sqrt((c(i,:)*w1+b1)^2+smallval);
          F(i,i)=1/sqrt((c(i,:)*w1+b1)^2+smallval);
           
        else
          F(i,i)=smallval; 
          %F(i,i)=1/sqrt((c(i,:)*w1+b1)^2+C1);
        end
    end
    
%     for j=1:rb
%         if abs(d(j,:)*w1+b1+1)<noise_b1
%             D(j,j)=1/abs(1+d(j,:)*w1+b1);
%         else
%            D(j,j)=1/(1+d(j,:)*w1+b1)^2; 
%         end
%    end

 GG=G'*D*G;
HH=H'*F*H;
ZH=C1*GG+1e-7*eye(size(GG))+HH+1e-7*eye(size(HH));
Z=-C1*ZH\(G'*D*e2);
r=size(Z,1);
    w1=Z(1:r-1,1);
    b1=Z(r,1);
fval2=C1*(G*Z+e2)'*D*(G*Z+e2)+(H*Z)'*F*(H*Z);  

   

   fv=[fv;fval2];
 iter1=iter1+1;
end


%fv

%fval2=e2'*alpha-1/2*alpha'*Q*alpha;
%fprintf(1,'\n==============================================');



% G1=G'*R*G+1e-7*eye(cb+1);
% %G1=G'*G+1e-7*eye(cb+1);
% P=H*(G1\H');
% P=(P+P')/2;

GG2=G'*R*G;
HH2=H'*S*H;
ZH2=C2*HH2+1e-7*eye(size(GG2))+GG2+1e-7*eye(size(HH2));
Z2=C2*ZH2\(H'*S*e1);
fval4=C2*(e1-H*Z2)'*S*(e1-H*Z2)+(G*Z2)'*R*(G*Z2);



%fval1=0;
%alpha2=quadprog(P,-e1,[],[],[],[],0,2);

%alpha2=qpSOR(P,0.7,C2,0.05);
%  c2 = -ones(ra,1);  
% % % c2=-(e1'+e1'*S*H*G1*H');
%       vlb = zeros(ra,1);      % Set the bounds: alphas >= 0
%       vub = 2*ones(rb,1);     %                 alphas <= C
% %      vub=inf*ones(ra,1);
%    a=sparse(1,ra);
%        [res]=mskqpopt(P,c2,a,[],[],vlb,vub,[],'minimize echo(0)');
%    alpha2=res.sol.itr.xx;
fval3=0;

while abs(fval4-fval3)>0.05 && iter2<100 ||iter2==0
    fval3=fval4;
    r2=size(Z2,1);
    w2=Z2(1:end-1,1);
    b2=Z2(r2,1);
    noise_c2=max(abs(d*w2+e2*b2));
     %noise_b2=max(abs(e1-c*w2-e1*b2));
%     J2=abs(d*w2+e2*b2);
%      sort(J2,'descend');
%     
%     %把%的数据作为噪声
%     sumcount2=ceil();
%     noise_c2=J2(sumcount2);
    for i=1:rb
%         if norm(d(i,:)*w2+b2,2)<C2
%            R(i,i)=1/norm(d(i,:)*w2+b2,2);
         if abs(d(i,:)*w2+b2)<noise_c2
            %R(i,i)=1/sqrt((d(i,:)*w2+b2)^2+smallval);           
             R(i,i)=1/sqrt((d(i,:)*w2+b2)^2+smallval); 
         else
            R(i,i)=smallval;  
%             R(i,i)=1/sqrt((d(i,:)*w2+b2)^2);
          end
    end
    
%     for j=1:ra
%         if abs(1-(c(j,:)*w2+b2))<noise_b2
%             S(j,j)=1/abs(1-c(j,:)*w2-b2); 
%         else
%             S(j,j)=1/(1-c(j,:)*w2-b2)^2; 
%         end
%     end
    
GG2=G'*R*G;
HH2=H'*S*H;
ZH2=C2*HH2+1e-7*eye(size(GG2))+GG2+1e-7*eye(size(HH2));
Z2=C2*ZH2\(H'*S*e1);
r2=size(Z2,1);
    w2=Z2(1:end-1,1);
    b2=Z2(r2,1);
fval4=C2*(e1-H*Z2)'*S*(e1-H*Z2)+(G*Z2)'*R*(G*Z2);



   
 iter2=iter2+1;
end


end








