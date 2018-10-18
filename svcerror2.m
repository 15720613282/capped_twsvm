function [err ]= svcerror2(w1,w2,bias1,bias2,xtest,ytest)
%TWSVM

%     da=ytest;
%      PoIndex=(find(ytest~=1));
%      da(PoIndex)=-1;   
      p1=abs(xtest*w1+bias1);
      %p2=abs(xtest*w2+bias2);
 [min_p,predictedY]=min(p1,[],2);
   

 err = sum(predictedY ~= ytest);


  
   
   
% for i=1:n
%     if p1(i,i)<p2(i,1)
%         predictedY(i,1)=n;
%     else
%           predictedY(i,1)=ytest(i);
%     end
% end
% 
%     err = sum(predictedY ~= ytest);