import 'package:flutter/material.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/features/items/data/repo/items_repository.dart';
import '../cubit/create_item_cubit.dart';
import '../cubit/create_item_state.dart';
import 'package:erp_sales/core/helpers/app_toast.dart';
import '../widgets/create_item_top_bar.dart';
import '../widgets/create_item_hero_card.dart';
import '../widgets/form_card.dart';
import '../widgets/premium_text_field.dart';
import '../widgets/switch_tile.dart';

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
        backgroundColor: isDark ? const Color(0xFF020617) : const Color(0xFFF5F7FB),
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 120),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CreateItemTopBar(
                    title: l10n.createItemTitle,
                    onBack: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 18),
                  CreateItemHeroCard(
                    title: 'New Inventory Item',
                    subtitle:
                        'Create a stock or sales item for ERP operations.',
                  ),
                  const SizedBox(height: 18),
                  FormCard(
                    child: Column(
                      children: [
                        PremiumTextField(
                          controller: _itemCodeController,
                          label: l10n.itemCode,
                          hint: l10n.enterItemCode,
                          icon: Icons.code_rounded,
                        ),
                        const SizedBox(height: 16),
                        PremiumTextField(
                          controller: _itemNameController,
                          label: l10n.itemName,
                          hint: l10n.enterItemName,
                          icon: Icons.label_outline_rounded,
                        ),
                        const SizedBox(height: 16),
                        PremiumTextField(
                          controller: _itemGroupController,
                          label: l10n.itemGroup,
                          hint: l10n.enterItemGroup,
                          icon: Icons.category_outlined,
                        ),
                        const SizedBox(height: 16),
                        PremiumTextField(
                          controller: _stockUomController,
                          label: l10n.stockUom,
                          hint: l10n.enterStockUom,
                          icon: Icons.straighten_rounded,
                        ),
                        const SizedBox(height: 16),
                        PremiumTextField(
                          controller: _countryOfOriginController,
                          label: l10n.countryOfOrigin,
                          hint: l10n.enterCountryOfOrigin,
                          icon: Icons.public_rounded,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  FormCard(
                    child: Column(
                      children: [
                        SwitchTile(
                          title: l10n.isStockItem,
                          subtitle: 'Track this item in inventory stock.',
                          icon: Icons.inventory_2_outlined,
                          value: _isStockItem,
                          onChanged: (value) {
                            setState(() => _isStockItem = value);
                          },
                        ),
                        const SizedBox(height: 12),
                        SwitchTile(
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
