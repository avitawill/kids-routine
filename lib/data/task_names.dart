import 'db/database.dart';

extension TaskNames on Task {
  /// The task name in [lang], falling back to Hebrew when it is missing.
  String nameIn(AppLanguage lang) => languageOfName(lang) == lang
      ? switch (lang) {
          AppLanguage.he => nameHe,
          AppLanguage.es => nameEs!,
          AppLanguage.en => nameEn!,
        }
      : nameHe;

  /// The language [nameIn] actually returns for [lang] (Hebrew when the
  /// translation is missing), so TTS reads it with the right voice.
  AppLanguage languageOfName(AppLanguage lang) {
    final name = switch (lang) {
      AppLanguage.he => nameHe,
      AppLanguage.es => nameEs,
      AppLanguage.en => nameEn,
    };
    return (name == null || name.trim().isEmpty) ? AppLanguage.he : lang;
  }
}
