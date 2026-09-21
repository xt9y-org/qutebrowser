
        if(NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/libexec/moc"
                AND NOT QT_SBOM_BUILD_TIME AND NOT QT_SBOM_FAKE_CHECKSUM)
            if(NOT FALSE)
                message(FATAL_ERROR "Cannot find 'libexec/moc' to compute its checksum. "
                    "Expected to find it at '$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/libexec/moc' ")
            endif()
        else()
            if(NOT QT_SBOM_BUILD_TIME)
                if(QT_SBOM_FAKE_CHECKSUM)
                    set(sha1 "158942a783ee1095eafacaffd93de73edeadbeef")
                else()
                    file(SHA1 "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/libexec/moc" sha1)
                endif()

                set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-tool-moc-b9a83120e846" true)

                list(APPEND QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES
                    "SPDXRef-Package-qtbase-qt-tool-moc-b9a83120e846")
                list(APPEND
                    "QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES_SPDXRef-Package-qtbase-qt-tool-moc-b9a83120e846"
                    "${sha1}")
            endif()
            file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
FileName: ./libexec/moc
SPDXID: SPDXRef-PackagedFile-qt-tool-moc-b9a83120e846
FileType: BINARY
FileChecksum: SHA1: ${sha1}
LicenseConcluded: LicenseRef-Qt-Commercial OR GPL-3.0-only WITH Qt-GPL-exception-1.0
FileCopyrightText: <text>Copyright (C) 2013 Olivier Goffart <ogoffart@woboq.com>
Copyright (C) 2014 Olivier Goffart <ogoffart@woboq.org>
Copyright (C) 2016 Intel Corporation.
Copyright (C) 2018 Intel Corporation.
Copyright (C) 2018 The Qt Company Ltd.
Copyright (C) 2019 Olivier Goffart <ogoffart@woboq.com>
Copyright (C) The Qt Company Ltd. and other contributors.</text>
LicenseInfoInFile: NOASSERTION
Relationship: SPDXRef-Package-qtbase-qt-tool-moc-b9a83120e846 CONTAINS SPDXRef-PackagedFile-qt-tool-moc-b9a83120e846
Relationship: SPDXRef-PackagedFile-qt-tool-moc-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/moc/cbordevice.h
Relationship: SPDXRef-PackagedFile-qt-tool-moc-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/moc/collectjson.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-moc-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/moc/collectjson.h
Relationship: SPDXRef-PackagedFile-qt-tool-moc-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/moc/generator.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-moc-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/moc/generator.h
Relationship: SPDXRef-PackagedFile-qt-tool-moc-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/moc/main.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-moc-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/moc/moc.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-moc-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/moc/moc.h
Relationship: SPDXRef-PackagedFile-qt-tool-moc-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/moc/outputrevision.h
Relationship: SPDXRef-PackagedFile-qt-tool-moc-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/moc/parser.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-moc-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/moc/parser.h
Relationship: SPDXRef-PackagedFile-qt-tool-moc-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/moc/preprocessor.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-moc-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/moc/preprocessor.h
Relationship: SPDXRef-PackagedFile-qt-tool-moc-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/moc/symbols.h
Relationship: SPDXRef-PackagedFile-qt-tool-moc-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/moc/token.cpp
Relationship: SPDXRef-PackagedFile-qt-tool-moc-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/moc/token.h
Relationship: SPDXRef-PackagedFile-qt-tool-moc-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/tools/moc/utils.h
"
                )
        endif()
