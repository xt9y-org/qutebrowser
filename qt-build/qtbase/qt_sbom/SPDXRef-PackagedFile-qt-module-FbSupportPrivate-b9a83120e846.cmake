
        if(NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6FbSupport.a"
                AND NOT QT_SBOM_BUILD_TIME AND NOT QT_SBOM_FAKE_CHECKSUM)
            if(NOT FALSE)
                message(FATAL_ERROR "Cannot find 'lib/libQt6FbSupport.a' to compute its checksum. "
                    "Expected to find it at '$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6FbSupport.a' ")
            endif()
        else()
            if(NOT QT_SBOM_BUILD_TIME)
                if(QT_SBOM_FAKE_CHECKSUM)
                    set(sha1 "158942a783ee1095eafacaffd93de73edeadbeef")
                else()
                    file(SHA1 "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6FbSupport.a" sha1)
                endif()

                set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-module-FbSupportPrivate-b9a83120e846" true)

                list(APPEND QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES
                    "SPDXRef-Package-qtbase-qt-module-FbSupportPrivate-b9a83120e846")
                list(APPEND
                    "QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES_SPDXRef-Package-qtbase-qt-module-FbSupportPrivate-b9a83120e846"
                    "${sha1}")
            endif()
            file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
FileName: ./lib/libQt6FbSupport.a
SPDXID: SPDXRef-PackagedFile-qt-module-FbSupportPrivate-b9a83120e846
FileType: BINARY
FileChecksum: SHA1: ${sha1}
LicenseConcluded: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
FileCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
LicenseInfoInFile: NOASSERTION
Relationship: SPDXRef-Package-qtbase-qt-module-FbSupportPrivate-b9a83120e846 CONTAINS SPDXRef-PackagedFile-qt-module-FbSupportPrivate-b9a83120e846
Relationship: SPDXRef-PackagedFile-qt-module-FbSupportPrivate-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/platformsupport/fbconvenience/qfbbackingstore.cpp
Relationship: SPDXRef-PackagedFile-qt-module-FbSupportPrivate-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/platformsupport/fbconvenience/qfbbackingstore_p.h
Relationship: SPDXRef-PackagedFile-qt-module-FbSupportPrivate-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/platformsupport/fbconvenience/qfbcursor.cpp
Relationship: SPDXRef-PackagedFile-qt-module-FbSupportPrivate-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/platformsupport/fbconvenience/qfbcursor_p.h
Relationship: SPDXRef-PackagedFile-qt-module-FbSupportPrivate-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/platformsupport/fbconvenience/qfbscreen.cpp
Relationship: SPDXRef-PackagedFile-qt-module-FbSupportPrivate-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/platformsupport/fbconvenience/qfbscreen_p.h
Relationship: SPDXRef-PackagedFile-qt-module-FbSupportPrivate-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/platformsupport/fbconvenience/qfbvthandler.cpp
Relationship: SPDXRef-PackagedFile-qt-module-FbSupportPrivate-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/platformsupport/fbconvenience/qfbvthandler_p.h
Relationship: SPDXRef-PackagedFile-qt-module-FbSupportPrivate-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/platformsupport/fbconvenience/qfbwindow.cpp
Relationship: SPDXRef-PackagedFile-qt-module-FbSupportPrivate-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/platformsupport/fbconvenience/qfbwindow_p.h
"
                )
        endif()
