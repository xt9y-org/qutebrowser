# Install script for directory: /Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmltoolingsettings

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
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/metatypes" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmltoolingsettings/meta_types/qt6qmltoolingsettingsprivate_metatypes.json")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlToolingSettingsPrivate" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlToolingSettingsPrivate/Qt6QmlToolingSettingsPrivateConfig.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlToolingSettingsPrivate/Qt6QmlToolingSettingsPrivateConfigVersion.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlToolingSettingsPrivate/Qt6QmlToolingSettingsPrivateConfigVersionImpl.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlToolingSettingsPrivate/Qt6QmlToolingSettingsPrivateTargetsPrecheck.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/libQt6QmlToolingSettings.a")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6QmlToolingSettings.a" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6QmlToolingSettings.a")
    execute_process(COMMAND "/usr/bin/ranlib" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6QmlToolingSettings.a")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlToolingSettingsPrivate/Qt6QmlToolingSettingsPrivateTargets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlToolingSettingsPrivate/Qt6QmlToolingSettingsPrivateTargets.cmake"
         "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmltoolingsettings/CMakeFiles/Export/e1b4a79419576b23a320b2a8a2769649/Qt6QmlToolingSettingsPrivateTargets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlToolingSettingsPrivate/Qt6QmlToolingSettingsPrivateTargets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlToolingSettingsPrivate/Qt6QmlToolingSettingsPrivateTargets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlToolingSettingsPrivate" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmltoolingsettings/CMakeFiles/Export/e1b4a79419576b23a320b2a8a2769649/Qt6QmlToolingSettingsPrivateTargets.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlToolingSettingsPrivate" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmltoolingsettings/CMakeFiles/Export/e1b4a79419576b23a320b2a8a2769649/Qt6QmlToolingSettingsPrivateTargets-release.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlToolingSettingsPrivate" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlToolingSettingsPrivate/Qt6QmlToolingSettingsPrivateVersionlessAliasTargets.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlToolingSettingsPrivate/Qt6QmlToolingSettingsPrivateVersionlessTargets.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlToolingSettingsPrivate" TYPE FILE FILES
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/modules" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/modules/QmlToolingSettingsPrivate.json")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlToolingSettingsPrivate" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlToolingSettingsPrivate/Qt6QmlToolingSettingsPrivateAdditionalTargetInfo.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/QtQmlToolingSettings" TYPE DIRECTORY FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/include/QtQmlToolingSettings/.syncqt_staging/")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/QtQmlToolingSettings" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/include/QtQmlToolingSettings/QtQmlToolingSettingsDepends")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/QtQmlToolingSettings/6.11.2/QtQmlToolingSettings/private" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmltoolingsettings/qqmltoolingsettings_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmltoolingsettings/qqmltoolingutils_p.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/libQt6QmlToolingSettings.prl")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/mkspecs/modules" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/mkspecs/modules/qt_lib_qmltoolingsettings_private.pri")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmltoolingsettings/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
