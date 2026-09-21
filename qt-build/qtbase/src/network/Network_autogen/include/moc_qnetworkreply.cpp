/****************************************************************************
** Meta object code from reading C++ file 'qnetworkreply.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.11.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../qt6/qtbase/src/network/access/qnetworkreply.h"
#include <QtNetwork/QSslError>
#include <QtCore/qmetatype.h>
#include <QtCore/QList>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'qnetworkreply.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN13QNetworkReplyE_t {};
} // unnamed namespace

template <> constexpr inline auto QNetworkReply::qt_create_metaobjectdata<qt_meta_tag_ZN13QNetworkReplyE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "QNetworkReply",
        "socketStartedConnecting",
        "",
        "requestSent",
        "metaDataChanged",
        "finished",
        "errorOccurred",
        "QNetworkReply::NetworkError",
        "encrypted",
        "sslErrors",
        "QList<QSslError>",
        "errors",
        "preSharedKeyAuthenticationRequired",
        "QSslPreSharedKeyAuthenticator*",
        "authenticator",
        "redirected",
        "QUrl",
        "url",
        "redirectAllowed",
        "uploadProgress",
        "bytesSent",
        "bytesTotal",
        "downloadProgress",
        "bytesReceived",
        "abort",
        "ignoreSslErrors",
        "NetworkError",
        "NoError",
        "ConnectionRefusedError",
        "RemoteHostClosedError",
        "HostNotFoundError",
        "TimeoutError",
        "OperationCanceledError",
        "SslHandshakeFailedError",
        "TemporaryNetworkFailureError",
        "NetworkSessionFailedError",
        "BackgroundRequestNotAllowedError",
        "TooManyRedirectsError",
        "InsecureRedirectError",
        "UnknownNetworkError",
        "ProxyConnectionRefusedError",
        "ProxyConnectionClosedError",
        "ProxyNotFoundError",
        "ProxyTimeoutError",
        "ProxyAuthenticationRequiredError",
        "UnknownProxyError",
        "ContentAccessDenied",
        "ContentOperationNotPermittedError",
        "ContentNotFoundError",
        "AuthenticationRequiredError",
        "ContentReSendError",
        "ContentConflictError",
        "ContentGoneError",
        "UnknownContentError",
        "ProtocolUnknownError",
        "ProtocolInvalidOperationError",
        "ProtocolFailure",
        "InternalServerError",
        "OperationNotImplementedError",
        "ServiceUnavailableError",
        "UnknownServerError"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'socketStartedConnecting'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'requestSent'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'metaDataChanged'
        QtMocHelpers::SignalData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'finished'
        QtMocHelpers::SignalData<void()>(5, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'errorOccurred'
        QtMocHelpers::SignalData<void(QNetworkReply::NetworkError)>(6, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 7, 2 },
        }}),
        // Signal 'encrypted'
        QtMocHelpers::SignalData<void()>(8, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'sslErrors'
        QtMocHelpers::SignalData<void(const QList<QSslError> &)>(9, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 10, 11 },
        }}),
        // Signal 'preSharedKeyAuthenticationRequired'
        QtMocHelpers::SignalData<void(QSslPreSharedKeyAuthenticator *)>(12, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 13, 14 },
        }}),
        // Signal 'redirected'
        QtMocHelpers::SignalData<void(const QUrl &)>(15, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 16, 17 },
        }}),
        // Signal 'redirectAllowed'
        QtMocHelpers::SignalData<void()>(18, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'uploadProgress'
        QtMocHelpers::SignalData<void(qint64, qint64)>(19, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::LongLong, 20 }, { QMetaType::LongLong, 21 },
        }}),
        // Signal 'downloadProgress'
        QtMocHelpers::SignalData<void(qint64, qint64)>(22, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::LongLong, 23 }, { QMetaType::LongLong, 21 },
        }}),
        // Slot 'abort'
        QtMocHelpers::SlotData<void()>(24, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'ignoreSslErrors'
        QtMocHelpers::SlotData<void()>(25, 2, QMC::AccessPublic, QMetaType::Void),
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
        // enum 'NetworkError'
        QtMocHelpers::EnumData<enum NetworkError>(26, 26, QMC::EnumFlags{}).add({
            {   27, NetworkError::NoError },
            {   28, NetworkError::ConnectionRefusedError },
            {   29, NetworkError::RemoteHostClosedError },
            {   30, NetworkError::HostNotFoundError },
            {   31, NetworkError::TimeoutError },
            {   32, NetworkError::OperationCanceledError },
            {   33, NetworkError::SslHandshakeFailedError },
            {   34, NetworkError::TemporaryNetworkFailureError },
            {   35, NetworkError::NetworkSessionFailedError },
            {   36, NetworkError::BackgroundRequestNotAllowedError },
            {   37, NetworkError::TooManyRedirectsError },
            {   38, NetworkError::InsecureRedirectError },
            {   39, NetworkError::UnknownNetworkError },
            {   40, NetworkError::ProxyConnectionRefusedError },
            {   41, NetworkError::ProxyConnectionClosedError },
            {   42, NetworkError::ProxyNotFoundError },
            {   43, NetworkError::ProxyTimeoutError },
            {   44, NetworkError::ProxyAuthenticationRequiredError },
            {   45, NetworkError::UnknownProxyError },
            {   46, NetworkError::ContentAccessDenied },
            {   47, NetworkError::ContentOperationNotPermittedError },
            {   48, NetworkError::ContentNotFoundError },
            {   49, NetworkError::AuthenticationRequiredError },
            {   50, NetworkError::ContentReSendError },
            {   51, NetworkError::ContentConflictError },
            {   52, NetworkError::ContentGoneError },
            {   53, NetworkError::UnknownContentError },
            {   54, NetworkError::ProtocolUnknownError },
            {   55, NetworkError::ProtocolInvalidOperationError },
            {   56, NetworkError::ProtocolFailure },
            {   57, NetworkError::InternalServerError },
            {   58, NetworkError::OperationNotImplementedError },
            {   59, NetworkError::ServiceUnavailableError },
            {   60, NetworkError::UnknownServerError },
        }),
    };
    return QtMocHelpers::metaObjectData<QNetworkReply, qt_meta_tag_ZN13QNetworkReplyE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject QNetworkReply::staticMetaObject = { {
    QMetaObject::SuperData::link<QIODevice::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN13QNetworkReplyE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN13QNetworkReplyE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN13QNetworkReplyE_t>.metaTypes,
    nullptr
} };

void QNetworkReply::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<QNetworkReply *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->socketStartedConnecting(); break;
        case 1: _t->requestSent(); break;
        case 2: _t->metaDataChanged(); break;
        case 3: _t->finished(); break;
        case 4: _t->errorOccurred((*reinterpret_cast<std::add_pointer_t<QNetworkReply::NetworkError>>(_a[1]))); break;
        case 5: _t->encrypted(); break;
        case 6: _t->sslErrors((*reinterpret_cast<std::add_pointer_t<QList<QSslError>>>(_a[1]))); break;
        case 7: _t->preSharedKeyAuthenticationRequired((*reinterpret_cast<std::add_pointer_t<QSslPreSharedKeyAuthenticator*>>(_a[1]))); break;
        case 8: _t->redirected((*reinterpret_cast<std::add_pointer_t<QUrl>>(_a[1]))); break;
        case 9: _t->redirectAllowed(); break;
        case 10: _t->uploadProgress((*reinterpret_cast<std::add_pointer_t<qint64>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<qint64>>(_a[2]))); break;
        case 11: _t->downloadProgress((*reinterpret_cast<std::add_pointer_t<qint64>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<qint64>>(_a[2]))); break;
        case 12: _t->abort(); break;
        case 13: _t->ignoreSslErrors(); break;
        default: ;
        }
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
        case 4:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 0:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< QNetworkReply::NetworkError >(); break;
            }
            break;
        case 6:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 0:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< QList<QSslError> >(); break;
            }
            break;
        case 7:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 0:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< QSslPreSharedKeyAuthenticator* >(); break;
            }
            break;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (QNetworkReply::*)()>(_a, &QNetworkReply::socketStartedConnecting, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (QNetworkReply::*)()>(_a, &QNetworkReply::requestSent, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (QNetworkReply::*)()>(_a, &QNetworkReply::metaDataChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (QNetworkReply::*)()>(_a, &QNetworkReply::finished, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (QNetworkReply::*)(QNetworkReply::NetworkError )>(_a, &QNetworkReply::errorOccurred, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (QNetworkReply::*)()>(_a, &QNetworkReply::encrypted, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (QNetworkReply::*)(const QList<QSslError> & )>(_a, &QNetworkReply::sslErrors, 6))
            return;
        if (QtMocHelpers::indexOfMethod<void (QNetworkReply::*)(QSslPreSharedKeyAuthenticator * )>(_a, &QNetworkReply::preSharedKeyAuthenticationRequired, 7))
            return;
        if (QtMocHelpers::indexOfMethod<void (QNetworkReply::*)(const QUrl & )>(_a, &QNetworkReply::redirected, 8))
            return;
        if (QtMocHelpers::indexOfMethod<void (QNetworkReply::*)()>(_a, &QNetworkReply::redirectAllowed, 9))
            return;
        if (QtMocHelpers::indexOfMethod<void (QNetworkReply::*)(qint64 , qint64 )>(_a, &QNetworkReply::uploadProgress, 10))
            return;
        if (QtMocHelpers::indexOfMethod<void (QNetworkReply::*)(qint64 , qint64 )>(_a, &QNetworkReply::downloadProgress, 11))
            return;
    }
}

const QMetaObject *QNetworkReply::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *QNetworkReply::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN13QNetworkReplyE_t>.strings))
        return static_cast<void*>(this);
    return QIODevice::qt_metacast(_clname);
}

int QNetworkReply::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QIODevice::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 14)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 14;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 14)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 14;
    }
    return _id;
}

// SIGNAL 0
void QNetworkReply::socketStartedConnecting()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void QNetworkReply::requestSent()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void QNetworkReply::metaDataChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void QNetworkReply::finished()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void QNetworkReply::errorOccurred(QNetworkReply::NetworkError _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 4, nullptr, _t1);
}

// SIGNAL 5
void QNetworkReply::encrypted()
{
    QMetaObject::activate(this, &staticMetaObject, 5, nullptr);
}

// SIGNAL 6
void QNetworkReply::sslErrors(const QList<QSslError> & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 6, nullptr, _t1);
}

// SIGNAL 7
void QNetworkReply::preSharedKeyAuthenticationRequired(QSslPreSharedKeyAuthenticator * _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 7, nullptr, _t1);
}

// SIGNAL 8
void QNetworkReply::redirected(const QUrl & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 8, nullptr, _t1);
}

// SIGNAL 9
void QNetworkReply::redirectAllowed()
{
    QMetaObject::activate(this, &staticMetaObject, 9, nullptr);
}

// SIGNAL 10
void QNetworkReply::uploadProgress(qint64 _t1, qint64 _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 10, nullptr, _t1, _t2);
}

// SIGNAL 11
void QNetworkReply::downloadProgress(qint64 _t1, qint64 _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 11, nullptr, _t1, _t2);
}
QT_WARNING_POP
