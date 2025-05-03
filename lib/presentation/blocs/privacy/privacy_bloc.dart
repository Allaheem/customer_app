import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// warning • Unused import: 'package:equatable/equatable.dart'

// TODO: Import PrivacyRepository
// TODO: Import UserSettings model from privacy_state.dart or a dedicated model file
part 'privacy_event.dart';
part 'privacy_state.dart';

class PrivacyBloc extends Bloc<PrivacyEvent, PrivacyState> {
  // TODO: Inject PrivacyRepository
  // final PrivacyRepository _privacyRepository;

  PrivacyBloc(/* required this._privacyRepository */) : super(PrivacyInitial()) {
    on<LoadPrivacySettings>(_onLoadPrivacySettings);
    on<UpdatePrivacySetting>(_onUpdatePrivacySetting);
  }

  Future<void> _onLoadPrivacySettings(
    LoadPrivacySettings event,
    Emitter<PrivacyState> emit,
  ) async {
    emit(PrivacyLoading());
    try {
      // TODO: Call _privacyRepository.getPrivacySettings();
      // print("Loading privacy settings from repository...");
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate API call
      const UserSettings currentSettings = UserSettings(); // Placeholder
      emit(PrivacyLoaded(currentSettings));
    } catch (e) {
      emit(PrivacyError("Failed to load settings: ${e.toString()}"));
    }
  }

  Future<void> _onUpdatePrivacySetting(
    UpdatePrivacySetting event,
    Emitter<PrivacyState> emit,
  ) async {
    if (state is PrivacyLoaded) {
      final currentState = state as PrivacyLoaded;
      UserSettings updatedSettings = currentState.settings;

      // Update the specific setting based on the key
      switch (event.settingKey) {
        case 'preciseLocation':
          updatedSettings = updatedSettings.copyWith(sharePreciseLocation: event.newValue);
          // If precise location is turned off, also turn off 'during ride only'
          if (!event.newValue) {
            updatedSettings = updatedSettings.copyWith(shareLocationDuringRideOnly: false);
          }
          break;
        case 'locationDuringRideOnly':
          updatedSettings = updatedSettings.copyWith(shareLocationDuringRideOnly: event.newValue);
          break;
        case 'showPhoneNumber':
          updatedSettings = updatedSettings.copyWith(showPhoneNumberToDriver: event.newValue);
          break;
        case 'accessRideHistory':
          updatedSettings = updatedSettings.copyWith(allowAccessToRideHistory: event.newValue);
          break;
        case 'promotionalEmails':
          updatedSettings = updatedSettings.copyWith(allowPromotionalEmails: event.newValue);
          break;
        case 'dataForAnalysis':
          updatedSettings = updatedSettings.copyWith(allowDataForAnalysis: event.newValue);
          break;
        default:
          // Handle unknown key or emit error?
          // print("Unknown setting key: ${event.settingKey}");
          return; // Or emit error state
      }

      // Optimistically update the UI
      emit(PrivacyLoaded(updatedSettings));

      try {
        // TODO: Call _privacyRepository.updatePrivacySetting(event.settingKey, event.newValue);
        // Or: _privacyRepository.savePrivacySettings(updatedSettings);
        // print("Saving updated setting to repository: ${event.settingKey} = ${event.newValue}");
        await Future.delayed(const Duration(milliseconds: 300)); // Simulate API call
        // No need to emit success state again unless confirmation is needed
      } catch (e) {
        // Revert UI and show error
        emit(PrivacyLoaded(currentState.settings)); // Revert to previous settings
        emit(PrivacyError("Failed to update setting ${event.settingKey}: ${e.toString()}"));
        // Optionally re-emit the loaded state after showing error
        await Future.delayed(const Duration(seconds: 2));
        if (state is PrivacyError) {
           emit(PrivacyLoaded(currentState.settings));
        }
      }
    } else {
      // Handle case where settings are not loaded yet
      emit(const PrivacyError("Cannot update settings before they are loaded."));
    }
  }
}

