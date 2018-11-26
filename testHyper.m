

%==============================================
%% step 1
%load data and split them into cells 
%========================================================
%Note : in this section, the datasetID column is the last col, and class ID column is
%the last but one col, if the data to load do not satisfy this, a pre-processing 
%step must be performed
clc; clear; close all;
dataID = 4;
datasetName = {'vowel', 'facial3', 'facial100','facial4'};
% datasetLocation = {'data/vowelRandom.txt', 'data/FacialData3Person-AUSU.txt', ...
%     'data/FacialData-100','data/FacialData-DeliberateAndUndeliberate4Person.txt'}; %FacialData6DeliberateAndUndeliberate6Person
datasetLocation = {'data/vowelRandom.txt', 'data/FacialData3Person-AUSU.txt', ...
    'data/FacialData-100','data/FacialData6DeliberateAndUndeliberate6Person.txt'};


D = load( datasetLocation{dataID} );
% D = load('data/FacialData3Person-AUSU.txt'); %//3 randomly chosen individuals' data are divided into 12 datasets, based on the method same as how to divede the vowel datasets.
% D = load('data/FacialData-100.txt');    %100 individuals are divided into 90 pieces.
% D = load('data/FacialData6DeliberateAndUndeliberate6Person.txt');   
%  %undeliberate facial expression data, only the results of the first 4 persons are used in my paper
fprintf('------------------------------------------\n');
display([datasetName{dataID} ]); 
fprintf('------------------------------------------\n');

datasetIDs = unique( D(:,end) );

datasetNum = length( datasetIDs );
if (dataID == 4)
    datasetNum = 4; %ignore the last two datasets
    datasetIDs(1:4);
end

Omega = cell(datasetNum,1); %the cells to store each dataset

for i = 1 : datasetNum
	Omega{i} = D( D(:,end) == i , 1:end-1); %disgard the dataset ID
end
display(['Omega includes ' num2str(datasetNum) ' datasets']);


classIDs = unique( D(:,end-1) );
classNum = length( classIDs );
if ( length( classIDs ) == 2 )
    display('Check the dataset, it should  be a multi-class problem...');
elseif ( length( classIDs ) > 2 )
    display('A multiple classes problem, the class labels are supposed to start from 1, e.g., 1, 2 ,3 ... The real class label are');
end
display(classIDs);


m = size(D,2) - 2; %numofFeature

%% 3.2 one vs one
%calculate hyperplanes for each dataset with respect to the data type (binary class, multiple class).
%for multiple classes problem, one-vs-all, one-vs-one are supposed to perform.
%Note: because we use the sigmoid function, so we need to map all the classes to
%0 and 1
% 

hyperplanes = cell(datasetNum,1); % each cell store the hyperplane(s) of the separate dataset.
%for binary class dataset, hyperplane is of size [1, m + 1], where m is the
%mumber of features, for one-vs-all strategy multi-class problem,
%hyperplane is of size [classNum, m + 1]; for one-vs-one  strategy     
%multi-class problem, hyperplane is of size [classNum, classNum, m + 1],
%because we have to save the hyperplanes of each pairs of binary classes


m = size(D,2) - 2; %numofFeature 
for i = 1 : datasetNum
    X =  Omega{i}(:, 1: end-1); y = Omega{i}(:, end);
    hypers = zeros( classNum, classNum, m + 1);
     for j = 1 : classNum -1 % we do not need loop to classNum
         for k = j + 1 : classNum 
            ind = find(y == j | y == k); y_pair = y(ind);
%             y_pair( y_pair == j ) = 1; % map the one class to 1
%             y_pair( y_pair == k ) = 0;  % map the other class to 0
            
            y_pair( y_pair == j ) = 0; % map the one class to 1
            y_pair( y_pair == k ) = 1;  % map the other class to 0
            hypers(j,k,:) = calHyperplane( X(ind,:), y_pair); 
         end
     end
     hyperplanes{i} = hypers; 
end
fprintf('one-vs-one : Calculate hyperplanes over.\n');



hyperplanesLoad = cell(datasetNum,1);
for i = 1 : datasetNum
    X =  Omega{i}(:, 1: end-1); y = Omega{i}(:, end);
    hypers = zeros( classNum, classNum, m + 1);
     for j = 1 : classNum -1 % we do not need loop to classNum
         for k = j + 1 : classNum 
            ind = find(y == j | y == k); y_pair = y(ind);
%             y_pair( y_pair == j ) = 1; % map the one class to 1
%             y_pair( y_pair == k ) = 0;  % map the other class to 0
            
            y_pair( y_pair == j ) = 1; % map the one class to 1
            y_pair( y_pair == k ) = 0;  % map the other class to 0
            hypers(j,k,:) = calHyperplane( X(ind,:), y_pair); 
         end
     end
     hyperplanesLoad{i} = hypers; 
end
fprintf('one-vs-one : Calculate hyperplanes over.\n');

% 
% 
% % hyperplanesLoad = cell(datasetNum,1);
% 
% hyperMulti = load('data/MultipleHypers.txt');
% for i = 1 : size(hyperMulti)
%     datasetID = hyperMulti(i,1); c1 =  hyperMulti(i,2);  c2 =  hyperMulti(i,3);
%     hyperplanesLoad{ datasetID }(c1,c2,:) = hyperMulti(i,4:end);
% end
% % hyperplanes = hyperplanesLoad;


for i = 1 : datasetNum
    similarity = zeros( classNum, classNum ); 
     for j = 1 : classNum -1 % we do not need loop to classNum
         for k = j + 1 : classNum 
            nVector = hyperplanes{i}(j,k, 2:end);
            cVector = hyperplanesLoad{i}(j,k, 2:end);
            similarity(j,k) = ( cossineSimilarity(  ...
                     nVector(:), ...
                     cVector(:) ...
                     ) + 1 ) / 2 ; 
         end
     end
    similarity
end


% m = size(D,2) - 2; %numofFeature 
% for i = 1 : datasetNum
%     X =  Omega{i}(:, 1: end-1); y = Omega{i}(:, end);
%     hypers = zeros( classNum, classNum, m + 1);
%      for j = 1 : classNum -1 % we do not need loop to classNum
%          for k = j + 1 : classNum 
%             ind = find(y == j | y == k); y_pair = y(ind);
%             y_pair( y_pair == j ) = 0; % map the one class to 1
%             y_pair( y_pair == k ) = 1;  % map the other class to 0
% %             hypers(j,k,:) = calHyperplane( X(ind,:), y_pair); 
%             theta = hyperplanes{i}(j,k,:);
%             data = X(ind,:);
%             data = [ones(size(data,1), 1) X(ind,:)];
%             p = predict(theta(:), data);
% 
%             fprintf('Test Accuracy: %f\n', mean(double(p == y_pair)) * 100);
% 
%          end
%      end
%      hyperplanes{i} = hypers; 
% end
% fprintf('one-vs-one : Calculate hyperplanes over.\n');


