function visual_contour(trainX,w,r,a,str)
% Reference ========================
% visual_contour(trainX,w,r,a)
% trainX:   the samples,whose row vector consponds to a sample.
% w     :   normal vector of hyperplane w'x+b = 0
% r     :   threshold of the hyperplane
% a     :   the axis grid of the plot
% hyperplane: w'x+r=0, where r = -w'*m, m means centre of the samples
% % ================================


% plot(trainX(:,1),trainX(:,2),'bo');
hold on
% axis = axis + ([-1 1 -1 1]);
% axis( axis + [-1 1 -1 1]);
temp1 = trainX(:,1);
temp2 = trainX(:,2);
a = [min(temp1),max(temp1),min(temp2),max(temp2)];
[x,y] = meshgrid( a(1)-2 : (a(2)-a(1))/20 : a(2)+2, a(3)-2 : (a(4)-a(3))/20 : a(4)+2 );
X2    = [reshape(x,prod(size(x)),1) reshape(y,prod(size(x)),1)];
r_vector   = X2*w + repmat(r,prod(size(x)),1);
r     = reshape(r_vector,size(x));
contour(x,y,r,[+0 +0],str);
box off

return