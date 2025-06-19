import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatley/core/success_dialog.dart';
import 'package:hatley/injection_container.dart';
import 'package:hatley/presentation/cubit/make_orders_cubit/make_orders_cubit.dart';
import 'package:hatley/presentation/cubit/order_cubit/delete_order_cubit.dart';
import 'package:hatley/presentation/cubit/order_cubit/getAllOrders_cubit.dart';
import 'package:hatley/presentation/cubit/order_cubit/order_state.dart';
import 'package:hatley/presentation/screens/home/home_drawer/widgets/custom_address_block.dart';
import 'package:hatley/presentation/screens/home/home_drawer/widgets/edit_order_dialog.dart';
import '../../../../../core/missing_fields_dialog.dart';
import '../widgets/custom_info_row.dart';
import '../widgets/custom_order_button.dart';
import '../widgets/delivery_offer_listView.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  int? lastDeletedOrderId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<GetAllOrdersCubit>()..getAllOrders()),
        BlocProvider(create: (_) => sl<DeleteOrderCubit>()),
        BlocProvider.value(value: context.read<MakeOrderCubit>()),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<DeleteOrderCubit, OrderState>(
          listener: (context, state) {
            if (state is OrderSuccess) {
              if (lastDeletedOrderId != null) {
                context.read<GetAllOrdersCubit>().removeOrderById(
                  lastDeletedOrderId!,
                );
              }
              //context.read<GetAllOrdersCubit>().getAllOrders(); // تحديث الطلبات
            } else if (state is OrderFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("فشل الحذف: ${state.error}")),
              );
            }
          },
          child: BlocBuilder<GetAllOrdersCubit, OrderState>(
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
                              value:
                                  order.orderTime.toString().split(' ').first,
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
                                    print('Edit button clicked');
                                    final makeOrderCubit =
                                        context.read<MakeOrderCubit>();

                                    showEditOrderDialog(
                                      context,
                                      makeOrderCubit,
                                      order,
                                    );
                                  },
                                ),
                                CustomOrderButton(
                                  text: "Cancel",
                                  backgroundColor: Colors.red,
                                  onPressed: () {
                                    lastDeletedOrderId = order.orderId;
                                    showMissingFieldsDialog(
                                      context,
                                      'Are you sure you want to cancel the order?',

                                      onOkPressed: () {
                                        Navigator.of(context).pop();
                                        context.read<DeleteOrderCubit>().deleteOrder(order.orderId);
                                      },

                                    );
                                  },
                                ),
                              ],
                            ),
                            DeliveryOffersWidget(orderId: order.orderId)
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
