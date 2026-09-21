
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-3rdparty-sources-TestInternalsPrivate-Attribution-cmake-runcmake-test-modules-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-TestInternalsPrivate-Attribution-cmake-runcmake-test-modules-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: TestInternalsPrivate_Attribution_cmake-runcmake-test-modules
SPDXID: SPDXRef-Package-qtbase-qt-3rdparty-sources-TestInternalsPrivate-Attribution-cmake-runcmake-test-modules-b9a83120e846
PackageDownloadLocation: https://cmake.org/
PackageVersion: 3.31.5
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: BSD-3-Clause
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=TestInternalsPrivate_Attribution_cmake-runcmake-test-modules
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-TestInternalsPrivate_Attribution_cmake-runcmake-test-modules@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=TestInternalsPrivate_Attribution_cmake-runcmake-test-modules
PackageCopyrightText: <text>Copyright © 2000-2024 Kitware, Inc. and Contributors</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: TestInternalsPrivate_Attribution_cmake-runcmake-test-modules
    Information extracted from:
     /src_dir/qtbase/src/testinternal/3rdparty/cmake/qt_attribution.json
    Entry index: 0
    Id: cmake-runcmake-test-modules
    Name: cmake-runcmake-test-modules
    Description: CMake helpers for running CMake tests.
    Qt usage: Used as part of the build system.
    License: BSD 3-Clause \"New\" or \"Revised\" License
    License file: Copyright.txt
</text>\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-3rdparty-sources-TestInternalsPrivate-Attribution-cmake-runcmake-test-modules-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-TestInternalsPrivate-Attribution-cmake-runcmake-test-modules-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-3rdparty-sources-TestInternalsPrivate-Attribution-cmake-runcmake-test-modules-b9a83120e846
"
        )
