import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:hatley/data/datasources/editOrder_datasource/edit_order_datasource_impl.dart';
import '../helpers/dio_mock.mocks.dart';

void main() {
  late MockDio mockDio;
  late EditOrderDatasourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = EditOrderDatasourceImpl(dio: mockDio);
  });

  test('should send correct data to Dio.put when editing an order', () async {
    // Arrange
    final orderId = 1;
    final orderTime = DateTime.parse('2025-06-03T12:00:00');
    final requestData = {
      'description': 'Updated order',
      'order_governorate_from': 'GovA',
      'order_zone_from': 'ZoneA',
      'order_city_from': 'CityA',
      'detailes_address_from': 'AddressA',
      'order_governorate_to': 'GovB',
      'order_zone_to': 'ZoneB',
      'order_city_to': 'CityB',
      'detailes_address_to': 'AddressB',
      'order_time': orderTime.toIso8601String(),
      'price': 150,
    };

    when(mockDio.put(any, data: anyNamed('data'))).thenAnswer(
          (_) async => Response(
        data: {},
        statusCode: 200,
        requestOptions: RequestOptions(path: '/Order/$orderId'),
      ),
    );

    // Act
    await dataSource.editOrder(
      orderId: orderId,
      description: requestData['description'] as String,
      orderGovernorateFrom: requestData['order_governorate_from'] as String,
      orderZoneFrom: requestData['order_zone_from'] as String,
      orderCityFrom: requestData['order_city_from'] as String,
      detailesAddressFrom: requestData['detailes_address_from'] as String,
      orderGovernorateTo: requestData['order_governorate_to'] as String,
      orderZoneTo: requestData['order_zone_to'] as String,
      orderCityTo: requestData['order_city_to'] as String,
      detailesAddressTo: requestData['detailes_address_to'] as String,
      orderTime: orderTime,
      price: requestData['price'] as num,
    );

    // Assert
    verify(mockDio.put(
      '/Order/$orderId',
      data: requestData,
    )).called(1);
  });
}
