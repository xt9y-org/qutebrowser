
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: Core
SPDXID: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846
PackageDownloadLocation: git://code.qt.io/qt/qtbase.git@ef55f427f2c8b410d34f8a7681020a3000cf6866
PackageVersion: 6.11.2
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
PackageLicenseDeclared: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtbase@ef55f427f2c?library_name=Core#src/corelib
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtbase-Core@ef55f427f2c?vcs_url=https://code.qt.io/qt/qtbase.git@ef55f427f2c&library_name=Core#src/corelib
PackageCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: Core
CMake exported target name: Qt6::Core
Contained in CMake package: Qt6Core
</text>
ExternalRef: SECURITY cpe23Type cpe:2.3:a:qt:qt:6.11.2:*:*:*:*:*:*:*
ExternalRef: SECURITY cpe23Type cpe:2.3:a:qt:qtbase:6.11.2:*:*:*:*:*:*:*\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846}
Relationship: SPDXRef-Package-qtbase-b9a83120e846 CONTAINS SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-module-GlobalConfigPrivate-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-system-3rdparty-WrapZLIB-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-module-PlatformModuleInternal-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-system-3rdparty-WrapBacktrace-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-system-3rdparty-WrapRt-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-module-Platform-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-system-3rdparty-WrapAtomic-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-unicode-character-database-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-unicode-cldr-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-tlexpected-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-siphash-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-blake2-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-md4-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-md5-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-sha1-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-sha3-endian-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-sha3-keccak-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-rfc6234-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-tinycbor-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-qeventdispatcher-cf-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-doubleconversion-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-easing-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-forkfd-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-3rdparty-sources-Core-Attribution-tika-mimetypes-b9a83120e846
Relationship: SPDXRef-Package-qtbase-qt-module-Core-b9a83120e846 DEPENDS_ON SPDXRef-Package-qtbase-qt-bundled-3rdparty-module-BundledPcre2-b9a83120e846
"
        )
