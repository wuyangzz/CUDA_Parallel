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


// ������������
int main(void) {

    float* h_matrixM, * h_matrixN, * h_matrixP, * d_matrixM, * d_matrixN, * d_matrixP;
    int mem_size = SIZE * SIZE * sizeof(float);

    // �������ڴ����� A��B��C �����Ŀռ�
    h_matrixM = (float*)malloc(mem_size);
    h_matrixN = (float*)malloc(mem_size);
    h_matrixP = (float*)malloc(mem_size);

    // �� GPU �豸���� A��B��C �����Ŀռ�
    cudaMalloc((void**)&d_matrixM, mem_size);
    cudaMalloc((void**)&d_matrixN, mem_size);
    cudaMalloc((void**)&d_matrixP, mem_size);

    // ��ʼ�������ڴ�� A��B ����
    for (int i = 0; i < SIZE * SIZE; ++i) {
        h_matrixM[i] = 3;
        h_matrixN[i] = 2;
    }

    // ���������ڴ�� A��B �����ݵ� GPU �豸�� A��B
    cudaMemcpy(d_matrixM, h_matrixM, mem_size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_matrixN, h_matrixN, mem_size, cudaMemcpyHostToDevice);

    // GPU �ں˺�����ά�Ȳ���
    dim3 dimGrid(GRID_SIZE, GRID_SIZE);
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);

    // ��¼����ʼ���е�ʱ��
    double startTime, endTime;
    startTime = (double)clock();
    // ִ�� GPU �ں˺���
    matrixMultiplication <<< dimGrid, dimBlock >>> (d_matrixM, d_matrixN, d_matrixP, SIZE);
    // ����������л��ѵ�ʱ��
    endTime = (double)clock();
    printf("Time elapsed: %.2f ms\n", endTime - startTime);


    // �� GPU �豸���ƽ������ C �������ڴ�� C
    cudaMemcpy(h_matrixP, d_matrixP, mem_size, cudaMemcpyDeviceToHost);

    // ������
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
