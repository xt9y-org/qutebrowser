/****************************************************************************
** Meta object code from reading C++ file 'qrangemodel.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.11.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../qt6/qtbase/src/corelib/itemmodels/qrangemodel.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'qrangemodel.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN11QRangeModelE_t {};
} // unnamed namespace

template <> constexpr inline auto QRangeModel::qt_create_metaobjectdata<qt_meta_tag_ZN11QRangeModelE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "QRangeModel",
        "RegisterEnumClassesUnscoped",
        "false",
        "roleNamesChanged",
        "",
        "autoConnectPolicyChanged",
        "AutoConnectPolicy",
        "policy",
        "resetInternalData",
        "roleNames",
        "QHash<int,QByteArray>",
        "autoConnectPolicy",
        "None",
        "Full",
        "OnRead"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'roleNamesChanged'
        QtMocHelpers::SignalData<void()>(3, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'autoConnectPolicyChanged'
        QtMocHelpers::RevisionedSignalData<void(enum AutoConnectPolicy)>(5, 4, QMC::AccessPublic, 0x60b, QMetaType::Void, {{
            { 0x80000000 | 6, 7 },
        }}),
        // Slot 'resetInternalData'
        QtMocHelpers::SlotData<void()>(8, 4, QMC::AccessProtected, QMetaType::Void),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'roleNames'
        QtMocHelpers::PropertyData<QHash<int,QByteArray>>(9, 0x80000000 | 10, QMC::DefaultPropertyFlags | QMC::Writable | QMC::Resettable | QMC::EnumOrFlag | QMC::StdCppSet | QMC::Final, 0),
        // property 'autoConnectPolicy'
        QtMocHelpers::PropertyData<enum AutoConnectPolicy>(11, 0x80000000 | 6, QMC::DefaultPropertyFlags | QMC::Writable | QMC::EnumOrFlag | QMC::StdCppSet, 1, 0x60b),
    };
    QtMocHelpers::UintData qt_enums {
        // enum 'AutoConnectPolicy'
        QtMocHelpers::EnumData<enum AutoConnectPolicy>(6, 6, QMC::EnumIsScoped).add({
            {   12, AutoConnectPolicy::None },
            {   13, AutoConnectPolicy::Full },
            {   14, AutoConnectPolicy::OnRead },
        }),
    };
    QtMocHelpers::UintData qt_constructors {};
    QtMocHelpers::ClassInfos qt_classinfo({
            {    1,    2 },
    });
    return QtMocHelpers::metaObjectData<QRangeModel, qt_meta_tag_ZN11QRangeModelE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums, qt_constructors, qt_classinfo);
}
Q_CONSTINIT const QMetaObject QRangeModel::staticMetaObject = { {
    QMetaObject::SuperData::link<QAbstractItemModel::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN11QRangeModelE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN11QRangeModelE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN11QRangeModelE_t>.metaTypes,
    nullptr
} };

void QRangeModel::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<QRangeModel *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->roleNamesChanged(); break;
        case 1: _t->autoConnectPolicyChanged((*reinterpret_cast<std::add_pointer_t<enum AutoConnectPolicy>>(_a[1]))); break;
        case 2: _t->resetInternalData(); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (QRangeModel::*)()>(_a, &QRangeModel::roleNamesChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (QRangeModel::*)(AutoConnectPolicy )>(_a, &QRangeModel::autoConnectPolicyChanged, 1))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QHash<int,QByteArray>*>(_v) = _t->roleNames(); break;
        case 1: *reinterpret_cast<enum AutoConnectPolicy*>(_v) = _t->autoConnectPolicy(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setRoleNames(*reinterpret_cast<QHash<int,QByteArray>*>(_v)); break;
        case 1: _t->setAutoConnectPolicy(*reinterpret_cast<enum AutoConnectPolicy*>(_v)); break;
        default: break;
        }
    }
    if (_c == QMetaObject::ResetProperty) {
        switch (_id) {
        case 0: _t->resetRoleNames(); break;
        default: break;
        }
    }
}

const QMetaObject *QRangeModel::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *QRangeModel::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN11QRangeModelE_t>.strings))
        return static_cast<void*>(this);
    return QAbstractItemModel::qt_metacast(_clname);
}

int QRangeModel::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QAbstractItemModel::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 3)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 3;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 3)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 3;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 2;
    }
    return _id;
}

// SIGNAL 0
void QRangeModel::roleNamesChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void QRangeModel::autoConnectPolicyChanged(AutoConnectPolicy _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 1, nullptr, _t1);
}
QT_WARNING_POP
