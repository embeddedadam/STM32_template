# STM32F4 MCU template setup
Configured for visual studio code using CMake. 

# Build
```cd build/```

```cmake -DCMAKE_MAKE_PROGRAM=ninja -G "Ninja" ..```

```ninja``` 

or 

```cd build/```

```cmake --build .```

# Cleaning

```cmake --build . --target clean```