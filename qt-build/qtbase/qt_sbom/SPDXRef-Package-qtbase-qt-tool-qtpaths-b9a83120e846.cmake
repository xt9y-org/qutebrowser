
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-tool-qtpaths-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-tool-qtpaths-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: qtpaths
SPDXID: SPDXRef-Package-qtbase-qt-tool-qtpaths-b9a83120e846
PackageDownloadLocation: git://code.qt.io/qt/qtbase.git@ef55f427f2c8b410d34f8a7681020a3000cf6866
PackageVersion: 6.11.2
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: LicenseRef-Qt-Commercial OR GPL-3.0-only WITH Qt-GPL-exception-1.0
PackageLicenseDeclared: LicenseRef-Qt-Commercial OR GPL-3.0-only WITH Qt-GPL-exception-1.0
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=qtpaths#src/tools/qtpaths
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-qtpaths@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=qtpaths#src/tools/qtpaths
PackageCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
PrimaryPackagePurpose: APPLICATION
PackageComment: <text>
CMake target name: qtpaths
</text>
ExternalRef: SECURITY cpe23Type cpe:2.3:a:qt:qt:6.11.2:*:*:*:*:*:*:*
ExternalRef: SECURITY cpe23Type cpe:2.3:a:qt:qtbase:6.11.2:*:*:*:*:*:*:*\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-tool-qtpaths-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-tool-qtpaths-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-tool-qtpaths-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-tool-qtpaths-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-module-PlatformToolInternal-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-tool-qtpaths-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-module-PlatformCommonInternal-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-tool-qtpaths-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846
"
        )
