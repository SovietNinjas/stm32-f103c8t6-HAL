cmake_minimum_required(VERSION 3.26.2)

#create fake lib (name common) for transferring settings to different targets
add_library(common INTERFACE)

target_include_directories(common INTERFACE
    "Core/Inc"
    "Drivers/STM32F1xx_HAL_Driver/Inc"
    "Drivers/STM32F1xx_HAL_Driver/Inc/Legacy"
    "Drivers/CMSIS/Device/ST/STM32F1xx/Include"
    "Drivers/CMSIS/Include"
    "Middlewares/Third_Party/FreeRTOS/Source/include"
    "Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS_V2"
    "Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM3"
)

set(COMMON_OPTIONS
    "-mcpu=cortex-m4"
    "--specs=nano.specs"
    "-mthumb"
)

target_compile_options(common INTERFACE
    "${COMMON_OPTIONS}"

    "$<$<COMPILE_LANGUAGE:C, CXX>:-ffunction-sections$<SEMICOLON>-fdata-sections$<SEMICOLON>-Wall$<SEMICOLON>-fstack-usage>"
    "$<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions$<SEMICOLON>-fno-rtti$<SEMICOLON>-fno-use-cxa-atexit>"

    "$<$<CONFIG:Debug>:-O0$<SEMICOLON>-g3>"
    "$<$<CONFIG:Release>:-Os>"
    "$<$<CONFIG:RelWithDebInfo>:-O2$<SEMICOLON>-g>"
)

file(GLOB LINKER_SCRIPT "${CMAKE_SOURCE_DIR}/*_FLASH.ld")
if (NOT LINKER_SCRIPT)
    file(GLOB LINKER_SCRIPT "${CMAKE_SOURCE_DIR}/*.ld")
    if (NOT LINKER_SCRIPT)
        message(FATAL_ERROR "NO LINKER SCRIPTS FOUND")
    endif ()
endif ()
message(STATUS " HELLO ${CMAKE_SOURCE_DIR}")
message(STATUS "Detected Linker Script for ${KRNL}: ${LINKER_SCRIPT}")

target_link_options(common INTERFACE
    "-T${LINKER_SCRIPT}"
    "-Wl,-Map=${PROJECT_BINARY_DIR}/${PROJECT_NAME}.map"
    "-static"
    "-Wl,--print-memory-usage,--gc-sections,--start-group"
    "-lc"
    "-lm"
    "-lstdc++"
    "-lsupc++"
    "$<$<CONFIG:Debug>:-Wl,--defsym=__DEBUG=1>"
    "-Wl,--end-group"
    "${COMMON_OPTIONS}"
)

target_compile_definitions(common INTERFACE
    "USE_HAL_DRIVER"
    "STM32F103xB"
    "$<$<CONFIG:Debug>:DEBUG>"
    "$<$<CONFIG:Release,RelWithDebInfo>:RELEASE$<SEMICOLON>NDEBUG>"
)
