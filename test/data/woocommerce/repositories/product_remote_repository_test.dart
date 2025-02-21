import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../data/error/exceptions.dart';
import '../data/network/network_status.dart';
import '../data/woocommerce/repositories/product_remote_repository.dart';
import '../data/woocommerce/repositories/woocommerce_wrapper.dart';

import '../../../fixtures/fixture_reader.dart';

class MockWoocommerceWrapper extends Mock implements WoocommercWrapperAbstract { }

class MockNetworkStatus extends Mock implements NetworkStatus {}

void main() {
  MockWoocommerceWrapper? woocommerce;
  late MockNetworkStatus mockNetworkStatus;
  late RemoteProductRepository remoteProductRepository;

  setUp(() {
    woocommerce = MockWoocommerceWrapper();
    mockNetworkStatus = MockNetworkStatus();
    remoteProductRepository = RemoteProductRepository(woocommerce: woocommerce);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkStatus.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  group('Get list of products ', () {
    runTestsOnline(() async {
      test(
        'should return list of products when getProducts is successful',
        () async {
          // arrange
          when(woocommerce!.getProductList(any))
            .thenAnswer((_) async => json.decode(fixture('woocommerce/products.json'))
          );
          // act
          final products = await remoteProductRepository.getProducts();
          // assert
          expect(products.length, equals(10));
        },
      );

      test(
        'should return server failure when getProducts is unsuccessful',
        () async {
          // arrange
          when(woocommerce!.getProductList(any))
              .thenThrow(HttpRequestException());
          // act
          // assert
          expect(() => remoteProductRepository.getProducts(), throwsA(isInstanceOf<RemoteServerException>()));
        },
      );
    });
  });
  
}
    