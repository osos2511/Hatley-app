import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/domain/entities/order_entity.dart';
import '../../../core/missing_fields_dialog.dart';
import '../../screens/home/make_orders/widgets/confirm_order_dialog.dart';
import 'make_order_state.dart';

class MakeOrderCubit extends Cubit<MakeOrderState> {
  MakeOrderCubit() : super(MakeOrderState.initial());

  final TextEditingController detailsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController fromAddressController = TextEditingController();
  final TextEditingController toAddressController = TextEditingController();

  List<OrderEntity> get orders => state.orders;

  void loadOrderForEdit(OrderEntity order) {
    print('Loading order for edit: ${order.orderId}');
    detailsController.text = order.description;
    priceController.text = order.price.toString();
    fromAddressController.text = order.detailesAddressFrom;
    toAddressController.text = order.detailesAddressTo;

    emit(
      state.copyWith(
        id: order.orderId,
        price: order.price.toString(),
        details: order.description,
        fromAddress: order.detailesAddressFrom,
        toAddress: order.detailesAddressTo,
        selectedDate: order.orderTime,
        selectedTime: TimeOfDay.fromDateTime(order.orderTime),
        selectedGovernorateFrom: order.orderGovernorateFrom,
        selectedCityFrom: order.orderCityFrom,
        selectedStateFrom: order.orderZoneFrom,
        selectedGovernorateTo: order.orderGovernorateTo,
        selectedCityTo: order.orderCityTo,
        selectedStateTo: order.orderZoneTo,
      ),
    );
  }

  void addOrder(OrderEntity order) {
    print('Adding new order: ${order.description}');
    final updatedOrders = List<OrderEntity>.from(state.orders)..add(order);
    emit(state.copyWith(orders: updatedOrders));
  }

  void updateOrder(int index, OrderEntity updatedOrder) {
    print('Updating order at index $index');
    final updatedOrders = List<OrderEntity>.from(state.orders);
    if (index >= 0 && index < updatedOrders.length) {
      updatedOrders[index] = updatedOrder;
      emit(state.copyWith(orders: updatedOrders));
    }
  }

  void deleteOrder(int index) {
    print('Deleting order at index $index');
    final updatedOrders = List<OrderEntity>.from(state.orders)..removeAt(index);
    emit(state.copyWith(orders: updatedOrders));
  }

  void fetchOrders() async {
    print('Fetching orders...');
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(orders: [], isLoading: false));
    print('Orders fetched.');
  }

  void updateDetails(String value) {
    print('Updating details: $value');
    emit(state.copyWith(details: value));
  }

  void updatePrice(String value) {
    print('Updating price: $value');
    emit(state.copyWith(price: value));
  }

  void updateFromAddress(String value) {
    print('Updating fromAddress: $value');
    emit(state.copyWith(fromAddress: value));
  }

  void updateToAddress(String value) {
    print('Updating toAddress: $value');
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
    if (picked != null) {
      print('Picked date: $picked');
      emit(state.copyWith(selectedDate: picked));
    }
  }

  void pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      print('Picked time: ${picked.format(context)}');
      emit(state.copyWith(selectedTime: picked));
    }
  }

  void selectGovernorateFrom(String? value) {
    print('Selected governorate from: $value');
    emit(state.copyWith(selectedGovernorateFrom: value));
  }

  void selectCityFrom(String? value) {
    print('Selected city from: $value');
    emit(state.copyWith(selectedCityFrom: value));
  }

  void selectStateFrom(String? value) {
    print('Selected state from: $value');
    emit(state.copyWith(selectedStateFrom: value));
  }

  void selectGovernorateTo(String? value) {
    print('Selected governorate to: $value');
    emit(state.copyWith(selectedGovernorateTo: value));
  }

  void selectCityTo(String? value) {
    print('Selected city to: $value');
    emit(state.copyWith(selectedCityTo: value));
  }

  void selectStateTo(String? value) {
    print('Selected state to: $value');
    emit(state.copyWith(selectedStateTo: value));
  }

  void resetOrder() {
    print('Resetting order...');
    detailsController.clear();
    priceController.clear();
    fromAddressController.clear();
    toAddressController.clear();

    emit(
      state.copyWith(
        id: 0,
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
      ),
    );
  }

  void submitOrder(BuildContext context) {
    print('Submitting order...');
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
      print('Missing fields detected.');
      showMissingFieldsDialog(
        context,
        'Make sure that you fill all fields first',
      );
      return;
    }

    final order = OrderEntity(
      orderId: state.id,
      description: details,
      detailesAddressFrom: fromAddress,
      detailesAddressTo: toAddress,
      orderCityFrom: state.selectedCityFrom!,
      orderCityTo: state.selectedCityTo!,
      orderGovernorateFrom: state.selectedGovernorateFrom!,
      orderGovernorateTo: state.selectedGovernorateTo!,
      orderZoneFrom: state.selectedStateFrom!,
      orderZoneTo: state.selectedStateTo!,
      price: num.tryParse(price) ?? 0,
      orderTime: combineDateAndTime(state.selectedDate, state.selectedTime)!,
    );

    print('Order created: $order');
    addOrder(order);
    showConfirmOrderDialog(context, state);
  }

  @override
  Future<void> close() {
    print('Disposing controllers...');
    detailsController.dispose();
    priceController.dispose();
    fromAddressController.dispose();
    toAddressController.dispose();
    return super.close();
  }
}
