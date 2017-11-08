#using Base.Test

#include("../perfutil.jl")


function col_means(my_m, n_iter)
	local m1
    for i = 1:n_iter
        m1 = mean(my_m, 1);
    end
    # just a little junk code to use m
    #m1 = m1 + 1;
end

function col_means2(my_m, n_iter)
	local m1, v1, nrows
	nrows =  size(my_m, 1);
	v1 = fill( 1 ./ nrows, 1, nrows);  # pre-instantiate averaging vector
    for i = 1:n_iter
        m1 = v1 * my_m;
   end
    # just a little junk code to use m
    #m1 = m1 + 1;
end

function row_means(my_m, n_iter)
	local m1
    for i = 1:n_iter
        m1 = mean(my_m, 2);  # take row means?
    end
    # just a little junk code to use m
    #m1 = m1 + 1;
end

function row_means2(my_m, n_iter)
	local m1, v1, ncols
	ncols =  size(my_m, 2);
	v1 = fill( 1 ./ ncols, ncols, 1);
   for i = 1:n_iter
        m1 = my_m * v1;
    end
    # just a little junk code to use m
    #m1 = m1 + 1;
end


nrows = 13;
ncols = 36;
n_iter = 626178;  # 6,261,780 / 10  (another time SCOPE made 7,560,938 calls)
small_m = rand(nrows, ncols);  # or rand(13,36);
m_10x_rows = rand(nrows*10, ncols);  # or rand(130,36);
m_10x_cols = rand(nrows, ncols*10);  # or rand(13,360);
m_100x_cols = rand(nrows, ncols*100);  # or rand(13,360);
m_500x_cols = rand(nrows, ncols*500);  # or rand(13,360);

#  tic() toc() is for convenience only
# note the different function names differentiate them for the profiler ("Run and Time")
# all three functions are identic()al
print("Pre-allocated vectors.\n")
print("Small array, many iterations: \n   ");
tic();
col_means(small_m, n_iter*10);  # 10x iterations
toc();

print("Small array, many iterations, using matrix algebra: \n   ");
tic();
col_means2(small_m, n_iter*10);  # 10x iterations
toc();

print("10x cols, 10x fewer iterations: \n   ");
tic();
col_means(m_10x_cols, n_iter); # 10x columns
toc()

print("10x cols, 10x fewer iterations, matrix algebra: \n   ");
tic();
col_means2(m_10x_cols, n_iter); # 10x columns
toc();

print("10x rows, 10x fewer iterations: \n   ");
tic();
col_means(m_10x_rows, n_iter);  # 10x rows
toc();

print("10x rows, 10x fewer iterations, matrix algebra: \n   ");
tic();
col_means2(m_10x_rows, n_iter);  # 10x rows
toc();

print("10x rows, 10x fewer iterations, row means: \n   ");
tic();
row_means(m_10x_rows, n_iter);  # 10x rows
toc();

print("10x rows, 10x fewer iterations, row means, matrix algebra: \n   ");
tic();
row_means2(m_10x_rows, n_iter);  # 10x rows
toc();

print("100x cols, 100x fewer iterations: \n   ");
tic();
col_means(m_100x_cols, n_iter/10); # 100x columns, note that the base # of iterations is already max_iter/10 
toc();

print("100x cols, 100x fewer iterations, using matrix algebra: \n   ");
tic();
#col_means2(m_10x_cols, n_iter); # 10x columns
col_means2(m_100x_cols, n_iter/10); # 100x columns, note that the base # of iterations is already max_iter/10 
toc();


print("500x cols, 500x fewer iterations: \n   ");
tic();
col_means(m_500x_cols, n_iter/50); # 100x columns, note that the base # of iterations is already max_iter/10 
toc();

print("500x cols, 50x fewer iterations, using matrix algebra: \n   ");
tic();
#small_array_op2(m_10x_cols, n_iter); # 10x columns
col_means2(m_500x_cols, n_iter/50); # 100x columns, note that the base # of iterations is already max_iter/10 
toc();

