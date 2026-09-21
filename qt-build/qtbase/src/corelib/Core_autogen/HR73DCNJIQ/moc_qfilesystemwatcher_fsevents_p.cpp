/****************************************************************************
** Meta object code from reading C++ file 'qfilesystemwatcher_fsevents_p.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.11.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../qt6/qtbase/src/corelib/io/qfilesystemwatcher_fsevents_p.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'qfilesystemwatcher_fsevents_p.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 69
#error "This file was generated using the moc from 6.11.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN32QFseventsFileSystemWatcherEngineE_t {};
} // unnamed namespace

template <> constexpr inline auto QFseventsFileSystemWatcherEngine::qt_create_metaobjectdata<qt_meta_tag_ZN32QFseventsFileSystemWatcherEngineE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "QFseventsFileSystemWatcherEngine",
        "emitFileChanged",
        "",
        "path",
        "removed",
        "emitDirectoryChanged",
        "scheduleStreamRestart",
        "doEmitFileChanged",
        "doEmitDirectoryChanged",
        "restartStream"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'emitFileChanged'
        QtMocHelpers::SignalData<void(const QString &, bool)>(1, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 3 }, { QMetaType::Bool, 4 },
        }}),
        // Signal 'emitDirectoryChanged'
        QtMocHelpers::SignalData<void(const QString &, bool)>(5, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 3 }, { QMetaType::Bool, 4 },
        }}),
        // Signal 'scheduleStreamRestart'
        QtMocHelpers::SignalData<void()>(6, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'doEmitFileChanged'
        QtMocHelpers::SlotData<void(const QString &, bool)>(7, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { QMetaType::QString, 3 }, { QMetaType::Bool, 4 },
        }}),
        // Slot 'doEmitDirectoryChanged'
        QtMocHelpers::SlotData<void(const QString &, bool)>(8, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { QMetaType::QString, 3 }, { QMetaType::Bool, 4 },
        }}),
        // Slot 'restartStream'
        QtMocHelpers::SlotData<bool()>(9, 2, QMC::AccessPrivate, QMetaType::Bool),
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<QFseventsFileSystemWatcherEngine, qt_meta_tag_ZN32QFseventsFileSystemWatcherEngineE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject QFseventsFileSystemWatcherEngine::staticMetaObject = { {
    QMetaObject::SuperData::link<QFileSystemWatcherEngine::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN32QFseventsFileSystemWatcherEngineE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN32QFseventsFileSystemWatcherEngineE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN32QFseventsFileSystemWatcherEngineE_t>.metaTypes,
    nullptr
} };

void QFseventsFileSystemWatcherEngine::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<QFseventsFileSystemWatcherEngine *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->emitFileChanged((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<bool>>(_a[2]))); break;
        case 1: _t->emitDirectoryChanged((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<bool>>(_a[2]))); break;
        case 2: _t->scheduleStreamRestart(); break;
        case 3: _t->doEmitFileChanged((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<bool>>(_a[2]))); break;
        case 4: _t->doEmitDirectoryChanged((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<bool>>(_a[2]))); break;
        case 5: { bool _r = _t->restartStream();
            if (_a[0]) *reinterpret_cast<bool*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (QFseventsFileSystemWatcherEngine::*)(const QString & , bool )>(_a, &QFseventsFileSystemWatcherEngine::emitFileChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (QFseventsFileSystemWatcherEngine::*)(const QString & , bool )>(_a, &QFseventsFileSystemWatcherEngine::emitDirectoryChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (QFseventsFileSystemWatcherEngine::*)()>(_a, &QFseventsFileSystemWatcherEngine::scheduleStreamRestart, 2))
            return;
    }
}

const QMetaObject *QFseventsFileSystemWatcherEngine::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *QFseventsFileSystemWatcherEngine::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN32QFseventsFileSystemWatcherEngineE_t>.strings))
        return static_cast<void*>(this);
    return QFileSystemWatcherEngine::qt_metacast(_clname);
}

int QFseventsFileSystemWatcherEngine::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QFileSystemWatcherEngine::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 6)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 6)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 6;
    }
    return _id;
}

// SIGNAL 0
void QFseventsFileSystemWatcherEngine::emitFileChanged(const QString & _t1, bool _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 0, nullptr, _t1, _t2);
}

// SIGNAL 1
void QFseventsFileSystemWatcherEngine::emitDirectoryChanged(const QString & _t1, bool _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 1, nullptr, _t1, _t2);
}

// SIGNAL 2
void QFseventsFileSystemWatcherEngine::scheduleStreamRestart()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}
QT_WARNING_POP
