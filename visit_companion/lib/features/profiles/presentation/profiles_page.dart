import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/profile_model.dart';
import 'profile_editor_page.dart';
import 'profile_view_model.dart';

class ProfilesPage extends StatefulWidget {
  const ProfilesPage({super.key});

  @override
  State<ProfilesPage> createState() => _ProfilesPageState();
}

class _ProfilesPageState extends State<ProfilesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().loadProfiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Profiles')),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              viewModel.startNewProfile();
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ProfileEditorPage(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add profile'),
          ),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.profiles.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Add a person who may need visit preparation or emergency information.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                  itemCount: viewModel.profiles.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final profile = viewModel.profiles[index];
                    return _ProfileCard(
                      profile: profile,
                      onEdit: () {
                        viewModel.editProfile(profile);
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const ProfileEditorPage(),
                          ),
                        );
                      },
                      onDelete: () => viewModel.deleteProfile(profile.id),
                    );
                  },
                ),
        );
      },
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.profile,
    required this.onEdit,
    required this.onDelete,
  });

  final ProfileModel profile;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            profile.name.isEmpty ? '?' : profile.name.trim()[0].toUpperCase(),
          ),
        ),
        title: Text(profile.name),
        subtitle: Text(
          '${profile.country}${profile.region.isEmpty ? '' : ', ${profile.region}'}',
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }
}
