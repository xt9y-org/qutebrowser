
        if(NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtPrintSupport.framework/Versions/A/QtPrintSupport"
                AND NOT QT_SBOM_BUILD_TIME AND NOT QT_SBOM_FAKE_CHECKSUM)
            if(NOT FALSE)
                message(FATAL_ERROR "Cannot find 'lib/QtPrintSupport.framework/Versions/A/QtPrintSupport' to compute its checksum. "
                    "Expected to find it at '$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtPrintSupport.framework/Versions/A/QtPrintSupport' ")
            endif()
        else()
            if(NOT QT_SBOM_BUILD_TIME)
                if(QT_SBOM_FAKE_CHECKSUM)
                    set(sha1 "158942a783ee1095eafacaffd93de73edeadbeef")
                else()
                    file(SHA1 "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/QtPrintSupport.framework/Versions/A/QtPrintSupport" sha1)
                endif()

                set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-module-PrintSupport-b9a83120e846" true)

                list(APPEND QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES
                    "SPDXRef-Package-qtbase-qt-module-PrintSupport-b9a83120e846")
                list(APPEND
                    "QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES_SPDXRef-Package-qtbase-qt-module-PrintSupport-b9a83120e846"
                    "${sha1}")
            endif()
            file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
FileName: ./lib/QtPrintSupport.framework/Versions/A/QtPrintSupport
SPDXID: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846
FileType: BINARY
FileChecksum: SHA1: ${sha1}
LicenseConcluded: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
FileCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
LicenseInfoInFile: NOASSERTION
Relationship: SPDXRef-Package-qtbase-qt-module-PrintSupport-b9a83120e846 CONTAINS SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtbase/include/QtPrintSupport/qtprintsupportexports.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qpaintengine_alpha.cpp
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qpaintengine_alpha_p.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qplatformprintdevice.cpp
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qplatformprintdevice.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qplatformprintersupport.cpp
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qplatformprintersupport.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qplatformprintplugin.cpp
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qplatformprintplugin.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qprint.cpp
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qprint_p.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qprintdevice.cpp
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qprintdevice_p.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qprintengine.cpp
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qprintengine.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qprintengine_pdf.cpp
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qprintengine_pdf_p.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qprinter.cpp
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qprinter.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qprinter_p.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qprinterinfo.cpp
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qprinterinfo.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qprinterinfo_p.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qtprintsupportglobal.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qtprintsupportglobal_p.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtbase/src/printsupport/qtprintsupport-config.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtbase/src/printsupport/qtprintsupport-config_p.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/platform/macos/qcocoaprintdevice.mm
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/platform/macos/qcocoaprintdevice_p.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/platform/macos/qcocoaprintersupport.mm
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/platform/macos/qcocoaprintersupport_p.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/platform/macos/qpaintengine_mac.mm
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/platform/macos/qpaintengine_mac_p.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/platform/macos/qprintengine_mac.mm
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/platform/macos/qprintengine_mac_p.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qpaintengine_preview.cpp
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/kernel/qpaintengine_preview_p.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/widgets/qprintpreviewwidget.cpp
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/widgets/qprintpreviewwidget.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/dialogs/qabstractprintdialog.cpp
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/dialogs/qabstractprintdialog.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/dialogs/qabstractprintdialog_p.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/dialogs/qpagesetupdialog.cpp
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/dialogs/qpagesetupdialog.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/dialogs/qpagesetupdialog_p.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/dialogs/qpagesetupwidget.ui
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/dialogs/qprintdialog.h
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtbase/src/printsupport/.qt/rcc/qrc_qprintdialog.cpp
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtbase/src/printsupport/.qt/rcc/qrc_qprintdialog1.cpp
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/dialogs/qpagesetupdialog_mac.mm
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/dialogs/qprintdialog_mac.mm
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/dialogs/qprintpreviewdialog.cpp
Relationship: SPDXRef-PackagedFile-qt-module-PrintSupport-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/printsupport/dialogs/qprintpreviewdialog.h
"
                )
        endif()
