/****************************************************************************
** Meta object code from reading C++ file 'qssl.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.11.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../qt6/qtbase/src/network/ssl/qssl.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'qssl.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN4QSslE_t {};
} // unnamed namespace

template <> constexpr inline auto QSsl::qt_create_metaobjectdata<qt_meta_tag_ZN4QSslE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "QSsl",
        "KeyType",
        "PrivateKey",
        "PublicKey",
        "EncodingFormat",
        "Pem",
        "Der",
        "KeyAlgorithm",
        "Opaque",
        "Rsa",
        "Dsa",
        "Ec",
        "Dh",
        "MlDsa",
        "AlternativeNameEntryType",
        "EmailEntry",
        "DnsEntry",
        "IpAddressEntry",
        "SslProtocol",
        "TlsV1_0",
        "TlsV1_1",
        "TlsV1_2",
        "AnyProtocol",
        "SecureProtocols",
        "TlsV1_0OrLater",
        "TlsV1_1OrLater",
        "TlsV1_2OrLater",
        "DtlsV1_0",
        "DtlsV1_0OrLater",
        "DtlsV1_2",
        "DtlsV1_2OrLater",
        "TlsV1_3",
        "TlsV1_3OrLater",
        "UnknownProtocol",
        "SslOption",
        "SslOptionDisableEmptyFragments",
        "SslOptionDisableSessionTickets",
        "SslOptionDisableCompression",
        "SslOptionDisableServerNameIndication",
        "SslOptionDisableLegacyRenegotiation",
        "SslOptionDisableSessionSharing",
        "SslOptionDisableSessionPersistence",
        "SslOptionDisableServerCipherPreference",
        "AlertLevel",
        "Warning",
        "Fatal",
        "Unknown",
        "AlertType",
        "CloseNotify",
        "UnexpectedMessage",
        "BadRecordMac",
        "RecordOverflow",
        "DecompressionFailure",
        "HandshakeFailure",
        "NoCertificate",
        "BadCertificate",
        "UnsupportedCertificate",
        "CertificateRevoked",
        "CertificateExpired",
        "CertificateUnknown",
        "IllegalParameter",
        "UnknownCa",
        "AccessDenied",
        "DecodeError",
        "DecryptError",
        "ExportRestriction",
        "ProtocolVersion",
        "InsufficientSecurity",
        "InternalError",
        "InappropriateFallback",
        "UserCancelled",
        "NoRenegotiation",
        "MissingExtension",
        "UnsupportedExtension",
        "CertificateUnobtainable",
        "UnrecognizedName",
        "BadCertificateStatusResponse",
        "BadCertificateHashValue",
        "UnknownPskIdentity",
        "CertificateRequired",
        "NoApplicationProtocol",
        "UnknownAlertMessage",
        "ImplementedClass",
        "Key",
        "Certificate",
        "Socket",
        "DiffieHellman",
        "EllipticCurve",
        "Dtls",
        "DtlsCookie",
        "SupportedFeature",
        "CertificateVerification",
        "ClientSideAlpn",
        "ServerSideAlpn",
        "Ocsp",
        "Psk",
        "SessionTicket",
        "Alerts"
    };

    QtMocHelpers::UintData qt_methods {
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
        // enum 'KeyType'
        QtMocHelpers::EnumData<KeyType>(1, 1, QMC::EnumFlags{}).add({
            {    2, KeyType::PrivateKey },
            {    3, KeyType::PublicKey },
        }),
        // enum 'EncodingFormat'
        QtMocHelpers::EnumData<EncodingFormat>(4, 4, QMC::EnumFlags{}).add({
            {    5, EncodingFormat::Pem },
            {    6, EncodingFormat::Der },
        }),
        // enum 'KeyAlgorithm'
        QtMocHelpers::EnumData<KeyAlgorithm>(7, 7, QMC::EnumFlags{}).add({
            {    8, KeyAlgorithm::Opaque },
            {    9, KeyAlgorithm::Rsa },
            {   10, KeyAlgorithm::Dsa },
            {   11, KeyAlgorithm::Ec },
            {   12, KeyAlgorithm::Dh },
            {   13, KeyAlgorithm::MlDsa },
        }),
        // enum 'AlternativeNameEntryType'
        QtMocHelpers::EnumData<AlternativeNameEntryType>(14, 14, QMC::EnumFlags{}).add({
            {   15, AlternativeNameEntryType::EmailEntry },
            {   16, AlternativeNameEntryType::DnsEntry },
            {   17, AlternativeNameEntryType::IpAddressEntry },
        }),
        // enum 'SslProtocol'
        QtMocHelpers::EnumData<SslProtocol>(18, 18, QMC::EnumFlags{}).add({
            {   19, SslProtocol::TlsV1_0 },
            {   20, SslProtocol::TlsV1_1 },
            {   21, SslProtocol::TlsV1_2 },
            {   22, SslProtocol::AnyProtocol },
            {   23, SslProtocol::SecureProtocols },
            {   24, SslProtocol::TlsV1_0OrLater },
            {   25, SslProtocol::TlsV1_1OrLater },
            {   26, SslProtocol::TlsV1_2OrLater },
            {   27, SslProtocol::DtlsV1_0 },
            {   28, SslProtocol::DtlsV1_0OrLater },
            {   29, SslProtocol::DtlsV1_2 },
            {   30, SslProtocol::DtlsV1_2OrLater },
            {   31, SslProtocol::TlsV1_3 },
            {   32, SslProtocol::TlsV1_3OrLater },
            {   33, SslProtocol::UnknownProtocol },
        }),
        // enum 'SslOption'
        QtMocHelpers::EnumData<SslOption>(34, 34, QMC::EnumFlags{}).add({
            {   35, SslOption::SslOptionDisableEmptyFragments },
            {   36, SslOption::SslOptionDisableSessionTickets },
            {   37, SslOption::SslOptionDisableCompression },
            {   38, SslOption::SslOptionDisableServerNameIndication },
            {   39, SslOption::SslOptionDisableLegacyRenegotiation },
            {   40, SslOption::SslOptionDisableSessionSharing },
            {   41, SslOption::SslOptionDisableSessionPersistence },
            {   42, SslOption::SslOptionDisableServerCipherPreference },
        }),
        // enum 'AlertLevel'
        QtMocHelpers::EnumData<AlertLevel>(43, 43, QMC::EnumIsScoped).add({
            {   44, AlertLevel::Warning },
            {   45, AlertLevel::Fatal },
            {   46, AlertLevel::Unknown },
        }),
        // enum 'AlertType'
        QtMocHelpers::EnumData<AlertType>(47, 47, QMC::EnumIsScoped).add({
            {   48, AlertType::CloseNotify },
            {   49, AlertType::UnexpectedMessage },
            {   50, AlertType::BadRecordMac },
            {   51, AlertType::RecordOverflow },
            {   52, AlertType::DecompressionFailure },
            {   53, AlertType::HandshakeFailure },
            {   54, AlertType::NoCertificate },
            {   55, AlertType::BadCertificate },
            {   56, AlertType::UnsupportedCertificate },
            {   57, AlertType::CertificateRevoked },
            {   58, AlertType::CertificateExpired },
            {   59, AlertType::CertificateUnknown },
            {   60, AlertType::IllegalParameter },
            {   61, AlertType::UnknownCa },
            {   62, AlertType::AccessDenied },
            {   63, AlertType::DecodeError },
            {   64, AlertType::DecryptError },
            {   65, AlertType::ExportRestriction },
            {   66, AlertType::ProtocolVersion },
            {   67, AlertType::InsufficientSecurity },
            {   68, AlertType::InternalError },
            {   69, AlertType::InappropriateFallback },
            {   70, AlertType::UserCancelled },
            {   71, AlertType::NoRenegotiation },
            {   72, AlertType::MissingExtension },
            {   73, AlertType::UnsupportedExtension },
            {   74, AlertType::CertificateUnobtainable },
            {   75, AlertType::UnrecognizedName },
            {   76, AlertType::BadCertificateStatusResponse },
            {   77, AlertType::BadCertificateHashValue },
            {   78, AlertType::UnknownPskIdentity },
            {   79, AlertType::CertificateRequired },
            {   80, AlertType::NoApplicationProtocol },
            {   81, AlertType::UnknownAlertMessage },
        }),
        // enum 'ImplementedClass'
        QtMocHelpers::EnumData<ImplementedClass>(82, 82, QMC::EnumIsScoped).add({
            {   83, ImplementedClass::Key },
            {   84, ImplementedClass::Certificate },
            {   85, ImplementedClass::Socket },
            {   86, ImplementedClass::DiffieHellman },
            {   87, ImplementedClass::EllipticCurve },
            {   88, ImplementedClass::Dtls },
            {   89, ImplementedClass::DtlsCookie },
        }),
        // enum 'SupportedFeature'
        QtMocHelpers::EnumData<SupportedFeature>(90, 90, QMC::EnumIsScoped).add({
            {   91, SupportedFeature::CertificateVerification },
            {   92, SupportedFeature::ClientSideAlpn },
            {   93, SupportedFeature::ServerSideAlpn },
            {   94, SupportedFeature::Ocsp },
            {   95, SupportedFeature::Psk },
            {   96, SupportedFeature::SessionTicket },
            {   97, SupportedFeature::Alerts },
        }),
    };
    return QtMocHelpers::metaObjectData<void, qt_meta_tag_ZN4QSslE_t>(QMC::PropertyAccessInStaticMetaCall, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}

static constexpr auto qt_staticMetaObjectContent_ZN4QSslE =
    QSsl::qt_create_metaobjectdata<qt_meta_tag_ZN4QSslE_t>();
static constexpr auto qt_staticMetaObjectStaticContent_ZN4QSslE =
    qt_staticMetaObjectContent_ZN4QSslE.staticData;
static constexpr auto qt_staticMetaObjectRelocatingContent_ZN4QSslE =
    qt_staticMetaObjectContent_ZN4QSslE.relocatingData;

Q_CONSTINIT const QMetaObject QSsl::staticMetaObject = { {
    nullptr,
    qt_staticMetaObjectStaticContent_ZN4QSslE.stringdata,
    qt_staticMetaObjectStaticContent_ZN4QSslE.data,
    nullptr,
    nullptr,
    qt_staticMetaObjectRelocatingContent_ZN4QSslE.metaTypes,
    nullptr
} };

QT_WARNING_POP
