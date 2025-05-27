import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/presentation/screens/home/home_drawer/widgets/custom_order_button.dart';
import '../../../../cubit/make_orders_cubit/make_order_state.dart';
import '../../../../cubit/make_orders_cubit/make_orders_cubit.dart';

void showEditOrderDialog(BuildContext context, MakeOrderCubit cubit, int index) {
  showDialog(
    context: context,
    builder: (_) {
      return BlocBuilder<MakeOrderCubit, MakeOrderState>(
        bloc: cubit,
        builder: (context, state) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            contentPadding: const EdgeInsets.all(20),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Edit Order',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: cubit.detailsController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Order Details',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: cubit.priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Price (EGP)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => cubit.pickDate(context),
                          child: Text(
                            state.selectedDate?.toString().split(' ').first ?? 'Select Date',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => cubit.pickTime(context),
                          child: Text(
                            state.selectedTime?.format(context) ?? 'Select Time',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: cubit.fromAddressController,
                    decoration: const InputDecoration(
                      labelText: 'From Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: cubit.toAddressController,
                    decoration: const InputDecoration(
                      labelText: 'To Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomOrderButton(
                        text:'Cancel' ,
                        backgroundColor: Colors.red,
                        onPressed: () => Navigator.pop(context),
                      ),
                      CustomOrderButton(
                        backgroundColor:Colors.blue,
                        text: 'Save',
                        onPressed: () {
                          cubit.updateOrder(
                            index,
                            state.copyWith(
                              details: cubit.detailsController.text,
                              price: cubit.priceController.text,
                              fromAddress: cubit.fromAddressController.text,
                              toAddress: cubit.toAddressController.text,
                            ),
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
