# Install script for directory: /Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom

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
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/metatypes" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmldom/meta_types/qt6qmldomprivate_metatypes.json")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlDomPrivate" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlDomPrivate/Qt6QmlDomPrivateConfig.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlDomPrivate/Qt6QmlDomPrivateConfigVersion.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlDomPrivate/Qt6QmlDomPrivateConfigVersionImpl.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlDomPrivate/Qt6QmlDomPrivateTargetsPrecheck.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/libQt6QmlDom.a")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6QmlDom.a" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6QmlDom.a")
    execute_process(COMMAND "/usr/bin/ranlib" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6QmlDom.a")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlDomPrivate/Qt6QmlDomPrivateTargets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlDomPrivate/Qt6QmlDomPrivateTargets.cmake"
         "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmldom/CMakeFiles/Export/3c6c070a37f2d7b9bf499e22e5020ffe/Qt6QmlDomPrivateTargets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlDomPrivate/Qt6QmlDomPrivateTargets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlDomPrivate/Qt6QmlDomPrivateTargets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlDomPrivate" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmldom/CMakeFiles/Export/3c6c070a37f2d7b9bf499e22e5020ffe/Qt6QmlDomPrivateTargets.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlDomPrivate" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmldom/CMakeFiles/Export/3c6c070a37f2d7b9bf499e22e5020ffe/Qt6QmlDomPrivateTargets-release.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlDomPrivate" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlDomPrivate/Qt6QmlDomPrivateVersionlessAliasTargets.cmake"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlDomPrivate/Qt6QmlDomPrivateVersionlessTargets.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlDomPrivate" TYPE FILE FILES
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/modules" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/modules/QmlDomPrivate.json")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6QmlDomPrivate" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake/Qt6QmlDomPrivate/Qt6QmlDomPrivateAdditionalTargetInfo.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/QtQmlDom" TYPE DIRECTORY FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/include/QtQmlDom/.syncqt_staging/")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/QtQmlDom" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldom_global.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/include/QtQmlDom/QtQmlDomDepends"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/QtQmlDom/6.11.2/QtQmlDom/private" TYPE FILE FILES
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldom_fwd_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldom_utils_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomastcreator_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomastdumper_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomfilelocations_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomcodeformatter_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomcomments_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomcompare_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomconstants_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomelements_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomerrormessage_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomexternalitems_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomfieldfilter_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomfilewriter_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomformatdirectivescanner_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomfunctionref_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomindentinglinewriter_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomitem_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldommock_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomlinewriter_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldommoduleindex_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomoutwriter_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldompath_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomstringdumper_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomreformatter_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomscanner_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomtop_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomtypesreader_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomscriptelements_p.h"
    "/Users/felixjaschul/CLionProjects/qutebrowser/qt6/qtdeclarative/src/qmldom/qqmldomlinewriterfactory_p.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/libQt6QmlDom.prl")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/mkspecs/modules" TYPE FILE FILES "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/mkspecs/modules/qt_lib_qmldom_private.pri")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/src/qmldom/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
