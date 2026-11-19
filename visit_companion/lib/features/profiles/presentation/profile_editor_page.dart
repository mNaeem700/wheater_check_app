import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'profile_view_model.dart';

class ProfileEditorPage extends StatefulWidget {
  const ProfileEditorPage({super.key});

  @override
  State<ProfileEditorPage> createState() => _ProfileEditorPageState();
}

class _ProfileEditorPageState extends State<ProfileEditorPage> {
  final _nameController = TextEditingController();
  final _countryController = TextEditingController();
  final _regionController = TextEditingController();
  final _allergyController = TextEditingController();
  final _conditionController = TextEditingController();
  final _medicineController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final draft = context.read<ProfileViewModel>().draft;
      _nameController.text = draft.name;
      _countryController.text = draft.country;
      _regionController.text = draft.region;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
    _regionController.dispose();
    _allergyController.dispose();
    _conditionController.dispose();
    _medicineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, _) {
        final draft = viewModel.draft;

        return Scaffold(
          appBar: AppBar(
            title: Text(draft.id.isEmpty ? 'Add profile' : 'Edit profile'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: viewModel.setName,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Country'),
                onChanged: viewModel.setCountry,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _regionController,
                decoration: const InputDecoration(labelText: 'Region / city'),
                onChanged: viewModel.setRegion,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: draft.languages.isEmpty
                    ? null
                    : draft.languages.first,
                decoration: const InputDecoration(labelText: 'Language'),
                items: const [
                  DropdownMenuItem(value: 'English', child: Text('English')),
                  DropdownMenuItem(value: 'Urdu', child: Text('Urdu')),
                ],
                onChanged: (value) {
                  if (value != null) viewModel.setLanguages([value]);
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                value: draft.isMinor,
                title: const Text('This is a child profile'),
                onChanged: (value) => viewModel.setIsMinor(value ?? false),
              ),
              const SizedBox(height: 8),
              _TagEditor(
                label: 'Allergies',
                values: draft.allergies,
                controller: _allergyController,
                onChanged: viewModel.setAllergies,
              ),
              const SizedBox(height: 16),
              _TagEditor(
                label: 'Conditions',
                values: draft.conditions,
                controller: _conditionController,
                onChanged: viewModel.setConditions,
              ),
              const SizedBox(height: 16),
              _TagEditor(
                label: 'Current medicines',
                values: draft.medicines,
                controller: _medicineController,
                onChanged: viewModel.setMedicines,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final saved = await viewModel.saveDraft();
                  if (!context.mounted) return;
                  if (saved) {
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Name, country and language are required.',
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Save profile'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TagEditor extends StatelessWidget {
  const _TagEditor({
    required this.label,
    required this.values,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final List<String> values;
  final TextEditingController controller;
  final ValueChanged<List<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final value in values)
              Chip(
                label: Text(value),
                onDeleted: () =>
                    onChanged(values.where((item) => item != value).toList()),
              ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(hintText: 'Add $label'),
              ),
            ),
            IconButton(
              tooltip: 'Add',
              onPressed: () {
                final value = controller.text.trim();
                if (value.isEmpty) return;
                onChanged([...values, value]);
                controller.clear();
              },
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }
}
