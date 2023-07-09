cmake_minimum_required(VERSION 3.26.2)

message(STATUS "BUILD MODE: ${CMAKE_BUILD_TYPE}")

set(CMAKE_TOOLCHAIN_FILE "${CMAKE_SOURCE_DIR}/cmake/toolchain.cmake")

project(stm32-f103c8t6-HAL
    LANGUAGES C ASM
)

set(CMAKE_C_STANDARD 11)

file(GLOB_RECURSE
    DRV_GLOB
    "${PROJECT_SOURCE_DIR}/Drivers/*.[cs]"
    "${PROJECT_SOURCE_DIR}/Middlewares/*.[cs]"
)

file(GLOB_RECURSE
    CORE_GLOB
    "${PROJECT_SOURCE_DIR}/Core/*.[cs]"
)

include(cmake/common.cmake)

set(EXEC_FILE "${PROJECT_NAME}.elf")

add_executable("${EXEC_FILE}")

target_link_libraries("${EXEC_FILE}" PRIVATE common)

target_sources("${EXEC_FILE}" PRIVATE
    ${DRV_GLOB}
    ${CORE_GLOB}
)
