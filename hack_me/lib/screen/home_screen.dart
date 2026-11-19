import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

   final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('Hack Me', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.darkBlue,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Welcome ${user!.email ?? ''}',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Choose Mode',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            buildModeCard(
              context,
              title: 'Easy',
              description: 'Name, DOB, Field of Work',
              onTap: () => Navigator.pushNamed(context, '/game/easy'),
            ),
            const SizedBox(height: 20),
            buildModeCard(
              context,
              title: 'Hard',
              description: 'Name, Father Name, DOB',
              onTap: () => Navigator.pushNamed(context, '/game/hard'),
            ),
            const SizedBox(height: 20),
            buildModeCard(
              context,
              title: 'Expert',
              description: 'All Info + Tougher Guess',
              onTap: () => Navigator.pushNamed(context, '/game/expert'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildModeCard(
    BuildContext context, {
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColors.darkBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Icon(Icons.lock_outline, color: AppColors.primaryBlue, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: AppColors.gray,
                        fontSize: 14,
                      ),
                    ),
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
