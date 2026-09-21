
        cmake_minimum_required(VERSION 3.16)
        message(STATUS "Starting SPDX SBOM generation in build dir: /Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in")
        
        set(QT_SBOM_EXTERNAL_DOC_REFS "")

        file(READ "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/SPDXRef-DOCUMENT-qtbase.spdx.in" content)
        # Override any previous file because we're starting from scratch.
        file(WRITE "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom/staging-qtbase.spdx.in" "${content}")
