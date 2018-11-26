clc; clear; close all;

addpath('mlclass-ex2')
%===============================================================================
%step 1. load data and split them into cells 
%The datasetID is the last column, and classID is the last but one column. 
%If your data format is different, a pre-processing may be needed.
%===============================================================================

D = load('data/SyntheticAll.txt');
datasetIDs = unique( D(:,end) );
datasetNum = length( datasetIDs );
Omega = cell(datasetNum,1); %the cells to store each dataset

for i = 1 : datasetNum
	Omega{i} = D( D(:,end) == i , 1:end-1); %disgard the dataset ID
end
display(['Omega includes ' num2str(datasetNum) ' datasets']);

%estimate the number of classes
classIDs = unique( D(:,end-1) );
classNum = length( classIDs );
if length( classIDs ) > 2
    display('Check the dataset, it should not be a multi-class problem...');
elseif ( length( classIDs ) == 2 )
    display('A binary classes problem, the class labels are supposed to be 0 , 1. The real class label are'); 
end
display(classIDs);


%===============================================================================
%Step 2. calculate hyperplanes for each dataset 
%For binary class dataset, a hyperplane is of size [1, m + 1], where m is the
%mumber of features, e.g., x0 + a * x1 +  b * x2 + c * x3 + ... = 0. Note that
%the first element of the hyperplane is the biase term.
%==============================================================================
hyperplanes = cell(datasetNum,1); % each cell store the hyperplane(s) of the separate dataset.
m = size(D,2) - 2; %numofFeature
for i = 1 : datasetNum
    X =  Omega{i}(:, 1: end-1); y =  Omega{i}(:, end);
    hypers = calHyperplane( X, y ); 
    hyperplanes{i} = hypers;
end
fprintf('Binary-class dataset: Calculate hyperplanes over.\n');


%========================================================
%step 3: %calculate the dissimilarity of our method and Tsoumakas' method  
%=========================================================== 
%tThere are two variants of cosine similarity proposed in the paper, a) 1 - abs( f(n,v) )
% b) 1 - ( f(n,v) - (-1) ) / 2 , i.e., 1 - ( f(n,v) + 1 ) / 2, where f(n,v) 
%means the original cosine similarity of two vectors n and v. 
%that is, n . v / |n| |v|
%For a), it returns the absolute value of the cossin similarity, i.e., we 
%restrict the angle of two normal vector to be in [0,90] degree. However, this method
%regard natetively related classifiers as similary and thus be clustered into one group
%For b), it maps the original cosine similarity (of range [-1,1]) to [0,180] degree
%In this script, we use b) as our cosinSimilarity measure.

dissimilarities = cell(2,1); %we change the similary to dissimilarity for later clustering purpose.
tStart = tic;
dissimilarity = zeros( datasetNum, datasetNum );
for i = 1 : datasetNum - 1 %for one dataset
    nVector = hyperplanes{i}(2:end); %normal vector should exclude the theta(1).
    for j = i + 1 : datasetNum
            vVector = hyperplanes{j}(2:end);
            
            %1 - ( f(n,v) + 1 ) / 2 
            dissimilarity(i,j) = 1 - ( cosineSimilarity( nVector, vVector ) + 1 ) / 2;
    end
end

toc(tStart);
fprintf('binary dataset: Calculate cossineSimilarity over.\n');

%note that, dissimilarity(i,j) is the dissimilarity between dataset i and dataset j.


##h = figure;
##bar3(dissimilarity); %this doesnot work in Octave
%name = ['synthetic' '_cosine_similarity.jpg'];
%saveas(h,name,'jpg')


    
 
