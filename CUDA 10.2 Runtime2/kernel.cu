#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<stdio.h>
#include<stdlib.h>
#include <time.h>

#define MAX_SIZE 1024
#define M_SIZE MAX_SIZE * MAX_SIZE 
#define GRID_SIZE  1024    //每个grid中有1024个block
#define BLOCK_SIZE  1024 //1070最大为每个block中有1024个线程

__global__ void MatrixMutiplyG(float* matrixM, float* matrixN, float* matrixC) {
    int bx = blockIdx.x;
    int tx = threadIdx.x;

    float sum = 0, m, n;
    for (int k = 0; k < MAX_SIZE; ++k) {
        m = matrixM[bx * MAX_SIZE + k];
        n = matrixN[k * MAX_SIZE + tx];
        sum += m * n;
    }
    matrixC[bx * MAX_SIZE + tx] = sum;
}

int main()
{

    clock_t start, finish;
    float* matrixM, * matrixN, * matrixC;
    float* g_matrixM, * g_matrixN, * g_matrixC;
    //初始化Host
    matrixM = (float*)malloc(M_SIZE * sizeof(float));
    matrixN = (float*)malloc(M_SIZE * sizeof(float));
    matrixC = (float*)malloc(M_SIZE * sizeof(float));
    //初始化GPUm
    cudaMalloc((void**)&g_matrixM, sizeof(float) * M_SIZE);
    cudaMalloc((void**)&g_matrixN, sizeof(float) * M_SIZE);
    cudaMalloc((void**)&g_matrixC, sizeof(float) * M_SIZE);
    //赋值
    for (int i = 0; i < M_SIZE; i++)
    {
        matrixM[i] = 7;
        matrixN[i] = 2;
    }
    cudaMemcpy(g_matrixM, matrixM, sizeof(float) * M_SIZE, cudaMemcpyHostToDevice);
    cudaMemcpy(g_matrixN, matrixN, sizeof(float) * M_SIZE, cudaMemcpyHostToDevice);
    dim3 dimGrid(GRID_SIZE);
    dim3 dimBlock(BLOCK_SIZE);
    start = clock();

    MatrixMutiplyG << < dimGrid, dimBlock >> > (g_matrixM, g_matrixN, g_matrixC);
    cudaDeviceSynchronize();
    finish = clock();
    cudaMemcpy(matrixC, g_matrixC, sizeof(float) * M_SIZE, cudaMemcpyDeviceToHost);
    printf("GPU_Time:%fs\n", (double)(finish - start) / CLOCKS_PER_SEC);
    printf("vlaue:%f", matrixC[0]);
    int num = 0; 
    //验证是否计算完毕 1024*1024=1048576
    for (int i = 0; i < M_SIZE; i++)
    {
        if (matrixC[i] == 14336)
            num++;
    }
    printf("\n%d", num);
    free(matrixM);
    free(matrixN);
    free(matrixC);
    cudaFree(g_matrixM);
    cudaFree(g_matrixN);
    cudaFree(g_matrixC);
    return 0;
}