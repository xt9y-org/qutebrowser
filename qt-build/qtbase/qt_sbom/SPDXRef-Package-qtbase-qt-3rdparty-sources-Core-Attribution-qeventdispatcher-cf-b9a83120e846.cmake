
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-qeventdispatcher-cf-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-qeventdispatcher-cf-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: Core_Attribution_qeventdispatcher_cf
SPDXID: SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-qeventdispatcher-cf-b9a83120e846
PackageDownloadLocation: NOASSERTION
PackageVersion: unknown
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: BSD-3-Clause
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=Core_Attribution_qeventdispatcher_cf
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-Core_Attribution_qeventdispatcher_cf@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=Core_Attribution_qeventdispatcher_cf
PackageCopyrightText: <text>Copyright (c) 2007-2008, Apple, Inc.</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: Core_Attribution_qeventdispatcher_cf
    Information extracted from:
     /src_dir/qtbase/src/corelib/kernel/qt_attribution.json
    Entry index: 0
    Id: qeventdispatcher_cf
    Name: QEventDispatcher on macOS
    Description: Implementation of QAbstractEventDispatcher for macOS.
    Qt usage: Used in Qt Core on macOS.
    License: BSD 3-clause \"New\" or \"Revised\" License
    License file: LICENSE.QEVENTDISPATCHER_CF.txt
</text>\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-qeventdispatcher-cf-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-qeventdispatcher-cf-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-qeventdispatcher-cf-b9a83120e846
"
        )
