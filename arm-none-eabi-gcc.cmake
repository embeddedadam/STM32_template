# Call Cmake from the 'build' subfolder with the command below.
# For using Make:
# cmake -DCMAKE_MAKE_PROGRAM=make.exe -DCMAKE_TOOLCHAIN_FILE="arm-none-eabi-gcc.cmake" -G "Unix Makefiles" ..
# followed by
# 'make' or 'cmake --build .' to build it
#
# For using Ninja:
# cmake -DCMAKE_MAKE_PROGRAM=ninja.exe -DCMAKE_TOOLCHAIN_FILE="arm-none-eabi-gcc.cmake" -G "Ninja" ..
# followed by
# 'ninja' or 'cmake --build .' to build it

# System Generic - no OS bare-metal application
set(CMAKE_SYSTEM_NAME Generic)
# Setup arm processor and gcc toolchain
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)
set(CMAKE_AR arm-none-eabi-ar)
set(CMAKE_OBJCOPY arm-none-eabi-objcopy)
set(CMAKE_OBJDUMP arm-none-eabi-objdump)
set(CMAKE_NM arm-none-eabi-nm)
set(CMAKE_STRIP arm-none-eabi-strip)
set(CMAKE_RANLIB arm-none-eabi-ranlib)
# When trying to link cross compiled test program, error occurs, so setting test compilation to static library
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

macro(add_arm_executable STM32F4_template)
# Output files
set(elf_file ${target_name}.elf)
set(map_file ${target_name}.map)
set(hex_file ${target_name}.hex)
set(bin_file ${target_name}.bin)
set(lss_file ${target_name}.lss)
set(dmp_file ${target_name}.dmp)
add_executable(${elf_file} ${ARGN})
#generate hex file
add_custom_command(
  OUTPUT ${hex_file}
  COMMAND
    ${CMAKE_OBJCOPY} -O ihex ${elf_file} ${hex_file}
  DEPENDS ${elf_file}
)
# #generate bin file
add_custom_command(
  OUTPUT ${bin_file}
  COMMAND
    ${CMAKE_OBJCOPY} -O binary ${elf_file} ${bin_file}
  DEPENDS ${elf_file}
)
# #generate extended listing
add_custom_command(
  OUTPUT ${lss_file}
  COMMAND
    ${CMAKE_OBJDUMP} -h -S ${elf_file} > ${lss_file}
  DEPENDS ${elf_file}
)
# #generate memory dump
add_custom_command(
  OUTPUT ${dmp_file}
  COMMAND
    ${CMAKE_OBJDUMP} -x --syms ${elf_file} > ${dmp_file}
  DEPENDS ${elf_file}
)
#postprocessing from elf file - generate hex bin etc.
add_custom_target(
  ${CMAKE_PROJECT_NAME}
  ALL
  DEPENDS ${hex_file} ${bin_file} ${lss_file} ${dmp_file}
)
set_target_properties(
  ${CMAKE_PROJECT_NAME}
  PROPERTIES
    OUTPUT_NAME ${elf_file}
)
endmacro(add_arm_executable)