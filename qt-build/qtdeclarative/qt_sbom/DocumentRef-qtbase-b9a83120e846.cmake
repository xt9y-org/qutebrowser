
        set(find_external_document "TRUE")
        set(document_search_paths "/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/qt_sbom;/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtdeclarative/qt_sbom;/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase/lib/cmake;$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX};/Users/felixjaschul/CLionProjects/qutebrowser/qt-build/qtbase")
        set(maybe_external_document_file_path "sbom/qtbase-6.11.2.spdx")
        set(sbom_format "SPDX_V2_TAG_VALUE")

        set(explicit_external_document_namespace "https://qt.io/spdxdocs/qtbase-6.11.2-host-darwin-arm64-target-macos-arm64-7f55961c-7c32-57a9-9b1e-25706f3d9a2c")
        set(explicit_external_document_sha1 "")

        # The helper functions below are used both during configure time and SBOM generation
        # time. During configure time, QT_GENERATE_SBOM is checked to return early gracefully,
        # to allow projects to skip SBOM generation.
        # During SBOM generation time, we need to ensure these functions run properly.
        # Backup the var instead of setting it directly, because some of the testing infrastructure
        # does checks of the variable at the end of sbom generation.
        set(backup_qt_generate_sbom "ON")
        set(QT_GENERATE_SBOM ON)
        if(find_external_document)
            _qt_internal_sbom_find_external_reference_document(document_file_path
                EXTERNAL_DOCUMENT_FILE_PATH "${maybe_external_document_file_path}"
                EXTERNAL_DOCUMENT_SEARCH_PATHS ${document_search_paths}
            )

            _qt_internal_sbom_parse_spdx_v2_document_namespace(
                EXTERNAL_DOCUMENT_FILE_PATH "${document_file_path}"
                SBOM_FORMAT "${sbom_format}"
                OUT_VAR_DOCUMENT_NAMESPACE ext_ns
            )

            file(SHA1 "${document_file_path}" ext_sha1)
        else()
            set(ext_ns "${explicit_external_document_namespace}")
            set(ext_sha1 "${explicit_external_document_sha1}")
        endif()
        set(QT_GENERATE_SBOM ${backup_qt_generate_sbom})

        string(APPEND QT_SBOM_EXTERNAL_DOC_REFS "
ExternalDocumentRef: DocumentRef-qtbase-b9a83120e846 ${ext_ns} SHA1: ${ext_sha1}")

        
