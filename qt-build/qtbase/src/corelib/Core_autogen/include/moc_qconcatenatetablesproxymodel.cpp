/****************************************************************************
** Meta object code from reading C++ file 'qconcatenatetablesproxymodel.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.11.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../qt6/qtbase/src/corelib/itemmodels/qconcatenatetablesproxymodel.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'qconcatenatetablesproxymodel.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN28QConcatenateTablesProxyModelE_t {};
} // unnamed namespace

template <> constexpr inline auto QConcatenateTablesProxyModel::qt_create_metaobjectdata<qt_meta_tag_ZN28QConcatenateTablesProxyModelE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "QConcatenateTablesProxyModel",
        "addSourceModel",
        "",
        "QAbstractItemModel*",
        "sourceModel",
        "removeSourceModel",
        "mapFromSource",
        "QModelIndex",
        "sourceIndex",
        "mapToSource",
        "proxyIndex"
    };

    QtMocHelpers::UintData qt_methods {
        // Method 'addSourceModel'
        QtMocHelpers::MethodData<void(QAbstractItemModel *)>(1, 2, QMC::AccessPublic | QMC::MethodScriptable, QMetaType::Void, {{
            { 0x80000000 | 3, 4 },
        }}),
        // Method 'removeSourceModel'
        QtMocHelpers::MethodData<void(QAbstractItemModel *)>(5, 2, QMC::AccessPublic | QMC::MethodScriptable, QMetaType::Void, {{
            { 0x80000000 | 3, 4 },
        }}),
        // Method 'mapFromSource'
        QtMocHelpers::RevisionedMethodData<QModelIndex(const QModelIndex &) const>(6, 2, QMC::AccessPublic, 0x60b, 0x80000000 | 7, {{
            { 0x80000000 | 7, 8 },
        }}),
        // Method 'mapToSource'
        QtMocHelpers::RevisionedMethodData<QModelIndex(const QModelIndex &) const>(9, 2, QMC::AccessPublic, 0x60b, 0x80000000 | 7, {{
            { 0x80000000 | 7, 10 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<QConcatenateTablesProxyModel, qt_meta_tag_ZN28QConcatenateTablesProxyModelE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject QConcatenateTablesProxyModel::staticMetaObject = { {
    QMetaObject::SuperData::link<QAbstractItemModel::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN28QConcatenateTablesProxyModelE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN28QConcatenateTablesProxyModelE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN28QConcatenateTablesProxyModelE_t>.metaTypes,
    nullptr
} };

void QConcatenateTablesProxyModel::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<QConcatenateTablesProxyModel *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->addSourceModel((*reinterpret_cast<std::add_pointer_t<QAbstractItemModel*>>(_a[1]))); break;
        case 1: _t->removeSourceModel((*reinterpret_cast<std::add_pointer_t<QAbstractItemModel*>>(_a[1]))); break;
        case 2: { QModelIndex _r = _t->mapFromSource((*reinterpret_cast<std::add_pointer_t<QModelIndex>>(_a[1])));
            if (_a[0]) *reinterpret_cast<QModelIndex*>(_a[0]) = std::move(_r); }  break;
        case 3: { QModelIndex _r = _t->mapToSource((*reinterpret_cast<std::add_pointer_t<QModelIndex>>(_a[1])));
            if (_a[0]) *reinterpret_cast<QModelIndex*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
        case 0:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 0:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< QAbstractItemModel* >(); break;
            }
            break;
        case 1:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 0:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< QAbstractItemModel* >(); break;
            }
            break;
        }
    }
}

const QMetaObject *QConcatenateTablesProxyModel::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *QConcatenateTablesProxyModel::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN28QConcatenateTablesProxyModelE_t>.strings))
        return static_cast<void*>(this);
    return QAbstractItemModel::qt_metacast(_clname);
}

int QConcatenateTablesProxyModel::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QAbstractItemModel::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 4)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 4)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    }
    return _id;
}
QT_WARNING_POP
