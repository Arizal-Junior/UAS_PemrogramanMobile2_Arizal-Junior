// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Planno Home';

  @override
  String get appVersion => 'App Version';

  @override
  String get version => 'v1.0.0';

  @override
  String get hello => 'Hello';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get appearance => 'APPEARANCE & APP';

  @override
  String get information => 'INFORMATION';

  @override
  String get aboutApp => 'About App';

  @override
  String get logout => 'Logout';

  @override
  String get noSchedule => 'No schedule yet';

  @override
  String get pressPlus => 'Press + button to create new';

  @override
  String get general => 'GENERAL';

  @override
  String get myProfile => 'My Profile';

  @override
  String get calendar => 'Calendar';

  @override
  String get addSchedule => 'Add Schedule';

  @override
  String get editPageTitle => 'Edit Schedule';

  @override
  String get createHeader => 'Create New Schedule';

  @override
  String get editHeader => 'Update Information';

  @override
  String get saveSchedule => 'SAVE SCHEDULE';

  @override
  String get updateSchedule => 'SAVE CHANGES';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get titleLabel => 'Activity Title';

  @override
  String get dateLabel => 'Date';

  @override
  String get timeLabel => 'Time';

  @override
  String get descLabel => 'Description';

  @override
  String get groupLabel => 'Group Name (Category)';

  @override
  String get titleError => 'Title is required';

  @override
  String get requiredError => 'Required';

  @override
  String get categoryLockedInfo =>
      '*Category automatically selected from folder';

  @override
  String get categoryEditInfo => '*Category cannot be changed';

  @override
  String get successSave => 'Schedule saved successfully!';

  @override
  String get successUpdate => 'Schedule updated successfully!';

  @override
  String get detailTitle => 'Schedule Detail';

  @override
  String get statusDone => 'Completed';

  @override
  String get descTitle => 'Activity Description';

  @override
  String get deleteTitle => 'Delete Schedule?';

  @override
  String get deleteConfirm => 'Deleted data cannot be recovered.';

  @override
  String get delete => 'Delete';

  @override
  String get deleteSuccess => 'Schedule deleted successfully';

  @override
  String get deleteFail => 'Failed to delete';

  @override
  String get calendarPageTitle => 'Calendar Agenda';

  @override
  String get scheduleList => 'Schedule';

  @override
  String get emptyScheduleDay => 'It\'s empty today, relax!';

  @override
  String get editNameTitle => 'Edit Name';

  @override
  String get nameLabel => 'Full Name';

  @override
  String get nameSuccess => 'Name updated successfully!';

  @override
  String get accountInfo => 'ACCOUNT INFORMATION';

  @override
  String get emailLabel => 'Email';

  @override
  String get statusLabel => 'Status';

  @override
  String get verifiedMember => 'Verified Member';

  @override
  String get joinedDate => 'Joined Since';

  @override
  String get settingsTitle => 'SETTINGS';

  @override
  String get confirmTitle => 'Confirmation';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get aboutDescTitle => 'What is Planno?';

  @override
  String get aboutDescContent =>
      'Planno is a simple schedule management app that helps you organize your daily activities to be more productive and organized.';

  @override
  String get devTitle => 'Developer';

  @override
  String get devContent => 'Created by:\n\nArizal Junior\nNIM: 23552011310';

  @override
  String get listPageTitle => 'My Lists';

  @override
  String get emptyList => 'No lists yet';

  @override
  String get createListTitle => 'Create New List';

  @override
  String get createListHint => 'e.g. Movies, Shopping...';

  @override
  String get createButton => 'Create';

  @override
  String get deleteListTitle => 'Delete this list?';

  @override
  String deleteListContent(Object title) {
    return 'List \'$title\' will be permanently deleted.';
  }

  @override
  String get deleteButton => 'Delete';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get addSubTaskHint => 'Add subtask...';

  @override
  String get emptySubTask => 'No items yet';

  @override
  String get titleHint => 'e.g. Team Meeting';

  @override
  String get groupHint => 'e.g. Work, Personal';

  @override
  String get dateHint => 'Select Date';

  @override
  String get timeHint => 'Select Time';

  @override
  String get descHint => 'Add notes...';

  @override
  String get generalCategory => 'General';

  @override
  String get failSave => 'Failed: ';
}
