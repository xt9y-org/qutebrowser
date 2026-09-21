# Copyright (C) 2024 The Qt Company Ltd.
# SPDX-License-Identifier: BSD-3-Clause

set(__standalone_parts_qt_packages_args
    QT_MODULE_PACKAGES
        QmlToolingSettingsPrivate
        QmlTypeRegistrarPrivate
        QmlIntegration
        Qml
        QmlModels
        QmlCore
        QmlNetwork
        QmlWorkerScript
        QmlMeta
        QmlLocalStorage
        QmlXmlListModel
        LabsSynchronizer
        LabsSettings
        LabsQmlModels
        LabsFolderListModel
        QmlCompiler
        QmlDomPrivate
        QmltcPrivate
        QmlFormatPrivate
        PacketProtocolPrivate
        QmlDebugPrivate

)
qt_internal_find_standalone_parts_qt_packages(__standalone_parts_qt_packages_args)
