# importing the needed libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.tree import DecisionTreeClassifier, plot_tree
from sklearn.metrics import classification_report, confusion_matrix , accuracy_score
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import GridSearchCV, train_test_split

dataset = pd.read_csv('C:/Users/mushi/Downloads/lahman/deliverables/taska_extracted.csv') #change it to your own directory

# Divide data into attributes and labels 
A = dataset.drop(['inducted','playerID'], axis=1)
A['debut'] = pd.DatetimeIndex(A['debut']).year
A['finalGame'] = pd.DatetimeIndex(A['finalGame']).year

# Filling any nulls with 0 incase the SQL script missed any (due to inconsistencies with the lahman DB)
t = ['Years_Batted','totGB', 'totRB', 'totHB', 'tot2B', 'tot3B', 'totHRB', 'totSOB', 'Years_Pitched', 'totGP', 'totW', 'totL', 'totIPOuts', 'totHP', 'totRP', 
     'totER', 'totBB', 'totSOP', 'totHRP', 'Years_Fielded', 'totGF', 'totA', 'totPO', 'totE', 'totDP', 'totPB', 'totCS', 'totInnOuts',
     'totSB', 'deathYear', 'debut' , 'finalGame']
A[t] = A[t].fillna(0)

B = dataset['inducted']

# Split testing and training to 20% and 80%, respectively
A_train, A_test, B_train, B_test = train_test_split(A, B, test_size=0.20)

# First test of the Decision Tree and model
# Decision Tree and plot tree
clf = DecisionTreeClassifier()
clf.fit(A_train, B_train)
plot_tree(clf,max_depth=4, fontsize=10)

# Predict method of classifier 
B_pred = clf.predict(A_test)

# Calculate metrics
print('Model before hyperparameter tuning')
print('---------------------------------------------------------------')
print('Confusion Matrix \n' , confusion_matrix(B_test, B_pred))
print('---------------------------------------------------------------')
print('Classification Report')
print(classification_report(B_test, B_pred))


# Create dictionary that the Grid Search will use as performance metrics to evaluate the best hyperparamters in fitting
param_dict = {
     "criterion":['gini','entropy'],
     "max_depth": range(1,10),
     "min_samples_split": range(1,10),
     "min_samples_leaf" : range(1,5)
 }

# After initially creating a DecisionTree model, we use the default scoring to fit the object. Using the param_dict, we will find the best fit for the model. 
# GridSearch allows us to test Multiple parameters in one go
grid = GridSearchCV(clf, param_grid = param_dict, cv = 10, verbose = 1, n_jobs = 1)
grid.fit(A_train, B_train)

# Using the previous code we query for the best parameters
grid.best_params_

# The best estimator to use for our thing
best_estim = grid.best_estimator_

# Find the average best score of this model.
grid.best_score_

# Redo the model to evaluate it 
clf = DecisionTreeClassifier(ccp_alpha=0.0, class_weight=None, criterion='gini',
                       max_depth=7, max_features=None, max_leaf_nodes=None,
                       min_impurity_decrease=0.0, min_impurity_split=None,
                       min_samples_leaf=4, min_samples_split=9,
                       min_weight_fraction_leaf=0.0, presort='deprecated',
                       random_state=None, splitter='best')
clf_fit = clf.fit(A_train, B_train)
fig, ax = plt.subplots(figsize=(12, 12))
plot_tree(clf_fit)
plt.show
plt.tight_layout

# Predict method of classifier 
B_pred = clf.predict(A_test)

# Calculate metrics
print('Model before hyperparameter tuning')
print('---------------------------------------------------------------')
print('Confusion Matrix \n' , confusion_matrix(B_test, B_pred))
print('---------------------------------------------------------------')
print('Classification Report')
print(classification_report(B_test, B_pred))
