
        list(APPEND QT_SBOM_PACKAGES "SPDXRef-Package-qtdeclarative-qt-3rdparty-sources-Qml-Attribution-masm-b812a27e4d8e")
        set("QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtdeclarative-qt-3rdparty-sources-Qml-Attribution-masm-b812a27e4d8e" false)

        file(APPEND "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/qt_sbom/staging-qtdeclarative.spdx.in"
"
PackageName: Qml_Attribution_masm
SPDXID: SPDXRef-Package-qtdeclarative-qt-3rdparty-sources-Qml-Attribution-masm-b812a27e4d8e
PackageDownloadLocation: https://trac.webkit.org/wiki/JavaScriptCore
PackageVersion: unknown
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: BSD-2-Clause
PackageLicenseDeclared: NOASSERTION
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtdeclarative@4e3399c26e?library_name=Qml_Attribution_masm
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtdeclarative-Qml_Attribution_masm@4e3399c26e?vcs_url=https://code.qt.io/qt/qtdeclarative.git@4e3399c26e&library_name=Qml_Attribution_masm
PackageCopyrightText: <text>Copyright (C) 2003-2018 Apple Inc. All rights reserved.
Copyright (C) 2007 Justin Haygood (jhaygood@reaktix.com)
Copyright (C) 2007-2009 Torch Mobile, Inc. All rights reserved. (http://www.torchmobile.com/)
Copyright (C) 2009, 2010 University of Szeged
Copyright (C) 2009-2011 STMicroelectronics. All rights reserved.
Copyright (C) 2010 MIPS Technologies, Inc. All rights reserved.
Copyright (C) 2010 Peter Varga (pvarga@inf.u-szeged.hu), University of Szeged
Copyright (C) 2010 MIPS Technologies, Inc. All rights reserved.
Copyright (C) 2010, 2011 Research In Motion Limited. All rights reserved.
Copyright (C) 2011 Google Inc. All rights reserved.
Copyright (C) 2013 Samsung Electronics. All rights reserved.
Copyright (C) 2015 Cisco Systems, Inc. All rights reserved.
Copyright (c) 2002-2009 Vivek Thampi</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: Qml_Attribution_masm
    Information extracted from:
     /src_dir/qtdeclarative/src/3rdparty/masm/qt_attribution.json
    Entry index: 0
    Id: masm
    Name: JavaScriptCore Macro Assembler
    Qt usage: Used in Qt QML.
    License: BSD 2-clause \"Simplified\" License
    License file: LICENSE
</text>\${QT_SBOM_VERIFICATION_CODE_SPDXRef-Package-qtdeclarative-qt-3rdparty-sources-Qml-Attribution-masm-b812a27e4d8e}
FilesAnalyzed: \${QT_SBOM_PACKAGE_HAS_FILES_SPDXRef-Package-qtdeclarative-qt-3rdparty-sources-Qml-Attribution-masm-b812a27e4d8e}
Relationship: SPDXRef-Package-qtdeclarative-b812a27e4d8e CONTAINS SPDXRef-Package-qtdeclarative-qt-3rdparty-sources-Qml-Attribution-masm-b812a27e4d8e
"
        )
