
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-grayraster-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-grayraster-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: Gui_Attribution_grayraster
SPDXID: SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-grayraster-b9a83120e846
PackageDownloadLocation: http://www.freetype.org
PackageVersion: unknown
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: FTL OR GPL-2.0-only
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:generic/freetype-grayraster?download_url=https://www.freetype.org/
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=Gui_Attribution_grayraster
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-Gui_Attribution_grayraster@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=Gui_Attribution_grayraster
PackageCopyrightText: <text>Copyright 2000-2016 by David Turner, Robert Wilhelm, and Werner Lemberg.</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: Gui_Attribution_grayraster
    Information extracted from:
     /src_dir/qtbase/src/gui/painting/qt_attribution.json
    Entry index: 0
    Id: grayraster
    Name: Anti-aliasing rasterizer from FreeType 2
    Description: FreeType is a freely available software library to render fonts.
    Qt usage: Used in Qt GUI.
    License: Freetype Project License or GNU General Public License v2.0 only
    License file: ../../3rdparty/freetype/LICENSE.txt
</text>\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-grayraster-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-grayraster-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-grayraster-b9a83120e846
"
        )
