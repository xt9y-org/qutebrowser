
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-tool-moc-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-tool-moc-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: moc
SPDXID: SPDXRef-Package-qtbase-qt-tool-moc-b9a83120e846
PackageDownloadLocation: git://code.qt.io/qt/qtbase.git@ef55f427f2c8b410d34f8a7681020a3000cf6866
PackageVersion: 6.11.2
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: LicenseRef-Qt-Commercial OR GPL-3.0-only WITH Qt-GPL-exception-1.0
PackageLicenseDeclared: LicenseRef-Qt-Commercial OR GPL-3.0-only WITH Qt-GPL-exception-1.0
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=moc#src/tools/moc
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-moc@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=moc#src/tools/moc
PackageCopyrightText: <text>Copyright (C) 2013 Olivier Goffart <ogoffart@woboq.com>
Copyright (C) 2014 Olivier Goffart <ogoffart@woboq.org>
Copyright (C) 2016 Intel Corporation.
Copyright (C) 2018 Intel Corporation.
Copyright (C) 2018 The Qt Company Ltd.
Copyright (C) 2019 Olivier Goffart <ogoffart@woboq.com>
Copyright (C) The Qt Company Ltd. and other contributors.</text>
PrimaryPackagePurpose: APPLICATION
PackageComment: <text>
CMake target name: moc
</text>
ExternalRef: SECURITY cpe23Type cpe:2.3:a:qt:qt:6.11.2:*:*:*:*:*:*:*
ExternalRef: SECURITY cpe23Type cpe:2.3:a:qt:qtbase:6.11.2:*:*:*:*:*:*:*\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-tool-moc-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-tool-moc-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-tool-moc-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-tool-moc-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-module-PlatformToolInternal-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-tool-moc-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-module-PlatformCommonInternal-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-tool-moc-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-module-Bootstrap-b9a83120e846
"
        )
