import 'package:flutter/material.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/features/items/data/repo/items_repository.dart';
import '../item_cubit.dart';
import '../create_item_state.dart';
import 'package:erp_sales/core/helpers/app_toast.dart';

class CreateItemScreen extends StatelessWidget {
  final ItemsRepository itemsRepository;

  const CreateItemScreen({super.key, required this.itemsRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateItemCubit(itemsRepository),
      child: const CreateItemView(),
    );
  }
}

class CreateItemView extends StatefulWidget {
  const CreateItemView({super.key});

  @override
  State<CreateItemView> createState() => _CreateItemViewState();
}

class _CreateItemViewState extends State<CreateItemView> {
  late final TextEditingController _itemCodeController;
  late final TextEditingController _itemNameController;
  late final TextEditingController _itemGroupController;
  late final TextEditingController _stockUomController;
  late final TextEditingController _countryOfOriginController;

  bool _isStockItem = true;
  bool _isSalesItem = true;

  final _formKey = GlobalKey<FormState>();

  static const Color primary = Color(0xFF60A5FA);
  static const Color bgDark = Color(0xFF020617);
  static const Color cardDark = Color(0xFF101A35);
  static const Color fieldDark = Color(0xFF0B1228);

  @override
  void initState() {
    super.initState();
    _itemCodeController = TextEditingController();
    _itemNameController = TextEditingController();
    _itemGroupController = TextEditingController(text: 'Products');
    _stockUomController = TextEditingController(text: 'Nos');
    _countryOfOriginController = TextEditingController(text: 'Egypt');
  }

  @override
  void dispose() {
    _itemCodeController.dispose();
    _itemNameController.dispose();
    _itemGroupController.dispose();
    _stockUomController.dispose();
    _countryOfOriginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<CreateItemCubit, CreateItemState>(
      listener: (context, state) {
        if (state is CreateItemSuccess) {
          AppToast.success(l10n.itemCreatedSuccessfully);
          Navigator.pop(context, true);
        } else if (state is CreateItemError) {
          AppToast.error(state.message);
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? bgDark : const Color(0xFFF5F7FB),
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 120),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _TopBar(
                    title: l10n.createItemTitle,
                    onBack: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 18),
                  _HeroCard(
                    title: 'New Inventory Item',
                    subtitle:
                        'Create a stock or sales item for ERP operations.',
                  ),
                  const SizedBox(height: 18),
                  _FormCard(
                    child: Column(
                      children: [
                        _PremiumTextField(
                          controller: _itemCodeController,
                          label: l10n.itemCode,
                          hint: l10n.enterItemCode,
                          icon: Icons.code_rounded,
                        ),
                        const SizedBox(height: 16),
                        _PremiumTextField(
                          controller: _itemNameController,
                          label: l10n.itemName,
                          hint: l10n.enterItemName,
                          icon: Icons.label_outline_rounded,
                        ),
                        const SizedBox(height: 16),
                        _PremiumTextField(
                          controller: _itemGroupController,
                          label: l10n.itemGroup,
                          hint: l10n.enterItemGroup,
                          icon: Icons.category_outlined,
                        ),
                        const SizedBox(height: 16),
                        _PremiumTextField(
                          controller: _stockUomController,
                          label: l10n.stockUom,
                          hint: l10n.enterStockUom,
                          icon: Icons.straighten_rounded,
                        ),
                        const SizedBox(height: 16),
                        _PremiumTextField(
                          controller: _countryOfOriginController,
                          label: l10n.countryOfOrigin,
                          hint: l10n.enterCountryOfOrigin,
                          icon: Icons.public_rounded,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _FormCard(
                    child: Column(
                      children: [
                        _SwitchTile(
                          title: l10n.isStockItem,
                          subtitle: 'Track this item in inventory stock.',
                          icon: Icons.inventory_2_outlined,
                          value: _isStockItem,
                          onChanged: (value) {
                            setState(() => _isStockItem = value);
                          },
                        ),
                        const SizedBox(height: 12),
                        _SwitchTile(
                          title: l10n.isSalesItem,
                          subtitle: 'Allow this item to be used in sales.',
                          icon: Icons.sell_outlined,
                          value: _isSalesItem,
                          onChanged: (value) {
                            setState(() => _isSalesItem = value);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(18, 8, 18, 18),
          child: BlocBuilder<CreateItemCubit, CreateItemState>(
            builder: (context, state) {
              final isLoading = state is CreateItemLoading;

              return SizedBox(
                height: 54,
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () => _handleCreateItem(context),
                  icon: isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.add_rounded),
                  label: Text(
                    isLoading ? 'Creating...' : l10n.createItem,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleCreateItem(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      AppToast.error('Please check the form fields');
      return;
    }

    context.read<CreateItemCubit>().createItem(
      itemCode: _itemCodeController.text.trim(),
      itemName: _itemNameController.text.trim(),
      itemGroup: _itemGroupController.text.trim(),
      stockUom: _stockUomController.text.trim(),
      countryOfOrigin: _countryOfOriginController.text.trim(),
      isStockItem: _isStockItem,
      isSalesItem: _isSalesItem,
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _TopBar({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onBack,
          child: Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF101A35) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: .08) : Colors.black12,
              ),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF111827),
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 44),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _HeroCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF101A35), const Color(0xFF0B1228)]
              : [Colors.white, const Color(0xFFEFF6FF)],
        ),
        border: Border.all(color: const Color(0xFF60A5FA).withValues(alpha: .20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: isDark ? .18 : .06),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFF60A5FA).withValues(alpha: .14),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: Color(0xFF60A5FA),
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
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

class _FormCard extends StatelessWidget {
  final Widget child;

  const _FormCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101A35) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: .08) : Colors.black12,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: isDark ? .16 : .05),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _PremiumTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;

  const _PremiumTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      style: TextStyle(
        color: isDark ? Colors.white : const Color(0xFF111827),
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 10),
          child: Icon(icon, size: 21),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF0B1228) : const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        labelStyle: TextStyle(
          color: isDark ? Colors.white60 : Colors.black54,
          fontWeight: FontWeight.w800,
        ),
        hintStyle: TextStyle(
          color: isDark ? Colors.white38 : Colors.black38,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: .08) : Colors.black12,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF60A5FA), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.4),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }
        if (value.trim().length < 2) {
          return '$label must be at least 2 characters';
        }
        return null;
      },
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = value ? const Color(0xFF22C55E) : const Color(0xFF94A3B8);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1228) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: .22)),
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: color.withValues(alpha: .14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF22C55E),
          ),
        ],
      ),
    );
  }
}
