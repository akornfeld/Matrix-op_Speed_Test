function RT_SpeedTest()
% Test the MATLAB trade-off between size and iterations, 
%  using data structure and number of iterations found in RTMf.m.
%  The "small array" case is what it was in SCOPE v1.53 before my tinkering
%
%  All of the subfunctions here will perform the same number of operations
%  but the first one has 10x as many iterations in the for loop.
%  The remaining functions try different variations on increasing the data size and decreasing loops
% RESULTS (on my computer, MATLAB 2013b, with profiler running):
%   small array: 55.7s
%   10x cols   :  7.1s
%   10x rows   :  7.2s
%   10x rows*  :  7.3s (calculating row means instead of column means)
%   100x cols  :  2.0s
%   500x cols  :  0.8s !
% Without profiler it's a bit faster:
%     Small array, many iterations: 
%        Elapsed time is 40.299573 seconds.
%     10x cols, 10x fewer iterations: 
%        Elapsed time is 5.583096 seconds.
%     10x rows, 10x fewer iterations: 
%        Elapsed time is 5.523173 seconds.
%     10x rows, 10x fewer iterations, row means: 
%        Elapsed time is 5.549131 seconds.
%     100x cols, 100x fewer iterations: 
%        Elapsed time is 1.745658 seconds.
%     500x cols, 500x fewer iterations: 
%        Elapsed time is 0.749448 seconds.
nrows =  13; % 60; %
ncols = 36;  %50;  %
%  NOTE: SCOPE 1.62 does 49*2*211 = 20,678 "iterations" (w/o BRDF) on 60 x 468 (13*36) matrices
n_iter = 626000; %626178;  % 6,261,780 / 10   % 21000; %
small_m = rand(nrows, ncols);  % or rand(13,36);
m_10x_rows = rand(nrows*10, ncols);  % or rand(130,    36);
m_10x_cols = rand(nrows, ncols*10);  % or rand( 13,   360);
m_50x_cols = rand(nrows, ncols*50);  % or rand( 13,  1800);
m_100x_cols = rand(nrows, ncols*100);  % or rand(13, 3600);
m_500x_cols = rand(nrows, ncols*500);  % or rand(13,18000);
m_1000x_cols = rand(nrows, ncols*1000);  % or rand(13,  36,000);
m_10000x_cols = rand(nrows, ncols*10000);  % or rand(13,  360,000);

% %Variations on 3D array processing
% small_m_1 = small_m; %m_10x_cols;
% small_m_3 = repmat(small_m_1, 1, 1, 10);
% 
% % mean, removing 3rd dim:
% fprintf('3D array, mean: \n   ');
% tic;
% mm1 = mean3(small_m_3, n_iter);   % 3.8 s for 60*50*10 (and n_iter*10)
% toc
% 
% % mean, removing 3rd dim w/ matrix op: -- 4x slower!
% fprintf('3D array, mean w/ matrix op: \n   ');
% tic;
% mm2 = mean_matop(small_m_3, n_iter);   % 13 s for 60*50*10
% toc
% fprintf('max err: %g\n', max(max(abs(mm1 - mm2))))
% return
% 
% % 1. Nested FOR loop (timing in 2013b on CIW computer)
% fprintf('3D array, nested for: \n   ');
% tic;
% forop(small_m_3, small_m_1, n_iter);   % 23 s for 13x36x10
% toc
% 
% % 2. BSXFUN - not very impressive!
% fprintf('3D array, bsxfn: \n   ');
% tic;
% bsxop(small_m_3, small_m_1, n_iter);   % 13 s for 13x36x10;  85 s for 13x360x10
% toc
% 
% %3. convert to 2D, repmat second arg to match, do A .* B:  QUITE A DIFFERENCE!
% %   but effect of reshape in loop is not consistent with SCOPE experience (or maybe we just do way fewer iterations, since it's all already vectorized)
% fprintf('3D->2D array, repmat .*: \n   ');
% %           only multiply in loop:            1.7 s 13x360!!;  16 s for 13x3600
% %           all reshape and repmat in loop:  11   s 13x360
% %           reshape-only in loop:             6   s
% %           reshape in loop w/o intermediate var: 8.5 s
% tic;
% matop(small_m_3, small_m_1, n_iter);
% toc
% 
% return


% fprintf('Powers \n')
% tic();
% powers(small_m, 100000); % 100,000 iterations
% powers(m_100x_cols, 1000);
% powers(m_500x_cols, 1000/5);
% toc()
% return

%  tic toc is for convenience only
% note the different function names differentiate them for the profiler ("Run and Time")
% all three functions are identical
fprintf('Small array, many iterations: \n   ');
tic;
cols_array(small_m, n_iter*10);  % 10x iterations
toc;

fprintf('Small array, many iterations, using matrix algebra: \n   ');
tic;
cols_array_mat(small_m, n_iter*10);  % 10x iterations
toc;

fprintf('10x cols, 10x fewer iterations: \n   ');
tic;
cols_array(m_10x_cols, n_iter); % 10x columns
toc;

fprintf('10x cols, 10x fewer iterations, matrix algebra: \n   ');
tic;
cols_array_mat(m_10x_cols, n_iter); % 10x columns
toc;

fprintf('10x rows, 10x fewer iterations: \n   ');
tic;
cols_array(m_10x_rows, n_iter);  % 10x rows
toc;

fprintf('10x rows, 10x fewer iterations, matrix algebra: \n   ');
tic;
cols_array_mat(m_10x_rows, n_iter);  % 10x rows
toc;

fprintf('10x rows, 10x fewer iterations, row means: \n   ');
tic;
rows_array(m_10x_rows, n_iter);  % 10x rows
toc;

fprintf('10x rows, 10x fewer iterations, row means, matrix algebra: \n   ');
tic;
rows_array_mat(m_10x_rows, n_iter);  % 10x rows
toc;

fprintf('50x cols, 50x fewer iterations: \n   ');
tic;
cols_array(m_50x_cols, n_iter/5); % 100x columns, note that the base # of iterations is already max_iter/10 
toc;

fprintf('50x cols, 50x fewer iterations, using matrix algebra: \n   ');
tic;
%small_array_op2(m_10x_cols, n_iter); % 10x columns
cols_array_mat(m_50x_cols, n_iter/5); % 100x columns, note that the base # of iterations is already max_iter/10 
toc;

fprintf('100x cols, 100x fewer iterations: \n   ');
tic;
cols_array(m_100x_cols, n_iter/10); % 100x columns, note that the base # of iterations is already max_iter/10 
toc;

fprintf('100x cols, 100x fewer iterations, using matrix algebra: \n   ');
tic;
%small_array_op2(m_10x_cols, n_iter); % 10x columns
cols_array_mat(m_100x_cols, n_iter/10); % 100x columns, note that the base # of iterations is already max_iter/10 
toc;


fprintf('500x cols, 500x fewer iterations: \n   ');
tic;
cols_array(m_500x_cols, n_iter/50); % 100x columns, note that the base # of iterations is already max_iter/10 
toc;

fprintf('500x cols, 500x fewer iterations, using matrix algebra: \n   ');
tic;
%small_array_op2(m_10x_cols, n_iter); % 10x columns
cols_array_mat(m_500x_cols, n_iter/50); % 100x columns, note that the base # of iterations is already max_iter/10 
toc;


fprintf('1,000x cols, 1,000x fewer iterations: \n   ');
tic;
cols_array(m_1000x_cols, n_iter/100); % 100x columns, note that the base # of iterations is already max_iter/10 
toc;

fprintf('1,000x cols, 1,000x fewer iterations, using matrix algebra: \n   ');
tic;
cols_array_mat(m_1000x_cols, n_iter/100); %  note that the base # of iterations is already max_iter/10 
toc;

fprintf('10,000x cols, 10,000x fewer iterations: \n   ');
tic;
cols_array(m_10000x_cols, n_iter/1000); % 100x columns, note that the base # of iterations is already max_iter/10 
toc;

fprintf('10,000x cols, 10,000x fewer iterations, using matrix algebra: \n   ');
tic;
cols_array_mat(m_10000x_cols, n_iter/1000); %  note that the base # of iterations is already max_iter/10 
toc;

end

%%%%%%%%%%%%%%%%%%%%%%%%
%% THREE WAYS TO PROCESS 3D arrays (elementwise)
function forop(my_m3, my_m, n_iter)
    m1 = zeros( size(my_m3) );
    for i = 1:n_iter
        for j = 1:size(my_m3, 3)
            m1(:, :, j) = my_m3(:, :, j) .* my_m;
        end
    end
    m1(1)=0;
end

function bsxop(my_m3, my_m, n_iter)
   % m1 = ones( size(my_m3) );
    for i = 1:n_iter
        m1 = bsxfun(@times, my_m3, my_m);
    end
    m1(1)=0;
end

% 3. reshape into 2D matrix, replicate the second operator
%   3a. test only the multiplication
%   3b. put all manipulations in the loop
%   3c. pre-compute the second arg but do reshape in loop
%   (3c2 - do reshape w/o intermediate variable -- is actually a bit worse)
function matop(my_m3, my_m, n_iter)
    %m1 = ones( size(my_m2) );
    m1rep = repmat(my_m, 1, size(my_m3, 3));
    my_m2 = reshape(my_m3, size(my_m3, 1), []);
    for i = 1:n_iter
        m1 = my_m2 .* m1rep;
    end
    m1(1)=0;
end

%% Mean of 3D array
function m1 = mean3(my_m3, n_iter)
    %m1 = ones( size(my_m2) );
    for i = 1:n_iter
        m1 = mean(my_m3, 3);
    end
end

function m1 = mean_matop(my_m3, n_iter)
   [~, b, c] = size(my_m3);
   ncol_base = zeros(b, 1); % single column
   ncol_base(1) = 1/c; % we're taking mean, so each non-zero is 1/#submatrices
   ncol1 = repmat(ncol_base, c, 1); % repeat for each submatrix
   mmat = repmat(ncol1, 1, b); % one column per column in the mean matrix
   for cidx = 2:b
       mmat(:, cidx) = circshift(mmat(:, cidx-1), 1);
   end
    my_m2 = reshape(my_m3, size(my_m3, 1), []);
    
    for i = 1:n_iter
        m1 = my_m2 * mmat;
    end
end

%% column/row means
function m1 = cols_array(my_m, n_iter)
    fprintf('(%f elem*iter) ', numel(my_m)*n_iter);
    m1 = zeros(1, size(my_m, 2));
    for i = 1:n_iter
        %m1(:) = mean(my_m, 1);  % this is actually ~ 10% slower!
        m1 = m1 + mean(my_m, 1);
    end
    % just a little junk code to use m
    %m1 = m1 + 1;
end

function m1 = cols_array_mat(my_m, n_iter)
    fprintf('(%f elem*iter) ', numel(my_m)*n_iter);
    nrows =  size(my_m, 1);
    m1 = zeros(1, size(my_m, 2));
    v1 = repmat( 1 ./ nrows, 1, nrows);
    for i = 1:n_iter
        m1 = m1 + v1 * my_m;
   end
    % just a little junk code to use m
    %m1 = m1 + 1;
end


function rows_array(my_m, n_iter)
    for i = 1:n_iter
        m1 = mean(my_m, 2);  % take row means?
    end
    % just a little junk code to use m
    %m1 = m1 + 1;
end

function rows_array_mat(my_m, n_iter)
    ncols =  size(my_m, 2);
    v1 = repmat( 1 ./ ncols, ncols, 1);
    for i = 1:n_iter
        m1 = my_m * v1;
    end
    % just a little junk code to use m
    %m1 = m1 + 1;
end

%
function junk = powers(my_mat, n_iter)
    log21 = log(2.1);
    a1 = my_mat;
    a2 = my_mat;
    a3 = my_mat;

    tic;
    for i = 1:n_iter % with 100,000 iterations (MATLAB r2015b)
        a1 = a1 + my_mat .^ 0.25;
    end
    toc;
    tic;
    for i = 1:n_iter % with 100,000 iterations (MATLAB r2015b)
        a2 = a2 + exp(log(my_mat)*0.25);
    end
    toc;
    tic;
    for i = 1:n_iter % with 100,000 iterations (MATLAB r2015b)
        a3 = a3 + sqrt(sqrt(my_mat));
    end
    toc;
%         a1 = a1 + 2.1 .^ my_mat;         % 7.0 s (in r2013b: 6.3s;  note: order in this list doesn't matter)
%         a2 = a2 + mypow(2.1, my_mat);    % 1.2 s  (in r2013b: 09 s; 6x faster some overhead for the function call)
%         %a2 = a2 + exp(log(2.1) * my_mat);   % 0.77 s  ( 9 x faster; in r2013b a2&3 are 0.55 s )
%         a3 = a3 + exp(log21 * my_mat);   % 0.45 s  ( 15x faster! )  
%         a4 = my_mat .^ 2; % square is fast  (0.04 s in both revs)
%         a5 = my_mat .^ 3; % cube is slow    (2.22 s;  in r2013b: 6.4 s!!)
%         %a6 = exp(log(my_mat) .* 3); %       (1.67 s;  in r2013b: 2.2 s)
%         %a6 = my_mat .* my_mat .* my_mat; % fast(0.05 s in both revs)
%         a6 = cube(my_mat); %          medium (0.44 s;  in r2013b: 0.24 s)
%    end
%    fprintf('ignore this: %f\n', sum(sum(abs(a4+a5)))); % just to use them
%    fprintf( 'a**3 - a*a*a: %g\n', sum(sum(abs(a5-a6))));  % 5e-15
    fprintf( 'a1 - a2: %g\n', sum(sum(abs(a1-a2))));  % identical or 4 e-10
    fprintf( 'a3 - a2: %g\n', sum(sum(abs(a3-a2))));  % identical
    junk = sum(abs(a3-a2));
end

function val = mypow(a, b)
    val = exp(log(a)* b);
end

function val = cube(a)
    val = a .* a .* a;
end
