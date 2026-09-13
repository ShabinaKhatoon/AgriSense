import 'package:flutter/material.dart';

import '../models/farmer.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({
    super.key,
    required this.farmer,
    required this.onLogout,
  });

  final Farmer farmer;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        farmer.fullName,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        farmer.phone,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            _InfoTile(
              icon: Icons.location_on_outlined,
              label: 'Village',
              value: farmer.village.isEmpty ? 'Not added' : farmer.village,
            ),
            _InfoTile(
              icon: Icons.landscape_outlined,
              label: 'Farm Size',
              value: '${farmer.farmSizeAcres.toStringAsFixed(1)} acres',
            ),
            _InfoTile(
              icon: Icons.storage_outlined,
              label: 'Login Status',
              value: 'Saved in Django database',
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFD84315),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE1E8DC)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2E7D32)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
