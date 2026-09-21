
        if(NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6QmlDebug.a"
                AND NOT QT_SBOM_BUILD_TIME AND NOT QT_SBOM_FAKE_CHECKSUM)
            if(NOT FALSE)
                message(FATAL_ERROR "Cannot find 'lib/libQt6QmlDebug.a' to compute its checksum. "
                    "Expected to find it at '$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6QmlDebug.a' ")
            endif()
        else()
            if(NOT QT_SBOM_BUILD_TIME)
                if(QT_SBOM_FAKE_CHECKSUM)
                    set(sha1 "158942a783ee1095eafacaffd93de73edeadbeef")
                else()
                    file(SHA1 "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6QmlDebug.a" sha1)
                endif()

                set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtdeclarative-qt-module-QmlDebugPrivate-b812a27e4d8e" true)

                list(APPEND QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES
                    "SPDXRef-Package-qtdeclarative-qt-module-QmlDebugPrivate-b812a27e4d8e")
                list(APPEND
                    "QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES_SPDXRef-Package-qtdeclarative-qt-module-QmlDebugPrivate-b812a27e4d8e"
                    "${sha1}")
            endif()
            file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/qt_sbom/staging-qtdeclarative.spdx.in"
"
FileName: ./lib/libQt6QmlDebug.a
SPDXID: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e
FileType: BINARY
FileChecksum: SHA1: ${sha1}
LicenseConcluded: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
FileCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
LicenseInfoInFile: NOASSERTION
Relationship: SPDXRef-Package-qtdeclarative-qt-module-QmlDebugPrivate-b812a27e4d8e CONTAINS SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmldebugclient.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmldebugclient_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmldebugclient_p_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmldebugconnection.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmldebugconnection_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmldebugmessageclient.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmldebugmessageclient_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmldebugtranslationclient.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmldebugtranslationclient_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlenginecontrolclient.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlenginecontrolclient_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlenginecontrolclient_p_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlenginedebugclient.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlenginedebugclient_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlenginedebugclient_p_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlinspectorclient.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlinspectorclient_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlinspectorclient_p_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlpreviewclient.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlpreviewclient_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlpreviewclient_p_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlprofilerclient.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlprofilerclient_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlprofilerclient_p_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlprofilerclientdefinitions_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlprofilerevent.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlprofilerevent_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlprofilereventlocation.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlprofilereventlocation_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlprofilereventreceiver.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlprofilereventreceiver_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlprofilereventtype.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlprofilereventtype_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlprofilerqtdwriter.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlprofilerqtdwriter_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlprofilertypedevent.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qqmlprofilertypedevent_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qquickeventreplayclient.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qquickeventreplayclient_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qv4debugclient.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qv4debugclient_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlDebugPrivate-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmldebug/qv4debugclient_p_p.h
"
                )
        endif()
