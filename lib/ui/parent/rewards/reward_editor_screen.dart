import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/db/database.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../state/providers.dart';
import '../editor_widgets.dart';
import '../media_draft.dart';
import '../parent_scaffold.dart';

class RewardEditorScreen extends ConsumerStatefulWidget {
  const RewardEditorScreen({super.key, this.rewardId});

  final int? rewardId;

  @override
  ConsumerState<RewardEditorScreen> createState() => _RewardEditorScreenState();
}

class _RewardEditorScreenState extends ConsumerState<RewardEditorScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  Reward? _reward;
  int _cost = 10;
  bool _loading = true;
  bool _dirty = false;
  bool _saved = false;
  late MediaDraft _draft;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final media = ref.read(mediaStoreProvider);
    final r = widget.rewardId == null
        ? null
        : await ref.read(rewardRepositoryProvider).getReward(widget.rewardId!);
    if (!mounted) return;
    setState(() {
      _reward = r;
      _name.text = r?.name ?? '';
      _cost = r?.starCost ?? 10;
      _draft = MediaDraft(media, photo: r?.photoPath);
      _loading = false;
    });
    _name.addListener(() {
      if (!_dirty) setState(() => _dirty = true);
    });
  }

  @override
  void dispose() {
    if (!_loading && !_saved) _draft.discard();
    _name.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto(ImageSource source) async {
    final picked = await ref
        .read(parentSessionProvider.notifier)
        .whileOutside(() => ref.read(photoPickerProvider)(source));
    if (picked == null || !mounted) return;
    final rel = await ref.read(mediaStoreProvider).importPhoto(picked);
    _draft.adopt(rel);
    setState(() {
      _draft.setPhoto(rel);
      _dirty = true;
    });
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final repo = ref.read(rewardRepositoryProvider);
    if (_reward == null) {
      await repo.createReward(
        RewardsCompanion.insert(
          name: _name.text.trim(),
          starCost: _cost,
          photoPath: Value(_draft.photo),
        ),
      );
    } else {
      await repo.updateReward(
        _reward!.id,
        RewardsCompanion(
          name: Value(_name.text.trim()),
          starCost: Value(_cost),
          photoPath: Value(_draft.photo),
        ),
      );
    }
    await _draft.commit();
    _saved = true;
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final l = AppLocalizations.of(context);
    final ok = await confirm(
      context,
      title: l.deleteRewardConfirm(_reward!.name),
      confirmLabel: l.delete,
      cancelLabel: l.cancel,
    );
    if (!ok) return;
    await ref.read(rewardRepositoryProvider).deleteReward(_reward!.id);
    _saved = true;
    await _draft.discard();
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final title = widget.rewardId == null ? l.rewardNew : l.rewardEdit;
    if (_loading) {
      return ParentScaffold(title: title, body: const SizedBox.shrink());
    }

    return PopScope(
      canPop: !(_dirty || _draft.changed),
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final leave = await confirm(
          context,
          title: l.discardChanges,
          confirmLabel: l.discard,
          cancelLabel: l.keepEditing,
        );
        if (leave && context.mounted) {
          setState(() => _dirty = false);
          await _draft.discard();
          if (context.mounted) context.pop();
        }
      },
      child: ParentScaffold(
        title: title,
        actions: [
          if (_reward != null)
            IconButton(
              tooltip: l.delete,
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: _delete,
            ),
          TextButton(onPressed: _save, child: Text(l.save)),
        ],
        body: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsetsDirectional.all(16),
            children: [
              TextFormField(
                controller: _name,
                decoration: InputDecoration(labelText: l.rewardName),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l.rewardNameRequired
                    : null,
              ),
              const SizedBox(height: 24),
              PictureEditor(
                photoPath: _draft.photo,
                emoji: '🎁',
                onPhoto: _pickPhoto,
                onRemovePhoto: () => setState(() {
                  _draft.setPhoto(null);
                  _dirty = true;
                }),
              ),
              const SizedBox(height: 24),
              NumberStepper(
                label: l.rewardCost,
                value: _cost,
                display: '$_cost ⭐',
                min: 1,
                max: 500,
                onChanged: (v) => setState(() {
                  _cost = v;
                  _dirty = true;
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
