
        if(NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtQmlMeta.framework/Versions/A/QtQmlMeta"
                AND NOT QT_SBOM_BUILD_TIME AND NOT QT_SBOM_FAKE_CHECKSUM)
            if(NOT FALSE)
                message(FATAL_ERROR "Cannot find 'lib/QtQmlMeta.framework/Versions/A/QtQmlMeta' to compute its checksum. "
                    "Expected to find it at '$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtQmlMeta.framework/Versions/A/QtQmlMeta' ")
            endif()
        else()
            if(NOT QT_SBOM_BUILD_TIME)
                if(QT_SBOM_FAKE_CHECKSUM)
                    set(sha1 "158942a783ee1095eafacaffd93de73edeadbeef")
                else()
                    file(SHA1 "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtQmlMeta.framework/Versions/A/QtQmlMeta" sha1)
                endif()

                set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtdeclarative-qt-module-QmlMeta-b812a27e4d8e" true)

                list(APPEND QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES
                    "SPDXRef-Package-qtdeclarative-qt-module-QmlMeta-b812a27e4d8e")
                list(APPEND
                    "QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES_SPDXRef-Package-qtdeclarative-qt-module-QmlMeta-b812a27e4d8e"
                    "${sha1}")
            endif()
            file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/qt_sbom/staging-qtdeclarative.spdx.in"
"
FileName: ./lib/QtQmlMeta.framework/Versions/A/QtQmlMeta
SPDXID: SPDXRef-PackagedFile-qt-module-QmlMeta-b812a27e4d8e
FileType: BINARY
FileChecksum: SHA1: ${sha1}
LicenseConcluded: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
FileCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
LicenseInfoInFile: NOASSERTION
Relationship: SPDXRef-Package-qtdeclarative-qt-module-QmlMeta-b812a27e4d8e CONTAINS SPDXRef-PackagedFile-qt-module-QmlMeta-b812a27e4d8e
Relationship: SPDXRef-PackagedFile-qt-module-QmlMeta-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/include/QtQmlMeta/qtqmlmetaexports.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlMeta-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmeta/types/qqmlmetadependencies.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlMeta-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmeta/types/qqmlmetadependencies_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlMeta-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmeta/types/qqmlbind.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlMeta-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmeta/types/qqmlbind_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlMeta-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmeta/types/qqmlconnections.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlMeta-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmeta/types/qqmlconnections_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlMeta-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmeta/types/qqmlloggingcategory.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlMeta-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmeta/types/qqmlloggingcategory_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlMeta-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/qmlmeta/qmlmeta_qmltyperegistrations.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlMeta-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/qmlmeta/.qt/rcc/qrc_qmake_QtQml.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlMeta-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmeta/types/qqmltimer.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlMeta-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmeta/types/qqmltimer_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlMeta-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmeta/types/qqmllocaleenums_p.h
"
                )
        endif()
