# Install script for directory: /Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug

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

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/metatypes" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmldebug/meta_types/qt6qmldebugprivate_metatypes.json")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlDebugPrivate" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlDebugPrivate/Qt6QmlDebugPrivateConfig.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlDebugPrivate/Qt6QmlDebugPrivateConfigVersion.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlDebugPrivate/Qt6QmlDebugPrivateConfigVersionImpl.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlDebugPrivate/Qt6QmlDebugPrivateTargetsPrecheck.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/libQt6QmlDebug.a")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6QmlDebug.a" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6QmlDebug.a")
    execute_process(COMMAND "/usr/bin/ranlib" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6QmlDebug.a")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlDebugPrivate/Qt6QmlDebugPrivateTargets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlDebugPrivate/Qt6QmlDebugPrivateTargets.cmake"
         "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmldebug/CMakeFiles/Export/9b79779730b5a3658a66967fc7bcca6f/Qt6QmlDebugPrivateTargets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlDebugPrivate/Qt6QmlDebugPrivateTargets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlDebugPrivate/Qt6QmlDebugPrivateTargets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlDebugPrivate" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmldebug/CMakeFiles/Export/9b79779730b5a3658a66967fc7bcca6f/Qt6QmlDebugPrivateTargets.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlDebugPrivate" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmldebug/CMakeFiles/Export/9b79779730b5a3658a66967fc7bcca6f/Qt6QmlDebugPrivateTargets-release.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlDebugPrivate" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlDebugPrivate/Qt6QmlDebugPrivateVersionlessAliasTargets.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlDebugPrivate/Qt6QmlDebugPrivateVersionlessTargets.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlDebugPrivate" TYPE FILE FILES
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/modules" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/modules/QmlDebugPrivate.json")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlDebugPrivate" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlDebugPrivate/Qt6QmlDebugPrivateAdditionalTargetInfo.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/QtQmlDebug" TYPE DIRECTORY FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/include/QtQmlDebug/.syncqt_staging/")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/QtQmlDebug" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/include/QtQmlDebug/QtQmlDebugDepends")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/QtQmlDebug/6.11.2/QtQmlDebug/private" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qqmldebugclient_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qqmldebugclient_p_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qqmldebugconnection_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qqmldebugmessageclient_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qqmldebugtranslationclient_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qqmlenginecontrolclient_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qqmlenginecontrolclient_p_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qqmlenginedebugclient_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qqmlenginedebugclient_p_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qqmlinspectorclient_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qqmlinspectorclient_p_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qqmlpreviewclient_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qqmlpreviewclient_p_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qqmlprofilerclient_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qqmlprofilerclient_p_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qqmlprofilerclientdefinitions_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qqmlprofilerevent_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qqmlprofilereventlocation_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qqmlprofilereventreceiver_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qqmlprofilereventtype_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qqmlprofilerqtdwriter_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qqmlprofilertypedevent_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qquickeventreplayclient_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qv4debugclient_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldebug/qv4debugclient_p_p.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/libQt6QmlDebug.prl")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/mkspecs/modules" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/mkspecs/modules/qt_lib_qmldebug_private.pri")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmldebug/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
