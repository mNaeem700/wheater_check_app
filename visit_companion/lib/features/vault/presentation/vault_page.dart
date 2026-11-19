import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'document_editor_page.dart';
import 'vault_view_model.dart';

class VaultPage extends StatefulWidget {
  const VaultPage({super.key});

  @override
  State<VaultPage> createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VaultViewModel>().loadDocuments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VaultViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Vault')),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              viewModel.startDocument();
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const DocumentEditorPage(),
                ),
              );
            },
            icon: const Icon(Icons.document_scanner_outlined),
            label: const Text('Add document'),
          ),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.documents.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Add a prescription or report to review and explain it.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                  itemCount: viewModel.documents.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final document = viewModel.documents[index];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.description_outlined),
                        ),
                        title: Text(document.title),
                        subtitle: Text(
                          document.reportProblem
                              ? 'Flagged for review'
                              : 'Explanation available',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  DocumentEditorPage(document: document),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
