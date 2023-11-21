#include <thrust/device_vector.h>
#include <thrust/host_vector.h>

#include "GPUThrustVectorAddPlugin.h"

void GPUThrustVectorAddPlugin::input(std::string infile) {
  readParameterFile(infile);
}

void GPUThrustVectorAddPlugin::run() {}

void GPUThrustVectorAddPlugin::output(std::string outfile) {
  float *hostInput1;
  float *hostInput2;
  float *hostOutput;
  int inputLength;

 inputLength = atoi(myParameters["N"].c_str());
 hostInput1 = (float*) malloc(inputLength*sizeof(float));
 hostInput2 = (float*) malloc(inputLength*sizeof(float));
 std::ifstream myinput((std::string(PluginManager::prefix())+myParameters["vector1"]).c_str(), std::ios::in);
 int i;
 for (i = 0; i < inputLength; ++i) {
        float k;
        myinput >> k;
        hostInput1[i] = k;
 }
 std::ifstream myinput2((std::string(PluginManager::prefix())+myParameters["vector2"]).c_str(), std::ios::in);
 for (i = 0; i < inputLength; ++i) {
        float k;
        myinput2 >> k;
        hostInput2[i] = k;
 }


  // Declare and allocate host output
  //@@ Insert code here
  hostOutput = (float *)malloc(sizeof(float) * inputLength);

  //@@ Insert code here
  thrust::device_vector<float> deviceInput1(inputLength);
  thrust::device_vector<float> deviceInput2(inputLength);
  thrust::device_vector<float> deviceOutput(inputLength);
  //@@ Insert code here
  thrust::copy(hostInput1, hostInput1 + inputLength, deviceInput1.begin());
  thrust::copy(hostInput2, hostInput2 + inputLength, deviceInput2.begin());
  //@@ Insert Code here
  thrust::transform(deviceInput1.begin(), deviceInput1.end(),
                    deviceInput2.begin(), deviceOutput.begin(),
                    thrust::plus<float>());
  //@@ Insert code here
  thrust::copy(deviceOutput.begin(), deviceOutput.end(), hostOutput);

 std::ofstream outsfile(outfile.c_str(), std::ios::out);
        for (i = 0; i < inputLength; ++i){
                outsfile << hostOutput[i];//std::setprecision(0) << a[i*N+j];
                outsfile << "\n";
        }


  free(hostInput1);
  free(hostInput2);
  free(hostOutput);
}

PluginProxy<GPUThrustVectorAddPlugin> GPUThrustVectorAddPluginProxy = PluginProxy<GPUThrustVectorAddPlugin>("GPUThrustVectorAdd", PluginManager::getInstance());
