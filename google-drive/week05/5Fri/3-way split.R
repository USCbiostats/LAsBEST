a = data.frame(A=rnorm(102), B=sample(letters[1:2], size=102,replace=T)) # create a toy data.frame to split

n = nrow(a)  # number of rows in the full data
ntrain = floor(0.6*n)  # number of rows in the training data
ntest = floor(0.2*n)   # number of rows in the test data
nval = n - ntrain - ntest  # number of rows in the validation data

set.seed(201)  # set seed for reproducibility
splt = sample(rep(1:3, times=c(ntrain, nval, ntest))) # create a vector of 1's (60%), 2's (20%), and 3's (20%), and shuffle it randomly with 'sample'

# Split the data according to the 1's (training), 2's (validation) and 3's(test) 
a_train = a[splt ==1, ]     
a_val = a[splt ==2, ]      
a_test = a[splt ==3, ]      

dim(a_train)
