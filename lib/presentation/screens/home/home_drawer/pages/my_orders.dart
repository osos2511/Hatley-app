import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatley/injection_container.dart';
import 'package:hatley/presentation/cubit/order_cubit/getAllOrders_cubit.dart';
import 'package:hatley/presentation/cubit/order_cubit/order_state.dart';
import 'package:hatley/presentation/screens/home/home_drawer/widgets/custom_address_block.dart';
import '../../../../../core/missing_fields_dialog.dart';
import '../widgets/custom_info_row.dart';
import '../widgets/custom_order_button.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GetAllOrdersCubit>()..getAllOrders(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<GetAllOrdersCubit, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is OrderFailure) {
              return Center(child: Text("خطأ: ${state.error}"));
            } else if (state is GetAllOrdersSuccess) {
              final orders = state.orders;

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
                            value: order.price.toString(),
                            valueColor: Colors.green,
                          ),
                          CustomInfoRow(
                            title: "Date:",
                            value: order.orderTime.toString().split(' ').first,
                          ),
                          CustomInfoRow(
                            title: "Time:",
                            value:
                                order.orderTime
                                    .toString()
                                    .split(' ')
                                    .last
                                    .split('.')
                                    .first,
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
                            child: Text(order.description),
                          ),
                          SizedBox(height: 20),
                          _sectionTitle("From:"),
                          CustomAddressBlock(
                            values: [
                              order.orderGovernorateFrom,
                              order.orderCityFrom,
                              order.orderZoneFrom,
                              order.detailesAddressFrom,
                            ],
                          ),
                          SizedBox(height: 20),
                          _sectionTitle("To:"),
                          CustomAddressBlock(
                            values: [
                              order.orderGovernorateTo,
                              order.orderCityTo,
                              order.orderZoneTo,
                              order.detailesAddressTo,
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
                                  // تضيف التعديل المناسب هنا لو محتاج تعدل
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
            } else {
              return SizedBox.shrink();
            }
          },
        ),
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
