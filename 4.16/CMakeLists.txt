project(recastnavigation)

file (GLOB_RECURSE recastnavigation_files_all "*.h" "*.cpp" "*.cc" "*.hpp")

# See functions.cmake
add_source_group (${recastnavigation_files_all})

add_library (recastnavigation STATIC ${recastnavigation_files_all})

set_target_properties (recastnavigation PROPERTIES
    OUTPUT_NAME ${project_lib_prefix}recastnavigation
    DEBUG_POSTFIX "${project_debug_postfix}")

target_include_directories (recastnavigation PUBLIC .)
target_include_directories (recastnavigation PUBLIC Public)


