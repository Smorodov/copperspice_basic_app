cmake_minimum_required(VERSION 3.16.0 FATAL_ERROR)
# -----------------------------------
# copperspice folder name where lib, bin and include
# folders contained
# lib and bin folders should contain Release and Debug
# subfolders.
# -----------------------------------
set(CopperSpice "Z:/Projects2022/copperspice/vs2022")
# -----------------------------------
# Project name
# -----------------------------------
project(copperspice_basic_app)
# -----------------------------------
# Definitions
# -----------------------------------
add_definitions(-DUNICODE -D_UNICODE -DNOMINMAX -D_USE_MATH_DEFINES)
# -----------------------------------
# copies copperspice DLL's
# copies copperspice platforms DLL's
# adds copperspice includes
# defines cs_libs variable to add to project
# -----------------------------------
include(cmake/prepare.cmake)
# -----------------------------------
# Add project files
# -----------------------------------
file(GLOB SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp")
file(GLOB HEADERS "${CMAKE_CURRENT_SOURCE_DIR}/src/*.h")
file(GLOB FORMS "${CMAKE_CURRENT_SOURCE_DIR}/forms/*.ui")
file(GLOB TRANSATIONS "${CMAKE_CURRENT_SOURCE_DIR}/resources/*.ts")
file(GLOB QRCS 
    ${CMAKE_CURRENT_SOURCE_DIR}/kitchensink.qrc
    ${CMAKE_CURRENT_SOURCE_DIR}/qdarkstyle/style.qrc
)
# -----------------------------------
# Compice resource
# -----------------------------------
COPPERSPICE_RESOURCES( ${TRANSATIONS} ${FORMS} ${QRCS})
# -----------------------------------
# add include dirs
# -----------------------------------
include_directories("${CMAKE_CURRENT_SOURCE_DIR}/src")
# -----------------------------------
# Add executable
# -----------------------------------
add_executable(${PROJECT_NAME}
 "${COMPILED_QRC}"
 "${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp"
 "${CMAKE_CURRENT_SOURCE_DIR}/src/mainwindow.cpp"
 "${TRANSATIONS}"
 "${FORMS}"
 "${QRCS}"
)
# ----------------------------------------------------------------------------
# attach libs
# ${cs_libs} defined in cmake/prepare.cmake
# ----------------------------------------------------------------------------
 target_link_libraries(${PROJECT_NAME} ${cs_libs})
# ----------------------------------------------------------------------------
# 
# ----------------------------------------------------------------------------
set_target_properties( ${project_name} PROPERTIES  VS_DEBUGGER_WORKING_DIRECTORY "$<TARGET_FILE_DIR:${PROJECT_NAME}>")
set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT ${project_name})
