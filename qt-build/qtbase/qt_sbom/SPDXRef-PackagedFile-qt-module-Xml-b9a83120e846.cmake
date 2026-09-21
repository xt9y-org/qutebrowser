
        if(NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtXml.framework/Versions/A/QtXml"
                AND NOT QT_SBOM_BUILD_TIME AND NOT QT_SBOM_FAKE_CHECKSUM)
            if(NOT FALSE)
                message(FATAL_ERROR "Cannot find 'lib/QtXml.framework/Versions/A/QtXml' to compute its checksum. "
                    "Expected to find it at '$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtXml.framework/Versions/A/QtXml' ")
            endif()
        else()
            if(NOT QT_SBOM_BUILD_TIME)
                if(QT_SBOM_FAKE_CHECKSUM)
                    set(sha1 "158942a783ee1095eafacaffd93de73edeadbeef")
                else()
                    file(SHA1 "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtXml.framework/Versions/A/QtXml" sha1)
                endif()

                set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-module-Xml-b9a83120e846" true)

                list(APPEND QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES
                    "SPDXRef-Package-qtbase-qt-module-Xml-b9a83120e846")
                list(APPEND
                    "QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES_SPDXRef-Package-qtbase-qt-module-Xml-b9a83120e846"
                    "${sha1}")
            endif()
            file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
FileName: ./lib/QtXml.framework/Versions/A/QtXml
SPDXID: SPDXRef-PackagedFile-qt-module-Xml-b9a83120e846
FileType: BINARY
FileChecksum: SHA1: ${sha1}
LicenseConcluded: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
FileCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
LicenseInfoInFile: NOASSERTION
Relationship: SPDXRef-Package-qtbase-qt-module-Xml-b9a83120e846 CONTAINS SPDXRef-PackagedFile-qt-module-Xml-b9a83120e846
Relationship: SPDXRef-PackagedFile-qt-module-Xml-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtbase/include/QtXml/qtxmlexports.h
Relationship: SPDXRef-PackagedFile-qt-module-Xml-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/xml/qtxmlglobal.h
Relationship: SPDXRef-PackagedFile-qt-module-Xml-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtbase/src/xml/qtxml-config.h
Relationship: SPDXRef-PackagedFile-qt-module-Xml-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtbase/src/xml/qtxml-config_p.h
Relationship: SPDXRef-PackagedFile-qt-module-Xml-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/xml/compat/removed_api.cpp
Relationship: SPDXRef-PackagedFile-qt-module-Xml-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/xml/dom/qdom.cpp
Relationship: SPDXRef-PackagedFile-qt-module-Xml-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/xml/dom/qdom.h
Relationship: SPDXRef-PackagedFile-qt-module-Xml-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/xml/dom/qdom_p.h
Relationship: SPDXRef-PackagedFile-qt-module-Xml-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/xml/dom/qdomhelpers.cpp
Relationship: SPDXRef-PackagedFile-qt-module-Xml-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/xml/dom/qdomhelpers_p.h
"
                )
        endif()
