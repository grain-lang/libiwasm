cmake_minimum_required(VERSION 3.10.2)

project(iwasm LANGUAGES C ASM CXX VERSION 1.1.1)
enable_language(ASM_MASM)

# Reset default linker flags
set (CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "")
set (CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "")

set (CMAKE_C_STANDARD 99)

add_definitions(-DCOMPILING_WASM_RUNTIME_API=1)

set(WAMR_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/wasm-micro-runtime)

# Configuration that is needed by Grain
set(WAMR_BUILD_INTERP 1)
set(WAMR_BUILD_FAST_INTERP 1)
set(WAMR_BUILD_AOT 0)
set(WAMR_BUILD_JIT 0)
set(WAMR_BUILD_FAST_JIT 0)
set(WAMR_BUILD_LIBC_BUILTIN 1)
set(WAMR_BUILD_LIBC_WASI 0)
set(WAMR_BUILD_LIBC_UVWASI 1)
set(WAMR_BUILD_MULTI_MODULE 0)
set(WAMR_BUILD_MINI_LOADER 0)
set(WAMR_BUILD_SHARED_MEMORY 0)
set(WAMR_BUILD_BULK_MEMORY 1)
set(WAMR_BUILD_THREAD_MGR 0)
set(WAMR_BUILD_LIB_PTHREAD 0)
set(WAMR_BUILD_LIB_PTHREAD_SEMAPHORE 0)
set(WAMR_BUILD_TAIL_CALL 1)
set(WAMR_BUILD_SIMD 0)
set(WAMR_BUILD_CUSTOM_NAME_SECTION 0)
set(WAMR_BUILD_DUMP_CALL_STACK 0)
set(WAMR_BUILD_MEMORY_PROFILING 0)
set(WAMR_BUILD_PERF_PROFILING 0)
set(WAMR_BUILD_REF_TYPES 0)
set(WAMR_BUILD_DEBUG_INTERP 0)
set(WAMR_BUILD_LOAD_CUSTOM_SECTION 0)

if (MINGW)
  set(WAMR_DISABLE_HW_BOUND_CHECK 1)
endif ()


include (${WAMR_ROOT_DIR}/build-scripts/runtime_lib.cmake)

set (CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--gc-sections -pie -fPIE")

set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra -Wformat -Wformat-security -Wshadow")

set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wformat -Wformat-security -Wno-unused")

if (WAMR_BUILD_TARGET MATCHES "X86_.*" OR WAMR_BUILD_TARGET STREQUAL "AMD_64")
  if (NOT (CMAKE_C_COMPILER MATCHES ".*clang.*" OR CMAKE_C_COMPILER_ID MATCHES ".*Clang"))
    set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mindirect-branch-register")
  endif ()
endif ()

add_library(iwasm_static STATIC ${WAMR_RUNTIME_LIB_SOURCE})
target_link_libraries (iwasm_static ${LLVM_AVAILABLE_LIBS} ${UV_A_LIBS})

if (MINGW)
  target_link_libraries (iwasm_static ws2_32)
endif ()

add_library(iwasm_shared SHARED ${WAMR_RUNTIME_LIB_SOURCE})
target_link_libraries (iwasm_shared ${LLVM_AVAILABLE_LIBS} ${UV_A_LIBS})

if (MINGW)
  target_link_libraries (iwasm_shared ws2_32)
endif ()
