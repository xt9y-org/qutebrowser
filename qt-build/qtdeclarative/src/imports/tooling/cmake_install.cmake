# Install script for directory: /Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/imports/tooling

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
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6Qml/QmlPlugins/Qt6quicktoolingConfig.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6Qml/QmlPlugins/Qt6quicktoolingConfigVersion.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6Qml/QmlPlugins/Qt6quicktoolingConfigVersionImpl.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6Qml/QmlPlugins/Qt6quicktoolingTargetsPrecheck.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/qml/QtQuick/tooling" TYPE MODULE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qml/QtQuick/tooling/libquicktoolingplugin.dylib")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/qml/QtQuick/tooling/libquicktoolingplugin.dylib" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/qml/QtQuick/tooling/libquicktoolingplugin.dylib")
    execute_process(COMMAND /usr/bin/install_name_tool
      -delete_rpath "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib"
      -add_rpath "@loader_path/../../../lib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/qml/QtQuick/tooling/libquicktoolingplugin.dylib")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" -x "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/qml/QtQuick/tooling/libquicktoolingplugin.dylib")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins/Qt6quicktoolingTargets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins/Qt6quicktoolingTargets.cmake"
         "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/imports/tooling/CMakeFiles/Export/a1553df5751c39c799cb845445fde701/Qt6quicktoolingTargets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins/Qt6quicktoolingTargets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins/Qt6quicktoolingTargets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/imports/tooling/CMakeFiles/Export/a1553df5751c39c799cb845445fde701/Qt6quicktoolingTargets.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/imports/tooling/CMakeFiles/Export/a1553df5751c39c799cb845445fde701/Qt6quicktoolingTargets-release.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/qml/QtQuick/tooling" TYPE FILE RENAME "Component.qml" FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/imports/tooling/Component.qml")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/qml/QtQuick/tooling" TYPE FILE RENAME "Enum.qml" FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/imports/tooling/Enum.qml")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/qml/QtQuick/tooling" TYPE FILE RENAME "Member.qml" FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/imports/tooling/Member.qml")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/qml/QtQuick/tooling" TYPE FILE RENAME "Method.qml" FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/imports/tooling/Method.qml")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/qml/QtQuick/tooling" TYPE FILE RENAME "Module.qml" FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/imports/tooling/Module.qml")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/qml/QtQuick/tooling" TYPE FILE RENAME "Parameter.qml" FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/imports/tooling/Parameter.qml")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/qml/QtQuick/tooling" TYPE FILE RENAME "Property.qml" FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/imports/tooling/Property.qml")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/qml/QtQuick/tooling" TYPE FILE RENAME "Signal.qml" FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/imports/tooling/Signal.qml")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/qml/QtQuick/tooling" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qml/QtQuick/tooling/quicktooling.qmltypes")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/qml/QtQuick/tooling" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qml/QtQuick/tooling/qmldir")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6Qml/QmlPlugins/Qt6quicktoolingAdditionalTargetInfo.cmake")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/imports/tooling/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
