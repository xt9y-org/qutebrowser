/****************************************************************************
** Meta object code from reading C++ file 'qdirlisting.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.11.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../qt6/qtbase/src/corelib/io/qdirlisting.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'qdirlisting.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN11QDirListingE_t {};
} // unnamed namespace

template <> constexpr inline auto QDirListing::qt_create_metaobjectdata<qt_meta_tag_ZN11QDirListingE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "QDirListing",
        "IteratorFlags",
        "IteratorFlag",
        "Default",
        "ExcludeFiles",
        "ExcludeDirs",
        "ExcludeSpecial",
        "ExcludeOther",
        "ResolveSymlinks",
        "FilesOnly",
        "DirsOnly",
        "IncludeHidden",
        "IncludeDotAndDotDot",
        "CaseSensitive",
        "Recursive",
        "FollowDirSymlinks",
        "IncludeBrokenSymlinks",
        "NoNameFiltersForDirs"
    };

    QtMocHelpers::UintData qt_methods {
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
        // flag 'IteratorFlags'
        QtMocHelpers::EnumData<IteratorFlags>(1, 2, QMC::EnumIsFlag | QMC::EnumIsScoped).add({
            {    3, IteratorFlag::Default },
            {    4, IteratorFlag::ExcludeFiles },
            {    5, IteratorFlag::ExcludeDirs },
            {    6, IteratorFlag::ExcludeSpecial },
            {    7, IteratorFlag::ExcludeOther },
            {    8, IteratorFlag::ResolveSymlinks },
            {    9, IteratorFlag::FilesOnly },
            {   10, IteratorFlag::DirsOnly },
            {   11, IteratorFlag::IncludeHidden },
            {   12, IteratorFlag::IncludeDotAndDotDot },
            {   13, IteratorFlag::CaseSensitive },
            {   14, IteratorFlag::Recursive },
            {   15, IteratorFlag::FollowDirSymlinks },
            {   16, IteratorFlag::IncludeBrokenSymlinks },
            {   17, IteratorFlag::NoNameFiltersForDirs },
        }),
    };
    return QtMocHelpers::metaObjectData<QDirListing, qt_meta_tag_ZN11QDirListingE_t>(QMC::PropertyAccessInStaticMetaCall, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject QDirListing::staticMetaObject = { {
    nullptr,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN11QDirListingE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN11QDirListingE_t>.data,
    nullptr,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN11QDirListingE_t>.metaTypes,
    nullptr
} };

QT_WARNING_POP
