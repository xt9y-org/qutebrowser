
        if(NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/libexec/tracegen"
                AND NOT QT_SBOM_BUILD_TIME AND NOT QT_SBOM_FAKE_CHECKSUM)
            if(NOT FALSE)
                message(FATAL_ERROR "Cannot find 'libexec/tracegen' to compute its checksum. "
                    "Expected to find it at '$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/libexec/tracegen' ")
            endif()
        else()
            if(NOT QT_SBOM_BUILD_TIME)
                if(QT_SBOM_FAKE_CHECKSUM)
                    set(sha1 "158942a783ee1095eafacaffd93de73edeadbeef")
                else()
                    file(SHA1 "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/libexec/tracegen" sha1)
                endif()

                set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-tool-tracegen-b9a83120e846" true)

                list(APPEND QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES
                    "SPDXRef-Package-qtbase-qt-tool-tracegen-b9a83120e846")
                list(APPEND
                    "QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES_SPDXRef-Package-qtbase-qt-tool-tracegen-b9a83120e846"
                    "${sha1}")
            endif()
            file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
FileName: ./libexec/tracegen
SPDXID: SPDXRef-PackagedFile-qt-tool-tracegen-b9a83120e846
FileType: BINARY
FileChecksum: SHA1: ${sha1}
LicenseConcluded: LicenseRef-Qt-Commercial OR GPL-3.0-only WITH Qt-GPL-exception-1.0
FileCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
LicenseInfoInFile: NOASSERTION
Relationship: SPDXRef-Package-qtbase-qt-tool-tracegen-b9a83120e846 CONTAINS SPDXRef-PackagedFile-qt-tool-tracegen-b9a83120e846
Relationship: SPDXRef-PackagedFile-qt-tool-tracegen-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/tracegen/etw.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-tracegen-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/tracegen/etw.h
Relationship: SPDXRef-PackagedFile-qt-tool-tracegen-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/tracegen/helpers.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-tracegen-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/tracegen/helpers.h
Relationship: SPDXRef-PackagedFile-qt-tool-tracegen-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/tracegen/ctf.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-tracegen-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/tracegen/ctf.h
Relationship: SPDXRef-PackagedFile-qt-tool-tracegen-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/tracegen/lttng.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-tracegen-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/tracegen/lttng.h
Relationship: SPDXRef-PackagedFile-qt-tool-tracegen-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/tracegen/panic.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-tracegen-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/tracegen/panic.h
Relationship: SPDXRef-PackagedFile-qt-tool-tracegen-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/tracegen/provider.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-tracegen-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/tracegen/provider.h
Relationship: SPDXRef-PackagedFile-qt-tool-tracegen-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/tracegen/qtheaders.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-tracegen-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/tracegen/qtheaders.h
Relationship: SPDXRef-PackagedFile-qt-tool-tracegen-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/tracegen/tracegen.cpp
"
                )
        endif()
