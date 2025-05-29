import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../core/missing_fields_dialog.dart';
import '../../screens/home/make_orders/widgets/confirm_order_dialog.dart';
import 'make_order_state.dart';

class MakeOrderCubit extends Cubit<MakeOrderState> {
  MakeOrderCubit() : super(MakeOrderState.initial());
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController fromAddressController = TextEditingController();
  final TextEditingController toAddressController = TextEditingController();

  List<MakeOrderState> get orders => state.orders;

  void loadOrderForEdit(MakeOrderState order) {
    detailsController.text = order.details;
    priceController.text = order.price;
    fromAddressController.text = order.fromAddress;
    toAddressController.text = order.toAddress;

    emit(
      state.copyWith(
        id: order.id,
        price: order.price,
        details: order.details,
        selectedDate: order.selectedDate,
        selectedTime: order.selectedTime,
        selectedGovernorateFrom: order.selectedGovernorateFrom,
        selectedCityFrom: order.selectedCityFrom,
        selectedStateFrom: order.selectedStateFrom,
        fromAddress: order.fromAddress,
        selectedGovernorateTo: order.selectedGovernorateTo,
        selectedCityTo: order.selectedCityTo,
        selectedStateTo: order.selectedStateTo,
        toAddress: order.toAddress,
        orders: state.orders,
      ),
    );
  }

  void updateOrder(int index, MakeOrderState updatedOrder) {
    final updatedOrders = List<MakeOrderState>.from(state.orders);
    if (index >= 0 && index < updatedOrders.length) {
      updatedOrders[index] = updatedOrder;
      emit(state.copyWith(orders: updatedOrders));
    }
  }

  void addOrder(MakeOrderState order) {
    final updatedOrders = List<MakeOrderState>.from(state.orders)..add(order);
    emit(state.copyWith(orders: updatedOrders));
  }

  void deleteOrder(int index) {
    final updatedOrders = List<MakeOrderState>.from(state.orders)
      ..removeAt(index);
    emit(state.copyWith(orders: updatedOrders));
  }

  void fetchOrders() async {
    emit(state.copyWith(isLoading: true));

    await Future.delayed(Duration(seconds: 2));

    emit(state.copyWith(orders: [], isLoading: false));
  }

  void updateDetails(String value) {
    emit(state.copyWith(details: value));
  }

  void updatePrice(String value) {
    emit(state.copyWith(price: value));
  }

  void updateFromAddress(String value) {
    emit(state.copyWith(fromAddress: value));
  }

  void updateToAddress(String value) {
    emit(state.copyWith(toAddress: value));
  }

  DateTime? combineDateAndTime(DateTime? date, TimeOfDay? time) {
    if (date == null || time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  void pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) emit(state.copyWith(selectedDate: picked));
  }

  void pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) emit(state.copyWith(selectedTime: picked));
  }

  void selectGovernorateFrom(String? value) {
    emit(state.copyWith(selectedGovernorateFrom: value));
  }

  void selectCityFrom(String? value) {
    emit(state.copyWith(selectedCityFrom: value));
  }

  void selectStateFrom(String? value) {
    emit(state.copyWith(selectedStateFrom: value));
  }

  void selectGovernorateTo(String? value) {
    emit(state.copyWith(selectedGovernorateTo: value));
  }

  void selectCityTo(String? value) {
    emit(state.copyWith(selectedCityTo: value));
  }

  void selectStateTo(String? value) {
    emit(state.copyWith(selectedStateTo: value));
  }

  void resetOrder() {
    detailsController.clear();
    priceController.clear();
    fromAddressController.clear();
    toAddressController.clear();

    emit(
      state.copyWith(
        id: '',
        price: '',
        details: '',
        fromAddress: '',
        toAddress: '',
        selectedDate: null,
        selectedTime: null,
        selectedGovernorateFrom: null,
        selectedCityFrom: null,
        selectedStateFrom: null,
        selectedGovernorateTo: null,
        selectedCityTo: null,
        selectedStateTo: null,
        // لاحظ أننا لم نغير قيمة orders هنا!
      ),
    );
  }

  void submitOrder(BuildContext context) {
    final price = priceController.text.trim();
    final details = detailsController.text.trim();
    final fromAddress = fromAddressController.text.trim();
    final toAddress = toAddressController.text.trim();

    emit(
      state.copyWith(
        price: price,
        details: details,
        fromAddress: fromAddress,
        toAddress: toAddress,
      ),
    );

    if (price.isEmpty ||
        details.isEmpty ||
        fromAddress.isEmpty ||
        toAddress.isEmpty ||
        state.selectedDate == null ||
        state.selectedTime == null ||
        state.selectedGovernorateFrom == null ||
        state.selectedCityFrom == null ||
        state.selectedStateFrom == null ||
        state.selectedGovernorateTo == null ||
        state.selectedCityTo == null ||
        state.selectedStateTo == null) {
      showMissingFieldsDialog(
        context,
        'Make sure that you fill all fields first',
      );
      return;
    }
    showConfirmOrderDialog(context, context.read<MakeOrderCubit>().state);
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
