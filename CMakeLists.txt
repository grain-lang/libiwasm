cmake_minimum_required(VERSION 3.10.2)

project(libwamr LANGUAGES C CXX VERSION 1.1.1)

# Reset default linker flags
set (CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "")
set (CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "")

set (CMAKE_C_STANDARD 99)

set(WAMR_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/wasm-micro-runtime)

include (${WAMR_ROOT_DIR}/build-scripts/runtime_lib.cmake)

set (CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--gc-sections -pie -fPIE")

set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra -Wformat -Wformat-security -Wshadow")

set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wformat -Wformat-security -Wno-unused")

if (WAMR_BUILD_TARGET MATCHES "X86_.*" OR WAMR_BUILD_TARGET STREQUAL "AMD_64")
  if (NOT (CMAKE_C_COMPILER MATCHES ".*clang.*" OR CMAKE_C_COMPILER_ID MATCHES ".*Clang"))
    set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mindirect-branch-register")
  endif ()
endif ()

add_library(wamr_static STATIC ${WAMR_RUNTIME_LIB_SOURCE})
target_link_libraries (wamr_static ${LLVM_AVAILABLE_LIBS} ${UV_A_LIBS})

if (MINGW)
  target_link_libraries (wamr_static ws2_32 iphlpapi userenv)
endif ()

add_library(wamr_shared SHARED ${WAMR_RUNTIME_LIB_SOURCE})
target_link_libraries (wamr_shared ${LLVM_AVAILABLE_LIBS} ${UV_A_LIBS})

if (MINGW)
  target_link_libraries (wamr_shared ws2_32 iphlpapi userenv)
endif ()
