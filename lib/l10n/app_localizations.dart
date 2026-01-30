import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In id, this message translates to:
  /// **'Planno Home'**
  String get appTitle;

  /// No description provided for @appVersion.
  ///
  /// In id, this message translates to:
  /// **'Versi Aplikasi'**
  String get appVersion;

  /// No description provided for @version.
  ///
  /// In id, this message translates to:
  /// **'v1.0.0'**
  String get version;

  /// No description provided for @hello.
  ///
  /// In id, this message translates to:
  /// **'Halo'**
  String get hello;

  /// No description provided for @settings.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In id, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @darkMode.
  ///
  /// In id, this message translates to:
  /// **'Mode Gelap'**
  String get darkMode;

  /// No description provided for @appearance.
  ///
  /// In id, this message translates to:
  /// **'TAMPILAN & APLIKASI'**
  String get appearance;

  /// No description provided for @information.
  ///
  /// In id, this message translates to:
  /// **'INFORMASI'**
  String get information;

  /// No description provided for @aboutApp.
  ///
  /// In id, this message translates to:
  /// **'Tentang Aplikasi'**
  String get aboutApp;

  /// No description provided for @logout.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get logout;

  /// No description provided for @noSchedule.
  ///
  /// In id, this message translates to:
  /// **'Belum ada jadwal'**
  String get noSchedule;

  /// No description provided for @pressPlus.
  ///
  /// In id, this message translates to:
  /// **'Tekan tombol + untuk membuat baru'**
  String get pressPlus;

  /// No description provided for @general.
  ///
  /// In id, this message translates to:
  /// **'UMUM'**
  String get general;

  /// No description provided for @myProfile.
  ///
  /// In id, this message translates to:
  /// **'Profil Saya'**
  String get myProfile;

  /// No description provided for @calendar.
  ///
  /// In id, this message translates to:
  /// **'Kalender'**
  String get calendar;

  /// No description provided for @addSchedule.
  ///
  /// In id, this message translates to:
  /// **'Tambah Jadwal'**
  String get addSchedule;

  /// No description provided for @editPageTitle.
  ///
  /// In id, this message translates to:
  /// **'Edit Jadwal'**
  String get editPageTitle;

  /// No description provided for @createHeader.
  ///
  /// In id, this message translates to:
  /// **'Buat Jadwal Baru'**
  String get createHeader;

  /// No description provided for @editHeader.
  ///
  /// In id, this message translates to:
  /// **'Perbarui Informasi'**
  String get editHeader;

  /// No description provided for @saveSchedule.
  ///
  /// In id, this message translates to:
  /// **'SIMPAN JADWAL'**
  String get saveSchedule;

  /// No description provided for @updateSchedule.
  ///
  /// In id, this message translates to:
  /// **'SIMPAN PERUBAHAN'**
  String get updateSchedule;

  /// No description provided for @save.
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get cancel;

  /// No description provided for @titleLabel.
  ///
  /// In id, this message translates to:
  /// **'Judul Kegiatan'**
  String get titleLabel;

  /// No description provided for @dateLabel.
  ///
  /// In id, this message translates to:
  /// **'Tanggal'**
  String get dateLabel;

  /// No description provided for @timeLabel.
  ///
  /// In id, this message translates to:
  /// **'Waktu'**
  String get timeLabel;

  /// No description provided for @descLabel.
  ///
  /// In id, this message translates to:
  /// **'Deskripsi'**
  String get descLabel;

  /// No description provided for @groupLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama Kelompok (Kategori)'**
  String get groupLabel;

  /// No description provided for @titleError.
  ///
  /// In id, this message translates to:
  /// **'Judul wajib diisi'**
  String get titleError;

  /// No description provided for @requiredError.
  ///
  /// In id, this message translates to:
  /// **'Wajib isi'**
  String get requiredError;

  /// No description provided for @categoryLockedInfo.
  ///
  /// In id, this message translates to:
  /// **'*Kategori otomatis terpilih dari folder'**
  String get categoryLockedInfo;

  /// No description provided for @categoryEditInfo.
  ///
  /// In id, this message translates to:
  /// **'*Kategori tidak dapat diubah'**
  String get categoryEditInfo;

  /// No description provided for @successSave.
  ///
  /// In id, this message translates to:
  /// **'Jadwal berhasil disimpan!'**
  String get successSave;

  /// No description provided for @successUpdate.
  ///
  /// In id, this message translates to:
  /// **'Jadwal berhasil diperbarui!'**
  String get successUpdate;

  /// No description provided for @detailTitle.
  ///
  /// In id, this message translates to:
  /// **'Detail Jadwal'**
  String get detailTitle;

  /// No description provided for @statusDone.
  ///
  /// In id, this message translates to:
  /// **'Selesai Dikerjakan'**
  String get statusDone;

  /// No description provided for @descTitle.
  ///
  /// In id, this message translates to:
  /// **'Deskripsi Kegiatan'**
  String get descTitle;

  /// No description provided for @deleteTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus Jadwal?'**
  String get deleteTitle;

  /// No description provided for @deleteConfirm.
  ///
  /// In id, this message translates to:
  /// **'Data yang dihapus tidak bisa dikembalikan.'**
  String get deleteConfirm;

  /// No description provided for @delete.
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get delete;

  /// No description provided for @deleteSuccess.
  ///
  /// In id, this message translates to:
  /// **'Jadwal berhasil dihapus'**
  String get deleteSuccess;

  /// No description provided for @deleteFail.
  ///
  /// In id, this message translates to:
  /// **'Gagal menghapus'**
  String get deleteFail;

  /// No description provided for @calendarPageTitle.
  ///
  /// In id, this message translates to:
  /// **'Agenda Kalender'**
  String get calendarPageTitle;

  /// No description provided for @scheduleList.
  ///
  /// In id, this message translates to:
  /// **'Jadwal'**
  String get scheduleList;

  /// No description provided for @emptyScheduleDay.
  ///
  /// In id, this message translates to:
  /// **'Hari ini kosong, santai dulu!'**
  String get emptyScheduleDay;

  /// No description provided for @editNameTitle.
  ///
  /// In id, this message translates to:
  /// **'Ubah Nama'**
  String get editNameTitle;

  /// No description provided for @nameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama Lengkap'**
  String get nameLabel;

  /// No description provided for @nameSuccess.
  ///
  /// In id, this message translates to:
  /// **'Nama berhasil diubah!'**
  String get nameSuccess;

  /// No description provided for @accountInfo.
  ///
  /// In id, this message translates to:
  /// **'INFORMASI AKUN'**
  String get accountInfo;

  /// No description provided for @emailLabel.
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @statusLabel.
  ///
  /// In id, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @verifiedMember.
  ///
  /// In id, this message translates to:
  /// **'Member Terverifikasi'**
  String get verifiedMember;

  /// No description provided for @joinedDate.
  ///
  /// In id, this message translates to:
  /// **'Bergabung Sejak'**
  String get joinedDate;

  /// No description provided for @settingsTitle.
  ///
  /// In id, this message translates to:
  /// **'PENGATURAN'**
  String get settingsTitle;

  /// No description provided for @confirmTitle.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi'**
  String get confirmTitle;

  /// No description provided for @logoutConfirm.
  ///
  /// In id, this message translates to:
  /// **'Yakin ingin keluar dari akun?'**
  String get logoutConfirm;

  /// No description provided for @aboutDescTitle.
  ///
  /// In id, this message translates to:
  /// **'Apa itu Planno?'**
  String get aboutDescTitle;

  /// No description provided for @aboutDescContent.
  ///
  /// In id, this message translates to:
  /// **'Planno adalah aplikasi manajemen jadwal sederhana yang membantu Anda mengatur aktivitas sehari-hari agar lebih produktif dan terorganisir.'**
  String get aboutDescContent;

  /// No description provided for @devTitle.
  ///
  /// In id, this message translates to:
  /// **'Pengembang'**
  String get devTitle;

  /// No description provided for @devContent.
  ///
  /// In id, this message translates to:
  /// **'Dibuat oleh:\n\nArizal Junior\nNIM: 23552011310'**
  String get devContent;

  /// No description provided for @listPageTitle.
  ///
  /// In id, this message translates to:
  /// **'Daftar Saya'**
  String get listPageTitle;

  /// No description provided for @emptyList.
  ///
  /// In id, this message translates to:
  /// **'Belum ada daftar'**
  String get emptyList;

  /// No description provided for @createListTitle.
  ///
  /// In id, this message translates to:
  /// **'Buat Daftar Baru'**
  String get createListTitle;

  /// No description provided for @createListHint.
  ///
  /// In id, this message translates to:
  /// **'Misal: Film, Belanja...'**
  String get createListHint;

  /// No description provided for @createButton.
  ///
  /// In id, this message translates to:
  /// **'Buat'**
  String get createButton;

  /// No description provided for @deleteListTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus Daftar Ini?'**
  String get deleteListTitle;

  /// No description provided for @deleteListContent.
  ///
  /// In id, this message translates to:
  /// **'Daftar \'{title}\' akan dihapus permanen.'**
  String deleteListContent(Object title);

  /// No description provided for @deleteButton.
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get deleteButton;

  /// No description provided for @cancelButton.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get cancelButton;

  /// No description provided for @addSubTaskHint.
  ///
  /// In id, this message translates to:
  /// **'Tambah sub tugas...'**
  String get addSubTaskHint;

  /// No description provided for @emptySubTask.
  ///
  /// In id, this message translates to:
  /// **'Daftar kosong'**
  String get emptySubTask;

  /// No description provided for @titleHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Rapat Tim'**
  String get titleHint;

  /// No description provided for @groupHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Kerja, Pribadi'**
  String get groupHint;

  /// No description provided for @dateHint.
  ///
  /// In id, this message translates to:
  /// **'Pilih Tanggal'**
  String get dateHint;

  /// No description provided for @timeHint.
  ///
  /// In id, this message translates to:
  /// **'Pilih Jam'**
  String get timeHint;

  /// No description provided for @descHint.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan catatan...'**
  String get descHint;

  /// No description provided for @generalCategory.
  ///
  /// In id, this message translates to:
  /// **'Umum'**
  String get generalCategory;

  /// No description provided for @failSave.
  ///
  /// In id, this message translates to:
  /// **'Gagal: '**
  String get failSave;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
