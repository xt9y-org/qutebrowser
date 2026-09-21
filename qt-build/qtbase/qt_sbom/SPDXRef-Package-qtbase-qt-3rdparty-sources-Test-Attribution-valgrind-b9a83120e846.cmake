
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-3rdparty-sources-Test-Attribution-valgrind-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Test-Attribution-valgrind-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: Test_Attribution_valgrind
SPDXID: SPDXRef-Package-qtbase-qt-3rdparty-sources-Test-Attribution-valgrind-b9a83120e846
PackageDownloadLocation: http://valgrind.org/
PackageVersion: 3.25.1
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: BSD-4-Clause
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:generic/valgrind@3.25.1?download_url=https://valgrind.org/
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=Test_Attribution_valgrind
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-Test_Attribution_valgrind@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=Test_Attribution_valgrind
PackageCopyrightText: <text>Copyright (C) 2000-2017 Julian Seward
Copyright (C) 2003-2017 Josef Weidendorfer.</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: Test_Attribution_valgrind
    Information extracted from:
     /src_dir/qtbase/src/testlib/3rdparty/valgrind/qt_attribution.json
    Entry index: 0
    Id: valgrind
    Name: Valgrind
    Description: An instrumentation framework for building dynamic analysis tools.
    Qt usage: Used on Linux ond MacOS in the Qt Test module.
    License: BSD 4-clause \"Original\" or \"Old\" License
    License file: LICENSE.txt
</text>\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-3rdparty-sources-Test-Attribution-valgrind-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Test-Attribution-valgrind-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-3rdparty-sources-Test-Attribution-valgrind-b9a83120e846
"
        )
