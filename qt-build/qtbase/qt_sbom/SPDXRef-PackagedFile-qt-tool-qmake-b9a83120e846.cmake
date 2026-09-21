
        if(NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/qmake"
                AND NOT QT_SBOM_BUILD_TIME AND NOT QT_SBOM_FAKE_CHECKSUM)
            if(NOT FALSE)
                message(FATAL_ERROR "Cannot find 'bin/qmake' to compute its checksum. "
                    "Expected to find it at '$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/qmake' ")
            endif()
        else()
            if(NOT QT_SBOM_BUILD_TIME)
                if(QT_SBOM_FAKE_CHECKSUM)
                    set(sha1 "158942a783ee1095eafacaffd93de73edeadbeef")
                else()
                    file(SHA1 "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/qmake" sha1)
                endif()

                set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-tool-qmake-b9a83120e846" true)

                list(APPEND QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES
                    "SPDXRef-Package-qtbase-qt-tool-qmake-b9a83120e846")
                list(APPEND
                    "QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES_SPDXRef-Package-qtbase-qt-tool-qmake-b9a83120e846"
                    "${sha1}")
            endif()
            file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
FileName: ./bin/qmake
SPDXID: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846
FileType: BINARY
FileChecksum: SHA1: ${sha1}
LicenseConcluded: LicenseRef-Qt-Commercial OR GPL-3.0-only WITH Qt-GPL-exception-1.0
FileCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
LicenseInfoInFile: NOASSERTION
Relationship: SPDXRef-Package-qtbase-qt-tool-qmake-b9a83120e846 CONTAINS SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/cachekeys.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/mac/pbuilder_pbx.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/mac/pbuilder_pbx.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/makefile.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/makefile.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/makefiledeps.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/makefiledeps.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/metamakefile.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/metamakefile.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/projectgenerator.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/projectgenerator.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/unix/unixmake.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/unix/unixmake.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/unix/unixmake2.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/win32/mingw_make.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/win32/mingw_make.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/win32/msbuild_objectmodel.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/win32/msbuild_objectmodel.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/win32/msvc_nmake.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/win32/msvc_nmake.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/win32/msvc_objectmodel.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/win32/msvc_objectmodel.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/win32/msvc_vcproj.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/win32/msvc_vcproj.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/win32/msvc_vcxproj.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/win32/msvc_vcxproj.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/win32/winmakefile.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/win32/winmakefile.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/xmloutput.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/generators/xmloutput.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/library/ioutils.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/library/ioutils.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/library/qmakebuiltins.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/library/qmakeevaluator.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/library/qmakeevaluator.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/library/qmakeevaluator_p.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/library/qmakeglobals.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/library/qmakeglobals.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/library/qmakeparser.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/library/qmakeparser.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/library/qmakevfs.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/library/qmakevfs.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/main.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/meta.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/meta.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/option.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/option.h
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/project.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qmake-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/qmake/project.h
"
                )
        endif()
