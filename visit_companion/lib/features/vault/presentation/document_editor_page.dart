import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/document_model.dart';
import 'vault_view_model.dart';

class DocumentEditorPage extends StatefulWidget {
  const DocumentEditorPage({super.key, this.document});

  final DocumentModel? document;

  @override
  State<DocumentEditorPage> createState() => _DocumentEditorPageState();
}

class _DocumentEditorPageState extends State<DocumentEditorPage> {
  int _step = 0;
  final _titleController = TextEditingController();
  final _textController = TextEditingController();
  final _medicineNameController = TextEditingController();
  final _strengthController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<VaultViewModel>();
      if (widget.document != null) {
        viewModel.setTitle(widget.document!.title);
        viewModel.setCorrectedText(widget.document!.correctedText);
        _titleController.text = widget.document!.title;
        _textController.text = widget.document!.correctedText;
        setState(() => _step = 2);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    _medicineNameController.dispose();
    _strengthController.dispose();
    _frequencyController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VaultViewModel>(
      builder: (context, viewModel, _) {
        final draft = viewModel.draft;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.document == null ? 'Add document' : 'Document review',
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: switch (_step) {
                      0 => _CaptureStep(
                        titleController: _titleController,
                        textController: _textController,
                        viewModel: viewModel,
                      ),
                      1 => _TextReviewStep(
                        textController: _textController,
                        viewModel: viewModel,
                      ),
                      _ => _ExplanationStep(
                        document:
                            widget.document ??
                            draft.copyWith(
                              explanation: viewModel.draft.explanation,
                            ),
                        medicineNameController: _medicineNameController,
                        strengthController: _strengthController,
                        frequencyController: _frequencyController,
                        durationController: _durationController,
                        viewModel: viewModel,
                      ),
                    },
                  ),
                  if (_step < 2)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_step == 0) {
                            if (_titleController.text.trim().isEmpty ||
                                _textController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Document title and extracted text are required.',
                                  ),
                                ),
                              );
                              return;
                            }
                            setState(() => _step = 1);
                          } else {
                            setState(() => _step = 2);
                          }
                        },
                        child: Text(_step == 0 ? 'Review text' : 'Explain'),
                      ),
                    ),
                  if (_step == 2)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (widget.document == null) {
                            await viewModel.saveDocument();
                          }
                          if (context.mounted) Navigator.of(context).pop();
                        },
                        child: const Text('Save document'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CaptureStep extends StatelessWidget {
  const _CaptureStep({
    required this.titleController,
    required this.textController,
    required this.viewModel,
  });

  final TextEditingController titleController;
  final TextEditingController textController;
  final VaultViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Capture or upload a prescription/report. For this code-level '
              'module, text can be entered manually before OCR integration.',
            ),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.camera_alt_outlined),
          label: const Text('Open camera'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.upload_file_outlined),
          label: const Text('Choose image or PDF'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: 'Document title'),
          onChanged: viewModel.setTitle,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: textController,
          decoration: const InputDecoration(
            labelText: 'Extracted text',
            alignLabelWithHint: true,
          ),
          maxLines: 8,
          onChanged: viewModel.setOriginalText,
        ),
      ],
    );
  }
}

class _TextReviewStep extends StatelessWidget {
  const _TextReviewStep({
    required this.textController,
    required this.viewModel,
  });

  final TextEditingController textController;
  final VaultViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          'Review extracted text',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        const Text(
          'Correct drug names, strengths, numbers and dates before creating an explanation.',
        ),
        const SizedBox(height: 16),
        TextField(
          controller: textController,
          decoration: const InputDecoration(
            labelText: 'Corrected text',
            alignLabelWithHint: true,
          ),
          maxLines: 12,
          onChanged: viewModel.setCorrectedText,
        ),
      ],
    );
  }
}

class _ExplanationStep extends StatelessWidget {
  const _ExplanationStep({
    required this.document,
    required this.medicineNameController,
    required this.strengthController,
    required this.frequencyController,
    required this.durationController,
    required this.viewModel,
  });

  final DocumentModel document;
  final TextEditingController medicineNameController;
  final TextEditingController strengthController;
  final TextEditingController frequencyController;
  final TextEditingController durationController;
  final VaultViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final explanation = document.explanation.isEmpty
        ? 'Corrected text reviewed. This app provides plain-language '
              'orientation only; it does not infer missing doses or durations.'
        : document.explanation;

    return ListView(
      children: [
        Text(
          'Review with original',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    document.correctedText.isEmpty
                        ? viewModel.draft.correctedText
                        : document.correctedText,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(explanation),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Safety: do not change, stop or combine medicines based on '
              'this app. Confirm with your clinician or pharmacist.',
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: medicineNameController,
          decoration: const InputDecoration(labelText: 'Medicine name'),
          onChanged: viewModel.setMedicationName,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: strengthController,
          decoration: const InputDecoration(labelText: 'Strength'),
          onChanged: viewModel.setMedicationStrength,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: frequencyController,
          decoration: const InputDecoration(labelText: 'Frequency'),
          onChanged: viewModel.setMedicationFrequency,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: durationController,
          decoration: const InputDecoration(labelText: 'Duration'),
          onChanged: viewModel.setMedicationDuration,
        ),
        CheckboxListTile(
          value: viewModel.reminderApproved,
          title: const Text('I approve creating this reminder'),
          onChanged: (value) => viewModel.setReminderApproved(value ?? false),
        ),
      ],
    );
  }
}
