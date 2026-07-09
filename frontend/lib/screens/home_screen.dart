import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../routes/app_routes.dart';
import '../providers/weather_provider.dart';
import '../widgets/animated_background.dart';
import '../widgets/weather_particles.dart';
import '../widgets/weather_card_3d.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/forecast_list.dart';
import '../widgets/glass_container.dart';
import '../utils/weather_utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, _) {
        SkyMood mood = SkyMood.clearDay;
        if (provider.current != null) {
          final w = provider.current!;
          final isDay = WeatherUtils.isDayTime(w.dt, w.sunrise, w.sunset);
          mood = WeatherUtils.moodFor(w.condition, isDay: isDay);
        }

        return Scaffold(
          body: AnimatedBackground(
            mood: mood,
            child: Stack(
              children: [
                Positioned.fill(child: WeatherParticles(mood: mood)),
                SafeArea(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      if (provider.current != null) {
                        await provider.loadByCity(provider.current!.city,
                            silent: true);
                      } else {
                        await provider.loadByCurrentLocation();
                      }
                    },
                    color: Colors.white,
                    backgroundColor: Colors.black45,
                    child: _buildBody(context, provider),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, WeatherProvider provider) {
    if (provider.status == LoadStatus.loading && provider.current == null) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.white));
    }

    if (provider.status == LoadStatus.error && provider.current == null) {
      return _ErrorState(provider: provider);
    }

    if (provider.current == null) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.white));
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        _TopBar(provider: provider),
        const SizedBox(height: 18),
        WeatherCard3D(
          weather: provider.current!,
          mood: WeatherUtils.moodFor(
            provider.current!.condition,
            isDay: WeatherUtils.isDayTime(
              provider.current!.dt,
              provider.current!.sunrise,
              provider.current!.sunset,
            ),
          ),
          unitSymbol: provider.unitSymbol,
        ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.08, end: 0),
        const SizedBox(height: 18),
        if (provider.forecast != null) ...[
          const _SectionLabel(text: 'Hourly forecast'),
          const SizedBox(height: 8),
          HourlyForecastList(
            hourly: provider.forecast!.hourly,
            unitSymbol: provider.unitSymbol,
          ),
          const SizedBox(height: 18),
          const _SectionLabel(text: '5-day forecast'),
          const SizedBox(height: 8),
          DailyForecastList(
            daily: provider.forecast!.daily,
            unitSymbol: provider.unitSymbol,
          ),
        ],
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  final WeatherProvider provider;
  const _TopBar({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.search),
            child: GlassContainer(
              borderRadius: 18,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    provider.current?.city ?? 'Search city',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _RoundIconButton(
          icon: Icons.my_location_rounded,
          onTap: () => provider.loadByCurrentLocation(),
        ),
        const SizedBox(width: 10),
        _RoundIconButton(
          icon: provider.useCelsius
              ? Icons.thermostat_rounded
              : Icons.ac_unit_rounded,
          label: provider.unitSymbol,
          onTap: () => provider.toggleUnits(),
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap, this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        borderRadius: 18,
        padding: const EdgeInsets.all(12),
        child: label == null
            ? Icon(icon, size: 20)
            : Row(children: [
                Icon(icon, size: 18),
                const SizedBox(width: 4),
                Text(label!, style: const TextStyle(fontSize: 13))
              ]),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white.withOpacity(0.75),
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final WeatherProvider provider;
  const _ErrorState({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: GlassContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 48),
              const SizedBox(height: 12),
              Text(
                provider.errorMessage ?? 'Something went wrong',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => provider.loadByCurrentLocation(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.search),
                child: const Text('Search a city instead',
                    style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
