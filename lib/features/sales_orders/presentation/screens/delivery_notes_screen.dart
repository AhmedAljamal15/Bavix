import 'package:erp_sales/features/sales_orders/data/repo/delivery_note_details_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_notes_list_repository.dart';
import 'package:erp_sales/features/sales_orders/presentation/cubit/delivery_notes_cubit.dart';
import 'package:erp_sales/features/sales_orders/presentation/cubit/delivery_note_state.dart';
import 'package:erp_sales/features/sales_orders/presentation/screens/delivery_note_details_screen.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryNotesScreen extends StatelessWidget {
  final DeliveryNotesListRepository deliveryNotesListRepository;

  const DeliveryNotesScreen({
    super.key,
    required this.deliveryNotesListRepository,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) =>
          DeliveryNotesCubit(deliveryNotesListRepository)..getDeliveryNotes(),
      child: const DeliveryNotesView(),
    );
  }
}

class DeliveryNotesView extends StatefulWidget {
  const DeliveryNotesView({super.key});

  @override
  State<DeliveryNotesView> createState() => _DeliveryNotesViewState();
}

class _DeliveryNotesViewState extends State<DeliveryNotesView> {
  final TextEditingController searchController = TextEditingController();
  String query = '';
  String selectedStatus = 'All';

  static const Color primary = Color(0xFF60A5FA);
  static const Color bgDark = Color(0xFF020617);
  static const Color cardDark = Color(0xFF101A35);

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF2ECC71);
      case 'draft':
        return const Color(0xFF42A5F5);
      case 'to bill':
        return primary;
      case 'cancelled':
        return const Color(0xFFE74C3C);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final detailsRepo = context.read<DeliveryNoteDetailsRepository>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? bgDark
          : Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              title: AppLocalizations.of(context)!.deliveryNotesTitle,
              onBack: () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
              child: _SearchBox(
                controller: searchController,
                selectedStatus: selectedStatus,
                onChanged: (value) {
                  setState(() => query = value.trim().toLowerCase());
                },
                onStatusChanged: (value) {
                  setState(() => selectedStatus = value);
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<DeliveryNotesCubit, DeliveryNotesState>(
                builder: (context, state) {
                  if (state is DeliveryNotesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is DeliveryNotesError) {
                    return _ErrorView(
                      message: state.message,
                      onRetry: () =>
                          context.read<DeliveryNotesCubit>().getDeliveryNotes(),
                    );
                  }

                  if (state is DeliveryNotesSuccess) {
                    final notes = state.notes.where((note) {
                      final text =
                          '${note.name} ${note.customer} ${note.status}'
                              .toLowerCase();

                      final matchesSearch = text.contains(query);
                      final matchesStatus =
                          selectedStatus == 'All' ||
                          note.status == selectedStatus;

                      return matchesSearch && matchesStatus;
                    }).toList();

                    if (notes.isEmpty) {
                      return _EmptyView(
                        title: query.isEmpty
                            ? 'No delivery notes found'
                            : 'No matching delivery notes',
                        subtitle: query.isEmpty
                            ? 'Delivery notes will appear here once created.'
                            : 'Try another search keyword.',
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () =>
                          context.read<DeliveryNotesCubit>().getDeliveryNotes(),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(18, 6, 18, 26),
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final note = notes[index];
                          final color = statusColor(note.status);

                          return _DeliveryNoteCard(
                            name: note.name,
                            customer: note.customer,
                            postingDate: note.postingDate,
                            grandTotal: '${note.grandTotal}',
                            status: note.status,
                            statusColor: color,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DeliveryNoteDetailsScreen(
                                    noteId: note.name,
                                    repository: detailsRepo,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _TopBar({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 18, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: dark ? Colors.white : Colors.black87,
            ),
          ),
          const Icon(Icons.local_shipping_outlined, color: Color(0xFF60A5FA)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: dark ? Colors.white : Colors.black87,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final String selectedStatus;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onStatusChanged;

  const _SearchBox({
    required this.controller,
    required this.selectedStatus,
    required this.onChanged,
    required this.onStatusChanged,
  });

  void _openFilter(BuildContext context) {
    final statuses = ['All', 'Draft', 'To Bill', 'Completed', 'Cancelled'];

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Filter by status',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                ...statuses.map((status) {
                  final selected = selectedStatus == status;

                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    leading: Icon(
                      selected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: selected ? const Color(0xFF60A5FA) : Colors.grey,
                    ),
                    title: Text(
                      status,
                      style: TextStyle(
                        fontWeight: selected
                            ? FontWeight.w900
                            : FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      onStatusChanged(status);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: dark ? const Color(0xFF101A35) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF60A5FA).withValues(alpha: .18)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(
                Icons.search_rounded,
                color: dark ? Colors.white54 : Colors.black45,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  decoration: const InputDecoration(
                    hintText: 'Search delivery notes...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _openFilter(context),
                icon: Icon(
                  Icons.filter_alt_outlined,
                  color: selectedStatus == 'All'
                      ? (dark ? Colors.white54 : Colors.black54)
                      : const Color(0xFF60A5FA),
                ),
              ),
            ],
          ),
        ),
        if (selectedStatus != 'All') ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              label: Text('${l10n.statusLabel}: $selectedStatus'),
              deleteIcon: const Icon(Icons.close_rounded, size: 18),
              onDeleted: () => onStatusChanged('All'),
            ),
          ),
        ],
      ],
    );
  }
}

class _DeliveryNoteCard extends StatelessWidget {
  final String name;
  final String customer;
  final String postingDate;
  final String grandTotal;
  final String status;
  final Color statusColor;
  final VoidCallback onTap;

  const _DeliveryNoteCard({
    required this.name,
    required this.customer,
    required this.postingDate,
    required this.grandTotal,
    required this.status,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF101A35) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF60A5FA).withValues(alpha: .22)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const _IconBox(
                  icon: Icons.local_shipping_outlined,
                  color: Color(0xFF60A5FA),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: dark ? Colors.white : Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                _Badge(label: status, color: statusColor),
              ],
            ),
            const SizedBox(height: 16),
            _InfoLine(icon: Icons.person_outline, text: customer),
            const SizedBox(height: 10),
            _InfoLine(icon: Icons.calendar_month_outlined, text: postingDate),
            const SizedBox(height: 10),
            _InfoLine(icon: Icons.payments_outlined, text: '$grandTotal EGP'),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Icon(icon, size: 17, color: const Color(0xFF60A5FA)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: dark ? Colors.white70 : Colors.black54,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Icon(
          Icons.chevron_right_rounded,
          color: dark ? Colors.white30 : Colors.black26,
        ),
      ],
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconBox({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color.withValues(alpha: .14),
      ),
      child: Icon(icon, color: color),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: color.withValues(alpha: .14),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final String title;
  final String subtitle;

  const _EmptyView({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping_outlined,
              size: 60,
              color: dark ? Colors.white38 : Colors.black26,
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                color: dark ? Colors.white : Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: dark ? Colors.white54 : Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 54),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
