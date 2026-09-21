
        if(NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6PacketProtocol.a"
                AND NOT QT_SBOM_BUILD_TIME AND NOT QT_SBOM_FAKE_CHECKSUM)
            if(NOT FALSE)
                message(FATAL_ERROR "Cannot find 'lib/libQt6PacketProtocol.a' to compute its checksum. "
                    "Expected to find it at '$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6PacketProtocol.a' ")
            endif()
        else()
            if(NOT QT_SBOM_BUILD_TIME)
                if(QT_SBOM_FAKE_CHECKSUM)
                    set(sha1 "158942a783ee1095eafacaffd93de73edeadbeef")
                else()
                    file(SHA1 "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6PacketProtocol.a" sha1)
                endif()

                set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtdeclarative-qt-module-PacketProtocolPrivate-b812a27e4d8e" true)

                list(APPEND QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES
                    "SPDXRef-Package-qtdeclarative-qt-module-PacketProtocolPrivate-b812a27e4d8e")
                list(APPEND
                    "QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES_SPDXRef-Package-qtdeclarative-qt-module-PacketProtocolPrivate-b812a27e4d8e"
                    "${sha1}")
            endif()
            file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/qt_sbom/staging-qtdeclarative.spdx.in"
"
FileName: ./lib/libQt6PacketProtocol.a
SPDXID: SPDXRef-PackagedFile-qt-module-PacketProtocolPrivate-b812a27e4d8e
FileType: BINARY
FileChecksum: SHA1: ${sha1}
LicenseConcluded: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
FileCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
LicenseInfoInFile: NOASSERTION
Relationship: SPDXRef-Package-qtdeclarative-qt-module-PacketProtocolPrivate-b812a27e4d8e CONTAINS SPDXRef-PackagedFile-qt-module-PacketProtocolPrivate-b812a27e4d8e
Relationship: SPDXRef-PackagedFile-qt-module-PacketProtocolPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/plugins/qmltooling/packetprotocol/qpacket.cpp
Relationship: SPDXRef-PackagedFile-qt-module-PacketProtocolPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/plugins/qmltooling/packetprotocol/qpacket_p.h
Relationship: SPDXRef-PackagedFile-qt-module-PacketProtocolPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/plugins/qmltooling/packetprotocol/qpacketprotocol.cpp
Relationship: SPDXRef-PackagedFile-qt-module-PacketProtocolPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/plugins/qmltooling/packetprotocol/qpacketprotocol_p.h
Relationship: SPDXRef-PackagedFile-qt-module-PacketProtocolPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/plugins/qmltooling/packetprotocol/qversionedpacket_p.h
"
                )
        endif()
