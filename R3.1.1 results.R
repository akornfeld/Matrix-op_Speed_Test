R standard Rblas.dll
Small array, many iterations:
   user  system elapsed
  27.17    0.04   27.24
Small array, many iterations, matrix algebra colMean:
   user  system elapsed
  17.42    0.06   17.50
10x cols, 10x fewer iterations:
   user  system elapsed
   4.57    0.02    4.58
10x cols, 10x fewer iterations, matrix algebra colMean:
   user  system elapsed
  13.95    0.00   13.95
10x rows, 10x fewer iterations:
   user  system elapsed
   4.98    0.00    4.97
10x rows, 10x fewer iterations, matrix algebra colMean:
   user  system elapsed
  12.71    0.00   12.71
10x rows, 10x fewer iterations, row means:
   user  system elapsed
  11.37    0.00   11.38
10x rows, 10x fewer iterations, matrix algebra row means:
   user  system elapsed
   4.71    0.00    4.71
100x cols, 100x fewer iterations:
   user  system elapsed
   2.36    0.00    2.37
100x cols, 100x fewer iterations, matrix algebra colMean:
   user  system elapsed
  13.51    0.02   13.52
500x cols, 500x fewer iterations:
   user  system elapsed
   2.08    0.00    2.07
500x cols, 500x fewer iterations, matrix algebra colMean:
   user  system elapsed
  13.42    0.00   13.41
>
# With GOTO BLAS (Dynamic_ARCH; Single-threaded) http://prs.ism.ac.jp/~nakama/SurviveGotoBLAS2/binary/windows/x64/
Small array, many iterations:
   user  system elapsed
  27.50    0.09   27.62
Small array, many iterations, matrix algebra colMean:
   user  system elapsed
  10.36    0.02   10.37
10x cols, 10x fewer iterations:
   user  system elapsed
   4.58    0.05    4.64
10x cols, 10x fewer iterations, matrix algebra colMean:
   user  system elapsed
   5.35    0.00    5.37
10x rows, 10x fewer iterations:
   user  system elapsed
   4.98    0.01    5.01
10x rows, 10x fewer iterations, matrix algebra colMean:
   user  system elapsed
   4.69    0.00    4.69
10x rows, 10x fewer iterations, row means:
   user  system elapsed
  11.34    0.04   11.39
10x rows, 10x fewer iterations, matrix algebra row means:
   user  system elapsed
   5.19    0.00    5.20
100x cols, 100x fewer iterations:
   user  system elapsed
   2.36    0.02    2.37
100x cols, 100x fewer iterations, matrix algebra colMean:
   user  system elapsed
   4.87    0.00    4.89
500x cols, 500x fewer iterations:
   user  system elapsed
   2.06    0.00    2.06
500x cols, 500x fewer iterations, matrix algebra colMean:
   user  system elapsed
   4.87    0.00    4.87
>
> RT_SpeedTest()
Small array, many iterations:
   user  system elapsed
  27.66    0.08   27.77
Small array, many iterations, matrix algebra colMean:
   user  system elapsed
  10.08    0.04   10.12
10x cols, 10x fewer iterations:
   user  system elapsed
   4.64    0.02    4.66
10x cols, 10x fewer iterations, matrix algebra colMean:
   user  system elapsed
   5.30    0.01    5.32
10x rows, 10x fewer iterations:
   user  system elapsed
   5.04    0.00    5.05
10x rows, 10x fewer iterations, matrix algebra colMean:
   user  system elapsed
   4.65    0.00    4.65
10x rows, 10x fewer iterations, row means:
   user  system elapsed
  11.43    0.02   11.45
10x rows, 10x fewer iterations, matrix algebra row means:
   user  system elapsed
   5.21    0.00    5.21
100x cols, 100x fewer iterations:
   user  system elapsed
   2.37    0.00    2.37
100x cols, 100x fewer iterations, matrix algebra colMean:
   user  system elapsed
   4.88    0.00    4.89
500x cols, 500x fewer iterations:
   user  system elapsed
   2.09    0.00    2.09
500x cols, 500x fewer iterations, matrix algebra colMean:
   user  system elapsed
   4.85    0.00    4.85
>

# Revolution R 3.1.2 (8.0.1 beta) -- the MKL definitely kicks in all cores at 100x100, but timing is still poor!
> > RT_SpeedTest()
Small array, many iterations:
   user  system elapsed
  27.61    0.12   27.77
Small array, many iterations, matrix algebra colMean:
   user  system elapsed
  11.32    0.01   11.34
10x cols, 10x fewer iterations:
   user  system elapsed
   4.54    0.00    4.54
10x cols, 10x fewer iterations, matrix algebra colMean:
   user  system elapsed
   6.67    0.00    6.68
10x rows, 10x fewer iterations:
   user  system elapsed
   4.93    0.04    4.99
10x rows, 10x fewer iterations, matrix algebra colMean:
   user  system elapsed
   5.75    0.00    5.76
10x rows, 10x fewer iterations, row means:
   user  system elapsed
  11.42    0.01   11.43
10x rows, 10x fewer iterations, matrix algebra row means:
   user  system elapsed
    4.1     0.0     4.1
100x cols, 100x fewer iterations:
   user  system elapsed
    2.4     0.0     2.4
100x cols, 100x fewer iterations, matrix algebra colMean:
   user  system elapsed
  18.71    1.35    5.17
500x cols, 500x fewer iterations:
   user  system elapsed
   2.56    0.07    2.13
500x cols, 500x fewer iterations, matrix algebra colMean:
   user  system elapsed
  17.93    1.06    4.83
>
# again
> RT_SpeedTest()
Small array, many iterations:
   user  system elapsed
  27.71    0.16   27.87
Small array, many iterations, matrix algebra colMean:
   user  system elapsed
  11.32    0.00   11.34
10x cols, 10x fewer iterations:
   user  system elapsed
   4.51    0.00    4.51
10x cols, 10x fewer iterations, matrix algebra colMean:
   user  system elapsed
   6.65    0.00    6.66
10x rows, 10x fewer iterations:
   user  system elapsed
   4.98    0.00    4.97
10x rows, 10x fewer iterations, matrix algebra colMean:
   user  system elapsed
   5.75    0.00    5.76
10x rows, 10x fewer iterations, row means:
   user  system elapsed
  11.40    0.01   11.42
10x rows, 10x fewer iterations, matrix algebra row means:
   user  system elapsed
   4.07    0.01    4.09
100x cols, 100x fewer iterations:
   user  system elapsed
   2.39    0.00    2.39
100x cols, 100x fewer iterations, matrix algebra colMean:
   user  system elapsed
  18.97    1.15    5.15
500x cols, 500x fewer iterations:
   user  system elapsed
   2.69    0.00    2.12
500x cols, 500x fewer iterations, matrix algebra colMean:
   user  system elapsed
  18.52    0.82    4.98
>