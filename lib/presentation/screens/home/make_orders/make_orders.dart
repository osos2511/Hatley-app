import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatley/domain/entities/governorate_entity.dart';
import 'package:hatley/domain/entities/zone_entity.dart';
import 'package:hatley/presentation/cubit/zone_cubit/zone_cubit.dart';
import 'package:hatley/presentation/cubit/zone_cubit/zone_state.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_button.dart';
import 'package:hatley/presentation/screens/home/make_orders/widgets/custom_container.dart';
import 'package:hatley/presentation/screens/home/make_orders/widgets/custom_drop_down.dart';
import 'package:hatley/presentation/screens/home/make_orders/widgets/custom_order_text_field.dart';
import 'package:hatley/presentation/screens/home/make_orders/widgets/date_time_picker.dart';
import 'package:intl/intl.dart';
import '../../../../core/colors_manager.dart';
import '../../../../injection_container.dart';
import '../../../cubit/governorate_cubit/governorate_cubit.dart';
import '../../../cubit/governorate_cubit/governorate_state.dart';
import '../../../cubit/make_orders_cubit/make_order_state.dart';
import '../../../cubit/make_orders_cubit/make_orders_cubit.dart';

class MakeOrders extends StatelessWidget {
  const MakeOrders({super.key});

  @override
  Widget build(BuildContext context) {
   return MultiBlocProvider(providers: [
      BlocProvider<GovernorateCubit>(
        create: (context) =>
        sl<GovernorateCubit>()
          ..fetchGovernorates(),),
     BlocProvider<ZoneCubit>(create: (context) => sl<ZoneCubit>(),)
    ],
      child: BlocBuilder<MakeOrderCubit, MakeOrderState>(
        builder: (context, state) {
          final cubit = context.read<MakeOrderCubit>();
          final screenSize = MediaQuery
              .of(context)
              .size;
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
              backgroundColor: ColorsManager.blue,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: Container(
                    width: screenSize.width * 0.85,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: ColorsManager.blue),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomOrderTextField(
                          controller: cubit.detailsController,
                          label: 'Order Details',
                          hint: 'Enter Your Order Details',
                          maxLines: 3,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 12),
                        CustomOrderTextField(
                          controller: cubit.priceController,
                          label: 'Order Price',
                          hint: 'Enter Your Order Price',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 12),
                        DateTimePickerRow(
                          dateText: state.selectedDate != null
                              ? DateFormat('MM/dd/yyyy').format(
                              state.selectedDate!)
                              : 'Date',
                          timeText: state.selectedTime != null
                              ? state.selectedTime!.format(context)
                              : 'Time',
                          onDateTap: () => cubit.pickDate(context),
                          onTimeTap: () => cubit.pickTime(context),
                        ),
                        const SizedBox(height: 20),
                        CustomContainer(
                            title: "From: Where you want to order From"),
                        const SizedBox(height: 12),
                        BlocSelector<GovernorateCubit,
                            GovernorateState,
                            List<GovernorateEntity>>(
                          selector: (selected) =>
                          selected is GovernorateLoaded
                              ? selected.governorates
                              : [],
                          builder: (context, governorates) {
                            final makeOrderState = context.watch<MakeOrderCubit>().state;
                            return CustomDropdown(
                              value: makeOrderState.selectedGovernorateFrom,
                              hint: 'Governorate',
                              items: governorates.map((g) => g.name).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  final cubit = context.read<MakeOrderCubit>();
                                  final zoneCubit = context.read<ZoneCubit>();
                                  cubit.selectGovernorateFrom(value);
                                  zoneCubit.fetchZones(govName: value);
                                }
                              },

                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        BlocSelector<ZoneCubit,ZoneState,List<ZoneEntity>>(
                          selector: (selected) =>
                          selected is ZonesLoaded
                              ? selected.zones
                              : [],
                          builder: (context, zones) {
                            final makeOrderState = context.watch<MakeOrderCubit>().state;
                            return CustomDropdown(
                              value: makeOrderState.selectedCityFrom,
                              hint: 'Select a City',
                              items: zones.map((z) => z.name).toList(),
                              onChanged: cubit.selectCityFrom,
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomDropdown(
                          value: state.selectedStateFrom,
                          hint: 'Select a State',
                          items: ['East', 'West', 'North'],
                          onChanged: cubit.selectStateFrom,
                        ),
                        const SizedBox(height: 12),
                        CustomOrderTextField(
                          controller: cubit.fromAddressController,
                          label: 'Details Address',
                          hint: 'Enter Your Detailed Address',
                          maxLines: 2,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 20),
                        const Icon(Icons.arrow_downward, size: 40),
                        const SizedBox(height: 12),
                        CustomContainer(
                            title: "To: Where you want to order To"),
                        const SizedBox(height: 12),
                        BlocSelector<GovernorateCubit,
                            GovernorateState,
                            List<
                                GovernorateEntity>>(
                          selector: (selected) =>
                          selected is GovernorateLoaded
                              ? selected.governorates
                              : [],
                          builder: (context, governorates) {
                            final makeOrderState = context
                                .watch<MakeOrderCubit>()
                                .state;
                            return CustomDropdown(
                              value: makeOrderState.selectedGovernorateTo,
                              hint: 'Governorate',
                              items: governorates.map((g) => g.name).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  final cubit = context.read<MakeOrderCubit>();
                                  final zoneCubit = context.read<ZoneCubit>();
                                  cubit.selectGovernorateFrom(value);
                                  zoneCubit.fetchZones(govName: value);
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        BlocSelector<ZoneCubit,ZoneState,List<ZoneEntity>>(
                          selector: (selected) =>
                          selected is ZonesLoaded
                              ? selected.zones
                              : [],
                          builder: (context, zones) {
                            final makeOrderState = context.watch<MakeOrderCubit>().state;
                            return CustomDropdown(
                              value: makeOrderState.selectedCityTo,
                              hint: 'Select a City',
                              items: zones.map((z) => z.name).toList(),
                              onChanged: cubit.selectCityTo,
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomDropdown(
                          value: state.selectedStateTo,
                          hint: 'Select a State',
                          items: ['East', 'West', 'North'],
                          onChanged: cubit.selectStateTo,
                        ),
                        const SizedBox(height: 12),
                        CustomOrderTextField(
                          controller: cubit.toAddressController,
                          label: 'Details Address',
                          hint: 'Enter Your Detailed Address',
                          maxLines: 2,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                            onPressed: () => cubit.submitOrder(context),
                            text: 'Send Order',
                            foColor: ColorsManager.blue,
                            bgColor: ColorsManager.white)

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}
