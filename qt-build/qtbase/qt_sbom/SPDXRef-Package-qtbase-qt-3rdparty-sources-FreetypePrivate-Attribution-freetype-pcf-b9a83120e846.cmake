
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-3rdparty-sources-FreetypePrivate-Attribution-freetype-pcf-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-FreetypePrivate-Attribution-freetype-pcf-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: FreetypePrivate_Attribution_freetype-pcf
SPDXID: SPDXRef-Package-qtbase-qt-3rdparty-sources-FreetypePrivate-Attribution-freetype-pcf-b9a83120e846
PackageDownloadLocation: https://download.savannah.gnu.org/releases/freetype/freetype-2.14.3.tar.gz
PackageVersion: 2.14.3
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: MIT AND MIT-open-group
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:github/freetype/freetype@VER-2-14-3
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=FreetypePrivate_Attribution_freetype-pcf
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-FreetypePrivate_Attribution_freetype-pcf@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=FreetypePrivate_Attribution_freetype-pcf
PackageCopyrightText: <text>Copyright (c) 2001, 2012 David Turner, Robert Wilhelm, and Werner Lemberg
Copyright (c) 2000-2014 Francesco Zappa Nardelli
Copyright (c) 1990, 1994, 1998 The Open Group</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: FreetypePrivate_Attribution_freetype-pcf
    Information extracted from:
     /src_dir/qtbase/src/3rdparty/freetype/qt_attribution.json
    Entry index: 3
    Id: freetype-pcf
    Name: Freetype 2 - Portable Compiled Format (PCF) support
    Description: FreeType is a freely available software library to render fonts.
    Qt usage: Optionally used in Qt GUI and platform plugins. Configure with -no-freetype, or -system-freetype to avoid.
    License: MIT License and MIT Open Group variant
    License file: PCF-LICENSE.txt
</text>
ExternalRef: SECURITY cpe23Type cpe:2.3:a:freetype:freetype:2.14.3:*:*:*:*:*:*:*\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-3rdparty-sources-FreetypePrivate-Attribution-freetype-pcf-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-FreetypePrivate-Attribution-freetype-pcf-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-3rdparty-sources-FreetypePrivate-Attribution-freetype-pcf-b9a83120e846
"
        )
