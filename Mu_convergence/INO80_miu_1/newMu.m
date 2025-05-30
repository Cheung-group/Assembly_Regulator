%Compute new mu's for next simulation

clear; 
phi=0.05;
vol=20^3;
vc=(4/3)*pi*(0.5^3);
T = 1;
xA=0.0392; xB=0.043; xC=0.1661; xD=0.2050; xE=0.0701; xF=0.0107; xG=0.0813; xH=0.0260; xI=0.0372; xJ=0.0728; xK=0.0201; xL=0.0579; xM=0.0873; xN=0.0331; xO=0.0499;
Nex = (phi*vol/vc)*[xA; xB; xC; xD; xE; xF; xG; xH; xI; xJ; xK; xL; xM; xN; xO];

dat = load('Snumber.dat');
allN = dat(:,2:16);

% Select a certain module for convergence. In individual convergence, module = single subunit type
module = [1];

C = cov(allN,1);
C = C(module, module);

N = mean(allN);
N_mod = N(module);

mu = load('mu.txt'); 

delta = N_mod' - Nex(module); 

[V,D] = eig(C);
iD = inv(D);
for i = 1:length(D)
    if iD(i,i) > 50
       iD(i,i)=0;
    end
end

iC = V*iD*inv(V);

N
C
iC
delta

new_mu_mod = mu(module) - (iC*delta)*T;
er = sum(abs(delta))/sum(Nex(module));
mu(module) = new_mu_mod;

fileID = fopen('newMu.txt','w');
fprintf(fileID,'%6.4f \n',mu);
fclose(fileID);

fileID2 = fopen('error.txt','w');
fprintf(fileID2,'%7.4f',er);
fclose(fileID2);

fileID3 = fopen('N.txt','w');
fprintf(fileID3,'%6.3f \n',N);
fclose(fileID3);
