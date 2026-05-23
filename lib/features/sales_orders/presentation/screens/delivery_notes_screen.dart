import 'package:erp_sales/features/sales_orders/data/repo/delivery_note_details_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_notes_list_repository.dart';
import 'package:erp_sales/features/sales_orders/presentation/cubit/delivery_notes_cubit.dart';
import 'package:erp_sales/features/sales_orders/presentation/cubit/delivery_note_state.dart';
import 'package:erp_sales/features/sales_orders/presentation/screens/delivery_note_details_screen.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/delivery_notes_top_bar.dart';
import '../widgets/delivery_notes_search_box.dart';
import '../widgets/delivery_note_card.dart';
import '../widgets/delivery_empty_view.dart';
import '../widgets/delivery_error_view.dart';

class DeliveryNotesScreen extends StatelessWidget {
  final DeliveryNotesListRepository deliveryNotesListRepository;

  const DeliveryNotesScreen({
    super.key,
    required this.deliveryNotesListRepository,
  });

  @override
  Widget build(BuildContext context) {
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
            DeliveryNotesTopBar(
              title: l10n.deliveryNotesTitle,
              onBack: () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
              child: DeliveryNotesSearchBox(
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
                    return DeliveryErrorView(
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
                      final matchesStatus = selectedStatus == 'All' ||
                          note.status == selectedStatus;

                      return matchesSearch && matchesStatus;
                    }).toList();

                    if (notes.isEmpty) {
                      return DeliveryEmptyView(
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

                          return DeliveryNoteCard(
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
