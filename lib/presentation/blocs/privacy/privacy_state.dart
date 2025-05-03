part of 'privacy_bloc.dart';


// TODO: Import UserSettings model

// Placeholder for UserSettings model
class UserSettings extends Equatable {
  final bool sharePreciseLocation;
  final bool shareLocationDuringRideOnly;
  final bool showPhoneNumberToDriver;
  final bool allowAccessToRideHistory;
  final bool allowPromotionalEmails;
  final bool allowDataForAnalysis;

  const UserSettings({
    this.sharePreciseLocation = true,
    this.shareLocationDuringRideOnly = true,
    this.showPhoneNumberToDriver = true,
    this.allowAccessToRideHistory = true,
    this.allowPromotionalEmails = false,
    this.allowDataForAnalysis = true,
  });

  UserSettings copyWith({
    bool? sharePreciseLocation,
    bool? shareLocationDuringRideOnly,
    bool? showPhoneNumberToDriver,
    bool? allowAccessToRideHistory,
    bool? allowPromotionalEmails,
    bool? allowDataForAnalysis,
  }) {
    return UserSettings(
      sharePreciseLocation: sharePreciseLocation ?? this.sharePreciseLocation,
      shareLocationDuringRideOnly: shareLocationDuringRideOnly ?? this.shareLocationDuringRideOnly,
      showPhoneNumberToDriver: showPhoneNumberToDriver ?? this.showPhoneNumberToDriver,
      allowAccessToRideHistory: allowAccessToRideHistory ?? this.allowAccessToRideHistory,
      allowPromotionalEmails: allowPromotionalEmails ?? this.allowPromotionalEmails,
      allowDataForAnalysis: allowDataForAnalysis ?? this.allowDataForAnalysis,
    );
  }

  @override
  List<Object?> get props => [
        sharePreciseLocation,
        shareLocationDuringRideOnly,
        showPhoneNumberToDriver,
        allowAccessToRideHistory,
        allowPromotionalEmails,
        allowDataForAnalysis,
      ];
}

abstract class PrivacyState extends Equatable {
  const PrivacyState();

  @override
  List<Object> get props => [];
}

// Initial state, settings not loaded yet
class PrivacyInitial extends PrivacyState {}

// State while loading settings
class PrivacyLoading extends PrivacyState {}

// State when settings are loaded successfully
class PrivacyLoaded extends PrivacyState {
  final UserSettings settings;

  const PrivacyLoaded(this.settings);

  @override
  List<Object> get props => [settings];
}

// State if an error occurs loading or updating settings
class PrivacyError extends PrivacyState {
  final String message;

  const PrivacyError(this.message);

  @override
  List<Object> get props => [message];
}

