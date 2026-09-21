/****************************************************************************
** Meta object code from reading C++ file 'qiooperation_p.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.11.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../qt6/qtbase/src/corelib/io/qiooperation_p.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'qiooperation_p.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN12QIOOperationE_t {};
} // unnamed namespace

template <> constexpr inline auto QIOOperation::qt_create_metaobjectdata<qt_meta_tag_ZN12QIOOperationE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "QIOOperation",
        "finished",
        "",
        "errorOccurred",
        "Error",
        "err",
        "None",
        "FileNotOpen",
        "IncorrectOffset",
        "Read",
        "Write",
        "Flush",
        "Open",
        "Aborted",
        "Type",
        "Unknown"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'finished'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'errorOccurred'
        QtMocHelpers::SignalData<void(enum Error)>(3, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 4, 5 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
        // enum 'Error'
        QtMocHelpers::EnumData<enum Error>(4, 4, QMC::EnumIsScoped).add({
            {    6, Error::None },
            {    7, Error::FileNotOpen },
            {    8, Error::IncorrectOffset },
            {    9, Error::Read },
            {   10, Error::Write },
            {   11, Error::Flush },
            {   12, Error::Open },
            {   13, Error::Aborted },
        }),
        // enum 'Type'
        QtMocHelpers::EnumData<enum Type>(14, 14, QMC::EnumIsScoped).add({
            {   15, Type::Unknown },
            {    9, Type::Read },
            {   10, Type::Write },
            {   11, Type::Flush },
            {   12, Type::Open },
        }),
    };
    return QtMocHelpers::metaObjectData<QIOOperation, qt_meta_tag_ZN12QIOOperationE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject QIOOperation::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12QIOOperationE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12QIOOperationE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN12QIOOperationE_t>.metaTypes,
    nullptr
} };

void QIOOperation::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<QIOOperation *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->finished(); break;
        case 1: _t->errorOccurred((*reinterpret_cast<std::add_pointer_t<enum Error>>(_a[1]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (QIOOperation::*)()>(_a, &QIOOperation::finished, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (QIOOperation::*)(Error )>(_a, &QIOOperation::errorOccurred, 1))
            return;
    }
}

const QMetaObject *QIOOperation::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *QIOOperation::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12QIOOperationE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int QIOOperation::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 2)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 2;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 2)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 2;
    }
    return _id;
}

// SIGNAL 0
void QIOOperation::finished()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void QIOOperation::errorOccurred(Error _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 1, nullptr, _t1);
}
QT_WARNING_POP
