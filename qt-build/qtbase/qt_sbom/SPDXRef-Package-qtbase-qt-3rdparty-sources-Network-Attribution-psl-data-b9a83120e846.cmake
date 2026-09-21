
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-3rdparty-sources-Network-Attribution-psl-data-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Network-Attribution-psl-data-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: Network_Attribution_psl-data
SPDXID: SPDXRef-Package-qtbase-qt-3rdparty-sources-Network-Attribution-psl-data-b9a83120e846
PackageDownloadLocation: https://publicsuffix.org/list/public_suffix_list.dat
PackageVersion: 2026-05-14_08-35-31_UTC
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: MPL-2.0
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:generic/psl-data@e452c7058d6946bd76952b128c12f5ce87a5acb8?download_url=https://publicsuffix.org/list/public_suffix_list.dat
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=Network_Attribution_psl-data
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-Network_Attribution_psl-data@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=Network_Attribution_psl-data
PackageCopyrightText: <text>The list was originally provided by Jo Hermans <jo.hermans@gmail.com>.
It is now maintained on github (https://github.com/publicsuffix/list).</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: Network_Attribution_psl-data
    Information extracted from:
     /src_dir/qtbase/src/3rdparty/libpsl/qt_attribution.json
    Entry index: 0
    Id: psl-data
    Name: The Public Suffix List
    Description: The Public Suffix List is an initiative of Mozilla,
but is maintained as a community resource. It is available for use in any software,
but was originally created to meet the needs of browser manufacturers.
It allows browsers to, for example:

- Avoid privacy-damaging \"supercookies\" being set for high-level domain name suffixes

- Highlight the most important part of a domain name in the user interface

- Accurately sort history entries by site
    Qt usage: Used in Qt Network to avoid setting \"supercookies\" in the cookie jar
supported by Qt (by the QNetworkCookieJar class).
    License: Mozilla Public License 2.0
    License file: PSL-LICENSE.txt
</text>\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-3rdparty-sources-Network-Attribution-psl-data-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Network-Attribution-psl-data-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-3rdparty-sources-Network-Attribution-psl-data-b9a83120e846
"
        )
