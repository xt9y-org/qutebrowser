
        if(NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtLabsSettings.framework/Versions/A/QtLabsSettings"
                AND NOT QT_SBOM_BUILD_TIME AND NOT QT_SBOM_FAKE_CHECKSUM)
            if(NOT FALSE)
                message(FATAL_ERROR "Cannot find 'lib/QtLabsSettings.framework/Versions/A/QtLabsSettings' to compute its checksum. "
                    "Expected to find it at '$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtLabsSettings.framework/Versions/A/QtLabsSettings' ")
            endif()
        else()
            if(NOT QT_SBOM_BUILD_TIME)
                if(QT_SBOM_FAKE_CHECKSUM)
                    set(sha1 "158942a783ee1095eafacaffd93de73edeadbeef")
                else()
                    file(SHA1 "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtLabsSettings.framework/Versions/A/QtLabsSettings" sha1)
                endif()

                set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtdeclarative-qt-module-LabsSettings-b812a27e4d8e" true)

                list(APPEND QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES
                    "SPDXRef-Package-qtdeclarative-qt-module-LabsSettings-b812a27e4d8e")
                list(APPEND
                    "QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES_SPDXRef-Package-qtdeclarative-qt-module-LabsSettings-b812a27e4d8e"
                    "${sha1}")
            endif()
            file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/qt_sbom/staging-qtdeclarative.spdx.in"
"
FileName: ./lib/QtLabsSettings.framework/Versions/A/QtLabsSettings
SPDXID: SPDXRef-PackagedFile-qt-module-LabsSettings-b812a27e4d8e
FileType: BINARY
FileChecksum: SHA1: ${sha1}
LicenseConcluded: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
FileCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
LicenseInfoInFile: NOASSERTION
Relationship: SPDXRef-Package-qtdeclarative-qt-module-LabsSettings-b812a27e4d8e CONTAINS SPDXRef-PackagedFile-qt-module-LabsSettings-b812a27e4d8e
Relationship: SPDXRef-PackagedFile-qt-module-LabsSettings-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/include/QtLabsSettings/qtlabssettingsexports.h
Relationship: SPDXRef-PackagedFile-qt-module-LabsSettings-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/labs/settings/qqmlsettings.cpp
Relationship: SPDXRef-PackagedFile-qt-module-LabsSettings-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/labs/settings/qqmlsettings_p.h
Relationship: SPDXRef-PackagedFile-qt-module-LabsSettings-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/labs/settings/qqmlsettingsglobal_p.h
Relationship: SPDXRef-PackagedFile-qt-module-LabsSettings-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/labs/settings/labssettings_qmltyperegistrations.cpp
Relationship: SPDXRef-PackagedFile-qt-module-LabsSettings-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/labs/settings/.qt/rcc/qrc_qmake_Qt_labs_settings.cpp
"
                )
        endif()
