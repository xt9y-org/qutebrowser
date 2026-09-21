
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-3rdparty-sources-Platform-Attribution-extra-cmake-modules-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Platform-Attribution-extra-cmake-modules-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: Platform_Attribution_extra-cmake-modules
SPDXID: SPDXRef-Package-qtbase-qt-3rdparty-sources-Platform-Attribution-extra-cmake-modules-b9a83120e846
PackageDownloadLocation: https://api.kde.org/ecm/
PackageVersion: 5.84.0
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: BSD-3-Clause
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=Platform_Attribution_extra-cmake-modules
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-Platform_Attribution_extra-cmake-modules@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=Platform_Attribution_extra-cmake-modules
PackageCopyrightText: <text>Copyright © 2011-2018 The KDE community</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: Platform_Attribution_extra-cmake-modules
    Information extracted from:
     /src_dir/qtbase/cmake/3rdparty/extra-cmake-modules/qt_attribution.json
    Entry index: 0
    Id: extra-cmake-modules
    Name: extra-cmake-modules
    Description: Additional CMake modules.
    Qt usage: Used as part of the build system.
    License: BSD-3-Clause
    License file: COPYING-CMAKE-SCRIPTS
</text>\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-3rdparty-sources-Platform-Attribution-extra-cmake-modules-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Platform-Attribution-extra-cmake-modules-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-3rdparty-sources-Platform-Attribution-extra-cmake-modules-b9a83120e846
"
        )
