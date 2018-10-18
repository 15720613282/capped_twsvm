%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate m1 positive points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

m1=50;
k1=1;
b1=1;
x1=rand(m1,1);
% x1=sqrt(x1);
y1=rand(m1,1);
% y1=sqrt(y1);
x1=sort(x1);
y1=sort(y1);
y1=k1*y1+b1;
plot(x1,y1,'ko')
hold on 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate m2 negative points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

m2=50;
k2=2;
b2=2;
x2=rand(m2,1);
y2=rand(m2,1);
x2=sort(x2);
y2=sort(y2);
y2=-k2*y2+b2;
plot(x2,y2,'k+')
hold off