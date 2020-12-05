
#include <mat.h>
#include <iostream>


using namespace std;

double mat_read(string path, string name, mxArray *&Array1, mxArray *&Array2)
{
	MATFile *pmatFile = matOpen((path + "\\" + name + ".mat").c_str(), "r");
	if (pmatFile == NULL)
		cout << "MatOpen error!!!" << endl;

	Array1 = matGetVariable(pmatFile, "length");
	Array2 = matGetVariable(pmatFile, "tracts");

	matClose(pmatFile);
	return 0;
}
int main()
{
	mxArray *Array1 = NULL;
	mxArray *Array2 = NULL;
	string filepath = "G:\\博客\\C++获取mat数据\\CPPgetMat\\CPPgetMat";
	string filename = "InputTest";
	mat_read(filepath, filename, Array1, Array2);

	int64_T *dim = (int64_T *)(mxGetDimensions(Array1));
	//int *Dim = (int*)dim;
	int ss = mxGetNumberOfDimensions(Array1);
	int pp = mxGetM(Array1);
	cout << "数据有" << ss << "维度" << endl;
	for (int i = 0; i < ss; i++)
	{
		cout << "第" << (i + 1) << "维度的大小是" << dim[i] << endl;
	}

	double *Data = (double*)mxGetData(Array1);

	cout << "Data[0]的值是" << Data[0] << endl;


	double *out = new double[6];
	for (int i = 0; i < 2; i++)
	{
		for (int j = 0; j < 3; j++)
		{
			out[i * 3 + j] = 5 * j + i;
		}
	}



	MATFile *OutFile = NULL;
	mxArray *pMxArray = NULL;

	OutFile = matOpen("G:\\博客\\C++获取mat数据\\CPPgetMat\\CPPgetMat\\outTest.mat", "w");
	pMxArray = mxCreateDoubleMatrix(2, 3, mxREAL);
	//mxSetData(pMxArray, (mxArray *)out);
	memcpy((void *)(mxGetPr(pMxArray)), (void *)out, sizeof(double) * 6);

	Data = (double*)mxGetData(pMxArray);

	//cout << Data[4] << endl;
	matPutVariable(OutFile, "test", pMxArray);

	system("pause");
	return 0;
}