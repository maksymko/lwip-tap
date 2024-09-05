cmake_minimum_required(VERSION 3.22)

project(LwIP-TAPIF)

set(CMAKE_CXX_STANDARD 17)

find_package(Threads REQUIRED)

add_compile_options(-Wall -Wextra -fdiagnostics-color=always)

include(lwip_libs.cmake)

add_library(my_tapif STATIC tapif.c)
target_include_directories(my_tapif
    PUBLIC
    ${CMAKE_SOURCE_DIR}
)
target_link_libraries(my_tapif
    PUBLIC
    lwip_core
    lwip_config
)

add_executable(lwip-tap lwip-tap.c)
target_link_libraries(lwip-tap
    PRIVATE
    my_tapif
    lwip_core
    lwip_api
    lwip_config
    lwip_contrib_apps
    lwip_unix
)

add_subdirectory(unittest)
add_subdirectory(thirdparty/catch2)
