/* Matrix normalization.
* Compile with "nvcc matrixNormCuda.c -lm"
*/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
#include <math.h>

/* Program Parameters */
#define N 8000  /* Matrix size */
int blocks_per_grid = 32;
int threads_per_block = 256; 

/* Matrices */
float A[N*N], B[N*N];

/* CUDA arrays */
float *A_d, *B_d;


/* Initialize A and B*/
void initialize_inputs() {
    int row, col;
    
    // srand((unsigned)time(NULL));
    for (row = 0; row < N; row++) {
        for (col = 0; col < N; col++) {
            A[row*N + col] = (float)rand() / 32768.0;
            B[row*N + col] = 0.0;
        }
    }
    
}

/* Print input matrices */
void print_inputs()
{
  int row, col;
  int howmuchtoprint = 10;
    printf("\nA =\n\t");
    for (row = 0; row < howmuchtoprint; row++)
    {
      for (col = 0; col < howmuchtoprint; col++)
      {
        printf("%5.2f%s", A[row*N + col], (col < howmuchtoprint - 1) ? ", " : ";\n\t");
      }
    }
    printf("\nB = [");
    for (row = 0; row < howmuchtoprint; row ++)
    {
        for (col = 0; col < howmuchtoprint; col++)
        {
        printf("%5.2f%s", B[row*N + col], (col < howmuchtoprint - 1 ) ? "; " : "]\n");
        }
    }

}

/* Kernel function */

__global__ void matrixNorm(float* A_dd, float* B_dd, int N_d) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    // __shared__ float mu, sigma;
    float mu, sigma;
    int row;

    if (idx < N_d) {
        mu = 0.0;
        for (row=0; row < N_d; row++){
            mu += A_dd[row*N_d + idx];
        }
        mu /= N_d;

        sigma = 0.0;
        for (row=0; row < N_d; row++){
            sigma += powf(A_dd[row*N_d + idx] - mu, 2.0);
        }
        sigma /= N_d;
        sigma = sqrt(sigma);

        for (row=0; row < N_d; row++) {
            if (sigma == 0.0){
                B_dd[row*N_d + idx] = 0.0;
            }
            else{
                B_dd[row*N_d + idx] = (A_dd[row*N_d + idx] - mu) / sigma;
            }
        }
    }
}



int main(int argc, char **argv) {
    /* Timing variables */
    struct timeval start, stop;  /* Elapsed times using gettimeofday() */
    struct timezone tzdummy;
    unsigned long long runtime;
    // int col, row;
    // float mu, sigma;
    
    /* Initialize A and B */
    initialize_inputs();
    print_inputs();
    
    /* Start Clock */
    printf("\n---------------------------------------------\n");
    printf("Matrix size N = %d", N);
    printf("\nStarting clock.\n\n");
    gettimeofday(&start, &tzdummy);
    
    printf("Computing Parallely.\n");
    
    /*allocating GPU space*/
    cudaMalloc((void **) &A_d, N*N*sizeof(float));
    cudaMalloc((void **) &B_d, N*N*sizeof(float));

    /*transfer data from host to device*/
    cudaMemcpy(A_d,A,N*N*sizeof(float),cudaMemcpyHostToDevice);
    cudaMemcpy(B_d,B,N*N*sizeof(float),cudaMemcpyHostToDevice);

    /* Kernal Matrix Normalization */
    matrixNorm<<<blocks_per_grid,threads_per_block>>>(A_d,B_d,N);

    //note to self: KERNAL CALLS ARE EXPENSIVE AF
    // for (col=0; col < N; col++) {
    //     mu = 0.0;
    //     for (row=0; row < N; row++)
    //         mu += A[row][col];
    //     mu /= (float) N;
    //     sigma = 0.0;
    //     for (row=0; row < N; row++)
    //         sigma += powf(A[row][col] - mu, 2.0);
    //     sigma /= (float) N;
    //     sigma = sqrt(sigma);
    //     matrixNorm<<<blocks_per_grid,threads_per_block>>>(A_d,B_d,mu,sigma, N);
    // }

    /*transfer data from device to host*/
    cudaMemcpy(B,B_d,N*N*sizeof(float),cudaMemcpyDeviceToHost);
    // cudaMemcpy(A,A_d,N*N*sizeof(float),cudaMemcpyDeviceToHost);
    
    /*deallocating GPU space*/
    cudaFree(A_d);
    cudaFree(B_d);
    
    printf("\n-------Output--------------------------------------------\n");
    print_inputs();
    
    /* Stop Clock */
    gettimeofday(&stop, &tzdummy);
    runtime = (unsigned long long)(stop.tv_sec - start.tv_sec) * 1000000 + (stop.tv_usec - start.tv_usec);
    
    
    /* Display timing results */
    printf("Runtime = %g ms.\n", (float)runtime/(float)1000);
    printf("\nStopped clock.");
    printf("\n---------------------------------------------\n");
    
    exit(0);
}














