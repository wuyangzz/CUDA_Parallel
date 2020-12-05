#include<stdio.h>
#include<stdlib.h>
#include <time.h>

#define MAX_SIZE 1024
#define M_SIZE MAX_SIZE * MAX_SIZE 


void MatrixMutiplyC(float* matrixM,float* matrixN, float* matrixC);

int main()
{   

    clock_t start, finish;
    double duration;
    float *matrixM, * matrixN, *matrixC;
    //��ʼ��Host
    matrixM = (float*)malloc(M_SIZE *sizeof(float));
    matrixN = (float*)malloc(M_SIZE * sizeof(float));
    matrixC = (float*)malloc(M_SIZE * sizeof(float));
  
    //��ֵ
    for (int i = 0; i < M_SIZE; i++)
    {
        matrixM[i] = 7;
        matrixN[i] = 2;
    }
    start = clock();
    MatrixMutiplyC(matrixM, matrixN, matrixC);   
    finish = clock();
    printf("CPU_Time:%fs", (double)(finish - start) / CLOCKS_PER_SEC);
    return 0;
}
void MatrixMutiplyC(float* matrixM,
    float* matrixN, float* matrixC)
{
    float mutiTemp;
    /*Ƕ��ѭ������������m*p����ÿ��Ԫ��*/
    for (int i = 0; i < MAX_SIZE; i++)
        for (int j = 0; j < MAX_SIZE; j++)
        {
            /*���վ���˷��Ĺ�������������i*jԪ��*/
            mutiTemp = 0;
            for (size_t k = 0; k < MAX_SIZE; k++)
            {
                mutiTemp += matrixM[i*MAX_SIZE+k]*matrixN[k*MAX_SIZE+j];
            }
            matrixC[i * MAX_SIZE + j] = mutiTemp;
        }
}