import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/presentation/cubit/edit_order_cubit/edit_order_cubit.dart';
import 'package:hatley/presentation/cubit/governorate_cubit/governorate_cubit.dart';
import 'package:hatley/presentation/cubit/governorate_cubit/governorate_state.dart';
import 'package:hatley/presentation/cubit/make_orders_cubit/make_order_state.dart';
import 'package:hatley/presentation/cubit/make_orders_cubit/make_orders_cubit.dart';
import 'package:hatley/presentation/cubit/zone_cubit/zone_cubit.dart';
import 'package:hatley/presentation/cubit/zone_cubit/zone_state.dart';
import 'package:hatley/presentation/screens/home/home_drawer/widgets/custom_order_button.dart';
import 'package:hatley/presentation/screens/home/make_orders/widgets/custom_container.dart';
import 'package:hatley/presentation/screens/home/make_orders/widgets/custom_drop_down.dart';
import 'package:hatley/presentation/screens/home/make_orders/widgets/custom_order_text_field.dart';
import 'package:hatley/presentation/screens/home/make_orders/widgets/date_time_picker.dart';
import 'package:intl/intl.dart';
import '../../../../domain/entities/governorate_entity.dart';
import '../../../../domain/entities/zone_entity.dart';

class ReusableOrderForm extends StatelessWidget {
  final VoidCallback onSubmit;
  final String submitButtonText;
  final bool isEdit;
  final int? orderId;

  const ReusableOrderForm({
    super.key,
    this.orderId,
    this.isEdit = false,
    required this.onSubmit,
    required this.submitButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MakeOrderCubit, MakeOrderState>(
      builder: (context, state) {
        final makeOrderCubit = context.read<MakeOrderCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Order Details
            CustomOrderTextField(
              controller: makeOrderCubit.detailsController,
              label: 'Order Details',
              hint: 'Enter Your Order Details',
              maxLines: 3,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 12),

            // Order Price
            CustomOrderTextField(
              controller: makeOrderCubit.priceController,
              label: 'Order Price',
              hint: 'Enter Your Order Price',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            // Date & Time
            DateTimePickerRow(
              dateText:
                  state.selectedDate != null
                      ? DateFormat('MM/dd/yyyy').format(state.selectedDate!)
                      : 'Date',
              timeText:
                  state.selectedTime != null
                      ? state.selectedTime!.format(context)
                      : 'Time',
              onDateTap: () => makeOrderCubit.pickDate(context),
              onTimeTap: () => makeOrderCubit.pickTime(context),
            ),

            const SizedBox(height: 20),
            const CustomContainer(title: "From: Where you want to order From"),
            const SizedBox(height: 12),

            // Governorate From
            _buildGovernorateDropdown(
              context,
              selected: makeOrderCubit.state.selectedGovernorateFrom,
              onChanged: (value) {
                makeOrderCubit.selectGovernorateFrom(value);
                makeOrderCubit.selectCityFrom(null);
                context.read<ZoneCubit>().fetchZones(govName: value);
              },
            ),

            const SizedBox(height: 12),

            // City From
            _buildZoneDropdown(
              context,
              selectedCity: makeOrderCubit.state.selectedCityFrom,
              onChanged: makeOrderCubit.selectCityFrom,
            ),

            const SizedBox(height: 12),

            // State From
            CustomDropdown(
              value: makeOrderCubit.state.selectedStateFrom,
              hint: 'Select a State',
              items: _streetNames,
              onChanged: makeOrderCubit.selectStateFrom,
            ),

            const SizedBox(height: 12),

            // Address From
            CustomOrderTextField(
              controller: makeOrderCubit.fromAddressController,
              label: 'Details Address',
              hint: 'Enter Your Detailed Address',
              maxLines: 2,
              keyboardType: TextInputType.text,
            ),

            const SizedBox(height: 20),
            const Icon(Icons.arrow_downward, size: 40),
            const SizedBox(height: 12),
            const CustomContainer(title: "To: Where you want to order To"),
            const SizedBox(height: 12),

            // Governorate To
            _buildGovernorateDropdown(
              context,
              selected: makeOrderCubit.state.selectedGovernorateTo,
              onChanged: (value) {
                makeOrderCubit.selectGovernorateTo(value);
                makeOrderCubit.selectCityTo(null);
                context.read<ZoneCubit>().fetchZones(govName: value);
              },
            ),

            const SizedBox(height: 12),

            // City To
            _buildZoneDropdown(
              context,
              selectedCity: makeOrderCubit.state.selectedCityTo,
              onChanged: makeOrderCubit.selectCityTo,
            ),

            const SizedBox(height: 12),

            // State To
            CustomDropdown(
              value: makeOrderCubit.state.selectedStateTo,
              hint: 'Select a State',
              items: _streetNames,
              onChanged: makeOrderCubit.selectStateTo,
            ),

            const SizedBox(height: 12),

            // Address To
            CustomOrderTextField(
              controller: makeOrderCubit.toAddressController,
              label: 'Details Address',
              hint: 'Enter Your Detailed Address',
              maxLines: 2,
              keyboardType: TextInputType.text,
            ),

            const SizedBox(height: 20),

            // Submit Buttons
            isEdit
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomOrderButton(
                      text: 'Cancel',
                      backgroundColor: Colors.red,
                      onPressed: () => Navigator.pop(context),
                    ),
                    CustomOrderButton(
                      backgroundColor: Colors.blue,
                      text: submitButtonText,
                      onPressed: () {
                        final editCubit = context.read<EditOrderCubit>();
                        final makeOrderCubit = context.read<MakeOrderCubit>();

                        if (orderId == null) return;

                        final fromAddress =
                            makeOrderCubit.fromAddressController.text.trim();
                        final toAddress =
                            makeOrderCubit.toAddressController.text.trim();
                        final priceText =
                            makeOrderCubit.priceController.text.trim();
                        final description =
                            makeOrderCubit.detailsController.text.trim();

                        if (description.isEmpty ||
                            fromAddress.isEmpty ||
                            toAddress.isEmpty ||
                            priceText.isEmpty ||
                            makeOrderCubit.state.selectedGovernorateFrom ==
                                null ||
                            makeOrderCubit.state.selectedStateFrom == null ||
                            makeOrderCubit.state.selectedCityFrom == null ||
                            makeOrderCubit.state.selectedGovernorateTo ==
                                null ||
                            makeOrderCubit.state.selectedStateTo == null ||
                            makeOrderCubit.state.selectedCityTo == null ||
                            makeOrderCubit.state.selectedDate == null ||
                            makeOrderCubit.state.selectedTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('يرجى ملء جميع الحقول المطلوبة'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final price = num.tryParse(priceText);
                        if (price == null || price <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('يرجى إدخال سعر صحيح'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // تنفيذ التعديل بعد التحقق
                        editCubit.editOrder(
                          orderId: orderId!,
                          description: description,
                          orderGovernorateFrom:
                              makeOrderCubit.state.selectedGovernorateFrom!,
                          orderZoneFrom:
                              makeOrderCubit.state.selectedStateFrom!,
                          orderCityFrom: makeOrderCubit.state.selectedCityFrom!,
                          detailesAddressFrom: fromAddress,
                          orderGovernorateTo:
                              makeOrderCubit.state.selectedGovernorateTo!,
                          orderZoneTo: makeOrderCubit.state.selectedStateTo!,
                          orderCityTo: makeOrderCubit.state.selectedCityTo!,
                          detailesAddressTo: toAddress,
                          orderTime:
                              makeOrderCubit.combineDateAndTime(
                                makeOrderCubit.state.selectedDate,
                                makeOrderCubit.state.selectedTime,
                              ) ??
                              DateTime.now(),
                          price: price,
                        );
                      },
                    ),
                  ],
                )
                : Center(
                  child: CustomOrderButton(
                    backgroundColor: Colors.blue,
                    text: submitButtonText,
                    onPressed: onSubmit,
                  ),
                ),
          ],
        );
      },
    );
  }

  List<String> get _streetNames => [
    'Al-Nemis Street',
    'Al-Mohafza Street',
    'Al-Gomhoriah Street',
    'Al-Maktabat Street',
  ];

  Widget _buildGovernorateDropdown(
    BuildContext context, {
    required String? selected,
    required ValueChanged<String> onChanged,
  }) {
    return BlocSelector<
      GovernorateCubit,
      GovernorateState,
      List<GovernorateEntity>
    >(
      selector: (state) => state is GovernorateLoaded ? state.governorates : [],
      builder: (context, governorates) {
        return CustomDropdown(
          value: selected,
          hint: 'Governorate',
          items: governorates.map((g) => g.name).toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        );
      },
    );
  }

  Widget _buildZoneDropdown(
    BuildContext context, {
    required String? selectedCity,
    required ValueChanged<String?> onChanged,
  }) {
    return BlocSelector<ZoneCubit, ZoneState, List<ZoneEntity>>(
      selector: (state) => state is ZonesLoaded ? state.zones : [],
      builder: (context, zones) {
        final zoneNames = zones.map((z) => z.name).toSet().toList();
        final validSelected =
            zoneNames.contains(selectedCity) ? selectedCity : null;

        return CustomDropdown(
          value: validSelected,
          hint: 'Select a City',
          items: zoneNames,
          onChanged: onChanged,
        );
      },
    );
  }
}
