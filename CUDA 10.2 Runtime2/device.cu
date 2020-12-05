//#include "cuda_runtime.h"
//#include "device_launch_parameters.h"
//#include <iostream>
//
//int main()
//{
//    int deviceCount;
//    cudaGetDeviceCount(&deviceCount);
//    for (int i = 0; i < deviceCount; i++)
//    {
//        cudaDeviceProp devProp;
//        cudaGetDeviceProperties(&devProp, i);
//        std::cout << "ʹ��GPU device " << i << ": " << devProp.name << std::endl;
//        std::cout << "�豸ȫ���ڴ������� " << devProp.totalGlobalMem / 1024 / 1024 << "MB" << std::endl;
//        std::cout << "SM��������" << devProp.multiProcessorCount << std::endl;
//        std::cout << "ÿ���߳̿�Ĺ����ڴ��С��" << devProp.sharedMemPerBlock / 1024.0 << " KB" << std::endl;
//        std::cout << "ÿ���߳̿������߳�����" << devProp.maxThreadsPerBlock << std::endl;
//        std::cout << "�豸��һ���߳̿飨Block���ֿ��õ�32λ�Ĵ��������� " << devProp.regsPerBlock << std::endl;
//        std::cout << "ÿ��EM������߳�����" << devProp.maxThreadsPerMultiProcessor << std::endl;
//        std::cout << "ÿ��EM������߳�������" << devProp.maxThreadsPerMultiProcessor / 32 << std::endl;
//        std::cout << "�豸�϶ദ������������ " << devProp.multiProcessorCount << std::endl;
//        std::cout << "======================================================" << std::endl;
//
//    }
//    return 0;
//}