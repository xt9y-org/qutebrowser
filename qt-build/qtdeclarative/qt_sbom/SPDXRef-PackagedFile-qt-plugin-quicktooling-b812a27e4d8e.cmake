
        if(NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/qml/QtQuick/tooling/libquicktoolingplugin.dylib"
                AND NOT QT_SBOM_BUILD_TIME AND NOT QT_SBOM_FAKE_CHECKSUM)
            if(NOT FALSE)
                message(FATAL_ERROR "Cannot find 'qml/QtQuick/tooling/libquicktoolingplugin.dylib' to compute its checksum. "
                    "Expected to find it at '$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/qml/QtQuick/tooling/libquicktoolingplugin.dylib' ")
            endif()
        else()
            if(NOT QT_SBOM_BUILD_TIME)
                if(QT_SBOM_FAKE_CHECKSUM)
                    set(sha1 "158942a783ee1095eafacaffd93de73edeadbeef")
                else()
                    file(SHA1 "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/qml/QtQuick/tooling/libquicktoolingplugin.dylib" sha1)
                endif()

                set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtdeclarative-qt-plugin-quicktooling-b812a27e4d8e" true)

                list(APPEND QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES
                    "SPDXRef-Package-qtdeclarative-qt-plugin-quicktooling-b812a27e4d8e")
                list(APPEND
                    "QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES_SPDXRef-Package-qtdeclarative-qt-plugin-quicktooling-b812a27e4d8e"
                    "${sha1}")
            endif()
            file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/qt_sbom/staging-qtdeclarative.spdx.in"
"
FileName: ./qml/QtQuick/tooling/libquicktoolingplugin.dylib
SPDXID: SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e
FileType: BINARY
FileChecksum: SHA1: ${sha1}
LicenseConcluded: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
FileCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
LicenseInfoInFile: NOASSERTION
Relationship: SPDXRef-Package-qtdeclarative-qt-plugin-quicktooling-b812a27e4d8e CONTAINS SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e
Relationship: SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/imports/tooling/quicktooling_qmltyperegistrations.cpp
Relationship: SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/imports/tooling/.qt/rcc/qrc_qmake_QtQuick_tooling.cpp
Relationship: SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/imports/tooling/quicktooling_QtQuick_toolingPlugin.cpp
Relationship: SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/imports/tooling/Component.qml
Relationship: SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/imports/tooling/.rcc/qmlcache/quicktooling_qmlcache_loader.cpp
Relationship: SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/imports/tooling/.rcc/qmlcache/quicktooling_Component_qml.cpp
Relationship: SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/imports/tooling/Enum.qml
Relationship: SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/imports/tooling/.rcc/qmlcache/quicktooling_Enum_qml.cpp
Relationship: SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/imports/tooling/Member.qml
Relationship: SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/imports/tooling/.rcc/qmlcache/quicktooling_Member_qml.cpp
Relationship: SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/imports/tooling/Method.qml
Relationship: SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/imports/tooling/.rcc/qmlcache/quicktooling_Method_qml.cpp
Relationship: SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/imports/tooling/Module.qml
Relationship: SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/imports/tooling/.rcc/qmlcache/quicktooling_Module_qml.cpp
Relationship: SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/imports/tooling/Parameter.qml
Relationship: SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/imports/tooling/.rcc/qmlcache/quicktooling_Parameter_qml.cpp
Relationship: SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/imports/tooling/Property.qml
Relationship: SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/imports/tooling/.rcc/qmlcache/quicktooling_Property_qml.cpp
Relationship: SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/imports/tooling/Signal.qml
Relationship: SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/imports/tooling/.rcc/qmlcache/quicktooling_Signal_qml.cpp
Relationship: SPDXRef-PackagedFile-qt-plugin-quicktooling-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/imports/tooling/.qt/rcc/qrc_quicktooling_raw_qml_0.cpp
"
                )
        endif()
