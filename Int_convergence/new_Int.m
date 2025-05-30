%Compute new Interaction strength's for next simulation
T = 0.03;
Contact_ex = load('contact_exp.txt');
dat = getfield(load('contactN_t_matrix.mat'),'contactN');
      
%B represent the contact number array for the current iteration
Contact_avg = mean(dat);
% Int.txt is the interaction from the current iteration
Int = load('Int.txt'); 

C= cov(dat,1); 
cross_linked_pairs = [2, 3, 4, 5, 6, 7, 8, 9, 10, 14, 17, 18, 24, 31, 50, 56, 57, 58, 62, 68, 77, 89, 94, 97, 103, 109, 117];
C_crosslinked = C(cross_linked_pairs, cross_linked_pairs);


[V,D] = eig(C_crosslinked);
iD = inv(D);
for i = 1:length(D)
    if abs(iD(i,i)) > 1000
       iD(i,i)= 0;
    end
end

iC = V*iD*inv(V);

delta = Contact_avg' - Contact_ex;
delta_crosslinked = delta(cross_linked_pairs);

%updating interaction strengtg new_int and write them into newInt.txt
Int_crosslinked = Int(cross_linked_pairs);
new_int_crosslinked = Int_crosslinked - (iC*delta_crosslinked)*T;
er = sum(abs(delta_crosslinked))/sum(Contact_ex(cross_linked_pairs));


err_max = 0;
for i = 1:length(delta)
    err = abs(delta(i)/Contact_ex(i));
    if err > err_max
       err_max = err;
    end
end

Int(cross_linked_pairs) = new_int_crosslinked; 

fileID = fopen('newInt.txt','w');
fprintf(fileID,'%6.3f \n',Int);
fclose(fileID);

fileID2 = fopen('error.txt','w');
fprintf(fileID2,'%7.4f',er);
fclose(fileID2);

fileID3 = fopen('error_max.txt','w');
fprintf(fileID3,'%7.4f',err_max);
fclose(fileID3);
