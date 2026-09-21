
        if(NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtQmlCompiler.framework/Versions/A/QtQmlCompiler"
                AND NOT QT_SBOM_BUILD_TIME AND NOT QT_SBOM_FAKE_CHECKSUM)
            if(NOT FALSE)
                message(FATAL_ERROR "Cannot find 'lib/QtQmlCompiler.framework/Versions/A/QtQmlCompiler' to compute its checksum. "
                    "Expected to find it at '$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtQmlCompiler.framework/Versions/A/QtQmlCompiler' ")
            endif()
        else()
            if(NOT QT_SBOM_BUILD_TIME)
                if(QT_SBOM_FAKE_CHECKSUM)
                    set(sha1 "158942a783ee1095eafacaffd93de73edeadbeef")
                else()
                    file(SHA1 "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtQmlCompiler.framework/Versions/A/QtQmlCompiler" sha1)
                endif()

                set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtdeclarative-qt-module-QmlCompiler-b812a27e4d8e" true)

                list(APPEND QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES
                    "SPDXRef-Package-qtdeclarative-qt-module-QmlCompiler-b812a27e4d8e")
                list(APPEND
                    "QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES_SPDXRef-Package-qtdeclarative-qt-module-QmlCompiler-b812a27e4d8e"
                    "${sha1}")
            endif()
            file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/qt_sbom/staging-qtdeclarative.spdx.in"
"
FileName: ./lib/QtQmlCompiler.framework/Versions/A/QtQmlCompiler
SPDXID: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e
FileType: BINARY
FileChecksum: SHA1: ${sha1}
LicenseConcluded: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
FileCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
LicenseInfoInFile: NOASSERTION
Relationship: SPDXRef-Package-qtdeclarative-qt-module-QmlCompiler-b812a27e4d8e CONTAINS SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/include/QtQmlCompiler/qtqmlcompilerexports.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qcoloroutput.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qcoloroutput_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qdeferredpointer_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsannotation.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsannotation_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsaotirbuilder.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsaotirbuilder_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsbasicblocks.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsbasicblocks_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljscodegenerator.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljscodegenerator_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljscompilepass_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljscompiler.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljscompiler_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljscompilerstats.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljscompilerstats_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljscompilerstatsreporter.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljscompilerstatsreporter_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljscontextualtypes_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljscontextualtypes.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsfunctioninitializer.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsfunctioninitializer_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsimporter.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsimporter_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsimportvisitor.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsimportvisitor_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljslinter.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljslinter_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljslintercodegen.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljslintercodegen_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljslintervisitor_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljslintervisitor.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsliteralbindingcheck.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsliteralbindingcheck_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsloadergenerator.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsloadergenerator_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljslogger.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljslogger_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsloggingutils.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsloggingutils.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsloggingutils_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsmetatypes.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsmetatypes_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsoptimizations.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsoptimizations_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsregistercontent.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsregistercontent_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsresourcefilemapper.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsresourcefilemapper_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsscope.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsscope_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsscopesbyid_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsshadowcheck.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsshadowcheck_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsstoragegeneralizer.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsstoragegeneralizer_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsstorageinitializer.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsstorageinitializer_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljstypedescriptionreader.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljstypedescriptionreader_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljstypepropagator.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljstypepropagator_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljstypereader.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljstypereader_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljstyperesolver.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljstyperesolver_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsutils.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsutils_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsvaluetypefromstringcheck.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsvaluetypefromstringcheck_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmlsa.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmlsa.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmlsa_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmlsaconstants.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmlsasourcelocation.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmlsasourcelocation.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmlsasourcelocation_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qresourcerelocater.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qresourcerelocater_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljscontextproperties_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljscontextproperties.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsusercontextproperties_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlcompiler/qqmljsusercontextproperties.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlCompiler-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/qmlcompiler/.qt/rcc/qrc_builtins.cpp
"
                )
        endif()
