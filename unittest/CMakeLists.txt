add_executable(tap_lib_test tap_lib_test.cpp)
target_link_libraries(tap_lib_test
    PRIVATE
    taplib
    Catch2WithMain
)
