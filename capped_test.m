%�������ݷ���class2��

clear
load  class2/australian.mat;%(-)
B=[A];

cla=1;   
A=B(1:end,2:end);
 Max=max(max(A));
 Min=min(min(A));
 A=2*(A-Min)./(Max-Min)-1;
d=(B(1:end,1)==cla)*2-1;

ker.type='lin';
ker.pars=1e-2;
k=10;output=1;
a=50;%input('the state=');
rand('state',a);
%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��Ϊ������
%     rand('state',a);
% 
% 
%     uniqued = unique(d);
%     outratio=0.25;
%     nf=0.1;
%     for jjk=1:size(uniqued,1) %%%%%%partion points of each class into k parts.
%         Inde=(find(d==uniqued(jjk,1)));
%         randn('state',jjk*1000);
%         %randn('state',a);
%         outn=fix(size(Inde,1)*outratio);
%         Mm= sqrt(1)*randn(outn,size(A,2));
%         %Ctrain(Inde(1:outn,:),:)=Ctrain(Inde(1:outn,:),:)+nf*(norm(Ctrain(Inde(1:outn,:),:),'fro')/norm(Mm,'fro'))*Mm;
%         A(Inde(1:outn,:),:)=A(Inde(1:outn,:),:)+nf*(norm(A(Inde(1:outn,:),:),'fro')/(norm(Mm,'fro')+eps))*Mm;
% %         if jjk==1
% %         tempdata=Ctrain(Inde(1:outn,:),:);
% %         end
%     end
%     r=randperm(size(A,1));
%     d=d(r,:);
%     %r2=randperm(size(Ctrain,1));
%     A=A(r,:);
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




r=randperm(size(d,1));
dd=d(r,:);
AA=A(r,:); 
dtrain=dd(1:fix(size(r,2)),:);
Ctrain=AA(1:fix(size(r,2)),:);  

 Result=hibiscus_capp(dtrain,Ctrain,k,ker);
  C1=Result.Best_C1; 
  C2=Result.Best_C1;
   best_noise_c1=Result.noise_c1;
   best_noise_c2=Result.noise_c2;
    w1=Result.w1;
    w2=Result.w2;
    bias1=Result.bias1;
    bias2=Result.bias2;   
    
 %%%%%%%%%%%%%%%%%%%%%%%%%%% 


  


[sm sn]=size(A);
cpu_time = 0;
indx = [0:k];
indx = floor(sm*indx/k);    %last row numbers for all 'segments'
%split trainining set from test set

trainCorr=0;
testCorr=0;

a=20;%input('the state=');
rand('state',a);
r=randperm(size(d,1));
d=d(r,:);
A=A(r,:); 


for i = 1:k
    
Ctest = []; dtest = [];Ctrain = []; dtrain = [];

Ctest = A((indx(i)+1:indx(i+1)),:);
dtest = d(indx(i)+1:indx(i+1));
Ctrain = A(1:indx(i),:);
Ctrain = [Ctrain;A(indx(i+1)+1:sm,:)];
dtrain = [d(1:indx(i));d(indx(i+1)+1:sm,:)];

   
r=find(dtrain>0);
r1=setdiff(1:length(Ctrain(:,1)),r);
Y1=dtrain(r,:);
Y2=dtrain(r1,:);
cc=Ctrain(r,:);
dd=Ctrain(r1,:);
e1=ones(size(cc,1),1);
e2=ones(size(dd,1),1);
tic
    
    [w1,w2,bias1,bias2]=capped_svc(cc,dd,C1,C2,best_noise_c1,best_noise_c2,w1,w2,bias1,bias2,ker);
    


thistoc(i,1)=toc;


C=[cc;dd];

[err ]= svcerror(w1,w2,bias1,bias2,Ctest,dtest,C,ker);
tmpTestCorr(i,1)=1-err/length(Ctest(:,1));


[err ]= svcerror(w1,w2,bias1,bias2,Ctrain,dtrain,C,ker);
tmpTrainCorr(i,1)=1-err/length(Ctrain(:,1));

 if output==1
fprintf(1,'________________________________________________\n');
fprintf(1,'Fold %d\n',i);
fprintf(1,'Training set correctness: %3.2f%%\n',tmpTrainCorr(i,1));
fprintf(1,'Testing set correctness: %3.2f%%\n',tmpTestCorr(i,1));

fprintf(1,'Elapse time: %10.4f\n',thistoc(i,1));
 end

end % end of for (looping through test sets)



     trainCorr = sum(tmpTrainCorr*100)/k;
     testCorr = sum(tmpTestCorr*100)/k;
     cpu_time=sum(thistoc)/k;
    

if output == 1
fprintf(1,'==============================================');
fprintf(1,'\nTraining set correctness: %3.2f%%',trainCorr);
fprintf(1,'\nTesting set correctness: %3.2f%%',testCorr);

fprintf(1,'\nAverage cpu_time: %10.4f\n',cpu_time);
end

testcorrstd=std(100*tmpTestCorr,1)








