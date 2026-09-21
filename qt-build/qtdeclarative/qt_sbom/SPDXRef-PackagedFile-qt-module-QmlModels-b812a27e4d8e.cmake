
        if(NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtQmlModels.framework/Versions/A/QtQmlModels"
                AND NOT QT_SBOM_BUILD_TIME AND NOT QT_SBOM_FAKE_CHECKSUM)
            if(NOT FALSE)
                message(FATAL_ERROR "Cannot find 'lib/QtQmlModels.framework/Versions/A/QtQmlModels' to compute its checksum. "
                    "Expected to find it at '$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtQmlModels.framework/Versions/A/QtQmlModels' ")
            endif()
        else()
            if(NOT QT_SBOM_BUILD_TIME)
                if(QT_SBOM_FAKE_CHECKSUM)
                    set(sha1 "158942a783ee1095eafacaffd93de73edeadbeef")
                else()
                    file(SHA1 "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtQmlModels.framework/Versions/A/QtQmlModels" sha1)
                endif()

                set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtdeclarative-qt-module-QmlModels-b812a27e4d8e" true)

                list(APPEND QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES
                    "SPDXRef-Package-qtdeclarative-qt-module-QmlModels-b812a27e4d8e")
                list(APPEND
                    "QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES_SPDXRef-Package-qtdeclarative-qt-module-QmlModels-b812a27e4d8e"
                    "${sha1}")
            endif()
            file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/qt_sbom/staging-qtdeclarative.spdx.in"
"
FileName: ./lib/QtQmlModels.framework/Versions/A/QtQmlModels
SPDXID: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e
FileType: BINARY
FileChecksum: SHA1: ${sha1}
LicenseConcluded: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
FileCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
LicenseInfoInFile: NOASSERTION
Relationship: SPDXRef-Package-qtdeclarative-qt-module-QmlModels-b812a27e4d8e CONTAINS SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/include/QtQmlModels/qtqmlmodelsexports.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmlchangeset.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmlchangeset_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmlmodelsmodule.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmlmodelsmodule_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qtqmlmodelsglobal.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qtqmlmodelsglobal_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/qmlmodels/qtqmlmodels-config.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/qmlmodels/qtqmlmodels-config_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/qmlmodels/qmlmodels_qmltyperegistrations.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtdeclarative/src/qmlmodels/.qt/rcc/qrc_qmake_QtQml_Models.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmlmodelindexvaluetype.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmlmodelindexvaluetype_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmlobjectmodel.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmlobjectmodel_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmltableinstancemodel.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmltableinstancemodel_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmltreemodeltotablemodel.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmltreemodeltotablemodel_p_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmllistmodel.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmllistmodel_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmllistmodel_p_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmllistmodelworkeragent.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmllistmodelworkeragent_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmlabstractdelegatecomponent.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmlabstractdelegatecomponent_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmladaptormodel.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmladaptormodel_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmladaptormodelenginedata.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmladaptormodelenginedata_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmldelegatecomponent.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmldelegatecomponent_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmldelegatemodel.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmldelegatemodel_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmldelegatemodel_p_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmldmabstractitemmodeldata.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmldmabstractitemmodeldata_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmldmlistaccessordata.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmldmlistaccessordata_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmldmobjectdata.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmldmobjectdata_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmlinstantiator.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmlinstantiator_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmlinstantiator_p_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmllistaccessor.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmllistaccessor_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmllistcompositor.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qqmllistcompositor_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qquickpackage.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/qquickpackage_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/qqmlsortfilterproxymodel_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/qqmlsortfilterproxymodel.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/qqmlsortfilterproxymodel_p_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/qsortfilterproxymodelhelper_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/qsortfilterproxymodelhelper.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/filters/qqmlfilterbase_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/filters/qqmlfilterbase.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/filters/qqmlfiltercompositor_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/filters/qqmlfiltercompositor.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/filters/qqmlrolefilter_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/filters/qqmlrolefilter.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/filters/qqmlvaluefilter_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/filters/qqmlvaluefilter.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/filters/qqmlfunctionfilter_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/filters/qqmlfunctionfilter.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/sorters/qqmlsorterbase_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/sorters/qqmlsorterbase.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/sorters/qqmlsortercompositor_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/sorters/qqmlsortercompositor.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/sorters/qqmlstringsorter_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/sorters/qqmlstringsorter.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/sorters/qqmlrolesorter_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/sorters/qqmlrolesorter.cpp
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/sorters/qqmlfunctionsorter_p.h
Relationship: SPDXRef-PackagedFile-qt-module-QmlModels-b812a27e4d8e GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtdeclarative/src/qmlmodels/sfpm/sorters/qqmlfunctionsorter.cpp
"
                )
        endif()
