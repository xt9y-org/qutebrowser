
        if(NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/plugins/platforms/libqcocoa.dylib"
                AND NOT QT_SBOM_BUILD_TIME AND NOT QT_SBOM_FAKE_CHECKSUM)
            if(NOT FALSE)
                message(FATAL_ERROR "Cannot find 'plugins/platforms/libqcocoa.dylib' to compute its checksum. "
                    "Expected to find it at '$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/plugins/platforms/libqcocoa.dylib' ")
            endif()
        else()
            if(NOT QT_SBOM_BUILD_TIME)
                if(QT_SBOM_FAKE_CHECKSUM)
                    set(sha1 "158942a783ee1095eafacaffd93de73edeadbeef")
                else()
                    file(SHA1 "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/plugins/platforms/libqcocoa.dylib" sha1)
                endif()

                set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846" true)

                list(APPEND QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES
                    "SPDXRef-Package-qtbase-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846")
                list(APPEND
                    "QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES_SPDXRef-Package-qtbase-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846"
                    "${sha1}")
            endif()
            file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
FileName: ./plugins/platforms/libqcocoa.dylib
SPDXID: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846
FileType: BINARY
FileChecksum: SHA1: ${sha1}
LicenseConcluded: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
FileCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
LicenseInfoInFile: NOASSERTION
Relationship: SPDXRef-Package-qtbase-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 CONTAINS SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/main.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoaapplication.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoaapplication.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoaapplicationdelegate.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoaapplicationdelegate.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoabackingstore.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoabackingstore.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoaclipboard.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoaclipboard.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoacursor.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoacursor.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoadrag.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoadrag.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoaeventdispatcher.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoaeventdispatcher.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoahelpers.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoahelpers.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoainputcontext.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoainputcontext.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoaintegration.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoaintegration.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoaintrospection.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoaintrospection.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoamenu.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoamenu.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoamenubar.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoamenubar.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoamenuitem.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoamenuitem.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoamenuloader.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoamenuloader.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoamimetypes.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoamimetypes.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoanativeinterface.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoanativeinterface.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoansmenu.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoansmenu.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoascreen.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoascreen.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoaservices.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoaservices.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoasystemtrayicon.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoasystemtrayicon.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoatheme.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoatheme.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoawindow.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoawindow.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoawindowmanager.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoawindowmanager.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qiosurfacegraphicsbuffer.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qiosurfacegraphicsbuffer.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qmacclipboard.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qmacclipboard.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qmultitouch_mac.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qmultitouch_mac_p.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qnsview.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qnsview.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qnsview_drawing.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qnsview_mouse.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qnsview_touch.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qnsview_gestures.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qnsview_tablet.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qnsview_dragging.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qnsview_keys.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qnsview_complextext.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qnsview_menus.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qnsview_accessibility.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qnswindow.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qnswindow.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qnswindowdelegate.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qnswindowdelegate.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoacolordialoghelper.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoacolordialoghelper.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoafiledialoghelper.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoafiledialoghelper.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoafontdialoghelper.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoafontdialoghelper.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoamessagedialog.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoamessagedialog.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtbase/src/plugins/platforms/cocoa/.qt/rcc/qrc_qcocoaresources.cpp
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoaglcontext.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoaglcontext.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoaaccessibility.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoaaccessibility.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoaaccessibilityelement.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoaaccessibilityelement.mm
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoasessionmanager.cpp
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/qcocoasessionmanager.h
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /build_dir/qtbase/src/plugins/platforms/cocoa/.qt/rcc/qcocoaresources.qrc
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/images/sizeallcursor.png
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/images/spincursor.png
Relationship: SPDXRef-PackagedFile-qt-plugin-QCocoaIntegrationPlugin-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/plugins/platforms/cocoa/images/waitcursor.png
"
                )
        endif()
