import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../models/weather_model.dart';
import '../widgets/animated_background.dart';
import '../widgets/glass_container.dart';
import '../utils/weather_utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List<CitySearchResult> _results = [];
  bool _loading = false;
  String? _error;

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.trim().length < 2) {
      setState(() => _results = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(value));
  }

  Future<void> _search(String query) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final provider = context.read<WeatherProvider>();
      final results = await provider.searchCities(query);
      if (!mounted) return;
      setState(() => _results = results);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return AnimatedBackground(
      mood: SkyMood.clearNight,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const Text('Search city', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 8),
              GlassContainer(
                borderRadius: 18,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  onChanged: _onChanged,
                  onSubmitted: (v) {
                    if (v.trim().isNotEmpty) {
                      context.read<WeatherProvider>().loadByCity(v.trim());
                      Navigator.of(context).pop();
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'e.g. Lahore, Tokyo, New York',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search_rounded, color: Colors.white70),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_loading) const LinearProgressIndicator(color: Colors.white, backgroundColor: Colors.white10),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(_error!, style: const TextStyle(color: Colors.redAccent)),
                ),
              Expanded(
                child: ListView(
                  children: [
                    if (_results.isNotEmpty) ...[
                      const _Label('Results'),
                      ..._results.map((r) => _CityTile(
                            title: r.displayName,
                            icon: Icons.location_city_rounded,
                            onTap: () {
                              provider.loadByCoords(r.lat, r.lon);
                              Navigator.of(context).pop();
                            },
                          )),
                    ],
                    if (provider.recentSearches.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const _Label('Recent'),
                          TextButton(
                            onPressed: () => provider.clearRecentSearches(),
                            child: const Text('Clear', style: TextStyle(color: Colors.white54, fontSize: 12)),
                          ),
                        ],
                      ),
                      ...provider.recentSearches.map((c) => _CityTile(
                            title: c,
                            icon: Icons.history_rounded,
                            onTap: () {
                              provider.loadByCity(c);
                              Navigator.of(context).pop();
                            },
                          )),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(text, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _CityTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _CityTile({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: GlassContainer(
          borderRadius: 14,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          opacity: 0.08,
          child: Row(
            children: [
              Icon(icon, size: 18, color: Colors.white70),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: const TextStyle(fontSize: 14))),
              const Icon(Icons.chevron_right_rounded, color: Colors.white38),
            ],
          ),
        ),
      ),
    );
  }
}
