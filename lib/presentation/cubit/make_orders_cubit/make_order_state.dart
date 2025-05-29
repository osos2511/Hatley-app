import 'package:flutter/material.dart';

class MakeOrderState {
  final String id;
  final String price;
  final String details;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final String? selectedGovernorateFrom;
  final String? selectedCityFrom;
  final String? selectedStateFrom;
  final String fromAddress;
  final String? selectedGovernorateTo;
  final String? selectedCityTo;
  final String? selectedStateTo;
  final String toAddress;
  final bool isLoading;
  final List<MakeOrderState> orders;

  const MakeOrderState({
    required this.id,
    required this.price,
    required this.details,
    this.selectedDate,
    this.selectedTime,
    this.selectedGovernorateFrom,
    this.selectedCityFrom,
    this.selectedStateFrom,
    required this.fromAddress,
    this.selectedGovernorateTo,
    this.selectedCityTo,
    this.selectedStateTo,
    required this.toAddress,
    this.orders = const [],
    required this.isLoading,
  });

  factory MakeOrderState.initial() {
    return const MakeOrderState(
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
      isLoading: false,
      orders: [],
    );
  }

  MakeOrderState copyWith({
    String? id,
    String? price,
    String? details,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    String? selectedGovernorateFrom,
    String? selectedCityFrom,
    String? selectedStateFrom,
    String? fromAddress,
    String? selectedGovernorateTo,
    String? selectedCityTo,
    String? selectedStateTo,
    String? toAddress,
    List<MakeOrderState>? orders,
    bool? isLoading,
  }) {
    return MakeOrderState(
      id: id ?? this.id,
      price: price ?? this.price,
      details: details ?? this.details,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedGovernorateFrom:
          selectedGovernorateFrom ?? this.selectedGovernorateFrom,
      selectedCityFrom: selectedCityFrom ?? this.selectedCityFrom,
      selectedStateFrom: selectedStateFrom ?? this.selectedStateFrom,
      fromAddress: fromAddress ?? this.fromAddress,
      selectedGovernorateTo:
          selectedGovernorateTo ?? this.selectedGovernorateTo,
      selectedCityTo: selectedCityTo ?? this.selectedCityTo,
      selectedStateTo: selectedStateTo ?? this.selectedStateTo,
      toAddress: toAddress ?? this.toAddress,
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
