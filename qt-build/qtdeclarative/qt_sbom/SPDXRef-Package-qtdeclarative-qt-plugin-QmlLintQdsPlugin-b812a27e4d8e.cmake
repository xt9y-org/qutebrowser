
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtdeclarative-qt-plugin-QmlLintQdsPlugin-b812a27e4d8e")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtdeclarative-qt-plugin-QmlLintQdsPlugin-b812a27e4d8e" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/qt_sbom/staging-qtdeclarative.spdx.in"
"
PackageName: QmlLintQdsPlugin
SPDXID: SPDXRef-Package-qtdeclarative-qt-plugin-QmlLintQdsPlugin-b812a27e4d8e
PackageDownloadLocation: git://code.qt.io/qt/qtdeclarative.git@4e3399c26ec57246c08de019cfcbda8d23604cfa
PackageVersion: 6.11.2
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
PackageLicenseDeclared: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtdeclarative@4e3399c26e?library_name=QmlLintQdsPlugin#src/plugins/qmllint/qds
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtdeclarative-QmlLintQdsPlugin@4e3399c26e?vcs_url=https://code.qt.io/qt/qtdeclarative.git@4e3399c26e&library_name=QmlLintQdsPlugin#src/plugins/qmllint/qds
PackageCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: QmlLintQdsPlugin
</text>
ExternalRef: SECURITY cpe23Type cpe:2.3:a:qt:qt:6.11.2:*:*:*:*:*:*:*
ExternalRef: SECURITY cpe23Type cpe:2.3:a:qt:qtdeclarative:6.11.2:*:*:*:*:*:*:*\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtdeclarative-qt-plugin-QmlLintQdsPlugin-b812a27e4d8e}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtdeclarative-qt-plugin-QmlLintQdsPlugin-b812a27e4d8e}
Relationship: SPDXRef-Package-qtdeclarative-b812a27e4d8e CONTAINS SPDXRef-Package-qtdeclarative-qt-plugin-QmlLintQdsPlugin-b812a27e4d8e
Relationship: SPDXRef-Package-qtdeclarative-qt-plugin-QmlLintQdsPlugin-b812a27e4d8e DEPENDS_ON DocumentRef-qtbase-b9a83120e846:SPDXRef-Package-qtbase-qt-module-PlatformPluginInternal-b9a83120e846
Relationship: SPDXRef-Package-qtdeclarative-qt-plugin-QmlLintQdsPlugin-b812a27e4d8e DEPENDS_ON SPDXRef-Package-qtdeclarative-qt-module-QmlCompiler-b812a27e4d8e
"
        )
