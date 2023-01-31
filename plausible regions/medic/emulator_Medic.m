
function[predicts,Ijs]=emulator_Medic(J,n,p,x,gx,sx,data)
predicts=zeros(n*p,J);
Ijs=zeros(n*p,J);
parfor i=1:J
  md1=fitrgp(x,gx(:,i), 'Basis','linear',...
      'FitMethod','exact','PredictMethod','exact');
  ypred= resubPredict(md1);
  predicts(:,i)=ypred;
  vs=mean(sx(:,i)); %variances due to stochastic model
  %implausibility measure:
  mes=mean(ypred);
  vc=md1.Sigma;
  Ijs(:,i)=abs(data(i)-ypred)./sqrt(vc+vs);   %implausibility measure:
end
end