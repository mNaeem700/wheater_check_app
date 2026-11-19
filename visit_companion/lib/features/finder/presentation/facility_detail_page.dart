import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../domain/facility_model.dart';

class FacilityDetailPage extends StatelessWidget {
  const FacilityDetailPage({super.key, required this.facility});

  final FacilityModel facility;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(facility.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    facility.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text('${facility.type} • ${facility.distanceKm} km'),
                  Text(facility.address),
                  const SizedBox(height: 12),
                  Text(facility.isOpen ? 'Currently open' : 'Currently closed'),
                  Text('Languages: ${facility.languages.join(', ')}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              await launchUrl(Uri.parse('tel:${facility.phone}'));
            },
            icon: const Icon(Icons.phone),
            label: const Text('Call facility'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              final query = Uri.encodeComponent(facility.address);
              await launchUrl(
                Uri.parse(
                  'https://www.google.com/maps/search/?api=1&query=$query',
                ),
                mode: LaunchMode.externalApplication,
              );
            },
            icon: const Icon(Icons.directions),
            label: const Text('Navigate'),
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Facility details are for navigation support and are not an endorsement.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
