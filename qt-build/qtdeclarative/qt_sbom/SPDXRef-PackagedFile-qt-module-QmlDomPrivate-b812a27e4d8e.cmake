
        if(NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6QmlDom.a"
                AND NOT QT_SBOM_BUILD_TIME AND NOT QT_SBOM_FAKE_CHECKSUM)
            if(NOT FALSE)
                message(FATAL_ERROR "Cannot find 'lib/libQt6QmlDom.a' to compute its checksum. "
                    "Expected to find it at '$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6QmlDom.a' ")
            endif()
        else()
            if(NOT QT_SBOM_BUILD_TIME)
                if(QT_SBOM_FAKE_CHECKSUM)
                    set(sha1 "158942a783ee1095eafacaffd93de73edeadbeef")
                else()
                    file(SHA1 "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6QmlDom.a" sha1)
                endif()

                set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtdeclarative-qt-module-QmlDomPrivate-b812a27e4d8e" true)

                list(APPEND QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES
                    "SPDXRef-Package-qtdeclarative-qt-module-QmlDomPrivate-b812a27e4d8e")
                list(APPEND
                    "QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES_SPDXRef-Package-qtdeclarative-qt-module-QmlDomPrivate-b812a27e4d8e"
                    "${sha1}")
            endif()
            file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/qt_sbom/staging-qtdeclarative.spdx.in"
"
FileName: ./lib/libQt6QmlDom.a
SPDXID: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e
FileType: BINARY
FileChecksum: SHA1: ${sha1}
LicenseConcluded: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
FileCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
LicenseInfoInFile: NOASSERTION
Relationship: SPDXRef-Package-qtdeclarative-qt-module-QmlDomPrivate-b812a27e4d8e CONTAINS SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldom_fwd_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldom_global.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldom_utils_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldom_utils.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomastcreator.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomastcreator_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomastdumper.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomastdumper_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomfilelocations.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomfilelocations_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomcodeformatter.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomcodeformatter_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomcomments.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomcomments_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomcompare.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomcompare_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomconstants.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomconstants_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomelements.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomelements_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomerrormessage.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomerrormessage_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomexternalitems.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomexternalitems_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomfieldfilter.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomfieldfilter_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomfilewriter.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomfilewriter_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomformatdirectivescanner.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomformatdirectivescanner_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomfunctionref_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomindentinglinewriter.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomindentinglinewriter_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomitem.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomitem_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldommock.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldommock_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomlinewriter.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomlinewriter_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldommoduleindex.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldommoduleindex_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomoutwriter.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomoutwriter_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldompath.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldompath_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomstringdumper.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomstringdumper_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomreformatter.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomreformatter_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomscanner.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomscanner_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomtop.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomtop_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomtypesreader.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomtypesreader_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomscriptelements_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomscriptelements.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDomPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldom/qqmldomlinewriterfactory_p.h
"
                )
        endif()
