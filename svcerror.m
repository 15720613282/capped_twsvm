function [err ]= svcerror(w1,w2,bias1,bias2,xtest,ytest,C,ker)
 mm = length(ytest);
 % if strcmp(ker.type,'lin')
      
     p1=abs(xtest*w1+bias1);
     p2=abs(xtest*w2+bias2);
%      w11=sqrt(w1'*w1);
%      w22=sqrt(w2'*w2);
%      p1=p1/w11;
%      p2=p2/w22; 
        
        for i=1:mm
            if p1(i,1)<p2(i,1)
                predictedY(i,1)=1;
            else
                  predictedY(i,1)=-1;
            end
        end


%   else
%      xtest=kernelfun(xtest,ker,C); 
%      
%      % p1=abs(xtest*w1+bias1);
%      % p2=abs(xtest*w2+bias2);
%   w11=sqrt(w1'*kernelfun(C,ker,C)*w1);
%   w22=sqrt(w2'*kernelfun(C,ker,C)*w2);
%   y1=xtest*w1+bias1*ones(mm,1);
%   y2=xtest*w2+bias2*ones(mm,1);
%   p1=y1/w11;
%   p2=y2/w22;
%   predictedY=sign(abs(p2)-abs(p1));
%   end
   
%    mm = length(ytest);
% for i=1:mm
%     if p1(i,1)<p2(i,1)
%         predictedY(i,1)=1;
%     else
%           predictedY(i,1)=-1;
%     end
% end

% figure
%  hold on     
%   plot(xtest*w1+bias1,'*b');
%   plot(xtest*w2+bias2,'*r');

    err = sum(predictedY ~= ytest);


