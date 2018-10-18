% w1=ones(ca,1);
% w2=ones(cb,1);
% b1=1;
% b2=1;
% F=eye(ra);
% D=eye(rb);
% R=D;
% for i=1:ra
%     if abs(c(i,:)*w1+b1)<C1
%        F(i,i)=1/abs(c(i,:)*w1+b1);
%     else
%         F(i,i)=0;
%     end
% end
% 
% % for i=1:rb
% %     if abs(d(i,:)*w1+b1)<C2
% %        D(i,i)=1/abs(d(i,:)*w1+b1);
% %     else
% %         D(i,i)=0;
% %     end
% % end
% 
% H1=H'*F*H+1e-7*eye(ca+1);
% Q=G*(H1\G');
% Q=(Q+Q')/2;
% alpha=qpSOR(Q,0.7,inf,0.05);
% fval2=-e2'*alpha+1/2*alpha'*Q*alpha;
% fval1=0;
% while abs(fval2-fval1)>0.05 &&iter1<100
%     fval1=fval2;
%     Z=-(H1\(G'*alpha));
%     r=size(Z,1);
%     w1=Z(1:r-1,1);
%     b1=Z(r,1);
%     for i=1:ra
%     if abs(c(i,:)*w1+b1)<C1
%        F(i,i)=1/abs(c(i,:)*w1+b1);
%     else
%         F(i,i)=0;
%     end
%     end
%     H1=H'*F*H+1e-7*eye(ca+1);
% Q=G*(H1\G');
% Q=(Q+Q')/2;
% alpha=qpSOR(Q,0.7,inf,0.05);
% fval2=-e2'*alpha+1/2*alpha'*Q*alpha;
%  iter1=iter1+1;
%     
% end
% 
% 
% for i=1:rb
%     if abs(d(i,:)*w2+b2)<C2
%        R(i,i)=1/abs(d(i,:)*w2+b2);
%     else
%         R(i,i)=0;
%     end
% end
% 
% G1=G'*R*G+1e-7*eye(cb+1);
% P=H*(G1\H');
% P=(P+P')/2;
% alpha2=qpSOR(P,0.7,inf,0.05);   
% fval3=0;
% fval4=-e1'*alpha2+1/2*alpha2'*P*alpha2;
% while abs(fval4-fval3)>0.05 &&iter2<100
%     fval3=fval4;
%     Z2=-G1\(H'*alpha2);
%     r2=size(Z2,1);
%     w2=Z2(1:r2-1,1);
%     b2=Z2(r2,1);
%     for i=1:rb
%     if abs(d(i,:)*w2+b2)<C2
%        R(i,i)=1/abs(d(i,:)*w2+b2);
%     else
%         R(i,i)=0;
%     end
%     end
%   G1=G'*R*G+1e-7*eye(cb+1);
% P=H*(G1\H');
% P=(P+P')/2;
% alpha2=qpSOR(P,0.7,inf,0.05);   
% fval4=-e1'*alpha2+1/2*alpha2'*P*alpha2;
%     iter2=iter2+1;
% end