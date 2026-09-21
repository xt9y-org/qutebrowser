
        if(NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/plugins/generic/libqtuiotouchplugin.dylib"
                AND NOT QT_SBOM_BUILD_TIME AND NOT QT_SBOM_FAKE_CHECKSUM)
            if(NOT FALSE)
                message(FATAL_ERROR "Cannot find 'plugins/generic/libqtuiotouchplugin.dylib' to compute its checksum. "
                    "Expected to find it at '$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/plugins/generic/libqtuiotouchplugin.dylib' ")
            endif()
        else()
            if(NOT QT_SBOM_BUILD_TIME)
                if(QT_SBOM_FAKE_CHECKSUM)
                    set(sha1 "158942a783ee1095eafacaffd93de73edeadbeef")
                else()
                    file(SHA1 "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/plugins/generic/libqtuiotouchplugin.dylib" sha1)
                endif()

                set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-plugin-QTuioTouchPlugin-b9a83120e846" true)

                list(APPEND QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES
                    "SPDXRef-Package-qtbase-qt-plugin-QTuioTouchPlugin-b9a83120e846")
                list(APPEND
                    "QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES_SPDXRef-Package-qtbase-qt-plugin-QTuioTouchPlugin-b9a83120e846"
                    "${sha1}")
            endif()
            file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
FileName: ./plugins/generic/libqtuiotouchplugin.dylib
SPDXID: SPDXRef-PackagedFile-qt-plugin-QTuioTouchPlugin-b9a83120e846
FileType: BINARY
FileChecksum: SHA1: ${sha1}
LicenseConcluded: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
FileCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
LicenseInfoInFile: NOASSERTION
Relationship: SPDXRef-Package-qtbase-qt-plugin-QTuioTouchPlugin-b9a83120e846 CONTAINS SPDXRef-PackagedFile-qt-plugin-QTuioTouchPlugin-b9a83120e846
Relationship: SPDXRef-PackagedFile-qt-plugin-QTuioTouchPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/generic/tuiotouch/main.cpp
Relationship: SPDXRef-PackagedFile-qt-plugin-QTuioTouchPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/generic/tuiotouch/qoscbundle.cpp
Relationship: SPDXRef-PackagedFile-qt-plugin-QTuioTouchPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/generic/tuiotouch/qoscbundle_p.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QTuioTouchPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/generic/tuiotouch/qoscmessage.cpp
Relationship: SPDXRef-PackagedFile-qt-plugin-QTuioTouchPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/generic/tuiotouch/qoscmessage_p.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QTuioTouchPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/generic/tuiotouch/qtuiocursor_p.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QTuioTouchPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/generic/tuiotouch/qtuiohandler.cpp
Relationship: SPDXRef-PackagedFile-qt-plugin-QTuioTouchPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/generic/tuiotouch/qtuiohandler_p.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QTuioTouchPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/generic/tuiotouch/qtuiotoken_p.h
"
                )
        endif()
