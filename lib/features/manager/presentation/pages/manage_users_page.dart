import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:c_h_p/features/user/presentation/providers/user_providers.dart';
import 'package:c_h_p/features/user/domain/usecases/update_user_role.dart';

class ManageUsersPage extends ConsumerWidget {
  const ManageUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUsers = ref.watch(allUsersStreamProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Users', style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: Colors.pink.shade600,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: asyncUsers.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (data) {
          if (data.isEmpty) {
            return Center(
                child: Text('No users found', style: GoogleFonts.poppins()));
          }
          final entries = Map<String, dynamic>.from(data).entries.toList();
          entries.sort((a, b) {
            final an =
                (a.value is Map ? (a.value['name'] ?? '') : '').toString();
            final bn =
                (b.value is Map ? (b.value['name'] ?? '') : '').toString();
            return an.toString().compareTo(bn.toString());
          });
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final uid = entries[i].key;
              final m = Map<String, dynamic>.from(entries[i].value as Map);
              final name = (m['name'] ?? 'N/A').toString();
              final email = (m['email'] ?? '').toString();
              final phone = (m['phone'] ?? '').toString();
              final userType = (m['userType'] ?? 'Customer').toString();
              final photoUrl = (m['photoUrl'] ?? '').toString();
              final profile = m['profile'] is Map
                  ? Map<String, dynamic>.from(m['profile'])
                  : <String, dynamic>{};
              final addr =
                  (profile['address'] ?? m['address'] ?? '').toString();
              final loc = profile['location'] is Map
                  ? Map<String, dynamic>.from(profile['location'])
                  : <String, dynamic>{};
              final lat = (loc['lat'] as num?)?.toDouble();
              final lng = (loc['lng'] as num?)?.toDouble();

              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.pink.shade100,
                    backgroundImage:
                        photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                    child: photoUrl.isEmpty ? const Icon(Iconsax.user) : null,
                  ),
                  title: Text(name,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    'Email: $email\nPhone: $phone\nRole: $userType\nAddress: ${addr.isEmpty ? 'N/A' : addr}${lat != null && lng != null ? '\nLocation: ($lat, $lng)' : ''}\nUID: $uid',
                    style: GoogleFonts.poppins(height: 1.3),
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            final result = await ref.read(updateUserRoleUseCaseProvider).call(
                              UpdateUserRoleParams(uid: uid, role: value),
                            );
                            if (context.mounted) {
                              result.fold(
                                (failure) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed: ${failure.message}'), backgroundColor: Colors.red),
                                  );
                                },
                                (_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Role updated to $value')),
                                  );
                                },
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                                value: 'Customer', child: Text('Customer')),
                            const PopupMenuItem(
                                value: 'Manager', child: Text('Manager')),
                            const PopupMenuItem(
                                value: 'Admin', child: Text('Admin')),
                            const PopupMenuItem(
                                value: 'Painter', child: Text('Painter')),
                          ],
                          child: const Icon(Iconsax.edit, color: Colors.blue),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
