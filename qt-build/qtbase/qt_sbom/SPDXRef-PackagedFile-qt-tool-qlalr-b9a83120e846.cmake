
        if(NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/libexec/qlalr"
                AND NOT QT_SBOM_BUILD_TIME AND NOT QT_SBOM_FAKE_CHECKSUM)
            if(NOT FALSE)
                message(FATAL_ERROR "Cannot find 'libexec/qlalr' to compute its checksum. "
                    "Expected to find it at '$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/libexec/qlalr' ")
            endif()
        else()
            if(NOT QT_SBOM_BUILD_TIME)
                if(QT_SBOM_FAKE_CHECKSUM)
                    set(sha1 "158942a783ee1095eafacaffd93de73edeadbeef")
                else()
                    file(SHA1 "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/libexec/qlalr" sha1)
                endif()

                set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-tool-qlalr-b9a83120e846" true)

                list(APPEND QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES
                    "SPDXRef-Package-qtbase-qt-tool-qlalr-b9a83120e846")
                list(APPEND
                    "QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES_SPDXRef-Package-qtbase-qt-tool-qlalr-b9a83120e846"
                    "${sha1}")
            endif()
            file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
FileName: ./libexec/qlalr
SPDXID: SPDXRef-PackagedFile-qt-tool-qlalr-b9a83120e846
FileType: BINARY
FileChecksum: SHA1: ${sha1}
LicenseConcluded: LicenseRef-Qt-Commercial OR GPL-3.0-only WITH Qt-GPL-exception-1.0
FileCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
LicenseInfoInFile: NOASSERTION
Relationship: SPDXRef-Package-qtbase-qt-tool-qlalr-b9a83120e846 CONTAINS SPDXRef-PackagedFile-qt-tool-qlalr-b9a83120e846
Relationship: SPDXRef-PackagedFile-qt-tool-qlalr-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/qlalr/compress.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qlalr-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/qlalr/compress.h
Relationship: SPDXRef-PackagedFile-qt-tool-qlalr-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/qlalr/cppgenerator.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qlalr-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/qlalr/cppgenerator.h
Relationship: SPDXRef-PackagedFile-qt-tool-qlalr-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/qlalr/dotgraph.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qlalr-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/qlalr/dotgraph.h
Relationship: SPDXRef-PackagedFile-qt-tool-qlalr-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/qlalr/grammar.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qlalr-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/qlalr/grammar_p.h
Relationship: SPDXRef-PackagedFile-qt-tool-qlalr-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/qlalr/lalr.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qlalr-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/qlalr/lalr.h
Relationship: SPDXRef-PackagedFile-qt-tool-qlalr-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/qlalr/main.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qlalr-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/qlalr/parsetable.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qlalr-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/qlalr/parsetable.h
Relationship: SPDXRef-PackagedFile-qt-tool-qlalr-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/qlalr/recognizer.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-qlalr-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/qlalr/recognizer.h
"
                )
        endif()
