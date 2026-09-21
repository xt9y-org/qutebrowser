
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-3rdparty-sources-BundledFreetype-Attribution-freetype-zlib-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-BundledFreetype-Attribution-freetype-zlib-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: BundledFreetype_Attribution_freetype-zlib
SPDXID: SPDXRef-Package-qtbase-qt-3rdparty-sources-BundledFreetype-Attribution-freetype-zlib-b9a83120e846
PackageDownloadLocation: https://download.savannah.gnu.org/releases/freetype/freetype-2.14.3.tar.gz
PackageVersion: 2.14.3
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: Zlib
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:github/freetype/freetype@VER-2-14-3
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=BundledFreetype_Attribution_freetype-zlib
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-BundledFreetype_Attribution_freetype-zlib@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=BundledFreetype_Attribution_freetype-zlib
PackageCopyrightText: <text>Copyright (C) 1995-2024 Jean-loup Gailly and Mark Adler</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: BundledFreetype_Attribution_freetype-zlib
    Information extracted from:
     /src_dir/qtbase/src/3rdparty/freetype/qt_attribution.json
    Entry index: 1
    Id: freetype-zlib
    Name: Freetype 2 - zlib
    Description: FreeType is a freely available software library to render fonts.
    Qt usage: Optionally used in Qt GUI and platform plugins. Configure with -no-freetype, or -system-freetype to avoid.
    License: zlib License
    License file: ZLIB-LICENSE.txt
</text>
ExternalRef: SECURITY cpe23Type cpe:2.3:a:freetype:freetype:2.14.3:*:*:*:*:*:*:*\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-3rdparty-sources-BundledFreetype-Attribution-freetype-zlib-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-BundledFreetype-Attribution-freetype-zlib-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-3rdparty-sources-BundledFreetype-Attribution-freetype-zlib-b9a83120e846
"
        )
