part of 'settings_cubit.dart';

class SettingsState {
  final bool isDarkMode;
  final bool notifications;
  final double fontSize;
  final String selectedFont;

  const SettingsState({
    required this.isDarkMode,
    required this.notifications,
    required this.fontSize,
    required this.selectedFont,
  });

  factory SettingsState.initial() {
    return SettingsState(
      isDarkMode: false,
      notifications: false,
      fontSize: 16.0,
      selectedFont: GoogleFonts.rubik().fontFamily!,
    );
  }

  SettingsState copyWith({
    bool? isDarkMode,
    bool? notifications,
    double? fontSize,
    String? selectedFont,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notifications: notifications ?? this.notifications,
      fontSize: fontSize ?? this.fontSize,
      selectedFont: selectedFont ?? this.selectedFont,
    );
  }

  factory SettingsState.fromMap(Map<String, dynamic> map) {
    return SettingsState(
      isDarkMode: map['isDarkMode'] as bool? ?? false,
      notifications: map['notifications'] as bool? ?? true,
      fontSize: (map['fontSize'] as num? ?? 16.0).toDouble(),
      selectedFont:
          map['selectedFont'] as String? ?? GoogleFonts.rubik().fontFamily!,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isDarkMode': isDarkMode,
      'notifications': notifications,
      'fontSize': fontSize,
      'selectedFont': selectedFont,
    };
  }
}
