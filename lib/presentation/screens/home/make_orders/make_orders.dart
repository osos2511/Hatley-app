import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatley/core/reusable_order_form.dart';
import 'package:hatley/core/utils.dart';
import 'package:hatley/presentation/cubit/order_cubit/add_order_cubit.dart';
import 'package:hatley/presentation/cubit/order_cubit/order_state.dart';
import 'package:hatley/presentation/cubit/zone_cubit/zone_cubit.dart';
import '../../../../core/colors_manager.dart';
import '../../../../injection_container.dart';
import '../../../cubit/governorate_cubit/governorate_cubit.dart';
import '../../../cubit/make_orders_cubit/make_order_state.dart';
import '../../../cubit/make_orders_cubit/make_orders_cubit.dart';

class MakeOrders extends StatelessWidget {
  const MakeOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GovernorateCubit>(
          create: (context) => sl<GovernorateCubit>()..fetchGovernorates(),
        ),
        BlocProvider<ZoneCubit>(create: (context) => sl<ZoneCubit>()),
        BlocProvider<AddOrderCubit>(create: (context) => sl<AddOrderCubit>()),
      ],
      child: BlocListener<AddOrderCubit, OrderState>(
        listener: (context, state) {},
        child: BlocBuilder<MakeOrderCubit, MakeOrderState>(
          builder: (context, state) {
            final cubit = context.read<MakeOrderCubit>();
            final screenSize = MediaQuery.of(context).size;

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  'Make Orders',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: ColorsManager.primaryColorApp,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding:  REdgeInsets.all(12),
                  child: Center(
                    child: Container(
                      width: screenSize.width * 0.85,
                      padding:  REdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2.w, color: ColorsManager.white70),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: ReusableOrderForm(
                        onSubmit: () {
                          final makeOrderCubit = context.read<MakeOrderCubit>();
                          final state = makeOrderCubit.state;
                          context.read<AddOrderCubit>().addOrder(
                            description: makeOrderCubit.detailsController.text,
                            price:
                                int.tryParse(
                                  makeOrderCubit.priceController.text,
                                ) ??
                                0,
                            orderGovernorateFrom:
                                state.selectedGovernorateFrom ?? '',
                            orderZoneFrom: state.selectedCityFrom ?? '',
                            orderCityFrom: state.selectedStateFrom ?? '',
                            detailesAddressFrom:
                                makeOrderCubit.fromAddressController.text,
                            orderGovernorateTo:
                                state.selectedGovernorateTo ?? '',
                            orderZoneTo: state.selectedCityTo ?? '',
                            orderCityTo: state.selectedStateTo ?? '',
                            detailesAddressTo:
                                makeOrderCubit.toAddressController.text,
                            orderTime:
                                combineDateAndTime(
                                  state.selectedDate,
                                  state.selectedTime,
                                ) ??
                                DateTime.now(),
                          );
                          cubit.submitOrder(context);
                        },
                        submitButtonText: 'Send Order',
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
