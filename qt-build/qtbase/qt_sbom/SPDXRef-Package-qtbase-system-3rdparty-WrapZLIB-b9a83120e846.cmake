
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-system-3rdparty-WrapZLIB-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-system-3rdparty-WrapZLIB-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: WrapZLIB
SPDXID: SPDXRef-Package-qtbase-system-3rdparty-WrapZLIB-b9a83120e846
PackageDownloadLocation: https://github.com/madler/zlib
PackageVersion: 1.2.12
PackageSupplier: Person: Anonymous
PackageLicenseConcluded: NOASSERTION
PackageLicenseDeclared: NOASSERTION
PackageCopyrightText: NOASSERTION
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: WrapZLIB::WrapZLIB
</text>
ExternalRef: SECURITY cpe23Type cpe:2.3:a:zlib:zlib:1.2.12:*:*:*:*:*:*:*\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-system-3rdparty-WrapZLIB-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-system-3rdparty-WrapZLIB-b9a83120e846}

"
        )
