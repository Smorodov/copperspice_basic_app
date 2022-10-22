# -----------------------------------
#
# -----------------------------------
cmake_policy(VERSION 3.16..3.23)
if (${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.20.0")
   # enable RTTI on MSVC
   cmake_policy(SET CMP0117 OLD)
endif()
# -----------------------------------
#
# -----------------------------------
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_INCLUDE_DIRECTORIES_BEFORE ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)
# -----------------------------------
# prepare folders and populate 
# thrm with dlls and resources
# -----------------------------------

 add_custom_target(build-time-make-directory ALL 
 COMMAND ${CMAKE_COMMAND} -E 
 make_directory      "$<TARGET_FILE_DIR:${PROJECT_NAME}>"		    
 make_directory      "$<TARGET_FILE_DIR:${PROJECT_NAME}>/platforms"
 make_directory      "$<TARGET_FILE_DIR:${PROJECT_NAME}>/resources"		    
 )


file(GLOB COPPERSPICE_DLLsRelease ${CopperSpice}/bin/Release/*.dll;${CopperSpice}/bin/Release/*.exe)
file(GLOB COPPERSPICE_DLLsDebug ${CopperSpice}/bin/Debug/*.dll;${CopperSpice}/bin/Debug/*.exe)

file(GLOB COPPERSPICE_PLATFORM_DLLsRelease ${CopperSpice}/lib/Release/*.dll)
file(GLOB COPPERSPICE_PLATFORM_DLLsDebug ${CopperSpice}/lib/Debug/*.dll)

file(GLOB COPPERSPICE_LIBsRelease ${CopperSpice}/lib/Release/*.lib)
file(GLOB COPPERSPICE_LIBsDebug ${CopperSpice}/lib/Debug/*.lib)

message("${COPPERSPICE_LIBsRelease}")
message("${COPPERSPICE_LIBsDebug}")

 add_custom_target(CopyCopperSpiceDLLs ALL
                 COMMENT "Copying copperspice DLLs ${COPPERSPICE_DLLs}"
                 DEPENDS build-time-make-directory
 	    VERBATIM
                 COMMAND_EXPAND_LISTS
                
 #	   COMMAND ${CMAKE_COMMAND} -E 
 #	   copy_directory 
 #               "${CMAKE_SOURCE_DIR}/resources/"
 #	   "$<$<CONFIG:Debug>:${CMAKE_BINARY_DIR}/Debug/resources/>"
 #               "$<$<CONFIG:Release>:${CMAKE_BINARY_DIR}/Release/resources/>"
 
 	   COMMAND ${CMAKE_COMMAND} -E
                     copy_if_different 
                             "$<$<CONFIG:Debug>:${COPPERSPICE_DLLsDebug}>"
 		                    "$<$<CONFIG:Release>:${COPPERSPICE_DLLsRelease}>" 
 		                    "$<TARGET_FILE_DIR:${PROJECT_NAME}>"
                     
         COMMAND ${CMAKE_COMMAND} -E
             copy_if_different 
                     "$<$<CONFIG:Release>:${COPPERSPICE_PLATFORM_DLLsRelease}>" 
                     "$<$<CONFIG:Debug>:${COPPERSPICE_PLATFORM_DLLsDebug}>"
                     "$<TARGET_FILE_DIR:${PROJECT_NAME}>/platforms"		    
 )

# -----------------------------------
# Macros 
# -----------------------------------
 MACRO(SUBDIRLIST result curdir)
   FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
  
   FOREACH(child ${children})
     IF(IS_DIRECTORY ${curdir}/${child})
       set(dirlist ${dirlist} ${child})
     ENDIF()
   ENDFOREACH()
   SET(${result} ${dirlist})
 ENDMACRO()

# -----------------------------------
# Macros to compile resources
# -----------------------------------
macro(COPPERSPICE_RESOURCES RESOURCES)
   foreach(resource ${RESOURCES} ${ARGN})
      get_filename_component(rscext ${resource}  EXT)
      get_filename_component(rscname ${resource} NAME_WE)
      set (toolsDir "$<TARGET_FILE_DIR:${PROJECT_NAME}>")
      if("${rscext}" STREQUAL ".ts")
         add_custom_command(
            OUTPUT "${CMAKE_SOURCE_DIR}/resources/${rscname}.qm"               
            COMMENT "Compiling ${rscname}.qm>"
            COMMAND ${toolsDir}/lrelease.exe ${resource} -qm  ${CMAKE_SOURCE_DIR}/resources/${rscname}.qm
            MAIN_DEPENDENCY "${resource}"
         )
      elseif("${rscext}" STREQUAL ".ui")
         set(rscout ${CMAKE_CURRENT_BINARY_DIR}/ui_${rscname}.h)
         add_custom_command(
            OUTPUT ${rscout}
            COMMENT "Compiling}${resource}"
            COMMAND ${toolsDir}/uic.exe ${resource} -o ${rscout}            
            MAIN_DEPENDENCY "${resource}"
         )
      elseif("${rscext}" STREQUAL ".qrc")
         set(rscout ${CMAKE_CURRENT_BINARY_DIR}/qrc_${rscname}.cpp)
         list(APPEND COMPILED_QRC ${rscout})
         add_custom_command(
            OUTPUT ${rscout}
            COMMENT "Compiling}${resource}"
            COMMAND ${toolsDir}/rcc.exe ${resource} -o ${rscout} -name ${rscname}
            MAIN_DEPENDENCY "${resource}"
         )
         set_property(SOURCE ${resource} APPEND PROPERTY OBJECT_DEPENDS ${rscout})
      endif()
   endforeach()
endmacro()

include_directories("${CopperSpice}/include/")
SUBDIRLIST(SUBDIRS "${CopperSpice}/include")
FOREACH(subdir ${SUBDIRS})
  message(${subdir})
  include_directories("${CopperSpice}/include/${subdir}")  
ENDFOREACH()

# ------------------------------------------------------------------------------
# Collect libs for ootimized configuration
# ----------------------------------------------------------------------------
 foreach(lib ${COPPERSPICE_LIBsRelease} ${ARGN})
 set(cs_libs ${cs_libs} optimized ${lib})   
 message (${lib})    
 endforeach()
# ----------------------------------------------------------------------------
# Collect libs for debug configuration
# ----------------------------------------------------------------------------
 foreach(lib ${COPPERSPICE_LIBsDebug} ${ARGN})
    message (${lib})
    set(cs_libs ${cs_libs} debug ${lib})   
 endforeach()