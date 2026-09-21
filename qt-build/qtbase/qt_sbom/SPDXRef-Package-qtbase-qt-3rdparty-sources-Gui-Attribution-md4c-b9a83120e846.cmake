
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-md4c-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-md4c-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: Gui_Attribution_md4c
SPDXID: SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-md4c-b9a83120e846
PackageDownloadLocation: https://github.com/mity/md4c/releases/tag/release-0.5.3
PackageVersion: 0.5.3
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: MIT
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:github/mity/md4c@release-0.5.3
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=Gui_Attribution_md4c
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-Gui_Attribution_md4c@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=Gui_Attribution_md4c
PackageCopyrightText: <text>Copyright © 2016-2024 Martin Mitáš</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: Gui_Attribution_md4c
    Information extracted from:
     /src_dir/qtbase/src/3rdparty/md4c/qt_attribution.json
    Entry index: 0
    Id: md4c
    Name: MD4C
    Description: A CommonMark-compliant Markdown parser.
    Qt usage: Optionally used in QTextDocument if configured with textmarkdownreader.
    License: MIT License
    License file: LICENSE.md
</text>
ExternalRef: SECURITY cpe23Type cpe:2.3:a:md4c_project:md4c:0.5.3:*:*:*:*:*:*:*\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-md4c-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-md4c-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-3rdparty-sources-Gui-Attribution-md4c-b9a83120e846
"
        )
