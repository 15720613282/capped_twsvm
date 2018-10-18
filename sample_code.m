% plot the glm fit as seen in Figure 4(a) of the paper

D = load('aaai07_humanSSL_dataset.csv');

train = 1:20;
test1 = 21:41;
test2start = 795;

C1 = D(find(D(:,1) == 1),:);
C2 = D(find(D(:,1) == 2),:);

C1sids = unique(C1(:,2));
C2sids = unique(C2(:,2));

C1T1 = [];
C1T2 = [];

for i = 1:length(C1sids)
  S = C1(find(C1(:,2) == C1sids(i)),:);

  C1T1 = [C1T1; S(test1,[3,5])];
  C1T2 = [C1T2; S(test2start:end,[3,5])];
end

C2T1 = [];
C2T2 = [];

for i = 1:length(C2sids)
  S = C2(find(C2(:,2) == C2sids(i)),:);

  C2T1 = [C2T1; S(test1,[3,5])];
  C2T2 = [C2T2; S(test2start:end,[3,5])];
end

testpoints = unique(C1T1(:,1));

for i = 1:length(testpoints)
  C1T1ppos(i,:) = length(find(C1T1(:,1) == testpoints(i) & C1T1(:,2) == 1))/length(find(C1T1(:,1) == testpoints(i)));;
  C1T2ppos(i,:) = length(find(C1T2(:,1) == testpoints(i) & C1T2(:,2) == 1))/length(find(C1T2(:,1) == testpoints(i)));;
  C2T1ppos(i,:) = length(find(C2T1(:,1) == testpoints(i) & C2T1(:,2) == 1))/length(find(C2T1(:,1) == testpoints(i)));;
  C2T2ppos(i,:) = length(find(C2T2(:,1) == testpoints(i) & C2T2(:,2) == 1))/length(find(C2T2(:,1) == testpoints(i)));;
end

figure
hold on
plot(testpoints,C1T1ppos,'k^');
plot(testpoints,C2T1ppos,'ko');
plot(testpoints,C1T2ppos,'k^','MarkerFaceColor','k')
plot(testpoints,C2T2ppos,'ko','MarkerFaceColor','k')

b = glmfit([testpoints;testpoints],[C1T1ppos ones(21,1); C2T1ppos ones(21,1)],'binomial','link','logit');
Z = 1./(1 + exp(-(b(1)+testpoints*(b(2)))));
plot(testpoints,Z,'b:');

b = glmfit([testpoints],[C1T2ppos ones(21,1)],'binomial','link','logit');
Z = 1./(1 + exp(-(b(1)+testpoints*(b(2)))));
plot(testpoints,Z,'b-');

b = glmfit([testpoints],[C2T2ppos ones(21,1)],'binomial','link','logit');
Z = 1./(1 + exp(-(b(1)+testpoints*(b(2)))));
plot(testpoints,Z,'r--');
