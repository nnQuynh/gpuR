library(gpuR)
context("CPU gpuMatrix Utility Functions")

current_context <- set_device_context("cpu")

set.seed(123)
A <- matrix(sample(seq.int(100), 100), 10)
D <- matrix(sample(rnorm(100), 100), 10)

cnames <- paste0("V", seq(10))

test_that("CPU gpuMatrix element access", {
    has_cpu_skip()
    
    dgpu <- gpuMatrix(D, type = "double")
    fgpu <- gpuMatrix(D, type="float")
    igpu <- gpuMatrix(A)
    
    expect_equivalent(dgpu[,1], D[,1],
                      info = "double column subset not equivalent")
    expect_equal(fgpu[,1], D[,1], tolerance = 1e-07,
                 info = "float column subset not equivalent ")
    expect_equivalent(igpu[,1], A[,1],
                      info = "integer column subset not equivalent")
    
    expect_equivalent(dgpu[1,], D[1,],
                      info = "double row subset not equivalent")
    expect_equal(fgpu[1,], D[1,], tolerance = 1e-07,
                 info = "float row subset not equivalent ")
    expect_equivalent(igpu[1,], A[1,],
                      info = "integer row subset not equivalent")
    
    expect_equivalent(dgpu[1,2], D[1,2],
                      info = "double element subset not equivalent")
    expect_equal(fgpu[1,2], D[1,2], tolerance = 1e-07,
                 info = "float element subset not equivalent ")
    expect_equivalent(igpu[1,2], A[1,2],
                      info = "integer element subset not equivalent")
    expect_equivalent(dgpu[c(3,5)], D[c(3,5)],
                      info = "double non-contiguous subset not equivalent")
    
    expect_equivalent(igpu[1:4,1:4], A[1:4,1:4],
                      info = "row & column subsets of igpuMatrix not equivalent")
    expect_equal(fgpu[1:4,1:4], D[1:4,1:4], tolerance = 1e-07,
                 info = "row & column subsets of fgpuMatrix not equivalent")
    expect_equivalent(dgpu[1:4,1:4], D[1:4,1:4],
                      info = "row & column subsets of dgpuMatrix not equivalent")
})

test_that("CPU gpuMatrix set column access", {
    has_cpu_skip()
    
    gpuA <- gpuMatrix(A)
    gpuD <- gpuMatrix(D, type = "double")
    gpuF <- gpuMatrix(D, type = "float")
    gpuB <- gpuD
    
    icolvec <- sample(seq.int(10), 10)
    colvec <- rnorm(10)
    
    gpuA[,1] <- icolvec
    gpuD[,1] <- colvec
    gpuF[,1] <- colvec
    
    A[,1] <- icolvec
    D[,1] <- colvec
    
    expect_equivalent(gpuD[,1], colvec,
                      info = "updated dgpuMatrix column not equivalent")
    expect_equivalent(gpuD[], D,
                      info = "updated dgpuMatrix not equivalent")
    expect_equivalent(gpuB[], D, 
                      info = "updated dgpuMatrix column not reflected in 'copy'")
    expect_equal(gpuF[,1], colvec, tolerance=1e-07,
                 info = "updated fgpuMatrix column not equivalent")
    expect_equal(gpuF[], D, tolerance=1e-07,
                 info = "updated fgpuMatrix not equivalent")
    expect_equivalent(gpuA[,1], icolvec,
                      info = "updated igpuMatrix column not equivalent")
    expect_equivalent(gpuA[], A,
                      info = "updated igpuMatrix not equivalent")
    expect_error(gpuA[,11] <- icolvec,
                 info = "no error when index greater than dims")
    expect_error(gpuD[,1] <- rnorm(12),
                 info = "no error when vector larger than number of rows")
    
    expect_equivalent(gpuA[,1:4], A[,1:4],
                      info = "column subsets of igpuMatrix not equivalent")
    expect_equivalent(gpuD[,1:4], D[,1:4],
                      info = "column subsets of fgpuMatrix not equivalent")
    expect_equal(gpuF[,1:4], D[,1:4], tolerance = 1e-07,
                 info = "column subsets of dgpuMatrix not equivalent")
})

test_that("CPU gpuMatrix set row access", {
    has_cpu_skip()
    
    gpuA <- gpuMatrix(A)
    gpuD <- gpuMatrix(D, type = "double")
    gpuF <- gpuMatrix(D, type = "float")
    gpuB <- gpuD
    
    icolvec <- sample(seq.int(10), 10)
    colvec <- rnorm(10)
    
    gpuA[1,] <- icolvec
    gpuD[1,] <- colvec
    gpuF[1,] <- colvec
    
    A[1,] <- icolvec
    D[1,] <- colvec
    
    expect_equivalent(gpuD[1,], colvec,
                      info = "updated dgpuMatrix row not equivalent")
    expect_equivalent(gpuD[], D,
                      info = "updated dgpuMatrix not equivalent")
    expect_equivalent(gpuB[], D, 
                      info = "updated dgpuMatrix row not reflected in 'copy'")
    expect_equal(gpuF[1,], colvec, tolerance=1e-07,
                 info = "updated fgpuMatrix row not equivalent")
    expect_equal(gpuF[], D, tolerance=1e-07,
                 info = "updated fgpuMatrix not equivalent")
    expect_equivalent(gpuA[1,], icolvec,
                      info = "updated igpuMatrix row not equivalent")
    expect_equivalent(gpuA[], A,
                      info = "updated igpuMatrix not equivalent")
    expect_error(gpuA[11,] <- icolvec,
                 info = "no error when index greater than dims")
    expect_error(gpuD[1,] <- rnorm(12),
                 info = "no error when vector larger than number of rows")
    
    expect_equivalent(gpuA[1:4,], A[1:4,],
                      info = "row subsets of igpuMatrix not equivalent")
    expect_equivalent(gpuD[1:4,], D[1:4,], 
                      info = "row subsets of fgpuMatrix not equivalent")
    expect_equal(gpuF[1:4,], D[1:4,], tolerance = 1e-07,
                 info = "row subsets of dgpuMatrix not equivalent")
})

test_that("CPU gpuMatrix set element access", {
    has_cpu_skip()
    
    gpuA <- gpuMatrix(A)
    gpuD <- gpuMatrix(D, type = "double")
    gpuF <- gpuMatrix(D, type = "float")
    gpuB <- gpuD
    
    int <- sample(seq.int(10), 1)
    float <- rnorm(1)
    
    gpuA[1,3] <- int
    gpuD[1,3] <- float
    gpuF[1,3] <- float
    
    A[1,3] <- int
    D[1,3] <- float
    
    D[c(6,10)] <- 0
    gpuD[c(6,10)] <- 0
    gpuF[c(6,10)] <- 0
    
    expect_equivalent(gpuD[1,3], float,
                      info = "updated dgpuMatrix element not equivalent")
    expect_equivalent(gpuD[], D,
                      info = "updated dgpuMatrix not equivalent")
    expect_equivalent(gpuB[], D, 
                      info = "updated dgpuMatrix elemnent not reflected in 'copy'")
    expect_equal(gpuF[1,3], float, tolerance=1e-07,
                 info = "updated fgpuMatrix element not equivalent")
    expect_equal(gpuF[], D, tolerance=1e-07,
                 info = "updated fgpuMatrix not equivalent")
    expect_equivalent(gpuA[1,3], int,
                      info = "updated igpuMatrix element not equivalent")
    expect_equivalent(gpuA[], A,
                      info = "updated igpuMatrix not equivalent")
    expect_error(gpuA[11,3] <- int,
                 info = "no error when index greater than dims")
    expect_error(gpuD[1,3] <- rnorm(12),
                 info = "no error when assigned vector to element")
    expect_equivalent(gpuD[c(6,10)], D[c(6,10)],
                      info = "double non-contiguous subset not equivalent")
})

test_that("CPU gpuMatrix confirm print doesn't error", {
    
    has_cpu_skip()
    
    dgpu <- gpuMatrix(D, type="float")
    
    expect_that(print(dgpu), prints_text("Source: gpuR Matrix"))
})

test_that("CPU gpuMatrix as.matrix method", {
    
    has_cpu_skip()
    
    dgpu <- gpuMatrix(D, type = "double")
    fgpu <- gpuMatrix(D, type="float")
    igpu <- gpuMatrix(A)
    
    expect_equal(as.matrix(dgpu), D,
                      info = "double as.matrix not equal")
    expect_equal(as.matrix(fgpu), D,
                      info = "float as.matrix not equal",
                      tolerance = 1e-07)
    expect_equal(as.matrix(dgpu), D,
                      info = "integer as.matrix not equal")
    
    
    expect_is(as.matrix(dgpu), 'matrix',
              info = "double as.matrix not producing 'matrix' class")
    expect_is(as.matrix(fgpu), 'matrix',
              info = "float as.matrix not producing 'matrix' class")
    expect_is(as.matrix(igpu), 'matrix',
              info = "integer as.matrix not producing 'matrix' class")
})

test_that("CPU gpuMatrix colnames methods", {
    
    has_cpu_skip()
    
    fgpu <- gpuMatrix(D, type="float")
    igpu <- gpuMatrix(A)
    
    expect_null(colnames(fgpu), 
                info = "float colnames should return NULL before assignment")
    expect_null(colnames(igpu), 
                info = "integer colnames should return NULL before assignment")
    
    colnames(fgpu) <- cnames
    colnames(igpu) <- cnames
    
    expect_equal(colnames(fgpu), cnames,
                 info = "float colnames don't reflect assigned names")
    expect_equal(colnames(igpu), cnames,
                 info = "integer colnames don't reflect assigned names")
    
    # Double tests
    
    dgpu <- gpuMatrix(D)
    
    expect_null(colnames(dgpu), 
                info = "double colnames should return NULL before assignment")
    
    colnames(dgpu) <- cnames
    
    expect_equal(colnames(dgpu), cnames,
                 info = "double colnames don't reflect assigned names")
})

setContext(current_context)
