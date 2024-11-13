#!/bin/bash


# download all dependencies
lake update

# build shared libraries of all dependencies
lake build Batteries:shared
# get current version of lean
export LEAN_VERSION=`cat lean-toolchain` && export LEAN_VERSION=${LEAN_VERSION:17}

# # convert `libLean.a` to `libLean.so`
# mkdir -p .lake/build
# g++ -shared -o .lake/build/libLean.so -Wl,--whole-archive -fvisibility=default $HOME/.elan/toolchains/leanprover--lean4---${LEAN_VERSION}/lib/lean/libLean.a -Wl,--no-whole-archive

# /Users/ahuja
# v4.14.0-rc1
# Convert `libLean.a` to `libLean.dylib` on macOS
# mkdir -p .lake/build
# g++ -shared -o .lake/build/libLean.dylib -Wl,-force_load,$HOME/.elan/toolchains/leanprover--lean4---${LEAN_VERSION}/lib/lean/libLean.a \
#     -fvisibility=default -mmacosx-version-min=13.0

# build project
lake build

# set up enviroment variables
export LIBRARY_PATH=$(pwd)/.lake/build/lib/
export LIBRARY_PATH=$LIBRARY_PATH:$HOME/.elan/toolchains/leanprover--lean4---${LEAN_VERSION}/lib/lean/
export LIBRARY_PATH=$LIBRARY_PATH:$(pwd)/.lake/packages/aesop/.lake/build/lib/
export LIBRARY_PATH=$LIBRARY_PATH:$(pwd)/.lake/packages/Cli/.lake/build/lib/
export LIBRARY_PATH=$LIBRARY_PATH:$(pwd)/.lake/packages/importGraph/.lake/build/lib/
export LIBRARY_PATH=$LIBRARY_PATH:$(pwd)/.lake/packages/mathlib/.lake/build/lib/
export LIBRARY_PATH=$LIBRARY_PATH:$(pwd)/.lake/packages/proofwidgets/.lake/build/lib/
export LIBRARY_PATH=$LIBRARY_PATH:$(pwd)/.lake/packages/Qq/.lake/build/lib/
export LIBRARY_PATH=$LIBRARY_PATH:$(pwd)/.lake/packages/batteries/.lake/build/lib/
export LIBRARY_PATH=$LIBRARY_PATH:$(pwd)/.lake/packages/LeanSearchClient/.lake/build/lib/

# export LIBRARY_PATH=$LIBRARY_PATH:$(pwd)/.lake/packages/plausible/.lake/build/lib/  # Add this line


export LD_LIBRARY_PATH=$LIBRARY_PATH
export DYLD_LIBRARY_PATH=$LIBRARY_PATH
export CPLUS_INCLUDE_PATH=$HOME/.elan/toolchains/leanprover--lean4---${LEAN_VERSION}/include/
# build C++ file calling Lean functions
# g++ test.cpp -o test -lleanshared -lreverseffiwithmathlib
g++ test.cpp -o test -lleanshared -lreverseffiwithmathlib


# run 
./test
