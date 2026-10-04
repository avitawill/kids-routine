import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/db/database.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../services/recorder.dart';
import '../../../state/providers.dart';
import '../editor_widgets.dart';
import '../media_draft.dart';
import '../parent_scaffold.dart';

/// Create or edit a task. With [addToRoutine], a newly created task is
/// appended to that routine.
class TaskEditorScreen extends ConsumerStatefulWidget {
  const TaskEditorScreen({super.key, this.taskId, this.addToRoutine});

  final int? taskId;
  final RoutineType? addToRoutine;

  @override
  ConsumerState<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends ConsumerState<TaskEditorScreen> {
  static const maxRecording = Duration(seconds: 20);

  final _form = GlobalKey<FormState>();
  final _he = TextEditingController();
  final _es = TextEditingController();
  final _en = TextEditingController();

  Task? _task;
  bool _loading = true;
  bool _dirty = false;
  bool _saved = false;
  String _emoji = '⭐';
  int _minutes = 3;
  late MediaDraft _draft;

  Timer? _recordTimer;
  int _recordSeconds = 0;
  String? _recording; // relative path while recording

  // Read up front: ref can't be used in dispose().
  late final VoiceRecorder _recorder;

  @override
  void initState() {
    super.initState();
    _recorder = ref.read(recorderProvider);
    _load();
  }

  Future<void> _load() async {
    final media = ref.read(mediaStoreProvider);
    final task = widget.taskId == null
        ? null
        : await ref.read(taskRepositoryProvider).getTask(widget.taskId!);
    if (!mounted) return;
    setState(() {
      _task = task;
      _he.text = task?.nameHe ?? '';
      _es.text = task?.nameEs ?? '';
      _en.text = task?.nameEn ?? '';
      _emoji = task?.emoji ?? '⭐';
      _minutes = task?.targetMinutes ?? 3;
      _draft = MediaDraft(
        media,
        photo: task?.photoPath,
        audio: task?.audioPath,
      );
      _loading = false;
    });
    for (final c in [_he, _es, _en]) {
      c.addListener(_markDirty);
    }
  }

  void _markDirty() {
    if (!_dirty) setState(() => _dirty = true);
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
    if (_recording != null) _recorder.stop();
    if (!_loading && !_saved) _draft.discard();
    _he.dispose();
    _es.dispose();
    _en.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto(ImageSource source) async {
    final session = ref.read(parentSessionProvider.notifier);
    final picked = await session.whileOutside(
      () => ref.read(photoPickerProvider)(source),
    );
    if (picked == null || !mounted) return;
    final rel = await ref.read(mediaStoreProvider).importPhoto(picked);
    _draft.adopt(rel);
    setState(() {
      _draft.setPhoto(rel);
      _dirty = true;
    });
  }

  Future<void> _startRecording() async {
    final l = AppLocalizations.of(context);
    final media = ref.read(mediaStoreProvider);
    final rel = media.newPath('audio', 'm4a');
    await ref.read(audioProvider).stop();
    final ok = await ref
        .read(parentSessionProvider.notifier)
        .whileOutside(() => _recorder.start(media.resolve(rel).path));
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.micDenied)));
      return;
    }
    setState(() {
      _recording = rel;
      _recordSeconds = 0;
    });
    _recordTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _recordSeconds++);
      if (_recordSeconds >= maxRecording.inSeconds) _stopRecording();
    });
  }

  Future<void> _stopRecording() async {
    final rel = _recording;
    if (rel == null) return;
    _recordTimer?.cancel();
    await _recorder.stop();
    if (!mounted) return;
    _draft.adopt(rel);
    setState(() {
      _recording = null;
      _draft.setAudio(rel);
      _dirty = true;
    });
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    if (_recording != null) await _stopRecording();
    String? opt(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();
    final changes = TasksCompanion(
      nameHe: Value(_he.text.trim()),
      nameEs: Value(opt(_es)),
      nameEn: Value(opt(_en)),
      emoji: Value(_emoji),
      photoPath: Value(_draft.photo),
      audioPath: Value(_draft.audio),
      targetMinutes: Value(_minutes),
    );

    final tasks = ref.read(taskRepositoryProvider);
    if (_task == null) {
      final id = await tasks.createTask(changes);
      final type = widget.addToRoutine;
      if (type != null) {
        final routine = await ref
            .read(repositoryProvider)
            .watchRoutine(type)
            .first;
        await ref.read(repositoryProvider).addToRoutine(routine.id, id);
      }
    } else {
      await tasks.updateTask(_task!.id, changes);
    }
    await _draft.commit();
    _saved = true;
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final l = AppLocalizations.of(context);
    final ok = await confirm(
      context,
      title: l.deleteTaskConfirm(_task!.nameHe),
      confirmLabel: l.delete,
      cancelLabel: l.cancel,
    );
    if (!ok) return;
    await ref.read(taskRepositoryProvider).deleteCustomTask(_task!.id);
    _saved = true; // nothing left to discard: the task's media is gone too
    await _draft.discard();
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final title = widget.taskId == null ? l.newTask : l.taskEditTitle;
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
          if (_task != null && !_task!.isBuiltIn)
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
                controller: _he,
                decoration: InputDecoration(labelText: l.taskNameHe),
                textDirection: TextDirection.rtl,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l.taskNameRequired : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _es,
                decoration: InputDecoration(labelText: l.taskNameEs),
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _en,
                decoration: InputDecoration(labelText: l.taskNameEn),
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: 24),
              PictureEditor(
                photoPath: _draft.photo,
                emoji: _emoji,
                onPickEmoji: () async {
                  final e = await pickEmoji(context);
                  if (e == null) return;
                  setState(() {
                    _emoji = e;
                    _draft.setPhoto(null); // the emoji is the picture now
                    _dirty = true;
                  });
                },
                onPhoto: _pickPhoto,
                onRemovePhoto: () => setState(() {
                  _draft.setPhoto(null);
                  _dirty = true;
                }),
              ),
              const SizedBox(height: 24),
              _VoiceSection(
                hasAudio: _draft.audio != null,
                recordingSeconds: _recording == null ? null : _recordSeconds,
                onRecord: _startRecording,
                onStop: _stopRecording,
                onPlay: () => ref.read(audioProvider).playFile(_draft.audio!),
                onDelete: () => setState(() {
                  _draft.setAudio(null);
                  _dirty = true;
                }),
              ),
              const SizedBox(height: 24),
              NumberStepper(
                label: l.taskMinutes,
                value: _minutes,
                display: l.minutesShort(_minutes),
                min: 1,
                max: 60,
                onChanged: (v) => setState(() {
                  _minutes = v;
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

class _VoiceSection extends StatelessWidget {
  const _VoiceSection({
    required this.hasAudio,
    required this.recordingSeconds,
    required this.onRecord,
    required this.onStop,
    required this.onPlay,
    required this.onDelete,
  });

  final bool hasAudio;
  final int? recordingSeconds;
  final VoidCallback onRecord;
  final VoidCallback onStop;
  final VoidCallback onPlay;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final recording = recordingSeconds != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.taskVoice, style: t.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (recording)
              FilledButton.icon(
                onPressed: onStop,
                icon: const Icon(Icons.stop_rounded),
                label: Text(l.stopRecording),
              )
            else
              FilledButton.tonalIcon(
                onPressed: onRecord,
                icon: const Icon(Icons.mic_rounded),
                label: Text(l.recordVoice),
              ),
            if (recording) Text(l.recordingNow(recordingSeconds!)),
            if (hasAudio && !recording) ...[
              OutlinedButton.icon(
                onPressed: onPlay,
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(l.playRecording),
              ),
              TextButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded),
                label: Text(l.deleteRecording),
              ),
            ],
          ],
        ),
        if (!hasAudio && !recording)
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 4),
            child: Text(l.noRecordingHint, style: t.bodyMedium),
          ),
      ],
    );
  }
}
