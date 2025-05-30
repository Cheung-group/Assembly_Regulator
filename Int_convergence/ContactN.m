tic
%define number of particles np
np = 15;
L = 20;
cutoff = 1.2;
cut_lennard = 2.5;
%Loading the trjectories for 15 tupes of particles
trj_list = cell(1, np);
trj_size = zeros(1, np);

% Loop through the files from 'A' to 'O'
for i = 1:np
    % Generate filename dynamically. 'A' + i - 1 gives the ASCII value of the letter.
    % char function converts ASCII value back to character.
    fileName = sprintf('equil%d.txt',i);
    
    % Load the trajectory
    currentTrj = load(fileName);
    
    % Store the loaded trajectory in the cell array
    trj_list{i} = currentTrj;
    
    % Calculate and store the size of the trajectory
    [s, ~] = size(currentTrj);
    trj_size(i) = s;
end

% Assign np to your desired endpoint in the alphabet
labels = char(65:64+np);


%count the number of particles for each type in each frame. nA means an
%array of counts in every frame, etc. 
for i = 1:length(labels)
    alphabet = labels(i);
    count = 0;
    count_list = [];
    line_i = 1;
    trj = trj_list{i};
    while line_i < trj_size(i)
        line_i = line_i + 1;
        if trj(line_i,1)==0
            count_list = [count_list,count];
            count = 0;
        else
            count = count + 1;
        end
    end
    count_list = [count_list,count];
    eval(['n',alphabet,'=count_list;'])
end

frame_no = length(nA);
count_whole = cell(1, np);

% Loop through the alphabets from 'A' to 'O'
for i = 1:np
    % Dynamically generate the variable name
    varName = sprintf('n%c', char('A' + i - 1));
    
    % Use eval to access the variable by name and store its value
    count_whole{i} = eval(varName);
end


% calculate intersect in each frame within the same type of particles.
% Intersect AA is an array of the number of intersects between A and A in
% every time frame, etc. 
for m = 1:length(labels)
    alphabet = labels(m);
    intersect_framelist = zeros(length(frame_no));
    contact_deg_framelist = zeros(length(frame_no));
    i = 1;
    frame_no = 0;
    s1 = trj_size(m);
    trj1 = trj_list{m};
    n1 = count_whole{m};
    while i <= s1
        frame_no = frame_no + 1;
        N1 = n1(frame_no);
        intersect = 0;
        contact_deg = 0;
        for j = i+1:i+N1-1
            for k = j+1:i+N1
                deltax = abs(trj1(j,3)-trj1(k,3));
                deltay = abs(trj1(j,4)-trj1(k,4));
                deltaz = abs(trj1(j,5)-trj1(k,5));
                deltax = min(deltax, L-deltax);
                deltay = min(deltay, L-deltay);
                deltaz = min(deltaz, L-deltaz);
                dist = sqrt((deltax)^2+(deltay)^2+(deltaz)^2);
                if dist < cutoff
                    intersect = intersect + 1;
                end
               if dist < cut_lennard
                    contact_deg = contact_deg + 1/dist^6;
               end 
            end
        end
        k = i + N1; %make sure that k got updated if the for loop didn't run due to N1 being 0
        intersect_framelist(frame_no) = intersect;
        contact_deg_framelist(frame_no) = contact_deg;
        i = k + 1;
    end
    %eval([alphabet,alphabet,'=intersect_framelist;'])
    eval([alphabet,alphabet,'=contact_deg_framelist;'])
end

% calculate intersect in each frame in difference types of particles, similar to the previous.  
for m = 1:length(labels)
    alphabet1 = labels(m);
    for n = m+1:length(labels)
        alphabet2 = labels(n);
        intersect_framelist = zeros(length(frame_no));
        i = 1;
        l = 1;
        frame_no = 0;
        s1 = trj_size(m);
        trj1 = trj_list{m};
        trj2 = trj_list{n};
        n1 = count_whole{m};
        n2 = count_whole{n};
        while i <= s1
            frame_no = frame_no + 1;
            N1 = n1(frame_no);
            N2 = n2(frame_no);
            intersect = 0;
            contact_deg = 0;
            for j = i+1:i+N1
                for k = l+1:l+N2
                    deltax = abs(trj1(j,3)-trj2(k,3));
                    deltay = abs(trj1(j,4)-trj2(k,4));
                    deltaz = abs(trj1(j,5)-trj2(k,5));
                    deltax = min(deltax, L-deltax);
                    deltay = min(deltay, L-deltay);
                    deltaz = min(deltaz, L-deltaz);
                    dist = sqrt((deltax)^2+(deltay)^2+(deltaz)^2);
                    %if dist < cutoff
                        %intersect = intersect + 1;
                    %end
                    if dist < cut_lennard
                        contact_deg = contact_deg + 1/dist^6;
                    end 
                end
            end
            j = i + N1;
            k = l + N2; %make sure j and k got updated if the for loop didn't run due to N1 or N2 being 0
            %intersect_framelist(frame_no) = intersect;
            contact_deg_framelist(frame_no) = contact_deg;
            i = j + 1;
            l = k + 1;
        end
        %eval([alphabet1,alphabet2,'=intersect_framelist;'])
        eval([alphabet1,alphabet2,'=contact_deg_framelist;'])
    end
end


%calcualte the contact nnumber matrix, where column represents contact
%numbers and row represents time frames
contactN = zeros;
n = 0;
for i = 1:length(labels)
    alphabet_i = labels(i);
    for j = i:length(labels)
        n = n+1; 
        alphabet_j = labels(j);
        Contact_list = eval([alphabet_i,alphabet_j]);
        for t = 1:length(Contact_list)
            contactN(t,n) = Contact_list(t);
        end
    end
end

%save the Contact matrix into a file
save('contactN_t_matrix.mat', 'contactN');
Contact_avg = mean(contactN);

fileID3 = fopen('avg_contactN.txt','w');
fprintf(fileID3,'%6.3f \n',Contact_avg);
fclose(fileID3);
toc
