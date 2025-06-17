
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatley/data/datasources/addOrder_datasource/add_order_datasource_impl.dart';
import 'package:mockito/mockito.dart';
import '../helpers/dio_mock.mocks.dart';


void main() {
  late AddOrderDatasourceImpl addOrderDatasourceImpl;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    addOrderDatasourceImpl = AddOrderDatasourceImpl(dio: mockDio);
  });

  test('should call Dio.post with correct data and succeed when statusCode is 200', () async {
    // Arrange
    final mockResponse = Response(
      requestOptions: RequestOptions(path: '/Order'),
      statusCode: 200,
    );

    when(mockDio.post(
      any,
      data: anyNamed('data'),
    )).thenAnswer((_) async => mockResponse);

    // Act
    await addOrderDatasourceImpl.addOrder(
      description: 'Test Order',
      orderGovernorateFrom: 'Cairo',
      orderZoneFrom: 'Nasr City',
      orderCityFrom: 'Cairo City',
      detailesAddressFrom: '123 Street',
      orderGovernorateTo: 'Alexandria',
      orderZoneTo: 'Sidi Gaber',
      orderCityTo: 'Alex City',
      detailesAddressTo: '456 Street',
      orderTime: DateTime(2025, 6, 1, 14, 30),
      price: 100,
    );

    // Assert
    verify(mockDio.post(
      '/Order',
      data: {
        'description': 'Test Order',
        'order_governorate_from': 'Cairo',
        'order_zone_from': 'Nasr City',
        'order_city_from': 'Cairo City',
        'detailes_address_from': '123 Street',
        'order_governorate_to': 'Alexandria',
        'order_zone_to': 'Sidi Gaber',
        'order_city_to': 'Alex City',
        'detailes_address_to': '456 Street',
        'order_time': '2025-06-01T14:30:00.000',
        'price': 100,
      },
    )).called(1);
  });
}
