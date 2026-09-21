
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: BundledFreetype
SPDXID: SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846
PackageDownloadLocation: https://download.savannah.gnu.org/releases/freetype/freetype-2.14.3.tar.gz
PackageVersion: 2.14.3
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: FTL OR GPL-2.0-only
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:github/freetype/freetype@VER-2-14-3
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=BundledFreetype#src/3rdparty/freetype
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-BundledFreetype@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=BundledFreetype#src/3rdparty/freetype
PackageCopyrightText: <text>Copyright (c) 2007-2014 Adobe Systems Incorporated
Copyright (c) 2004-2026 Albert Chin-A-Young
Copyright (c) 2018-2026 Armin Hasitzka, David Turner, Robert Wilhelm, and Werner Lemberg
Copyright (c) 2000 Computing Research Labs, New Mexico State University
Copyright (c) 1996-2026 David Turner, Robert Wilhelm, Dominik Röttsches, and Werner Lemberg
Copyright (c) 2004-2026 David Turner, Robert Wilhelm, Werner Lemberg and George Williams
Copyright (c) 2022-2026 David Turner, Robert Wilhelm, Werner Lemberg, and Moazin Khatti
Copyright (c) 2008-2026 David Turner, Robert Wilhelm, Werner Lemberg, and suzuki toshiya
Copyright (c) 2003-2026 David Turner, Robert Wilhelm, and Werner Lemberg
Copyright (c) 2005-2026 David Turner
Copyright (c) 2007-2026 Derek Clegg and Michael Toftdal
Copyright (c) 2007 Dmitry Timoshkov for Codeweavers
Copyright (c) 2001-2015 Francesco Zappa Nardelli
Copyright (c) 2005, 2007, 2008, 2013 George Williams
Copyright (c) 2013-2026 Google, Inc. Google Author(s) Behdad Esfahbod and Stuart Gill
Copyright (c) 2013-2022 Google, Inc.
Copyright (c) 2003 Huw D M Davies for Codeweavers
Copyright (c) 2010-2026 Joel Klinghed
Copyright (c) 1996-2026 Just van Rossum, David Turner, Robert Wilhelm, and Werner Lemberg
Copyright (c) 2003-2026 Masatake YAMATO and Redhat K.K.
Copyright (c) 2004-2026 Masatake YAMATO, Redhat K.K, David Turner, Robert Wilhelm, and Werner Lemberg
Copyright (c) 2019-2026 Nikhil Ramakrishnan, David Turner, Robert Wilhelm, and Werner Lemberg
Copyright (c) 2009-2026 Oran Agra and Mickey Gabel
Copyright (c) 2007-2026 Rahul Bhalerao <rahul.bhalerao@redhat.com>
Copyright (c) 2002-2026 Roberto Alameda
Copyright (c) 2015-2026 Werner Lemberg
Copyright (c) 2004-2026 suzuki toshiya, Masatake YAMATO, Red Hat K.K., David Turner, Robert Wilhelm, and Werner Lemberg
Copyright (c) 2019 nyorain
Copyright (c) 2022-2026 David Turner, Robert Wilhelm, Werner Lemberg, George Williams, and Dominik Röttsches
Copyright (C) 2009, 2023  Red Hat, Inc.</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: BundledFreetype
CMake exported target name: Qt6::BundledFreetype
Contained in CMake package: Qt6BundledFreetype
    Information extracted from:
     /src_dir/qtbase/src/3rdparty/freetype/qt_attribution.json
    Entry index: 0
    Id: freetype
    Name: Freetype 2
    Description: FreeType is a freely available software library to render fonts.
    Qt usage: Optionally used in Qt GUI and platform plugins. Configure with -no-freetype, or -system-freetype to avoid.
    License: Freetype Project License or GNU General Public License v2.0 only
    License file: LICENSE.txt
</text>
ExternalRef: SECURITY cpe23Type cpe:2.3:a:freetype:freetype:2.14.3:*:*:*:*:*:*:*\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-module-PlatformModuleInternal-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-system-3rdparty-WrapZLIB-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-3rdparty-sources-BundledFreetype-Attribution-freetype-zlib-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-3rdparty-sources-BundledFreetype-Attribution-freetype-bdf-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-3rdparty-sources-BundledFreetype-Attribution-freetype-pcf-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-BundledLibpng-b9a83120e846
"
        )
