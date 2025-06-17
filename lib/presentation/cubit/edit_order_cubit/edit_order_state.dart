import 'package:flutter/material.dart';

class EditOrderState {
  final int orderId;
  final String price;
  final String details;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final String? selectedGovernorateFrom;
  final String? selectedCityFrom;
  final String? selectedZoneFrom;
  final String fromAddress;
  final String? selectedGovernorateTo;
  final String? selectedCityTo;
  final String? selectedZoneTo;
  final String toAddress;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  const EditOrderState({
    required this.orderId,
    required this.price,
    required this.details,
    this.selectedDate,
    this.selectedTime,
    this.selectedGovernorateFrom,
    this.selectedCityFrom,
    this.selectedZoneFrom,
    required this.fromAddress,
    this.selectedGovernorateTo,
    this.selectedCityTo,
    this.selectedZoneTo,
    required this.toAddress,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  factory EditOrderState.initial() {
    return const EditOrderState(
      orderId: 0,
      price: '',
      details: '',
      fromAddress: '',
      toAddress: '',
    );
  }

  EditOrderState copyWith({
    int? orderId,
    String? price,
    String? details,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    String? selectedGovernorateFrom,
    String? selectedCityFrom,
    String? selectedZoneFrom,
    String? fromAddress,
    String? selectedGovernorateTo,
    String? selectedCityTo,
    String? selectedZoneTo,
    String? toAddress,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return EditOrderState(
      orderId: orderId ?? this.orderId,
      price: price ?? this.price,
      details: details ?? this.details,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedGovernorateFrom:
          selectedGovernorateFrom ?? this.selectedGovernorateFrom,
      selectedCityFrom: selectedCityFrom ?? this.selectedCityFrom,
      selectedZoneFrom: selectedZoneFrom ?? this.selectedZoneFrom,
      fromAddress: fromAddress ?? this.fromAddress,
      selectedGovernorateTo:
          selectedGovernorateTo ?? this.selectedGovernorateTo,
      selectedCityTo: selectedCityTo ?? this.selectedCityTo,
      selectedZoneTo: selectedZoneTo ?? this.selectedZoneTo,
      toAddress: toAddress ?? this.toAddress,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
