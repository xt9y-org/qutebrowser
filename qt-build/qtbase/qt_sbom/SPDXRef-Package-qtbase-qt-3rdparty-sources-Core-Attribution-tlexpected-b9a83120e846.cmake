
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-tlexpected-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-tlexpected-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: Core_Attribution_tlexpected
SPDXID: SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-tlexpected-b9a83120e846
PackageDownloadLocation: https://github.com/TartanLlama/expected/blob/41d3e1f48d682992a2230b2a715bca38b848b269/include/tl/expected.hpp
PackageVersion: 41d3e1f48d682992a2230b2a715bca38b848b269
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: CC0-1.0
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=Core_Attribution_tlexpected
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-Core_Attribution_tlexpected@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=Core_Attribution_tlexpected
PackageCopyrightText: <text>To the extent possible under law, Sy Brand has waived all copyright and related or neighboring rights to the expected library. This work is published from: United Kingdom.</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: Core_Attribution_tlexpected
    Information extracted from:
     /src_dir/qtbase/src/corelib/global/qt_attribution.json
    Entry index: 0
    Id: tlexpected
    Name: tl::expected
    Description: Single header implementation of std::expected with functional-style extensions.
    Qt usage: Available as a private type in all Qt modules
    License: Creative Commons Zero v1.0 Universal
</text>\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-tlexpected-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-tlexpected-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-tlexpected-b9a83120e846
"
        )
