
        if(NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6BundledFreetype.a"
                AND NOT QT_SBOM_BUILD_TIME AND NOT QT_SBOM_FAKE_CHECKSUM)
            if(NOT FALSE)
                message(FATAL_ERROR "Cannot find 'lib/libQt6BundledFreetype.a' to compute its checksum. "
                    "Expected to find it at '$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6BundledFreetype.a' ")
            endif()
        else()
            if(NOT QT_SBOM_BUILD_TIME)
                if(QT_SBOM_FAKE_CHECKSUM)
                    set(sha1 "158942a783ee1095eafacaffd93de73edeadbeef")
                else()
                    file(SHA1 "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6BundledFreetype.a" sha1)
                endif()

                set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846" true)

                list(APPEND QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES
                    "SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846")
                list(APPEND
                    "QT_SBOM_PACKAGES_WITH_VERIFICATION_CODES_SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846"
                    "${sha1}")
            endif()
            file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
FileName: ./lib/libQt6BundledFreetype.a
SPDXID: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846
FileType: BINARY
FileChecksum: SHA1: ${sha1}
LicenseConcluded: FTL OR GPL-2.0-only
FileCopyrightText: <text>Copyright (c) 2007-2014 Adobe Systems Incorporated
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
LicenseInfoInFile: NOASSERTION
Relationship: SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 CONTAINS SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/autofit/afadjust.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/autofit/afgsub.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/autofit/autofit.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/base/ftbase.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/base/ftbbox.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/base/ftbdf.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/base/ftbitmap.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/base/ftcid.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/base/ftfstype.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/base/ftgasp.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/base/ftglyph.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/base/ftgxval.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/base/ftinit.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/base/ftmm.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/base/ftotval.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/base/ftpatent.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/base/ftpfr.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/base/ftstroke.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/base/ftsynth.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/base/fttype1.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/base/ftwinfnt.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/bdf/bdf.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/bzip2/ftbzip2.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/cache/ftcache.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/cff/cff.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/cid/type1cid.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/gzip/ftgzip.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/lzw/ftlzw.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/pcf/pcf.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/pfr/pfr.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/psaux/psaux.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/pshinter/pshinter.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/psnames/psnames.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/raster/raster.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/sdf/sdf.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/sfnt/sfnt.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/smooth/smooth.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/svg/svg.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/truetype/truetype.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/type1/type1.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/type42/type42.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/winfonts/winfnt.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/src/base/ftdebug.c
Relationship: SPDXRef-PackagedFile-qt-bundled-3rdparty-module-BundledFreetype-b9a83120e846 GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtbase/src/3rdparty/freetype/builds/unix/ftsystem.c
"
                )
        endif()
