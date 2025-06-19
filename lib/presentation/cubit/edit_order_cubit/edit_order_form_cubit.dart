import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/domain/entities/order_entity.dart';
import 'package:hatley/presentation/cubit/edit_order_cubit/edit_order_state.dart';

class EditOrderFormCubit extends Cubit<EditOrderState> {
  EditOrderFormCubit() : super(EditOrderState.initial());

  final TextEditingController detailsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController fromAddressController = TextEditingController();
  final TextEditingController toAddressController = TextEditingController();

  void loadOrderForEdit(OrderEntity order) {
    print('Loading order for edit: ${order.orderId}');

    detailsController.text = order.description;
    priceController.text = order.price.toString();
    fromAddressController.text = order.detailesAddressFrom;
    toAddressController.text = order.detailesAddressTo;

    emit(
      state.copyWith(
        orderId: order.orderId,
        price: order.price.toString(),
        details: order.description,
        fromAddress: order.detailesAddressFrom,
        toAddress: order.detailesAddressTo,
        selectedDate: order.orderTime,
        selectedTime: TimeOfDay.fromDateTime(order.orderTime),
        selectedGovernorateFrom: order.orderGovernorateFrom,
        selectedCityFrom: order.orderCityFrom,
        selectedZoneFrom: order.orderZoneFrom,
        selectedGovernorateTo: order.orderGovernorateTo,
        selectedCityTo: order.orderCityTo,
        selectedZoneTo: order.orderZoneTo,
      ),
    );
  }

  void updateDetails(String value) => emit(state.copyWith(details: value));
  void updatePrice(String value) => emit(state.copyWith(price: value));
  void updateFromAddress(String value) =>
      emit(state.copyWith(fromAddress: value));
  void updateToAddress(String value) => emit(state.copyWith(toAddress: value));

  void selectGovernorateFrom(String? value) =>
      emit(state.copyWith(selectedGovernorateFrom: value));
  void selectCityFrom(String? value) =>
      emit(state.copyWith(selectedCityFrom: value));
  void selectZoneFrom(String? value) =>
      emit(state.copyWith(selectedZoneFrom: value));

  void selectGovernorateTo(String? value) =>
      emit(state.copyWith(selectedGovernorateTo: value));
  void selectCityTo(String? value) =>
      emit(state.copyWith(selectedCityTo: value));
  void selectZoneTo(String? value) =>
      emit(state.copyWith(selectedZoneTo: value));

  void pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      emit(state.copyWith(selectedDate: picked));
    }
  }

  void pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      emit(state.copyWith(selectedTime: picked));
    }
  }

  DateTime? combineDateAndTime(DateTime? date, TimeOfDay? time) {
    if (date == null || time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  OrderEntity? getUpdatedOrderEntity() {
    if (state.selectedDate == null || state.selectedTime == null) return null;

    return OrderEntity(
      orderId: state.orderId,
      description: state.details,
      price: num.tryParse(state.price) ?? 0,
      detailesAddressFrom: state.fromAddress,
      detailesAddressTo: state.toAddress,
      orderTime: combineDateAndTime(state.selectedDate, state.selectedTime)!,
      orderGovernorateFrom: state.selectedGovernorateFrom ?? '',
      orderCityFrom: state.selectedCityFrom ?? '',
      orderZoneFrom: state.selectedZoneFrom ?? '',
      orderGovernorateTo: state.selectedGovernorateTo ?? '',
      orderCityTo: state.selectedCityTo ?? '',
      orderZoneTo: state.selectedZoneTo ?? '',
    );
  }

  void reset() {
    detailsController.clear();
    priceController.clear();
    fromAddressController.clear();
    toAddressController.clear();

    emit(EditOrderState.initial());
  }

  @override
  Future<void> close() {
    detailsController.dispose();
    priceController.dispose();
    fromAddressController.dispose();
    toAddressController.dispose();
    return super.close();
  }
}
