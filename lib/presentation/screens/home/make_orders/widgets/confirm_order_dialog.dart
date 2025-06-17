import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/presentation/screens/home/home_drawer/widgets/custom_order_button.dart';
import '../../../../../core/routes_manager.dart';
import '../../../../../core/success_dialog.dart';
import '../../../../cubit/make_orders_cubit/make_order_state.dart';
import '../../../../cubit/make_orders_cubit/make_orders_cubit.dart';

void showConfirmOrderDialog(BuildContext context, MakeOrderState state) {
  final cubit = context.read<MakeOrderCubit>();
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(20),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Confirm Order',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Details:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(state.details),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Price:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${state.price} EGP',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text(
                    'Date:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(state.selectedDate?.toString().split(' ').first ?? ''),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Text(
                    'Time:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(state.selectedTime?.format(context) ?? ''),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'From:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${state.selectedGovernorateFrom ?? ''}, ${state.selectedCityFrom ?? ''}, ${state.selectedStateFrom ?? ''}',
              ),
              const SizedBox(height: 8),
              const Text('To:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '${state.selectedGovernorateTo ?? ''}, ${state.selectedCityTo ?? ''}, ${state.selectedStateTo ?? ''}',
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomOrderButton(
                    backgroundColor: Colors.red,
                    text: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                  ),
                  CustomOrderButton(
                    backgroundColor: Colors.blue,
                    text: 'Confirm',
                    onPressed: () {
                      Navigator.pop(context);

                      Future.delayed(const Duration(milliseconds: 300), () {
                        cubit.resetOrder();
                      });

                      showSuccessDialog(
                        context,
                        'thank you! send order has been successfully!',

                        nextRoute: RoutesManager.homeRoute,
                        arguments: 5,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
