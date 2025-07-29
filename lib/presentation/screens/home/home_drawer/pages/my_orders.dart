import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatley/core/colors_manager.dart';
import 'package:hatley/core/routes_manager.dart';
import 'package:hatley/injection_container.dart';
import 'package:hatley/presentation/cubit/make_orders_cubit/make_orders_cubit.dart';
import 'package:hatley/presentation/cubit/order_cubit/delete_order_cubit.dart';
import 'package:hatley/presentation/cubit/order_cubit/getAllOrders_cubit.dart';
import 'package:hatley/presentation/cubit/order_cubit/order_state.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_toast.dart';
import 'package:hatley/presentation/screens/home/home_drawer/widgets/custom_address_block.dart';
import 'package:hatley/presentation/screens/home/home_drawer/widgets/edit_order_dialog.dart';
import '../../../../../core/missing_fields_dialog.dart';
import '../../../../cubit/offer_cubit/offer_cubit.dart';
import '../../../../cubit/offer_cubit/offer_state.dart';
import '../widgets/custom_info_row.dart';
import '../widgets/custom_order_button.dart';
import '../widgets/delivery_offer_listView.dart';
import 'package:hatley/l10n/app_localizations.dart';

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
        BlocProvider(create: (_) => sl<OfferCubit>()),
      ],
      child: Scaffold(
        body: MultiBlocListener(
          listeners: [
            BlocListener<DeleteOrderCubit, OrderState>(
              listener: (context, state) {
                if (state is OrderSuccess) {
                  context.read<GetAllOrdersCubit>().getAllOrders();
                  CustomToast.show(
                    message:
                        AppLocalizations.of(context)!.order_cancelled_success,
                  );
                } else if (state is OrderFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(
                          context,
                        )!.delete_failed(state.error),
                      ),
                    ),
                  );
                }
              },
            ),
            BlocListener<OfferCubit, OfferState>(
              listener: (context, state) {
                if (state is OfferAcceptedSuccess) {
                  CustomToast.show(
                    message:
                        "Offer accepted successfully! Redirecting to tracking...",
                  );
                } else if (state is OfferDeclinedSuccess) {
                  CustomToast.show(message: "Offer Decline successfully!");
                } else if (state is OfferFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Failed to process offer: ${state.errorMessage}",
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<GetAllOrdersCubit, OrderState>(
            builder: (context, state) {
              if (state is OrderLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              } else if (state is OrderFailure) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.error_message(state.error),
                  ),
                );
              } else if (state is GetAllOrdersSuccess) {
                final orders = state.orders;

                if (orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.my_orders_title,
                          style: GoogleFonts.inter(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed(RoutesManager.makeOrdersRoute);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsManager.buttonColorApp,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.add_new_order,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<GetAllOrdersCubit>().getAllOrders();
                  },
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Center(
                        child: Container(
                          margin: REdgeInsets.all(16),
                          padding: REdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: ColorsManager.primaryColorApp,
                            ),
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
                                title: AppLocalizations.of(context)!.price,
                                value: order.price.toString(),
                                valueColor: Colors.green,
                              ),
                              CustomInfoRow(
                                title: AppLocalizations.of(context)!.date,
                                value:
                                    order.orderTime.toString().split(' ').first,
                              ),
                              CustomInfoRow(
                                title: AppLocalizations.of(context)!.time,
                                value:
                                    order.orderTime
                                        .toString()
                                        .split(' ')
                                        .last
                                        .split('.')
                                        .first,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                AppLocalizations.of(context)!.order_details,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                padding: REdgeInsets.all(8),
                                height: 80.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(order.description),
                              ),
                              SizedBox(height: 20.h),
                              _sectionTitle(AppLocalizations.of(context)!.from),
                              CustomAddressBlock(
                                values: [
                                  order.orderGovernorateFrom,
                                  order.orderCityFrom,
                                  order.orderZoneFrom,
                                  order.detailesAddressFrom,
                                ],
                              ),
                              SizedBox(height: 20.h),
                              _sectionTitle(AppLocalizations.of(context)!.to),
                              CustomAddressBlock(
                                values: [
                                  order.orderGovernorateTo,
                                  order.orderCityTo,
                                  order.orderZoneTo,
                                  order.detailesAddressTo,
                                ],
                                isArabic: false,
                              ),
                              SizedBox(height: 24.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomOrderButton(
                                    backgroundColor:
                                        ColorsManager.primaryColorApp,
                                    text: "Edit",
                                    onPressed: () {
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
                                    backgroundColor:
                                        ColorsManager.buttonColorApp,
                                    text: "Cancel",
                                    onPressed: () {
                                      lastDeletedOrderId = order.orderId;
                                      showMissingFieldsDialog(
                                        context,
                                        'Are you sure you want to cancel the order?',
                                        onOkPressed: () {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                                context
                                                    .read<DeleteOrderCubit>()
                                                    .deleteOrder(order.orderId);
                                              });
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                              DeliveryOffersWidget(orderId: order.orderId),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const SizedBox.shrink();
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
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
    );
  }
}
