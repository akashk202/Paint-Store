import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import 'package:c_h_p/features/user/presentation/providers/user_providers.dart';

class ManagerRequestsPage extends ConsumerStatefulWidget {
  const ManagerRequestsPage({super.key});

  @override
  ConsumerState<ManagerRequestsPage> createState() => _ManagerRequestsPageState();
}

class _ManagerRequestsPageState extends ConsumerState<ManagerRequestsPage> {
  List<Map<String, dynamic>> _pendingRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPendingRequests();
  }

  Future<void> _fetchPendingRequests() async {
    final result = await ref.read(fetchPendingManagerRequestsUseCaseProvider).call(const NoParams());
    if (!mounted) return;
    result.fold(
      (failure) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load requests: ${failure.message}')));
      },
      (requests) {
        setState(() {
          _pendingRequests = requests;
          _isLoading = false;
        });
      },
    );
  }

  Future<void> _approveRequest(String uid) async {
    final result = await ref.read(approveManagerRequestUseCaseProvider).call(uid);
    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to approve request: ${failure.message}"), backgroundColor: Colors.red),
          );
        }
      },
      (_) async {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Manager request approved")),
          );
          await _fetchPendingRequests();
        }
      },
    );
  }

  Future<void> _denyRequest(String uid) async {
    final result = await ref.read(denyManagerRequestUseCaseProvider).call(uid);
    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to deny request: ${failure.message}"), backgroundColor: Colors.red),
          );
        }
      },
      (_) async {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Manager request denied")),
          );
          await _fetchPendingRequests();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Users", style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: Colors.deepOrange,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pendingRequests.isEmpty
          ? Center(
        child: Text(
          "No pending manager requests",
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _pendingRequests.length,
        itemBuilder: (context, index) {
          final user = _pendingRequests[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(user['name'] ?? 'Unknown',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              subtitle: Text(user['email'] ?? '',
                  style: GoogleFonts.poppins(fontSize: 13)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                    onPressed: () => _approveRequest(user['uid']),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () => _denyRequest(user['uid']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
