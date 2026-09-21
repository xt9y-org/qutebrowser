# Install script for directory: /Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtbase/src/plugins/tls/securetransport

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/Users/felixjaschul/CLionProjects/qutebrowser/qt-webgpu")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set path to fallback-tool for dependency-resolution.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Network" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6Network/Qt6QSecureTransportBackendPluginConfig.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6Network/Qt6QSecureTransportBackendPluginConfigVersion.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6Network/Qt6QSecureTransportBackendPluginConfigVersionImpl.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6Network/Qt6QSecureTransportBackendPluginTargetsPrecheck.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/plugins/tls" TYPE MODULE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/plugins/tls/libqsecuretransportbackend.dylib")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/plugins/tls/libqsecuretransportbackend.dylib" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/plugins/tls/libqsecuretransportbackend.dylib")
    execute_process(COMMAND /usr/bin/install_name_tool
      -delete_rpath "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib"
      -add_rpath "@loader_path/../../lib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/plugins/tls/libqsecuretransportbackend.dylib")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" -x "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/plugins/tls/libqsecuretransportbackend.dylib")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Network/Qt6QSecureTransportBackendPluginTargets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Network/Qt6QSecureTransportBackendPluginTargets.cmake"
         "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/src/plugins/tls/securetransport/CMakeFiles/Export/4f7a78213d2af5c8b0a2bc72fc885662/Qt6QSecureTransportBackendPluginTargets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Network/Qt6QSecureTransportBackendPluginTargets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Network/Qt6QSecureTransportBackendPluginTargets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Network" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/src/plugins/tls/securetransport/CMakeFiles/Export/4f7a78213d2af5c8b0a2bc72fc885662/Qt6QSecureTransportBackendPluginTargets.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Network" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/src/plugins/tls/securetransport/CMakeFiles/Export/4f7a78213d2af5c8b0a2bc72fc885662/Qt6QSecureTransportBackendPluginTargets-release.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Network" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6Network/Qt6QSecureTransportBackendPluginAdditionalTargetInfo.cmake")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/src/plugins/tls/securetransport/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
