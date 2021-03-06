function Result = hibiscus_capp(Label, Inst,v,ker)% inst: 训练数据，Method:学习方法默认SSVM, Type:模式选择，默认UD

RIndex = 1:length(Label);%即样本的个数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k=1;
        for i=-7:7
            C1Grid(1,k)=i;
            %C2Grid(1,k)=i;
            k=k+1;
        end
        
  
    [ic1,noise_c1,noise_c2,w1,w2,bias1,bias2] = GridExplore(Label, Inst, C1Grid,C1Grid,v,ker);
    Best_C1 = 2^C1Grid(1,ic1);
Best_noise1=noise_c1;
Best_noise2=noise_c2;
% Result structure

Result.Best_C1 = Best_C1;
%Result.Best_C2 = Best_C2;


Result.noise_c1=Best_noise1;
Result.noise_c2=Best_noise2;


Result.w1=w1;
Result.w2=w2;
Result.bias1=bias1;
Result.bias2=bias2;

clear functions;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ic1,noise_c1,noise_c2,w1,w2,bias1,bias2] = GridExplore(Label, Inst, C1,C2,v,ker)
maxerror=200;

[m1] = size(C1,2); 
[m2] = size(C2,2); 

TErr =0;
VErr =0;
flag = 0;


E=[0.001,0.005,0.01,0.02,0.03,0.04,0.05,0.1,0.2]; %实验证明取0.05和0.005的效果比较好
for i=1:m1
   
    for j=1:9
        
       for k=1:9       
           % Model = K_capped_svm_train(Label,Inst,2^C1(1,i),2^C1(1,i),0.05,0.005,v,ker);  
            Model = K_capped_svm_train(Label,Inst,2^C1(1,i),2^C1(1,i),E(j),E(k),v,ker);  
            VErr=Model.Err.Validation(1);
            
            if VErr<maxerror
                maxerror=VErr;
                ic1=i;%ic2=j;
                 noise_c1=Model.noise_c1;
                noise_c2=Model.noise_c2;
                w1=Model.w1';
                w2=Model.w2';
               bias1=Model.b1;
               bias2=Model.b2;
                
            end 
               
      end
    end
end


    


