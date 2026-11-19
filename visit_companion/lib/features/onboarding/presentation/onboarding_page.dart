import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../domain/onboarding_model.dart';
import 'onboarding_view_model.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _step = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final model = viewModel.model;

        return Scaffold(
          appBar: AppBar(title: Text('Setup ${_step + 1} of 3')),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: switch (_step) {
                      0 => _LanguageStep(viewModel: viewModel, model: model),
                      1 => _PurposeStep(viewModel: viewModel, model: model),
                      _ => _ConsentStep(viewModel: viewModel, model: model),
                    },
                  ),
                  Row(
                    children: [
                      if (_step > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => _step -= 1),
                            child: const Text('Back'),
                          ),
                        ),
                      if (_step > 0) const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _continue(viewModel),
                          child: Text(_step == 2 ? 'Continue' : 'Next'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _continue(OnboardingViewModel viewModel) async {
    if (_step < 2) {
      setState(() => _step += 1);
      return;
    }

    final completed = await viewModel.completeOnboarding();
    if (!mounted) return;

    if (completed) {
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select a purpose and accept the required consents.'),
        ),
      );
    }
  }
}

class _LanguageStep extends StatelessWidget {
  const _LanguageStep({required this.viewModel, required this.model});

  final OnboardingViewModel viewModel;
  final OnboardingModel model;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          'Choose your languages',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        DropdownButtonFormField<String>(
          initialValue: model.interfaceLanguage,
          decoration: const InputDecoration(labelText: 'App language'),
          items: const [
            DropdownMenuItem(value: 'en', child: Text('English')),
            DropdownMenuItem(value: 'ur', child: Text('Urdu')),
          ],
          onChanged: (value) {
            if (value != null) viewModel.setInterfaceLanguage(value);
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: model.homeLanguage,
          decoration: const InputDecoration(labelText: 'Home language'),
          items: const [
            DropdownMenuItem(value: 'en', child: Text('English')),
            DropdownMenuItem(value: 'ur', child: Text('Urdu')),
          ],
          onChanged: (value) {
            if (value != null) viewModel.setHomeLanguage(value);
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: model.localLanguage,
          decoration: const InputDecoration(labelText: 'Local language'),
          items: const [
            DropdownMenuItem(value: 'en', child: Text('English')),
            DropdownMenuItem(value: 'ur', child: Text('Urdu')),
          ],
          onChanged: (value) {
            if (value != null) viewModel.setLocalLanguage(value);
          },
        ),
      ],
    );
  }
}

class _PurposeStep extends StatelessWidget {
  const _PurposeStep({required this.viewModel, required this.model});

  final OnboardingViewModel viewModel;
  final OnboardingModel model;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          'Why will you use Visit Companion?',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Visit Companion prepares and explains information. '
              'It does not diagnose, prescribe or recommend doses.',
            ),
          ),
        ),
        const SizedBox(height: 16),
        RadioGroup<String>(
          groupValue: model.purpose,
          onChanged: (value) {
            if (value != null) viewModel.setPurpose(value);
          },
          child: Column(
            children:
                [
                      'Prepare for a clinic visit',
                      'Understand a prescription or report',
                      'Manage family health records',
                      'Find nearby care',
                    ]
                    .map(
                      (purpose) => RadioListTile<String>(
                        value: purpose,
                        title: Text(purpose),
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }
}

class _ConsentStep extends StatelessWidget {
  const _ConsentStep({required this.viewModel, required this.model});

  final OnboardingViewModel viewModel;
  final OnboardingModel model;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          'Review required consents',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'AI is an aid, not a certified medical translator. '
              'You can review and edit every result. Emergency guidance '
              'is never blocked by consent.',
            ),
          ),
        ),
        CheckboxListTile(
          value: model.termsAccepted,
          title: const Text('I accept the terms'),
          onChanged: (value) => viewModel.setTermsAccepted(value ?? false),
        ),
        CheckboxListTile(
          value: model.privacyAccepted,
          title: const Text('I accept the privacy notice'),
          onChanged: (value) => viewModel.setPrivacyAccepted(value ?? false),
        ),
        CheckboxListTile(
          value: model.healthDataAccepted,
          title: const Text('I consent to health-data storage'),
          onChanged: (value) => viewModel.setHealthDataAccepted(value ?? false),
        ),
        CheckboxListTile(
          value: model.aiProcessingAccepted,
          title: const Text('I consent to AI processing'),
          onChanged: (value) =>
              viewModel.setAiProcessingAccepted(value ?? false),
        ),
      ],
    );
  }
}
