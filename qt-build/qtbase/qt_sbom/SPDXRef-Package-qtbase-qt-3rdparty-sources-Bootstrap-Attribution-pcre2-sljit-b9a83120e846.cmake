
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-3rdparty-sources-Bootstrap-Attribution-pcre2-sljit-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Bootstrap-Attribution-pcre2-sljit-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: Bootstrap_Attribution_pcre2-sljit
SPDXID: SPDXRef-Package-qtbase-qt-3rdparty-sources-Bootstrap-Attribution-pcre2-sljit-b9a83120e846
PackageDownloadLocation: https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.47/pcre2-10.47.tar.bz2
PackageVersion: 10.47
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: BSD-2-Clause
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:github/PCRE2Project/pcre2@pcre2-10.47
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=Bootstrap_Attribution_pcre2-sljit
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-Bootstrap_Attribution_pcre2-sljit@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=Bootstrap_Attribution_pcre2-sljit
PackageCopyrightText: <text>Copyright Zoltan Herczeg</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: Bootstrap_Attribution_pcre2-sljit
    Information extracted from:
     /src_dir/qtbase/src/3rdparty/pcre2/qt_attribution.json
    Entry index: 1
    Id: pcre2-sljit
    Name: PCRE2 - Stack-less Just-In-Time Compiler
    Description: The PCRE library is a set of functions that implement regular expression pattern matching using the same syntax and semantics as Perl 5.
    Qt usage: Used in Qt Core (QRegularExpression).
    License: BSD 2-clause \"Simplified\" License
    License file: LICENSE-SLJIT
</text>
ExternalRef: SECURITY cpe23Type cpe:2.3:a:pcre:pcre2:10.47:*:*:*:*:*:*:*\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-3rdparty-sources-Bootstrap-Attribution-pcre2-sljit-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Bootstrap-Attribution-pcre2-sljit-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-3rdparty-sources-Bootstrap-Attribution-pcre2-sljit-b9a83120e846
"
        )
