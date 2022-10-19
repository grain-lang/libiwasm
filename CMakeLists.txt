cmake_minimum_required(VERSION 3.10.2)
project(libwamr LANGUAGES C CXX VERSION 1.1.1)

set(WAMR_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/wasm-micro-runtime)

include (${WAMR_ROOT_DIR}/build-scripts/runtime_lib.cmake)
add_library(wamr ${WAMR_RUNTIME_LIB_SOURCE})

