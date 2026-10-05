import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/database.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../state/providers.dart';
import '../parent_scaffold.dart';

/// Child name, gender (for gendered phrasing) and mascot name are saved with
/// the Save button; language and the Jewish pack apply immediately.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _name = TextEditingController();
  final _mascot = TextEditingController();
  Gender _gender = Gender.female;
  bool _loaded = false;

  @override
  void dispose() {
    _name.dispose();
    _mascot.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    await ref
        .read(repositoryProvider)
        .updateChild(
          name: _name.text,
          gender: _gender,
          mascotName: _mascot.text,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l.saved)));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final child = ref.watch(childProvider).value;
    if (child != null && !_loaded) {
      _loaded = true;
      _name.text = child.name;
      _mascot.text = child.mascotName;
      _gender = child.gender;
    }
    final repo = ref.read(repositoryProvider);

    return ParentScaffold(
      title: l.parentSettings,
      actions: [
        TextButton(
          onPressed: child == null ? null : _save,
          child: Text(l.save),
        ),
      ],
      body: ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          TextField(
            controller: _name,
            decoration: InputDecoration(labelText: l.childName),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 24),
          Text(l.childGender, style: t.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<Gender>(
            segments: [
              ButtonSegment(value: Gender.female, label: Text(l.genderFemale)),
              ButtonSegment(value: Gender.male, label: Text(l.genderMale)),
            ],
            selected: {_gender},
            onSelectionChanged: (s) => setState(() => _gender = s.first),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _mascot,
            decoration: InputDecoration(labelText: l.mascotName),
          ),
          const SizedBox(height: 24),
          Text(l.settingsLanguage, style: t.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<AppLanguage>(
            segments: [
              ButtonSegment(value: AppLanguage.he, label: Text(l.languageHe)),
              ButtonSegment(value: AppLanguage.es, label: Text(l.languageEs)),
              ButtonSegment(value: AppLanguage.en, label: Text(l.languageEn)),
            ],
            selected: {child?.language ?? AppLanguage.he},
            onSelectionChanged: child == null
                ? null
                : (s) => repo.setLanguage(s.first),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsetsDirectional.zero,
            title: Text(l.jewishPack),
            subtitle: Text(l.jewishPackHint),
            value: child?.jewishPack ?? false,
            onChanged: child == null ? null : repo.setJewishPack,
          ),
        ],
      ),
    );
  }
}
