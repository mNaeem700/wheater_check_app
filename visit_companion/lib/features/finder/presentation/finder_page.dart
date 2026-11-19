import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/facility_model.dart';
import 'facility_detail_page.dart';
import 'finder_view_model.dart';

class FinderPage extends StatefulWidget {
  const FinderPage({super.key});

  @override
  State<FinderPage> createState() => _FinderPageState();
}

class _FinderPageState extends State<FinderPage> {
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FinderViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Find care')),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'City or postcode',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      onChanged: viewModel.setLocation,
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterDropdown(
                            label: 'Type',
                            value: viewModel.facilityType,
                            values: const [
                              'All',
                              'Clinic',
                              'Pharmacy',
                              'Lab',
                              'Hospital',
                            ],
                            onChanged: viewModel.setFacilityType,
                          ),
                          const SizedBox(width: 8),
                          _FilterDropdown(
                            label: 'Language',
                            value: viewModel.language,
                            values: const ['Any', 'English', 'Urdu'],
                            onChanged: viewModel.setLanguage,
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            label: const Text('Open now'),
                            selected: viewModel.openNow,
                            onSelected: viewModel.setOpenNow,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: viewModel.isLoading
                            ? null
                            : viewModel.search,
                        icon: const Icon(Icons.search),
                        label: const Text('Search'),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : viewModel.results.isEmpty
                    ? const Center(
                        child: Text('Search for a clinic, pharmacy or lab.'),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: viewModel.results.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final facility = viewModel.results[index];
                          return _FacilityCard(facility: facility);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.values,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> values;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      label: Text(label),
      initialSelection: value,
      dropdownMenuEntries: [
        for (final item in values)
          DropdownMenuEntry<String>(value: item, label: item),
      ],
      onSelected: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _FacilityCard extends StatelessWidget {
  const _FacilityCard({required this.facility});

  final FacilityModel facility;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => FacilityDetailPage(facility: facility),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      facility.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    facility.isOpen ? 'Open' : 'Closed',
                    style: TextStyle(
                      color: facility.isOpen
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFC62828),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text('${facility.type} • ${facility.distanceKm} km'),
              const SizedBox(height: 6),
              Text(facility.address),
              const SizedBox(height: 8),
              Text('Languages: ${facility.languages.join(', ')}'),
            ],
          ),
        ),
      ),
    );
  }
}
