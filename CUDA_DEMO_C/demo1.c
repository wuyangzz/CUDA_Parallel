#include<stdio.h>
#include<stdlib.h>
#include <time.h>

#define MAX_SIZE 1024
#define M_SIZE MAX_SIZE * MAX_SIZE 

void MatrixMutiplyC(float* matrixM, float* matrixN, float* matrixC);

int main()
{

    clock_t start, finish;
    float* matrixM, * matrixN, * matrixC;
    //初始化Host
    matrixM = (float*)malloc(M_SIZE * sizeof(float));
    matrixN = (float*)malloc(M_SIZE * sizeof(float));
    matrixC = (float*)malloc(M_SIZE * sizeof(float));

    //赋值
    for (int i = 0; i < M_SIZE; i++)
    {
        matrixM[i] = 7;
        matrixN[i] = 2;
    }
    start = clock();
    MatrixMutiplyC(matrixM, matrixN, matrixC);
    finish = clock();
    printf("CPU_Time:%fs\n", (double)(finish - start) / CLOCKS_PER_SEC);
    printf("vuale:%f", matrixC[0]);
    int num = 0;
    //验证是否计算完毕 1024*1024=1048576
    for (int i = 0; i < M_SIZE; i++)
    {
        if (matrixC[i] == 14336)
            num++;
    }
    printf("\n%d", num);
    free(matrixM);
    free(matrixC);
    free(matrixN);
    return 0;
}
void MatrixMutiplyC(float* matrixM,
    float* matrixN, float* matrixC)
{
    float mutiTemp;
    /*嵌套循环计算结果矩阵（m*p）的每个元素*/
    for (int i = 0; i < MAX_SIZE; i++)
        for (int j = 0; j < MAX_SIZE; j++)
        {
            /*按照矩阵乘法的规则计算结果矩阵的i*j元素*/
            mutiTemp = 0;
            for (size_t k = 0; k < MAX_SIZE; k++)
            {
                mutiTemp += matrixM[i * MAX_SIZE + k] * matrixN[k * MAX_SIZE + j];
            }
            matrixC[i * MAX_SIZE + j] = mutiTemp;
        }
}