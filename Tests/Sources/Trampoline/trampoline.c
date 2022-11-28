#include <NAPI.h>

napi_value _init_napoli_tests(napi_env, napi_value);

NAPI_MODULE(napoli_tests, _init_napoli_tests)
