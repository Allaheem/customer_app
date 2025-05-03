part of 'privacy_bloc.dart';


abstract class PrivacyEvent extends Equatable {
  const PrivacyEvent();

  @override
  List<Object> get props => [];
}

// Event to load the current privacy settings
class LoadPrivacySettings extends PrivacyEvent {}

// Event to update a specific privacy setting
class UpdatePrivacySetting extends PrivacyEvent {
  final String settingKey;
  final bool newValue;

  const UpdatePrivacySetting({required this.settingKey, required this.newValue});

  @override
  List<Object> get props => [settingKey, newValue];
}

