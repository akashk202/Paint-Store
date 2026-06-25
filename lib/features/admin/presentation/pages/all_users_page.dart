import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:c_h_p/features/user/presentation/providers/user_providers.dart';

class AllUsersPage extends ConsumerStatefulWidget {
  const AllUsersPage({super.key});

  @override
  ConsumerState<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends ConsumerState<AllUsersPage> {

  Future<void> _promoteToManager(String userId, String userName) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Promote User', style: GoogleFonts.poppins()),
          content: Text('Are you sure you want to promote "$userName" to a Manager role?', style: GoogleFonts.poppins()),
          actions: [
            TextButton(
              child: Text('Cancel', style: GoogleFonts.poppins()),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              child: Text('Promote', style: GoogleFonts.poppins()),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await ref.read(updateUserRoleUseCaseProvider).call(uid: userId, role: 'Manager');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$userName has been promoted to Manager.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to promote user: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  void _confirmDelete(BuildContext context, String key, String name) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text('Confirm Deletion', style: GoogleFonts.poppins()),
          content: Text('Are you sure you want to delete the user "$name"? This action cannot be undone.', style: GoogleFonts.poppins()),
          actions: [
            TextButton(
              child: Text('Cancel', style: GoogleFonts.poppins()),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('Delete', style: GoogleFonts.poppins()),
              onPressed: () async {
                try {
                  await ref.read(deleteUserUseCaseProvider).call(key);
                  if (!ctx.mounted) return;
                  Navigator.of(ctx).pop();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User deleted successfully")),
                  );
                } catch (e) {
                  if (!ctx.mounted) return;
                  Navigator.of(ctx).pop();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete: $e'), backgroundColor: Colors.red),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncUsers = ref.watch(allUsersStreamProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("All Users", style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: Colors.red.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: asyncUsers.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.deepOrange)),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Colors.deepOrange));
          }

          final usersMap = Map<String, dynamic>.from(data);
          final usersList = usersMap.entries.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: usersList.length,
            itemBuilder: (context, index) {
              final userKey = usersList[index].key;
              final userData = Map<String, dynamic>.from(usersList[index].value as Map);
              final name = userData['name'] ?? 'No Name';
              final email = userData['email'] ?? 'No Email';
              final userType = userData['userType'] ?? 'N/A';
              final photoUrl = userData['photoUrl'] as String?;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.red.withValues(alpha: 0.1),
                      backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                          ? NetworkImage(photoUrl)
                          : null,
                      child: (photoUrl == null || photoUrl.isEmpty)
                          ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold),
                      )
                          : null,
                    ),
                    title: Text(name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    subtitle: Text('$email\nRole: $userType', style: GoogleFonts.poppins()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (userType == 'Customer')
                          IconButton(
                            icon: const Icon(Iconsax.arrow_up_1, color: Colors.green),
                            tooltip: 'Promote to Manager',
                            onPressed: () => _promoteToManager(userKey, name),
                          ),
                        IconButton(
                          icon: const Icon(Iconsax.trash, color: Colors.red),
                          tooltip: 'Delete User',
                          onPressed: () => _confirmDelete(context, userKey, name),
                        ),
                      ],
                    ),
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
