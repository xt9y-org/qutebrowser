
        if(NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtQmlCore.framework/Versions/A/QtQmlCore"
                AND NOT QT_SBOM_BUILD_TIME AND NOT QT_SBOM_FAKE_CHECKSUM)
            if(NOT FALSE)
                message(FATAL_ERROR "Cannot find 'lib/QtQmlCore.framework/Versions/A/QtQmlCore' to compute its checksum. "
                    "Expected to find it at '$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtQmlCore.framework/Versions/A/QtQmlCore' ")
            endif()
        else()
            if(NOT QT_SBOM_BUILD_TIME)
                if(QT_SBOM_FAKE_CHECKSUM)
                    set(sha1 "158942a783ee1095eafacaffd93de73edeadbeef")
                else()
                    file(SHA1 "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtQmlCore.framework/Versions/A/QtQmlCore" sha1)
                endif()

                set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtdeclarative-qt-module-QmlCore-b812a27e4d8e" true)

                list(APPEND QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES
                    "SPDXRef-Package-qtdeclarative-qt-module-QmlCore-b812a27e4d8e")
                list(APPEND
                    "QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES_SPDXRef-Package-qtdeclarative-qt-module-QmlCore-b812a27e4d8e"
                    "${sha1}")
            endif()
            file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/qt_sbom/staging-qtdeclarative.spdx.in"
"
FileName: ./lib/QtQmlCore.framework/Versions/A/QtQmlCore
SPDXID: SPDXRef-PackagedFile-qt-module-QmlCore-b812a27e4d8e
FileType: BINARY
FileChecksum: SHA1: ${sha1}
LicenseConcluded: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
FileCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
LicenseInfoInFile: NOASSERTION
Relationship: SPDXRef-Package-qtdeclarative-qt-module-QmlCore-b812a27e4d8e CONTAINS SPDXRef-PackagedFile-qt-module-QmlCore-b812a27e4d8e
Relationship: SPDXRef-PackagedFile-qt-module-QmlCore-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/include/QtQmlCore/qtqmlcoreexports.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCore-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/core/qqmlsysteminformation_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCore-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/core/qqmlsysteminformation.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCore-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/core/qqmlstandardpaths_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCore-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/core/qqmlstandardpaths.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCore-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/core/qqmlcoreglobal_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCore-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/core/qmlcore_qmltyperegistrations.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCore-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/core/.qt/rcc/qrc_qmake_QtCore.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCore-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/core/qqmlsettings_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCore-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/core/qqmlsettings.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCore-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/core/qqmlpermissions_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCore-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/core/qqmlpermissions.cpp
"
                )
        endif()
