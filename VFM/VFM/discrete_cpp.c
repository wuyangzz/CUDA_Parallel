#include "mex.h"
// ʹ��MEX���������ͷ�ļ�

int discrete(double d);

void mexFunction(int nlhs, mxArray *plhs[], 
                 int nrhs, const mxArray *prhs[]){

    if (nrhs != 1)
        mexErrMsgTxt("Wrong number of input arguments.\n");
   // ���������������Ƿ���ȷ�����򱨴�

    if (nlhs > 1)   
        mexErrMsgTxt("Too many output argumnents.\n");
    // ���������������Ƿ���ȷ�����򱨴�
    
    #define A_IN  prhs[0]
    #define B_OUT plhs[0]
    
    int M = mxGetM(A_IN);
    int N = mxGetN(A_IN);
    // �õ��������A������������

    B_OUT = mxCreateDoubleMatrix(M, N, mxREAL);
    // Ϊ�������B����洢�ռ�
    
    double *A = mxGetPr(A_IN);
    double *B = mxGetPr(B_OUT);
    // ȡ���������A���������B������ָ��
    
    for (int i = 0; i < M * N; ++i)
        B[i] = discrete(A[i]);
    // ����discrete������A(i, j)����B(i, j)
}

int discrete(double d) {
    if (d < 1.0 / 3.0)
        return 0;
    else if (d < 2.0 / 3.0)
        return 1;
    return 2;
}