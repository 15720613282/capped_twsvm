function model=K_capped_svm_train(label, Inst, C1,C2,ratio1,ratio2,v,ker)



 model = svm(label,Inst,C1,C2,ratio1,ratio2,v,ker);

%==========================================================================

VErrList=0; TErrList=0; w1=0;w2=0;bias1=0;bias2=0;

function model=svm(d,A,C1,C2,ratio1,ratio2,v,ker)

[sm sn]=size(A);

indx = [0:v];
indx = floor(sm*indx/v);
best_noise1=0;
best_noise2=0;
best_TErr=1;
for i = 1:v
Ctest = []; dtest = [];Ctrain = []; dtrain = [];

Ctest = A((indx(i)+1:indx(i+1)),:);
dtest = d(indx(i)+1:indx(i+1));
Ctrain = A(1:indx(i),:);
Ctrain = [Ctrain;A(indx(i+1)+1:sm,:)];
dtrain = [d(1:indx(i));d(indx(i+1)+1:sm,:)];


r=find(dtrain>0);%正类的元素
r1=setdiff(1:length(Ctrain(:,1)),r);%负类的元素
Y1=dtrain(r,:);
Y2=dtrain(r1,:);
cc=Ctrain(r,:);
dd=Ctrain(r1,:);

C=[cc;dd];


[w1,w2,bias1,bias2,noise_c1,noise_c2]=capped_svc_train1(cc,dd,C1,C2,ratio1,ratio2,ker);

train_w1(i,:)=w1';
train_w2(i,:)=w2';
train_b1(i)=bias1;
train_b2(i)=bias2;
train_noise1(i)=noise_c1;
train_noise2(i)=noise_c2;
[err ]= svcerror(w1,w2,bias1,bias2,Ctest,dtest,C,ker);
VErrList(i)=err/length(Ctest(:,1));


[err ]= svcerror(w1,w2,bias1,bias2,Ctrain,dtrain,C,ker);
 TErrList(i)=err/length(Ctrain(:,1));


end
   
         model.Err.Training=mean(TErrList);
      model.Err.Validation=mean(VErrList);
      model.noise_c1=mean(train_noise1);
      model.noise_c2=mean(train_noise2);
        model.w1=mean(train_w1);
         model.w2=mean(train_w2);
         model.b1=mean(train_b1);
         model.b2=mean(train_b2);
    

    
      

              
        



