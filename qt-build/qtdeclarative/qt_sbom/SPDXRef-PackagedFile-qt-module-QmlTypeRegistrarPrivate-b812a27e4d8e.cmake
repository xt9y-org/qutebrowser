
        if(NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6QmlTypeRegistrar.a"
                AND NOT QT_SBOM_BUILD_TIME AND NOT QT_SBOM_FAKE_CHECKSUM)
            if(NOT FALSE)
                message(FATAL_ERROR "Cannot find 'lib/libQt6QmlTypeRegistrar.a' to compute its checksum. "
                    "Expected to find it at '$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6QmlTypeRegistrar.a' ")
            endif()
        else()
            if(NOT QT_SBOM_BUILD_TIME)
                if(QT_SBOM_FAKE_CHECKSUM)
                    set(sha1 "158942a783ee1095eafacaffd93de73edeadbeef")
                else()
                    file(SHA1 "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6QmlTypeRegistrar.a" sha1)
                endif()

                set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtdeclarative-qt-module-QmlTypeRegistrarPrivate-b812a27e4d8e" true)

                list(APPEND QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES
                    "SPDXRef-Package-qtdeclarative-qt-module-QmlTypeRegistrarPrivate-b812a27e4d8e")
                list(APPEND
                    "QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES_SPDXRef-Package-qtdeclarative-qt-module-QmlTypeRegistrarPrivate-b812a27e4d8e"
                    "${sha1}")
            endif()
            file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/qt_sbom/staging-qtdeclarative.spdx.in"
"
FileName: ./lib/libQt6QmlTypeRegistrar.a
SPDXID: SPDXRef-PackagedFile-qt-module-QmlTypeRegistrarPrivate-b812a27e4d8e
FileType: BINARY
FileChecksum: SHA1: ${sha1}
LicenseConcluded: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
FileCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
LicenseInfoInFile: NOASSERTION
Relationship: SPDXRef-Package-qtdeclarative-qt-module-QmlTypeRegistrarPrivate-b812a27e4d8e CONTAINS SPDXRef-PackagedFile-qt-module-QmlTypeRegistrarPrivate-b812a27e4d8e
Relationship: SPDXRef-PackagedFile-qt-module-QmlTypeRegistrarPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmltyperegistrar/qanystringviewutils_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlTypeRegistrarPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmltyperegistrar/qmetatypesjsonprocessor.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlTypeRegistrarPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmltyperegistrar/qmetatypesjsonprocessor_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlTypeRegistrarPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmltyperegistrar/qqmljsstreamwriter.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlTypeRegistrarPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmltyperegistrar/qqmljsstreamwriter_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlTypeRegistrarPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmltyperegistrar/qqmltyperegistrar.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlTypeRegistrarPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmltyperegistrar/qqmltyperegistrar_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlTypeRegistrarPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmltyperegistrar/qqmltyperegistrarconstants_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlTypeRegistrarPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmltyperegistrar/qqmltypesclassdescription.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlTypeRegistrarPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmltyperegistrar/qqmltypesclassdescription_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlTypeRegistrarPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmltyperegistrar/qqmltypescreator.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlTypeRegistrarPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmltyperegistrar/qqmltypescreator_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlTypeRegistrarPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmltyperegistrar/qqmltyperegistrarutils_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlTypeRegistrarPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmltyperegistrar/qqmltyperegistrarutils.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlTypeRegistrarPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/qmltyperegistrar/.qt/rcc/qrc_jsRootMetaTypes.cpp
"
                )
        endif()
