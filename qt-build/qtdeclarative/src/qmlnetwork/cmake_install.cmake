# Install script for directory: /Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmlnetwork

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
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/metatypes" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmlnetwork/meta_types/qt6qmlnetwork_metatypes.json")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlNetwork" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlNetwork/Qt6QmlNetworkConfig.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlNetwork/Qt6QmlNetworkConfigVersion.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlNetwork/Qt6QmlNetworkConfigVersionImpl.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlNetwork/Qt6QmlNetworkTargetsPrecheck.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlNetworkPrivate" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlNetworkPrivate/Qt6QmlNetworkPrivateConfig.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlNetworkPrivate/Qt6QmlNetworkPrivateConfigVersion.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlNetworkPrivate/Qt6QmlNetworkPrivateConfigVersionImpl.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlNetworkPrivate/Qt6QmlNetworkPrivateTargetsPrecheck.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE DIRECTORY FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/QtQmlNetwork.framework" USE_SOURCE_PERMISSIONS)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtQmlNetwork.framework/Versions/A/QtQmlNetwork" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtQmlNetwork.framework/Versions/A/QtQmlNetwork")
    execute_process(COMMAND /usr/bin/install_name_tool
      -delete_rpath "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib"
      -add_rpath "@loader_path/../../../"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtQmlNetwork.framework/Versions/A/QtQmlNetwork")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" -x "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtQmlNetwork.framework/Versions/A/QtQmlNetwork")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlNetwork/Qt6QmlNetworkTargets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlNetwork/Qt6QmlNetworkTargets.cmake"
         "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmlnetwork/CMakeFiles/Export/6b7e4fdd9f396cec0f76509c340aad2e/Qt6QmlNetworkTargets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlNetwork/Qt6QmlNetworkTargets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlNetwork/Qt6QmlNetworkTargets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlNetwork" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmlnetwork/CMakeFiles/Export/6b7e4fdd9f396cec0f76509c340aad2e/Qt6QmlNetworkTargets.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlNetwork" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmlnetwork/CMakeFiles/Export/6b7e4fdd9f396cec0f76509c340aad2e/Qt6QmlNetworkTargets-release.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlNetwork" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlNetwork/Qt6QmlNetworkVersionlessAliasTargets.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlNetwork/Qt6QmlNetworkVersionlessTargets.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlNetwork" TYPE FILE FILES
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlNetworkPrivate/Qt6QmlNetworkPrivateTargets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlNetworkPrivate/Qt6QmlNetworkPrivateTargets.cmake"
         "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmlnetwork/CMakeFiles/Export/e018817d37d54805a32a0e4c7af6f627/Qt6QmlNetworkPrivateTargets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlNetworkPrivate/Qt6QmlNetworkPrivateTargets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlNetworkPrivate/Qt6QmlNetworkPrivateTargets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlNetworkPrivate" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmlnetwork/CMakeFiles/Export/e018817d37d54805a32a0e4c7af6f627/Qt6QmlNetworkPrivateTargets.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlNetworkPrivate" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlNetworkPrivate/Qt6QmlNetworkPrivateVersionlessAliasTargets.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlNetworkPrivate/Qt6QmlNetworkPrivateVersionlessTargets.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlNetworkPrivate" TYPE FILE FILES
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/modules" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/modules/QmlNetwork.json")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6Qml/QmlPlugins/Qt6QmlNetworkpluginConfig.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6Qml/QmlPlugins/Qt6QmlNetworkpluginConfigVersion.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6Qml/QmlPlugins/Qt6QmlNetworkpluginConfigVersionImpl.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6Qml/QmlPlugins/Qt6QmlNetworkpluginTargetsPrecheck.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/qml/QtNetwork" TYPE MODULE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qml/QtNetwork/libqmlnetworkplugin.dylib")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/qml/QtNetwork/libqmlnetworkplugin.dylib" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/qml/QtNetwork/libqmlnetworkplugin.dylib")
    execute_process(COMMAND /usr/bin/install_name_tool
      -delete_rpath "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib"
      -add_rpath "@loader_path/../../lib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/qml/QtNetwork/libqmlnetworkplugin.dylib")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" -x "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/qml/QtNetwork/libqmlnetworkplugin.dylib")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins/Qt6QmlNetworkpluginTargets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins/Qt6QmlNetworkpluginTargets.cmake"
         "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmlnetwork/CMakeFiles/Export/a1553df5751c39c799cb845445fde701/Qt6QmlNetworkpluginTargets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins/Qt6QmlNetworkpluginTargets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins/Qt6QmlNetworkpluginTargets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmlnetwork/CMakeFiles/Export/a1553df5751c39c799cb845445fde701/Qt6QmlNetworkpluginTargets.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmlnetwork/CMakeFiles/Export/a1553df5751c39c799cb845445fde701/Qt6QmlNetworkpluginTargets-release.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/qml/QtNetwork" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qml/QtNetwork/plugins.qmltypes")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/qml/QtNetwork" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qml/QtNetwork/qmldir")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "_install_html_docs_QmlNetwork")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/doc/qtqmlnetwork" TYPE DIRECTORY FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/doc/qtqmlnetwork/")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "_install_qch_docs_QmlNetwork")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/doc" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/doc/qtqmlnetwork.qch")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlNetwork" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlNetwork/Qt6QmlNetworkAdditionalTargetInfo.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlNetworkPrivate" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlNetworkPrivate/Qt6QmlNetworkPrivateAdditionalTargetInfo.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/mkspecs/modules" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/mkspecs/modules/qt_lib_qmlnetwork.pri"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/mkspecs/modules/qt_lib_qmlnetwork_private.pri"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/pkgconfig/Qt6QmlNetwork.pc")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6Qml/QmlPlugins/Qt6QmlNetworkpluginAdditionalTargetInfo.cmake")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmlnetwork/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
