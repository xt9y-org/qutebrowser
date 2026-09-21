
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-JpegPrivate-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-JpegPrivate-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: JpegPrivate
SPDXID: SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-JpegPrivate-b9a83120e846
PackageDownloadLocation: https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/3.2.0/libjpeg-turbo-3.2.0.tar.gz
PackageVersion: 3.2.0
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: IJG AND BSD-3-Clause
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:github/libjpeg-turbo/libjpeg-turbo@3.2.0
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=JpegPrivate
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-JpegPrivate@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=JpegPrivate
PackageCopyrightText: <text>Copyright (C) 2009-2026 D. R. Commander
Copyright (C) 1991-1998 Thomas G. Lane
Copyright (C) 2009 Pierre Ossman for Cendio AB
Copyright (C) 1999-2006 MIYASAKA Masaru
Copyright (C) 1999 Ken Murchison
Copyright (C) 2015-2016, 2018, 2022 Matthieu Darbois
Copyright (C) 2018 Matthias Räncker
Copyright (C) 2019-2020 Arm Limited
Copyright (C) 2022 Felix Hanau
Copyright (C) 1997-1998 Thomas G. Lane, Todd Newman
Copyright (C) 2021 Alex Richardson
Copyright (C) 2015, 2020 Google, Inc.
Copyright (C) 2013 Linaro Limited
Copyright (C) 2014 Olle Liljenzin
Copyright (C) 1991-2020 Thomas G. Lane, Guido Vollbeding
</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: JpegPrivate
CMake exported target name: Qt6::Jpeg
Contained in CMake package: Qt6JpegPrivate
    Information extracted from:
     /src_dir/qtbase/src/3rdparty/libjpeg/qt_attribution.json
    Entry index: 0
    Id: libjpeg
    Name: LibJPEG-turbo
    Description: The Independent JPEG Group's JPEG software
    Qt usage: Used in the qjpeg image plugin. Configure with -system-libjpeg or -no-libjpeg to avoid.
    License: Independent JPEG Group License and BSD 3-Clause \"New\" or \"Revised\" License
</text>
ExternalRef: SECURITY cpe23Type cpe:2.3:a:libjpeg-turbo:libjpeg-turbo:3.2.0:*:*:*:*:*:*:*\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-JpegPrivate-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-JpegPrivate-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-JpegPrivate-b9a83120e846
"
        )
