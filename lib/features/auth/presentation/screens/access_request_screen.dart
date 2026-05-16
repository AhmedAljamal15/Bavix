import 'package:erp_sales/features/auth/presentation/cubit.dart';
import 'package:erp_sales/features/auth/presentation/widgets/access_request_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/features/auth/data/repo/access_request_repository.dart';

class AccessRequestScreen extends StatelessWidget {
  final AccessRequestRepository accessRequestRepository;

  const AccessRequestScreen({super.key, required this.accessRequestRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AccessRequestCubit(accessRequestRepository),
      child: const AccessRequestView(),
    );
  }
}


