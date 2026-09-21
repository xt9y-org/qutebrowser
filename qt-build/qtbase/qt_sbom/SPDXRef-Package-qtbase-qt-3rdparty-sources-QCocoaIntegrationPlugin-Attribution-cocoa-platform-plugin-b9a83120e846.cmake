
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-3rdparty-sources-QCocoaIntegrationPlugin-Attribution-cocoa-platform-plugin-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-QCocoaIntegrationPlugin-Attribution-cocoa-platform-plugin-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: QCocoaIntegrationPlugin_Attribution_cocoa-platform-plugin
SPDXID: SPDXRef-Package-qtbase-qt-3rdparty-sources-QCocoaIntegrationPlugin-Attribution-cocoa-platform-plugin-b9a83120e846
PackageDownloadLocation: NOASSERTION
PackageVersion: unknown
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: BSD-3-Clause
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=QCocoaIntegrationPlugin_Attribution_cocoa-platform-plugin
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-QCocoaIntegrationPlugin_Attribution_cocoa-platform-plugin@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=QCocoaIntegrationPlugin_Attribution_cocoa-platform-plugin
PackageCopyrightText: <text>Copyright (c) 2007-2008, Apple, Inc.</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: QCocoaIntegrationPlugin_Attribution_cocoa-platform-plugin
    Information extracted from:
     /src_dir/qtbase/src/plugins/platforms/cocoa/qt_attribution.json
    Entry index: 0
    Id: cocoa-platform-plugin
    Name: Cocoa Platform Plugin
    Description: Allows Qt to integrate into Apple's Cocoa API.
    Qt usage: Code used in the Qt Platform Abstraction (QPA) for macOS.
    License: BSD 3-clause \"New\" or \"Revised\" License
    License file: LICENSE.COCOA.txt
</text>\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-3rdparty-sources-QCocoaIntegrationPlugin-Attribution-cocoa-platform-plugin-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-QCocoaIntegrationPlugin-Attribution-cocoa-platform-plugin-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-3rdparty-sources-QCocoaIntegrationPlugin-Attribution-cocoa-platform-plugin-b9a83120e846
"
        )
