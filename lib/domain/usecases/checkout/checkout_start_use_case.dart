import 'package:flutter/material.dart';
import '../data/model/cart_item.dart';
import '../data/model/payment_method.dart';
import '../data/model/shipping_address.dart';
import '../data/repositories/abstract/cart_repository.dart';
import '../data/repositories/abstract/payment_method_repository.dart';
import '../data/repositories/abstract/shipping_address_repository.dart';
import '../domain/usecases/base_use_case.dart';
import '../locator.dart';

/// # 6. Checkout screen
/// 6.1. Checkout start screen use-case: User clicks “Checkout button” 
/// from the Cart Screen and gets to Checkout screen. The default shipping address, 
/// payment method and delivery method is displayed. 
/// The delivery price is added and affect the Summary.
/// https://medium.com/@openflutterproject/open-flutter-project-e-commerce-app-use-cases-and-features-6b7414a6e708


abstract class CheckoutStartUseCase
  implements BaseUseCase<ChekcoutStartResult, ChekcoutStartParams> {}

    
class CheckoutStartUseCaseImpl implements CheckoutStartUseCase {
  @override
  Future<ChekcoutStartResult> execute(ChekcoutStartParams params) async {
    
    try {
      ShippingAddressRepository shippingAddressRepository = sl();
      PaymentMethodRepository paymentMethodRepository = sl();
      CartRepository cartRepository = sl();
      //TODO: make delivery price dynamic
      const double deliveryPrice = 10;
      final double calculatedPrice = cartRepository.getCalculatedPrice();
      return ChekcoutStartResult(
        result: true,
        paymentMethods: await paymentMethodRepository.getPaymentMethodList(),
        shippingAddress: await shippingAddressRepository.getShippingAddressList(),
        cartItems: await cartRepository.getCartContent(),
        currentPaymentMethod:  await paymentMethodRepository.getDefaultPaymentMethod(),
        currentShippingAddress: await shippingAddressRepository.getDefaultShippingAddress(),
        totalCalculatedPrice: calculatedPrice,
        deliveryPrice: deliveryPrice, 
        summaryPrice: calculatedPrice + deliveryPrice
      );
    } catch (e) {
      return ChekcoutStartResult(  
        result: false,
        exception: CheckoutStartException(), 
        currentPaymentMethod: null, 
        deliveryPrice: null, 
        totalCalculatedPrice: null
      );
    }
  }
}

class ChekcoutStartResult extends UseCaseResult {
  final List<PaymentMethodModel>? paymentMethods;
  final List<ShippingAddressModel>? shippingAddress;
  final List<CartItem>? cartItems;
  final ShippingAddressModel? currentShippingAddress;
  final PaymentMethodModel? currentPaymentMethod;
  final double? totalCalculatedPrice;
  final double? deliveryPrice;
  final double? summaryPrice;

  ChekcoutStartResult({
    this.paymentMethods,
    this.shippingAddress,
    this.cartItems,
    this.currentShippingAddress,
    required this.currentPaymentMethod,
    required this.totalCalculatedPrice,
    required this.deliveryPrice,
    this.summaryPrice,
    Exception? exception, bool? result}) 
    : super(exception: exception, result: result);
}

class ChekcoutStartParams{ }

class CheckoutStartException implements Exception { }