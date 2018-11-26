# ClusteringClassifiers
Code for the paper "Clustering Classifiers Learnt from Local Datasets Based on Cosine Similarity"
Written in Octave

We used logistic regression to estimate the hyperplane of the data from two different classes. Most of the implementations are borrowed from the programming exercise of the Coursera lecture "Machine Learning" (https://www.coursera.org/learn/machine-learning by Prof. Andrew Ng).
Generally, support vector machine (SVM) works better than logistic regression in learning boundaries, so you can try SVM if you like.

We assumed the decision boundary of the data of two classes are linear. 
If this is not the case, you can extend the method by using feature mapping, kernels or other nolinear feature transformation.

The method can be applied to binary or multi-class problems.
The main files for them are binary_class_main.m and multi_class_main.m, respectively.

Please use the code freely.
