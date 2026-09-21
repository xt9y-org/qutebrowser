# Install script for directory: /Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmlworkerscript

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
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/metatypes" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmlworkerscript/meta_types/qt6qmlworkerscript_metatypes.json")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlWorkerScript" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlWorkerScript/Qt6QmlWorkerScriptConfig.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlWorkerScript/Qt6QmlWorkerScriptConfigVersion.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlWorkerScript/Qt6QmlWorkerScriptConfigVersionImpl.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlWorkerScript/Qt6QmlWorkerScriptTargetsPrecheck.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlWorkerScriptPrivate" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlWorkerScriptPrivate/Qt6QmlWorkerScriptPrivateConfig.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlWorkerScriptPrivate/Qt6QmlWorkerScriptPrivateConfigVersion.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlWorkerScriptPrivate/Qt6QmlWorkerScriptPrivateConfigVersionImpl.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlWorkerScriptPrivate/Qt6QmlWorkerScriptPrivateTargetsPrecheck.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE DIRECTORY FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/QtQmlWorkerScript.framework" USE_SOURCE_PERMISSIONS)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtQmlWorkerScript.framework/Versions/A/QtQmlWorkerScript" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtQmlWorkerScript.framework/Versions/A/QtQmlWorkerScript")
    execute_process(COMMAND /usr/bin/install_name_tool
      -delete_rpath "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib"
      -add_rpath "@loader_path/../../../"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtQmlWorkerScript.framework/Versions/A/QtQmlWorkerScript")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" -x "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtQmlWorkerScript.framework/Versions/A/QtQmlWorkerScript")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlWorkerScript/Qt6QmlWorkerScriptTargets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlWorkerScript/Qt6QmlWorkerScriptTargets.cmake"
         "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmlworkerscript/CMakeFiles/Export/068021df516f66b8eadaeab97dd1916e/Qt6QmlWorkerScriptTargets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlWorkerScript/Qt6QmlWorkerScriptTargets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlWorkerScript/Qt6QmlWorkerScriptTargets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlWorkerScript" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmlworkerscript/CMakeFiles/Export/068021df516f66b8eadaeab97dd1916e/Qt6QmlWorkerScriptTargets.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlWorkerScript" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmlworkerscript/CMakeFiles/Export/068021df516f66b8eadaeab97dd1916e/Qt6QmlWorkerScriptTargets-release.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlWorkerScript" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlWorkerScript/Qt6QmlWorkerScriptVersionlessAliasTargets.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlWorkerScript/Qt6QmlWorkerScriptVersionlessTargets.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlWorkerScript" TYPE FILE FILES
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlWorkerScriptPrivate/Qt6QmlWorkerScriptPrivateTargets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlWorkerScriptPrivate/Qt6QmlWorkerScriptPrivateTargets.cmake"
         "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmlworkerscript/CMakeFiles/Export/92c57b060f28177355a8d0aedc5c1d91/Qt6QmlWorkerScriptPrivateTargets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlWorkerScriptPrivate/Qt6QmlWorkerScriptPrivateTargets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlWorkerScriptPrivate/Qt6QmlWorkerScriptPrivateTargets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlWorkerScriptPrivate" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmlworkerscript/CMakeFiles/Export/92c57b060f28177355a8d0aedc5c1d91/Qt6QmlWorkerScriptPrivateTargets.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlWorkerScriptPrivate" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlWorkerScriptPrivate/Qt6QmlWorkerScriptPrivateVersionlessAliasTargets.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlWorkerScriptPrivate/Qt6QmlWorkerScriptPrivateVersionlessTargets.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlWorkerScriptPrivate" TYPE FILE FILES
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/modules" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/modules/QmlWorkerScript.json")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6Qml/QmlPlugins/Qt6workerscriptpluginConfig.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6Qml/QmlPlugins/Qt6workerscriptpluginConfigVersion.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6Qml/QmlPlugins/Qt6workerscriptpluginConfigVersionImpl.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6Qml/QmlPlugins/Qt6workerscriptpluginTargetsPrecheck.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/qml/QtQml/WorkerScript" TYPE MODULE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qml/QtQml/WorkerScript/libworkerscriptplugin.dylib")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/qml/QtQml/WorkerScript/libworkerscriptplugin.dylib" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/qml/QtQml/WorkerScript/libworkerscriptplugin.dylib")
    execute_process(COMMAND /usr/bin/install_name_tool
      -delete_rpath "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib"
      -add_rpath "@loader_path/../../../lib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/qml/QtQml/WorkerScript/libworkerscriptplugin.dylib")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" -x "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/qml/QtQml/WorkerScript/libworkerscriptplugin.dylib")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins/Qt6workerscriptpluginTargets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins/Qt6workerscriptpluginTargets.cmake"
         "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmlworkerscript/CMakeFiles/Export/a1553df5751c39c799cb845445fde701/Qt6workerscriptpluginTargets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins/Qt6workerscriptpluginTargets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins/Qt6workerscriptpluginTargets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmlworkerscript/CMakeFiles/Export/a1553df5751c39c799cb845445fde701/Qt6workerscriptpluginTargets.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmlworkerscript/CMakeFiles/Export/a1553df5751c39c799cb845445fde701/Qt6workerscriptpluginTargets-release.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/qml/QtQml/WorkerScript" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qml/QtQml/WorkerScript/plugins.qmltypes")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/qml/QtQml/WorkerScript" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qml/QtQml/WorkerScript/qmldir")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "_install_html_docs_QmlWorkerScript")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/doc/qtqmlworkerscript" TYPE DIRECTORY FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/doc/qtqmlworkerscript/")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "_install_qch_docs_QmlWorkerScript")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/doc" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/doc/qtqmlworkerscript.qch")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlWorkerScript" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlWorkerScript/Qt6QmlWorkerScriptAdditionalTargetInfo.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlWorkerScriptPrivate" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlWorkerScriptPrivate/Qt6QmlWorkerScriptPrivateAdditionalTargetInfo.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/mkspecs/modules" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/mkspecs/modules/qt_lib_qmlworkerscript.pri"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/mkspecs/modules/qt_lib_qmlworkerscript_private.pri"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/pkgconfig/Qt6QmlWorkerScript.pc")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Qml/QmlPlugins" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6Qml/QmlPlugins/Qt6workerscriptpluginAdditionalTargetInfo.cmake")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmlworkerscript/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
