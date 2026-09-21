
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-3rdparty-sources-Test-Attribution-linuxperf-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Test-Attribution-linuxperf-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: Test_Attribution_linuxperf
SPDXID: SPDXRef-Package-qtbase-qt-3rdparty-sources-Test-Attribution-linuxperf-b9a83120e846
PackageDownloadLocation: https://www.kernel.org
PackageVersion: 6.13
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: GPL-2.0-only WITH Linux-syscall-note
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:github/torvalds/linux@v6.13#include/uapi/linux/perf_event.h
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=Test_Attribution_linuxperf
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-Test_Attribution_linuxperf@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=Test_Attribution_linuxperf
PackageCopyrightText: <text>Copyright (C) 2008-2009, Thomas Gleixner <tglx@linutronix.de>
Copyright (C) 2008-2011, Red Hat, Inc., Ingo Molnar
Copyright (C) 2008-2011, Red Hat, Inc., Peter Zijlstra</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: Test_Attribution_linuxperf
    Information extracted from:
     /src_dir/qtbase/src/testlib/3rdparty/linux/qt_attribution.json
    Entry index: 0
    Id: linuxperf
    Name: Linux Performance Events
    Description: Allows access to the Linux kernel's performance events.
    Qt usage: Used on Linux and Android in the Qt Test module.
    License: GNU General Public License v2.0 only with Linux Syscall Note
    License file: LICENSE.txt
</text>\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-3rdparty-sources-Test-Attribution-linuxperf-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-3rdparty-sources-Test-Attribution-linuxperf-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-3rdparty-sources-Test-Attribution-linuxperf-b9a83120e846
"
        )
