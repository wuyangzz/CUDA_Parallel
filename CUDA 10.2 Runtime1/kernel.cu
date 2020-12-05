#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <cuda_runtime.h>
#include "device_launch_parameters.h"

#define SIZE 1024 
#define GRID_SIZE 32
#define BLOCK_SIZE 16

__global__ void matrixMultiplication(float* matrixM, float* matrixN, float* matrixP, int width) {
    int tx = threadIdx.x;
    int ty = threadIdx.y;
    float sum = 0, m, n;
    for (int k = 0; k < width; ++k) {
        m = matrixM[ty * width + k];
        n = matrixN[k * width + tx];
        sum += m * n;
    }
    matrixP[ty * width + tx] = sum;
}


// 主机端主函数
int main(void) {

    float* h_matrixM, * h_matrixN, * h_matrixP, * d_matrixM, * d_matrixN, * d_matrixP;
    int mem_size = SIZE * SIZE * sizeof(float);

    // 在主机内存申请 A，B，C 向量的空间
    h_matrixM = (float*)malloc(mem_size);
    h_matrixN = (float*)malloc(mem_size);
    h_matrixP = (float*)malloc(mem_size);

    // 在 GPU 设备申请 A，B，C 向量的空间
    cudaMalloc((void**)&d_matrixM, mem_size);
    cudaMalloc((void**)&d_matrixN, mem_size);
    cudaMalloc((void**)&d_matrixP, mem_size);

    // 初始化主机内存的 A，B 向量
    for (int i = 0; i < SIZE * SIZE; ++i) {
        h_matrixM[i] = 3;
        h_matrixN[i] = 2;
    }

    // 拷贝主机内存的 A，B 的内容到 GPU 设备的 A，B
    cudaMemcpy(d_matrixM, h_matrixM, mem_size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_matrixN, h_matrixN, mem_size, cudaMemcpyHostToDevice);

    // GPU 内核函数的维度参数
    dim3 dimGrid(GRID_SIZE, GRID_SIZE);
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);

    // 记录程序开始运行的时间
    double startTime, endTime;
    startTime = (double)clock();
    // 执行 GPU 内核函数
    matrixMultiplication <<< dimGrid, dimBlock >>> (d_matrixM, d_matrixN, d_matrixP, SIZE);
    // 输出程序运行花费的时间
    endTime = (double)clock();
    printf("Time elapsed: %.2f ms\n", endTime - startTime);


    // 从 GPU 设备复制结果向量 C 到主机内存的 C
    cudaMemcpy(h_matrixP, d_matrixP, mem_size, cudaMemcpyDeviceToHost);

    // 输出结果
    // for (int i = 0; i < SIZE * SIZE; ++i) {
    //     printf("%.2f\n", h_matrixP[0]);
    // }

    printf("end\n");

    free(h_matrixM);
    free(h_matrixN);
    free(h_matrixP);
    cudaFree(d_matrixM);
    cudaFree(d_matrixN);
    cudaFree(d_matrixP);
    return 0;
}
