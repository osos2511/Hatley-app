import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatley/presentation/screens/home/home_drawer/widgets/custom_address_block.dart';
import 'package:hatley/presentation/screens/home/home_drawer/widgets/edit_order_dialog.dart';
import '../../../../../core/missing_fields_dialog.dart';
import '../../../../cubit/make_orders_cubit/make_order_state.dart';
import '../../../../cubit/make_orders_cubit/make_orders_cubit.dart';
import '../widgets/custom_info_row.dart';
import '../widgets/custom_order_button.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<MakeOrderCubit, MakeOrderState>(
        builder: (context, state) {
          final orders = context.watch<MakeOrderCubit>().orders;
          // Future.microtask(() => context.read<MakeOrderCubit>().fetchOrders());
          // if(state.isLoading){
          //   return Center(child: CircularProgressIndicator());
          // }
          if (orders.isEmpty) {
            return Center(
              child: Text(
                'لا توجد طلبات حالياً',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Center(
                child: Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomInfoRow(
                        title: "Price:",
                        value: order.price,
                        valueColor: Colors.green,
                      ),
                      CustomInfoRow(
                        title: "Date:",
                        value:
                            order.selectedDate?.toString().split(' ').first ??
                            '',
                      ),
                      CustomInfoRow(
                        title: "Time:",
                        value: order.selectedTime?.format(context) ?? '',
                      ),

                      SizedBox(height: 16),

                      Text(
                        "Order Details:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(8),
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(order.details),
                      ),

                      SizedBox(height: 20),
                      _sectionTitle("From:"),
                      CustomAddressBlock(
                        values: [
                          order.selectedGovernorateFrom ?? '',
                          order.selectedCityFrom ?? '',
                          order.selectedStateFrom ?? '',
                          order.fromAddress,
                        ],
                      ),

                      SizedBox(height: 20),
                      _sectionTitle("To:"),
                      CustomAddressBlock(
                        values: [
                          order.selectedGovernorateTo ?? '',
                          order.selectedCityTo ?? '',
                          order.selectedStateTo ?? '',
                          order.toAddress,
                        ],
                        isArabic: false,
                      ),

                      SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomOrderButton(
                            backgroundColor: Colors.blue,
                            text: "Edit",
                            onPressed: () {
                              final cubit = context.read<MakeOrderCubit>();
                              final selectOrder = orders[index];
                              cubit.loadOrderForEdit(selectOrder);
                              showEditOrderDialog(context, cubit, index);
                            },
                          ),
                          CustomOrderButton(
                            text: "Cancel",
                            backgroundColor: Colors.red,
                            onPressed: () {
                              showMissingFieldsDialog(
                                context,
                                'Are you sure you want to cancel the order?',
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
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }
}
