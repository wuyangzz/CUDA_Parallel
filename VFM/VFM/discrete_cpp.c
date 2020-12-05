#include "mex.h"
// 使用MEX必须包含的头文件

int discrete(double d);

void mexFunction(int nlhs, mxArray *plhs[], 
                 int nrhs, const mxArray *prhs[]){

    if (nrhs != 1)
        mexErrMsgTxt("Wrong number of input arguments.\n");
   // 检查输入变量数量是否正确，否则报错

    if (nlhs > 1)   
        mexErrMsgTxt("Too many output argumnents.\n");
    // 检查输出变量数量是否正确，否则报错
    
    #define A_IN  prhs[0]
    #define B_OUT plhs[0]
    
    int M = mxGetM(A_IN);
    int N = mxGetN(A_IN);
    // 得到输入矩阵A的行数和列数

    B_OUT = mxCreateDoubleMatrix(M, N, mxREAL);
    // 为输出矩阵B分配存储空间
    
    double *A = mxGetPr(A_IN);
    double *B = mxGetPr(B_OUT);
    // 取得输入矩阵A和输出矩阵B的数据指针
    
    for (int i = 0; i < M * N; ++i)
        B[i] = discrete(A[i]);
    // 调用discrete，根据A(i, j)计算B(i, j)
}

int discrete(double d) {
    if (d < 1.0 / 3.0)
        return 0;
    else if (d < 2.0 / 3.0)
        return 1;
    return 2;
}