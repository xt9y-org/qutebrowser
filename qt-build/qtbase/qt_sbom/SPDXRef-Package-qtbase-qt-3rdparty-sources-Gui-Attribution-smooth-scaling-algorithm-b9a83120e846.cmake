
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-smooth-scaling-algorithm-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-smooth-scaling-algorithm-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: Gui_Attribution_smooth-scaling-algorithm
SPDXID: SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-smooth-scaling-algorithm-b9a83120e846
PackageDownloadLocation: NOASSERTION
PackageVersion: unknown
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: BSD-2-Clause AND Imlib2
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=Gui_Attribution_smooth-scaling-algorithm
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-Gui_Attribution_smooth-scaling-algorithm@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=Gui_Attribution_smooth-scaling-algorithm
PackageCopyrightText: <text>Copyright (C) 2004, 2005 Daniel M. Duley.
(C) Carsten Haitzler and various contributors.
(C) Willem Monsuwe <willem@stack.nl></text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: Gui_Attribution_smooth-scaling-algorithm
    Information extracted from:
     /src_dir/qtbase/src/gui/painting/qt_attribution.json
    Entry index: 1
    Id: smooth-scaling-algorithm
    Name: Smooth Scaling Algorithm
    Description: Normal smoothscale method, based on Imlib2's smoothscale.
    Qt usage: Used in Qt Gui (QImage::transformed() functions).
    License: BSD 2-clause \"Simplified\" License and Imlib2 License
    License file: LICENSE.QIMAGETRANSFORM.txt
</text>\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-smooth-scaling-algorithm-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-smooth-scaling-algorithm-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-smooth-scaling-algorithm-b9a83120e846
"
        )
