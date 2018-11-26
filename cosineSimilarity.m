   
    %cossine Similarity of two vectors, as long as nVector, vVector are vectors,
    %whatever Vector, vVector are column vectors or row vectors, 
    %that is, n . v / |n| |v|
    function sim = cosineSimilarity( nVector, vVector )
      epslion = 0.0000000001; %to avoid being divided by zero
      sim = sum( nVector(:) .* vVector(:) ) / ...
                     ( sqrt( nVector(:)' * nVector(:) )  *   sqrt( vVector(:)' * vVector(:) + epslion) );
    end


% C version 
% 	int j;
% 	double v = 0;%note here is not v = hy->theta[0]
% 	double normX = 0; double normY = 0;
% 	for ( j = 1; j <= NUM_OF_FEATURE; j++) %not from theta[0]
% 	{
% 		v += hy1->theta[j] * hy2->theta[j];
% 		normX += hy1->theta[j] * hy1->theta[j];
% 		normY += hy2->theta[j] * hy2->theta[j];
% 	}
% 	normX = sqrt( normX );% standard deviation
% 	normY = sqrt( normY );% standard deviation
% 
% 
% 	double result = ( (double)v ) / ( normX *  normY);
% 	 % [-1,1] -> [0,1], this is similarity measure
% 	%change result to abs(result), because there has minus value sometimes, but the directions of two normal vectors do not really matter 
% 	%if we care only about the angle between two hyperplanes(normal vectors), cos(theta) = -0.5 is same with cos(theta) = 0.5
% 	%but if we don't change minus value to positive value, it will cause sum error when we calculate the total similairty (needs sum over some measure )
