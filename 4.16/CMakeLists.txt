cmake_minimum_required(VERSION 3.0)

project(recastnavigation-ue4)

# Turn on the ability to create folders to organize projects (.vcproj)
# It creates "CMakePredefinedTargets" folder by default and adds CMake
# defined projects like INSTALL.vcproj and ZERO_CHECK.vcproj
set_property (GLOBAL PROPERTY USE_FOLDERS ON)

# set library prefix and postfix
if (MSVC)
  # Add the "lib" prefix for generated .lib outputs.
  set (project_lib_prefix lib)
else (MSVC)
  # When building with "make", "lib" prefix will be added automatically by
  # the build tool.
  set (project_lib_prefix)
  # Add _DEBUG macro with debug build
  set (CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -D_DEBUG")
  # Tell compiler to use latest C/C++ language standards
  set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")
  # Enable multithreading with pthread
  set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread")
  # Always enable strict aliasing in order to discover aliasing problems as quickly as possible
  # See: http://cellperformance.beyond3d.com/articles/2006/06/understanding-strict-aliasing.html
  set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fstrict-aliasing")
  # Enable all warnings, treat warnings as errors, only disable some certain warnings
  #set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Werror -Woverloaded-virtual -Wpointer-arith")
  # Statically link libstdc++ and libgcc
  # so the runtime environment has no need to install extra depdendencies
  set (CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static-libstdc++ -static-libgcc")
endif (MSVC)
set (project_debug_postfix "d"
  CACHE STRING "Default debug postfix")

# Disable C++11 ABI to be compatible with static libraries
add_definitions (-D_GLIBCXX_USE_CXX11_ABI=0)

# Print out compiler and linker flags
message (STATUS "CMAKE_CXX_FLAGS: " ${CMAKE_CXX_FLAGS})
message (STATUS "CMAKE_EXE_LINKER_FLAGS: " ${CMAKE_EXE_LINKER_FLAGS})

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)

file (GLOB_RECURSE recastnavigation-ue4_files_all "*.h" "*.cpp" "*.cc" "*.hpp")
add_library (${PROJECT_NAME} STATIC ${recastnavigation-ue4_files_all})
include_directories(Public/Recast)
include_directories(Public/Detour)

set_target_properties (${PROJECT_NAME} PROPERTIES
    OUTPUT_NAME ${project_lib_prefix}${PROJECT_NAME}
    DEBUG_POSTFIX "${project_debug_postfix}")

target_include_directories (${PROJECT_NAME} PUBLIC Public)

# Destinations for installing different kinds of targets (pass to install command).
set (target_install_list
	RUNTIME DESTINATION  bin
	LIBRARY DESTINATION  lib
	ARCHIVE DESTINATION  lib
)
install (TARGETS ${PROJECT_NAME} DESTINATION ${target_install_list})
install (DIRECTORY Public/ DESTINATION include)


