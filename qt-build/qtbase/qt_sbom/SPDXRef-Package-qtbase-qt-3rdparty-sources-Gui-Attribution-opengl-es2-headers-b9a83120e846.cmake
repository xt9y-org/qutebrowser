
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-opengl-es2-headers-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-opengl-es2-headers-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: Gui_Attribution_opengl-es2-headers
SPDXID: SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-opengl-es2-headers-b9a83120e846
PackageDownloadLocation: https://www.khronos.org/
PackageVersion: Revision 27673
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: MIT
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:generic/khronos-opengl-es2-headers?download_url=https://www.khronos.org/?revision=27673
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=Gui_Attribution_opengl-es2-headers
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-Gui_Attribution_opengl-es2-headers@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=Gui_Attribution_opengl-es2-headers
PackageCopyrightText: <text>Copyright (c) 2013-2014 The Khronos Group Inc.</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: Gui_Attribution_opengl-es2-headers
    Information extracted from:
     /src_dir/qtbase/src/gui/opengl/qt_attribution.json
    Entry index: 1
    Id: opengl-es2-headers
    Name: OpenGL ES 2 Headers
    Description: OpenGL ES 2 header generated from the Khronos OpenGL / OpenGL ES XML API Registry.
    Qt usage: Used on Windows and Linux in the OpenGL related headers of Qt GUI.
    License: MIT License
    License file: LICENSE.KHRONOS.txt
</text>\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-opengl-es2-headers-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-opengl-es2-headers-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-opengl-es2-headers-b9a83120e846
"
        )
