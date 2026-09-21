
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-forkfd-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-forkfd-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: Core_Attribution_forkfd
SPDXID: SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-forkfd-b9a83120e846
PackageDownloadLocation: NOASSERTION
PackageVersion: unknown
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: MIT
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=Core_Attribution_forkfd
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-Core_Attribution_forkfd@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=Core_Attribution_forkfd
PackageCopyrightText: <text>Copyright (C) 2016 Intel Corporation
Copyright (C) 2015 Klarälvdalens Datakonsult AB, a KDAB Group company, info@kdab.com</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: Core_Attribution_forkfd
    Information extracted from:
     /src_dir/qtbase/src/3rdparty/forkfd/qt_attribution.json
    Entry index: 0
    Id: forkfd
    Name: forkfd
    Qt usage: Used on most Unix platforms in Qt Core.
    License: MIT License
    License file: LICENSE
</text>\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-forkfd-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-forkfd-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-forkfd-b9a83120e846
"
        )
