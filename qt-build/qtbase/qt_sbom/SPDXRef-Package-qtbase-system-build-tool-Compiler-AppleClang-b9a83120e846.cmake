
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtbase-system-build-tool-Compiler-AppleClang-b9a83120e846")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-system-build-tool-Compiler-AppleClang-b9a83120e846" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in"
"
PackageName: Compiler AppleClang
SPDXID: SPDXRef-Package-qtbase-system-build-tool-Compiler-AppleClang-b9a83120e846
PackageDownloadLocation: NOASSERTION
PackageVersion: 21.0.0.21000334
PackageSupplier: Person: Anonymous
PackageLicenseConcluded: NOASSERTION
PackageLicenseDeclared: NOASSERTION
PackageCopyrightText: NOASSERTION
PackageSummary: <text>The compiler as identified by CMake, running on 'Darwin' (arm64)</text>
PrimaryPackagePurpose: OTHER
PackageComment: <text>
CMake target name: qtbaseSbomBuildToolCompiler
</text>\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtbase-system-build-tool-Compiler-AppleClang-b9a83120e846}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtbase-system-build-tool-Compiler-AppleClang-b9a83120e846}

"
        )
