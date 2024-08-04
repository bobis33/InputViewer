#!/bin/bash

function clean() {
    if [ -d "build" ]; then
        rm -rf build/*
        echo "build directory has been cleaned."
    else
        echo "build directory does not exist."
    fi
    if [ -d ".doxygen" ]; then
        rm -rf .doxygen/html/* .doxygen/latex/*
        echo ".doxygen directory has been cleaned."
    else
        echo ".doxygen directory does not exist."
    fi
    if [ -f "inputviewer" ]; then
        rm inputviewer
        echo "inputviewer binary has been removed."
    else
        echo "inputviewer binary does not exist."
    fi
}

function build() {
    debug=$1
    if [ ! -d "build" ]; then
        mkdir -p build
    fi
    if [ "$debug" == "true" ]; then
        ./build.sh clean && cmake -S . -Bbuild -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DUSE_CLANG_TIDY=ON && cmake --build build
    else
        cmake -S . -Bbuild -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release && cmake --build build
    fi
}

if [ $# -eq 0 ]; then
    echo "Usage $0 build [debug] | clean | format"
    exit 1
fi

case $1 in
    build)
        if [ "$2" == "debug" ]; then
            build true
        else
            build false
        fi
        ;;
    clean)
        clean
        ;;
    format)
      cmake -S . -Bbuild -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release && cmake --build build --target clangformat
        ;;
    doc)
      cmake -S . -Bbuild -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release && cmake --build build --target doxygen
        ;;
    *)
        echo "Usage $0 build [debug] | clean"
        exit 1
        ;;
esac
