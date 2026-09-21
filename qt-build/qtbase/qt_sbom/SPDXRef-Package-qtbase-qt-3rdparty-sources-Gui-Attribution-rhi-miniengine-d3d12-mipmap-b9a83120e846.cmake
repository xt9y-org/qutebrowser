
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-rhi-miniengine-d3d12-mipmap-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-rhi-miniengine-d3d12-mipmap-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: Gui_Attribution_rhi-miniengine-d3d12-mipmap
SPDXID: SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-rhi-miniengine-d3d12-mipmap-b9a83120e846
PackageDownloadLocation: https://github.com/microsoft/DirectX-Graphics-Samples
PackageVersion: 0aa79bad78992da0b6a8279ddb9002c1753cb849
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: MIT
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:github/microsoft/DirectX-Graphics-Samples@0aa79bad78992da0b6a8279ddb9002c1753cb849
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=Gui_Attribution_rhi-miniengine-d3d12-mipmap
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-Gui_Attribution_rhi-miniengine-d3d12-mipmap@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=Gui_Attribution_rhi-miniengine-d3d12-mipmap
PackageCopyrightText: <text>Copyright (c) 2015 Microsoft</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: Gui_Attribution_rhi-miniengine-d3d12-mipmap
    Information extracted from:
     /src_dir/qtbase/src/gui/rhi/qt_attribution.json
    Entry index: 0
    Id: rhi-miniengine-d3d12-mipmap
    Name: Mipmap generator for D3D12
    Description: Compute shader for mipmap generation from MiniEngine in DirectX-Graphics-Samples
    Qt usage: Compute shader for mipmap generation with Direct 3D 12
    License: MIT License
    License file: LICENSE.MiniEngine.txt
</text>\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-rhi-miniengine-d3d12-mipmap-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-rhi-miniengine-d3d12-mipmap-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-rhi-miniengine-d3d12-mipmap-b9a83120e846
"
        )
