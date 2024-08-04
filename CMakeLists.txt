cmake_minimum_required(VERSION 3.27)

project(inputviewer
        DESCRIPTION "Viewer for input devices"
        LANGUAGES CXX
        VERSION 0.1.0
)

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/modules)

option(BUILD_EXTERNAL_LIBRARIES "Build external libraries" ON)
option(USE_CLANG_TIDY "Use Clang-tidy" OFF)

include(${CMAKE_MODULE_PATH}/myVariables.cmake)
include(${CMAKE_MODULE_PATH}/ClangFormat.cmake)
clangformat_setup()
include(${CMAKE_MODULE_PATH}/MakeDoc.cmake)
if (USE_CLANG_TIDY)
    include(${CMAKE_MODULE_PATH}/ClangTidy.cmake)
endif()

find_package(PkgConfig REQUIRED)
pkg_check_modules(LIBEVDEV REQUIRED libevdev)

add_subdirectory(lib)

file(GLOB_RECURSE SOURCES ${SRC_DIR}/*.cpp)

add_executable(${PROJECT_NAME} ${SOURCES})

target_include_directories(${PROJECT_NAME} PRIVATE
        ${INCLUDE_DIR}
)

target_link_libraries(${PROJECT_NAME} PRIVATE
        my_lib
        ${LIBEVDEV_LIBRARIES}
)


target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_20)
target_compile_options(${PROJECT_NAME} PRIVATE ${WARNING_FLAGS})
