# Pulsar-Classification

Dataset: ‘https://archive.ics.uci.edu/ml/datasets/HTRU2’ 

Pulsars are a type of neutron star that emit beams, which give scientific interest. Here, there is data for detecting Pulsars with 8 different variables. 
1. Mean of the integrated profile.
2. Standard deviation of the integrated profile.
3. Excess kurtosis of the integrated profile.
4. Skewness of the integrated profile.
5. Mean of the DM-SNR curve.
6. Standard deviation of the DM-SNR curve.
7. Excess kurtosis of the DM-SNR curve.
8. Skewness of the DM-SNR curve.


The Class is binary classification with 0 being negative, which means the detected star is not Pulsar and 1 being positive, which means detected star is Purlar. 

For this project, classification tree, logistic regression, boosting method, and random forest methods are used to fit and train the model, then confusion matrix is used to compare the testing error of these models. Then the best methods can be selected among all. By using the model interpretability with variable importance measures and partial dependence plots, the most important variables can be classified.
