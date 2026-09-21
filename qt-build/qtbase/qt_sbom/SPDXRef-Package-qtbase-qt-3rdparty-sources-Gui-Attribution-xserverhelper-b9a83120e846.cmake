
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-xserverhelper-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-xserverhelper-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: Gui_Attribution_xserverhelper
SPDXID: SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-xserverhelper-b9a83120e846
PackageDownloadLocation: https://www.x.org/
PackageVersion: unknown
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: X11 AND HPND
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:generic/xserverhelper?download_url=https://www.x.org/
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=Gui_Attribution_xserverhelper
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-Gui_Attribution_xserverhelper@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=Gui_Attribution_xserverhelper
PackageCopyrightText: <text>Copyright (c) 1987, 1988 X Consortium
Copyright 1987, 1988 by Digital Equipment Corporation, Maynard, Massachusetts.</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: Gui_Attribution_xserverhelper
    Information extracted from:
     /src_dir/qtbase/src/gui/painting/qt_attribution.json
    Entry index: 2
    Id: xserverhelper
    Name: X Server helper
    Description: Code from X11's region.h, Region.c, poly.h, and PolyReg.c
    Qt usage: Used in Qt GUI (QRegion).
    License: X11 License and Historical Permission Notice and Disclaimer
    License file: LICENSE.XCONSORTIUM.txt
</text>\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-xserverhelper-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-xserverhelper-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-xserverhelper-b9a83120e846
"
        )
