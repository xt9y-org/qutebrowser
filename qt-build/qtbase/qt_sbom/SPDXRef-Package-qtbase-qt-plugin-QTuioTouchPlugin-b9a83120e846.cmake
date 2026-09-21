
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-plugin-QTuioTouchPlugin-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-plugin-QTuioTouchPlugin-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: QTuioTouchPlugin
SPDXID: SPDXRef-Package-qtbase-qt-plugin-QTuioTouchPlugin-b9a83120e846
PackageDownloadLocation: git://code.qt.io/qt/qtbase.git@ef55f427f2c8b410d34f8a7681020a3000cf6866
PackageVersion: 6.11.2
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
PackageLicenseDeclared: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=QTuioTouchPlugin#src/plugins/generic/tuiotouch
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-QTuioTouchPlugin@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=QTuioTouchPlugin#src/plugins/generic/tuiotouch
PackageCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: QTuioTouchPlugin
</text>
ExternalRef: SECURITY cpe23Type cpe:2.3:a:qt:qt:6.11.2:*:*:*:*:*:*:*
ExternalRef: SECURITY cpe23Type cpe:2.3:a:qt:qtbase:6.11.2:*:*:*:*:*:*:*\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-plugin-QTuioTouchPlugin-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-plugin-QTuioTouchPlugin-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-plugin-QTuioTouchPlugin-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-plugin-QTuioTouchPlugin-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-plugin-QTuioTouchPlugin-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-module-Gui-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-plugin-QTuioTouchPlugin-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-module-Network-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-plugin-QTuioTouchPlugin-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-module-PlatformPluginInternal-b9a83120e846
"
        )
