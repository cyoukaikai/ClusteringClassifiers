%==============================================
%step 1: load data and split them into cells 
%========================================================
clc; clear; close all;
addpath('mlclass-ex2')

D = load('data/vowelRandom.txt');
%%D = load('data/FacialData3Person-AUSU.txt'); %//3 randomly chosen individuals' data are divided into 12 datasets, based on the method same as how to divede the vowel datasets.
%%D = load('data/FacialData-100.txt');    %100 individuals are divided into 90 pieces.
%%D = load('data/FacialData6DeliberateAndUndeliberate6Person.txt');   


datasetIDs = unique( D(:,end) );
datasetNum = length( datasetIDs );
m = size(D,2) - 2; %numofFeature 
 
Omega = cell(datasetNum,1); %the cells to store each dataset

for i = 1 : datasetNum
	Omega{i} = D( D(:,end) == i , 1:end-1); %disgard the dataset ID
end
disp(['Omega includes ' num2str(datasetNum) ' datasets']);


classIDs = unique( D(:,end-1) );
classNum = length( classIDs );
if ( length( classIDs ) == 2 )
    disp('Check the dataset, it should  be a multi-class problem...');
elseif ( length( classIDs ) > 2 )
    disp('A multiple classes problem, the class labels are supposed to start from 1, e.g., 1, 2 ,3 ... The real class label are');
end
display(classIDs);


%===============================================================================
%Step 2. calculate hyperplanes for each dataset 
%==============================================================================
%For one-vs-all (multi-class problem), hyperplane is of size [classNum, m + 1]; 
%For one-vs-one  (multi-class problem), hyperplane is of size [classNum, classNum, m + 1],
%since we have to save the hyperplanes of each pairs of binary classes


%%-------------------------------------
%%one-vs-all
%%
%%-------------------------------------
hypers = zeros( classNum, m + 1); 
for i = 1 : datasetNum
    X =  Omega{i}(:, 1: end-1); 
    for j = 1 : classNum
        y = Omega{i}(:, end);
        y( y == j ) = 1; % reset the class labels to 1
        y( y ~= j ) = 0;  % reset the class labels to 0
        hypers(j, :) = calHyperplane(X, y); 
    end
    hyperplanes_onevsall{i} = hypers;
end
fprintf('one-vs-all : Calculate hyperplanes over.\n');




tStart = tic;
dissimilarity = zeros( datasetNum, datasetNum );
classNum = size( hyperplanes_onevsall{1}, 1); 
for i = 1 : datasetNum - 1
    hypers1 = hyperplanes_onevsall{i};

    for j = i + 1 : datasetNum
        hypers2 = hyperplanes_onevsall{j};
        for k = 1 : classNum
            nVector = hypers1(k, 2:end);
            vVector = hypers2(k, 2:end); %normal vector should exclude the theta(1).

            dissimilarity(i,j) = dissimilarity(i,j) +  ...
                ( 1 - ( cosineSimilarity( nVector, vVector ) + 1 ) / 2 );
        end
    end
end
normalizeFactor = classNum;
dissimilarity = dissimilarity / normalizeFactor;
toc(tStart)
fprintf('one-vs-all: Calculate cossineSimilarity over.\n');

%%figure,
%%bar3(dissimilarity);

    
%%
%% % % %  one-vs-one
%% hyperplanes = cell(datasetNum,1); 
%%
%% for i = 1 : datasetNum
%%     X =  Omega{i}(:, 1: end-1); y = Omega{i}(:, end);
%%     hypers = zeros( classNum, classNum, m + 1);
%%      for j = 1 : classNum -1 % we do not need loop to classNum
%%          for k = j + 1 : classNum 
%%             ind = find(y == j | y == k); 
%%             X_data = X(ind,:); 
%%             y_data = y(ind);
%%             y_data( y_data == j ) = 1; % map the one class to 1
%%             y_data( y_data == k ) = 0;  % map the other class to 0
%%             hypers(j,k,:) = calHyperplane(X_data , y_data); 
%%          end
%%      end
%%      hyperplanes{i} = hypers; 
%% end
%% fprintf('one-vs-one : Calculate hyperplanes over.\n');
%% 
%% 
%% %estimate the dissimilarity
%% tStart = tic;
%% dissimilarity = zeros( datasetNum, datasetNum );
%%  for i = 1 : datasetNum - 1
%%     hypers1 = hyperplanes{i};
%%     for j = i + 1 : datasetNum
%%         hypers2 = hyperplanes{j};
%%         for k = 1 : classNum - 1
%%             for l = k + 1 : classNum
%%                 nVector = hypers1(k, l, 2:end);
%%                 vVector = hypers2(k, l, 2:end); %normal vector should exclude the theta(1).
%% 
%%                 dissimilarity(i,j) = dissimilarity(i,j) +  ...
%%                      ( 1 - ( cosineSimilarity( nVector, vVector ) + 1 ) / 2 );
%%             end
%%         end
%%     end
%% end
%% 
%% %normalize the dissimilarity
%% normalizeFactor = classNum * (classNum - 1) / 2
%% dissimilarity = dissimilarity / normalizeFactor;
%% fprintf('one-vs-one : Calculate cossineSimilarity over.\n');

 
    