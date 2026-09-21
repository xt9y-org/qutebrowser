
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-webgradients-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-webgradients-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: Gui_Attribution_webgradients
SPDXID: SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-webgradients-b9a83120e846
PackageDownloadLocation: https://webgradients.com/
PackageVersion: unknown
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: MIT
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:generic/webgradients?download_url=https://webgradients.com/
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=Gui_Attribution_webgradients
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-Gui_Attribution_webgradients@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=Gui_Attribution_webgradients
PackageCopyrightText: <text>Copyright (c) 2017 itmeo</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: Gui_Attribution_webgradients
    Information extracted from:
     /src_dir/qtbase/util/gradientgen/qt_attribution.json
    Entry index: 0
    Id: webgradients
    Name: WebGradients
    Description: WebGradients is a free collection of 180 linear gradients.
    Qt usage: Used in Qt GUI to provide presets for QGradient.
    License: MIT License
    License file: LICENSE.WEBGRADIENTS.txt
</text>\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-webgradients-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-webgradients-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-webgradients-b9a83120e846
"
        )
