function [w1,w2,b1,b2] = capped_train(c,d) %c是正类，d是负类
c=c';
d=d';

D1=eye(size(c,2));
D2=eye(size(d,2));
iter1=0;
iter2=0;
[ca,ra]=size(c);
[cb,rb]=size(d);

e1=ones(1,ra);
e2=ones(1,rb);

% H=e1*D1*e1';
% P=2*C1*e2*e2'+(C1*e2*d')*inv(c*D1*c')*(c*D1*e1');
% b1=P/H;
% w1=-1/2*(C1*e2*d'+b1*e1*D1*c')*inv(c*D1*c');
% w1=w1';
% obj2=trace((w1'*c+e1*b1)*D1*(w1'*c+e1*b1)')+C1*e2*(d'*w1+e2'*b1+e2');

% H=e1*D1*e1'+e2*e2';
% P=inv(c*D1*c'+d*d')*(c*D1*e1');
% Q=H-(e1*D1*c'+e2*d')*P;
% b1=(e2*d'*P)/Q;
% w1=(-b1*e1*D1*c'-(e2*b1+e2)*d')*inv(c*D1*c'+d*d');
% w1=w1';
% obj2=trace((w1'*c+e1*b1)*D1*(w1'*c+e1*b1)')+1/2*(w1'*d+e2*b1+e2)*(w1'*d+e2*b1+e2)';

H=e1*D1*e1'+C1*e2*e2';
P=inv(c*D1*c'+C1*d*d')*(c*D1*e1');
Q=H-(e1*D1*c'+C1*e2*d')*P;
b1=(C1*e2*d'*P)/Q;
w1=(-b1*e1*D1*c'-C1*(e2*b1+e2)*d')*inv(c*D1*c'+C1*d*d');
w1=w1';
obj2=trace((w1'*c+e1*b1)*D1*(w1'*c+e1*b1)')+C1/2*(w1'*d+e2*b1+e2)*(w1'*d+e2*b1+e2)';

obj1=0;







small_value=0.01;
%err=max(w1'*c+e1*b1);
err=T1;
while (obj2-obj1)>=small_value && iter1<100
    obj1=obj2;
    for i=1:ra
            if abs(w1'*c(:,i)+b1)<=err
                %D1(i,i)=norm(w1'*c(:,i)+b1,2)^0.25;
                D1(i,i)=abs(1/(w1'*c(:,i)+b1));
                %D1(i,i)=norm(w1'*c+b1,1);
            else
                 D1(i,i)=0;
            end
    end
% H=e1*D1*e1'+e2*e2';
% P=inv(c*D1*c'+d*d')*(c*D1*e1');
% Q=H-(e1*D1*c'+e2*d')*P;
% b1=(e2*d'*P)/Q;
% w1=(-b1*e1*D1*c'-(e2*b1+e2)*d')*inv(c*D1*c'+d*d');

    H=e1*D1*e1'+C1*e2*e2';
    P=inv(c*D1*c'+C1*d*d')*(c*D1*e1');
    Q=H-(e1*D1*c'+C1*e2*d')*P;
    b1=(C1*e2*d'*P)/Q;
    w1=(-b1*e1*D1*c'-C1*(e2*b1+e2)*d')*inv(c*D1*c'+C1*d*d');
    w1=w1'; 
    obj2=trace((w1'*c+e1*b1)*D1*(w1'*c+e1*b1)')+C1/2*(w1'*d+e2*b1+e2)*(w1'*d+e2*b1+e2)';
    
%  H=e1*D1*e1';
% P=2*C1*e2*e2'+(C1*e2*d')*inv(c*D1*c')*(c*D1*e1');
% b1=P/H;
% w1=-1/2*(C1*e2*d'+b1*e1*D1*c')*inv(c*D1*c');
% w1=w1';
% obj2=trace((w1'*c+e1*b1)*D1*(w1'*c+e1*b1)')+C1*e2*(d'*w1+e2'*b1+e2');
   
    iter1=iter1+1;
end

% H=e2*D2*e2'+e1*e1';
% P=inv(d*D2*d'+c*c')*(d*D2*e2');
% Q=H-(e2*D2*d'+e1*c')*P;
% b2=(e1*c'*P)/Q;
% w2=(-b2*e2*D2*d'-(e1*b2+e1)*c')*inv(d*D2*d'+c*c');
% w2=w2';
% obj2=trace((w2'*d+e2*b2)*D2*(w2'*d+e2*b2)')+1/2*(w2'*c+e1*b2+e1)*(w2'*c+e1*b2+e1)';

H=e2*D2*e2'+C2*e1*e1';
P=inv(d*D2*d'+C2*c*c')*(d*D2*e2');
Q=H-(e2*D2*d'+C2*e1*c')*P;
b2=(C2*e1*c'*P)/Q;
w2=(-b2*e2*D2*d'-C2*(e1*b2+e1)*c')*inv(d*D2*d'+C2*c*c');
w2=w2';
obj2=trace((w2'*d+e2*b2)*D2*(w2'*d+e2*b2)')+C2/2*(w2'*c+e1*b2+e1)*(w2'*c+e1*b2+e1)';

% H=e2*D2*e2';
% P=2*C2*e1*e1'+(C2*e1*c')*inv(d*D2*d')*(d*D2*e2');
% b2=P/H;
% w2=-1/2*(C2*e1*c'+b2*e2*D2*d')*inv(d*D2*d');
% w2=w2';
% obj2=trace((w2'*d+e2*b2)*D2*(w2'*d+e2*b2)')+C2*e1*(c'*w2+e1'*b2+e1');


obj1=0;
err=T2;
while (obj2-obj1)>=small_value && iter2<100
    obj1=obj2;
    for i=1:rb
             if abs(w2'*d(:,i)+b2)<=err
            %if norm(w2'*d(:,i)+b2,1)<=0.5*err
                %D2(i,i)=norm(w2'*d(:,i)+b2,2)^0.25;
                D2(i,i)=abs(1/(w2'*d(:,i)+b2));
                %D2(i,i)=norm(w2'*d+b2,1);
            else
                 D2(i,i)=0;
            end
    end
    H=e2*D2*e2'+e1*e1';
% P=inv(d*D2*d'+c*c')*(d*D2*e2');
% Q=H-(e2*D2*d'+e1*c')*P;
% b2=(e1*c'*P)/Q;
% w2=(-b2*e2*D2*d'-(e1*b2+e1)*c')*inv(d*D2*d'+c*c');
% w2=w2';
% obj2=trace((w2'*d+e2*b2)*D2*(w2'*d+e2*b2)')+1/2*(w2'*c+e1*b2+e1)*(w2'*c+e1*b2+e1)';

   H=e2*D2*e2'+C2*e1*e1';
P=inv(d*D2*d'+C2*c*c')*(d*D2*e2');
Q=H-(e2*D2*d'+C2*e1*c')*P;
b2=(C2*e1*c'*P)/Q;
w2=(-b2*e2*D2*d'-C2*(e1*b2+e1)*c')*inv(d*D2*d'+C2*c*c');
w2=w2';
obj2=trace((w2'*d+e2*b2)*D2*(w2'*d+e2*b2)')+C2/2*(w2'*c+e1*b2+e1)*(w2'*c+e1*b2+e1)';

% H=e2*D2*e2';
% P=2*C2*e1*e1'+(C2*e1*c')*inv(d*D2*d')*(d*D2*e2');
% b2=P/H;
% w2=-1/2*(C2*e1*c'+b2*e2*D2*d')*inv(d*D2*d');
% w2=w2';
% obj2=trace((w2'*d+e2*b2)*D2*(w2'*d+e2*b2)')+C2*e1*(c'*w2+e1'*b2+e1');

iter2=iter2+1;
end
  


