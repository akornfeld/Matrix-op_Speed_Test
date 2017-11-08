  RT_SpeedTest <- function(){
  # Test the MATLAB trade-off between size and iterations, 
  #  using data structure and number of iterations found in RTMf.m.
  #  The "small array" case is what it was in SCOPE v1.53 before my tinkering
  #
  #  All of the subfunctions here will perform the same number of operations
  #  but the first one has 10x as many iterations in the for loop.
  #  The remaining functions try different variations on increasing the data size and decreasing loops
  # RESULTS (on my computer, MATLAB 2013b):
  #   small array: 55.7s
  #   10x cols   :  7.1s
  #   10x rows   :  7.2s
  #   10x rows*  :  7.3s (calculating row means instead of column means)
  #   100x cols  :  2.0s
  #   500x cols  :  0.8s ! (not in this file; just change 100 to 500, divide n_iter by 50 instead of 10)
  #
  # R Results (3.1.1)
  #  Small array, many iterations: 
  #     user  system elapsed 
  #    25.39    0.08   25.47 
  #  10x cols, 10x fewer iterations: 
  #     user  system elapsed 
  #     4.45    0.01    4.46 
  #  10x rows, 10x fewer iterations: 
  #     user  system elapsed 
  #     4.76    0.03    4.80 
  #  10x rows, 10x fewer iterations, row means: 
  #     user  system elapsed 
  #     9.28    0.03    9.33 
  #  100x cols, 100x fewer iterations: 
  #     user  system elapsed 
  #     2.58    0.02    2.59 
  #    500x cols, 500x fewer iterations: 
  #     user  system elapsed 
  #     2.29    0.00    2.31 
#
  nrows = 13;
  ncols = 36;
  n_iter = 626178;  # 6,261,780 / 10  (another time SCOPE made 7,560,938 calls)
  small_m     = matrix(runif(nrows * ncols), nrows, ncols);  # or rand(13,36);
  m_10x_rows  = matrix(runif(nrows*10 * ncols), nrows*10, ncols);  # or rand(130,36);
  m_10x_cols  = matrix(runif(nrows * ncols*10), nrows, ncols*10);  # or rand(13,360);
  m_100x_cols = matrix(runif(nrows * ncols*100), nrows, ncols*100);  # or rand(13,360);
  m_500x_cols = matrix(runif(nrows * ncols*500), nrows, ncols*500);  # or rand(13,360);
  
  #  tic toc is for convenience only
  # note the different function names differentiate them for the profiler ("Run and Time")
  # all three functions are identical
  cat('Small array, many iterations: \n');
  print(system.time(
  array_op(small_m, n_iter*10)  # 10x iterations
  ))

  cat('Small array, many iterations, matrix algebra colMean: \n');
  print(system.time(
  array_op2(small_m, n_iter*10)  # 10x iterations
  ))

  cat('10x cols, 10x fewer iterations: \n');
  print(system.time(
  array_op(m_10x_cols, n_iter) # 10x columns
  ))

  cat('10x cols, 10x fewer iterations, matrix algebra colMean: \n');
  print(system.time(
  array_op2(m_10x_cols, n_iter) # 10x columns
  ))

  cat('10x rows, 10x fewer iterations: \n');
  print(system.time(
  array_op(m_10x_rows, n_iter)  # 10x rows
  ))

  cat('10x rows, 10x fewer iterations, matrix algebra colMean: \n');
  print(system.time(
  array_op2(m_10x_rows, n_iter)  # 10x rows
  ))

  cat('10x rows, 10x fewer iterations, row means: \n');
  print(system.time(
  rows_array2(m_10x_rows, n_iter)  # 10x rows
  ))

  cat('10x rows, 10x fewer iterations, matrix algebra row means: \n');
  print(system.time(
  rows_op2(m_10x_rows, n_iter)  # 10x rows
  ))

  cat('100x cols, 100x fewer iterations: \n');
  print(system.time(
  array_op(m_100x_cols, n_iter/10) # 100x columns, note that the base # of iterations is already max_iter/10 
  ))
  cat('100x cols, 100x fewer iterations, matrix algebra colMean: \n');
  print(system.time(
  array_op2(m_100x_cols, n_iter/10) # 100x columns, note that the base # of iterations is already max_iter/10
  ))


  cat('500x cols, 500x fewer iterations: \n');
  print(system.time(
  array_op(m_500x_cols, n_iter/50) # 100x columns, note that the base # of iterations is already max_iter/10 
  ))

  cat('500x cols, 500x fewer iterations, matrix algebra colMean: \n');
  print(system.time(
  array_op2(m_500x_cols, n_iter/50) # 100x columns, note that the base # of iterations is already max_iter/10
  ))

  
}

array_op <- function(my_m, n_iter) {  #small_
    for (i in 1:n_iter) {
        m1 <- colMeans(my_m);
    }
    # just a little junk code to use m
    #m1 = m1 + 1;
}

array_op2 <- function(my_m, n_iter) {
   # using matrix algebra
        rows <- nrow(my_m);
        v1 <- rep( 1/rows, rows);
    for (i in 1:n_iter) {
        m1 <- v1 %*% my_m;
    }
    # just a little junk code to use m
    #m1 = m1 + 1;
}

#function cols_array(my_m, n_iter) {
#    for i = 1:n_iter
#        m1 = mean(my_m, 1);
#    }
#    # just a little junk code to use m
#    #m1 = m1 + 1;
#}
#
#function cols_jumbo_array(my_m, n_iter) {
#    for i = 1:n_iter
#        m1 = mean(my_m, 1);
#    }
#    # just a little junk code to use m
#    #m1 = m1 + 1;
#}
#
#function rows_array(my_m, n_iter) {
#    for i = 1:n_iter
#        m1 = mean(my_m, 2);  # take row means?
#    }
#    # just a little junk code to use m
#    #m1 = m1 + 1;
#}
#
rows_array2 <- function(my_m, n_iter) {  #small_
    for (i in 1:n_iter) {
        m1 <- rowMeans(my_m);
    }
    # just a little junk code to use m
    #m1 = m1 + 1;
}

rows_op2 <- function(my_m, n_iter) {
   # using matrix algebra
        cols <- ncol(my_m);
        v1 <- array(rep( 1/cols, cols), c(cols, 1));
    for (i in 1:n_iter) {
        m1 <- my_m %*% v1;
    }
    # just a little junk code to use m
    #m1 = m1 + 1;
}