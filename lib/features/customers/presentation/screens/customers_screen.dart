import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:erp_sales/features/customers/data/repo/customers_repository.dart';
import 'package:erp_sales/features/customers/presentation/cubit/customers/customers_cubit.dart';
import 'package:erp_sales/features/customers/presentation/cubit/customers/customers_state.dart';
import 'package:erp_sales/features/customers/presentation/widgets/customer_card.dart';
import 'package:erp_sales/features/customers/presentation/widgets/customers_empty_state.dart';
import 'package:erp_sales/features/customers/presentation/widgets/customers_hero_header.dart';
import 'package:erp_sales/features/customers/presentation/widgets/customers_search_box.dart';
import 'package:erp_sales/features/customers/presentation/widgets/customers_stat_card.dart';
import 'package:erp_sales/features/customers/presentation/widgets/customers_status_views.dart';
import 'create_customer_screen.dart';

class CustomersScreen extends StatelessWidget {
  final CustomersRepository customersRepository;

  const CustomersScreen({super.key, required this.customersRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomersCubit(customersRepository)..getCustomers(),
      child: CustomersView(customersRepository: customersRepository),
    );
  }
}

class CustomersView extends StatefulWidget {
  final CustomersRepository customersRepository;

  const CustomersView({super.key, required this.customersRepository});

  @override
  State<CustomersView> createState() => _CustomersViewState();
}

class _CustomersViewState extends State<CustomersView> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _navigateToCreateCustomer(BuildContext context) async {
    final cubit = context.read<CustomersCubit>();

    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => CreateCustomerScreen(
          customersRepository: widget.customersRepository,
        ),
      ),
    );

    if (result == true && mounted) {
      cubit.getCustomers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCreateCustomer(context),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.addCustomer),
      ),
      body: BlocBuilder<CustomersCubit, CustomersState>(
        builder: (context, state) {
          if (state is CustomersLoading) {
            return const CustomersLoadingView();
          }

          if (state is CustomersError) {
            return CustomersErrorView(
              message: state.message,
              onRetry: () => context.read<CustomersCubit>().getCustomers(),
            );
          }

          if (state is CustomersSuccess) {
            final customers = state.customers;
            final filteredCustomers = customers.where((customer) {
              final q = _query.toLowerCase().trim();
              if (q.isEmpty) return true;

              return customer.customerName.toLowerCase().contains(q) ||
                  customer.name.toLowerCase().contains(q) ||
                  customer.customerType.toLowerCase().contains(q) ||
                  (customer.customerGroup ?? '').toLowerCase().contains(q) ||
                  (customer.territory ?? '').toLowerCase().contains(q);
            }).toList();

            final companies = customers
                .where((c) => c.customerType.toLowerCase() == 'company')
                .length;

            final individuals = customers
                .where((c) => c.customerType.toLowerCase() == 'individual')
                .length;

            return RefreshIndicator(
              onRefresh: () => context.read<CustomersCubit>().getCustomers(),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  CustomersHeroHeader(
                    totalCustomers: customers.length,
                    onBack: () => Navigator.pop(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 90),
                    child: Column(
                      children: [
                        CustomersStatsGrid(
                          children: [
                            CustomerStatCard(
                              title: 'Total',
                              value: customers.length.toString(),
                              icon: Icons.people_outline,
                              color: const Color(0xFF42A5F5),
                            ),
                            CustomerStatCard(
                              title: l10n.company,
                              value: companies.toString(),
                              icon: Icons.business_outlined,
                              color: const Color(0xFF9B59B6),
                            ),
                            CustomerStatCard(
                              title: l10n.individual,
                              value: individuals.toString(),
                              icon: Icons.person_outline_rounded,
                              color: const Color(0xFF2ECC71),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        CustomersSearchBox(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() => _query = value);
                          },
                          onClear: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        ),

                        const SizedBox(height: 18),

                        if (customers.isEmpty)
                          CustomersEmptyState(
                            icon: Icons.people_outline,
                            title: l10n.noCustomersFound,
                            message:
                                'Create your first customer to start selling.',
                            actionLabel: l10n.addCustomer,
                            onAction: () =>
                                _navigateToCreateCustomer(context),
                          )
                        else if (filteredCustomers.isEmpty)
                          const CustomersEmptyState(
                            icon: Icons.search_off_rounded,
                            title: 'No matching customers',
                            message:
                                'Try searching with another name, type, or territory.',
                          )
                        else
                          Column(
                            children: filteredCustomers.asMap().entries.map((
                              entry,
                            ) {
                              final index = entry.key;
                              final customer = entry.value;

                              return CustomerCard(
                                    name: customer.customerName,
                                    id: customer.name,
                                    type: customer.customerType,
                                    group:
                                        customer.customerGroup ?? l10n.notSet,
                                    territory:
                                        customer.territory ?? l10n.notSet,
                                    isDark: isDark,
                                  )
                                  .animate()
                                  .fade(
                                    delay: (index * 45).ms,
                                    duration: 350.ms,
                                  )
                                  .slideY(begin: .08, duration: 350.ms);
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
