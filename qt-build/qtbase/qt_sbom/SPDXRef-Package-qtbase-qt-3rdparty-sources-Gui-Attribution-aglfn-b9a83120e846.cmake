
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-aglfn-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-aglfn-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: Gui_Attribution_aglfn
SPDXID: SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-aglfn-b9a83120e846
PackageDownloadLocation: https://github.com/adobe-type-tools/agl-aglfn
PackageVersion: 1.7
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: BSD-3-Clause
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:github/adobe-type-tools/agl-aglfn@1.7
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=Gui_Attribution_aglfn
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-Gui_Attribution_aglfn@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=Gui_Attribution_aglfn
PackageCopyrightText: <text>Copyright 2002, 2003, 2005, 2006, 2008, 2010, 2015 Adobe Systems</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: Gui_Attribution_aglfn
    Information extracted from:
     /src_dir/qtbase/src/gui/text/qt_attribution.json
    Entry index: 0
    Id: aglfn
    Name: Adobe Glyph List For New Fonts
    Description: Provides standardized names for glyphs.
    Qt usage: Used by PDF generator to make it easier for reader applications to resolve  the original contents of rendered text.
    License: BSD 3-Clause \"New\" or \"Revised\" License
    License file: LICENSE.AGLFN.txt
</text>\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-aglfn-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-aglfn-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-aglfn-b9a83120e846
"
        )
