%% this script contains the example from the paper:
% Dependency and redundancy: how information theory untangles three variable interactions in environmental data
% By Steven V, Weijs, Akhil Kumar, and Hossein Foroozand
% Submitted to Water Resources Research, 2018
%
%This file is provided to further explore the example, which is a difficult
%test case for partial information decomposition approaches.
%The idea of this example is that it provides a case where there is
%dependence between sources, but only over a range where the sources do not
%jointly inform the target variable T.
%Conversely, over the range where T is a sum of both sources, the sources
%are independent. 
%This is to highlight that dependency of variables is not a guarantee for 
%redundant influencing of a target, and to aid in developing methods of 
% estimating redundancy that can handle this behaviour.
% For more information, please contact the corresponding author of the
% article mentioned above.

clear all;

% add functions to the path that were downloaded from the "TIPNet" GIT repository
% This can be downloaded from the repository:
% https://github.com/HydroComplexity/TIPNet 
% the master folder should be added as a subfolder to the pathof this script
% the functions used are in v2, which is here added to the path:
try 
    addpath TIPNet-master\TIPNet_v2\Functions\
catch
    disp('please download the TIPNets toolbox as a subfolder and add to path');
    disp('available here: https://github.com/HydroComplexity/TIPNet');  
    disp('Also see the comments in this script');
end

% Note1: , this code is relating to the paper:
%Goodwell, A. E., & Kumar, P. (2017a). 
%Temporal information partitioning: Characterizing synergy, uniqueness, and redundancy in interacting environmental variables. 
%Water Resources Research, 53(7), 5920–5942. doi:10.1002/2016WR020216
%Note2: the only functions used from the TIPNets toolbox by Goodwell and Kumar are : 
%compute_pdf_fixedbins.m
%compute_info_measures.m
%These can be found under the follwing direct links:
%https://github.com/HydroComplexity/TIPNet/blob/master/TIPNet_v2/Functions/compute_pdf_fixedbins.m
%https://github.com/HydroComplexity/TIPNet/blob/master/TIPNet_v2/Functions/compute_info_measures.m


% Note:for figure in the paper N=10000000 was used to reduce sampling effects. Now set to something
% 100000 to reduce memory usage
N=100000;

%initialize the signals with zeros
% Note, in the paper, sources are now called X_1 and X_2 to avoid confusion
% with S for synergy.
S1(N,1)=0; S2(N,1)=0; S3(N,1)=0; T(N,1)=0; T2(N,1)=0; Tcontrol(N,1)=0; %init for speed

%load custom colormap for the figure
load('WRRcolormap');

%% generate the signals for S1, S2 and T

p1=0.5; % allows to change the treshold (probability) for the switching behaviour of source S1. In the paper only 0.5 is used.
for n=1:N
    S1(n)=rand;
    if S1(n)<p1
        S2(n)=(1/p1)*S1(n);
        S3(n)=rand;
        T(n)=rand+rand;
        T2(n)=T(n);
    else
        S2(n)=rand;
        S3(n)=rand;
        T(n)=(1/(1-p1))*(S1(n)-p1)+S2(n);
        T2(n)=(1/(1-p1))*(S1(n)-p1)+S3(n);
    end
    Tcontrol(n)=rand+rand;

end
%


%% plot scatter plots
figure(1);
plot(S1,S2,'b.');
xlabel('S1');ylabel('S2')
figure(2);
plot(S1,T,'b.');
xlabel('S1');ylabel('T')
figure(3);
plot(S2,T,'b.');
xlabel('S2');ylabel('T')
figure(4)
plot(2*(S1-0.5)+S2,T,'b.');
xlabel('f(S1,S2)');ylabel('T')

%% plot univariate histograms:
figure(5)
subplot(2,2,1)
hist(S1,8)
subplot(2,2,2);
hist(S2,8)
subplot(2,2,3);
hist(T,8);
subplot(2,2,4);
hist(Tcontrol,8);

T_pdf_theory=[2 6 10 14 14 10 6 2]/64;   % H = 2.749 (8 bins)


%% calculate info measures

% generate discretized PDF
Apdf=compute_pdf_fixedbins([S1,S2,T],8,'global',[0, 1;0,1;0,2]');
Bpdf=compute_pdf_fixedbins([S1,S3,T2],8,'global',[0, 1;0,1;0,2]');
% 
% %% diagnostic plots
% % 2D joint distributions
% %x1 x2
%% colormap('jet');
figure(8)
MAP=WRRcolormap;
colormap(MAP);
Apdf_x1_x2=sum(Apdf,3);
Apdf_x1_y=squeeze(sum(Apdf,2));
Apdf_x2_y=squeeze(sum(Apdf,1));
%bivariate marginal histograms
%this is the code for Figure 1 of the paper
figure(6);
subplot(1,3,1);
imagesc(Apdf_x1_x2*64-0.01,[0, 4]);
colormap(MAP);
xlabel('X_2');ylabel('X_1');
title('I(X_1;X_2) = 1 bit');
subplot(1,3,2);
imagesc(Apdf_x1_y*64-0.01,[0, 4]);
colormap(MAP);
xlabel('T');ylabel('X_1');
%title('Discrete 2D joint probabilities')
title('I(X_1;T) = 0.285 bits');
subplot(1,3,3);
imagesc(Apdf_x2_y*64-0.01,[0, 4]);
colormap(MAP);
xlabel('T');ylabel('X_2');
title('I(X_2;T) = 0.27 bits');
hc=colorbar('east');
set(hc,'Ticks',[0 1 2 3 4]);
set(hc,'TickLabels',{'0' '1/64' '2/64' '3/64' '4/64'});
set(hc,'position',[0.92 0.1754 0.0167 0.7128])
%set(hc,'label','Probability')
set(get(hc,'label'),'string','Probability');

%%
% calculate info measures using GK2017 function
% these values are the basis for the table in the paper
infoA= compute_info_measures(Apdf);
infoB= compute_info_measures(Bpdf);

