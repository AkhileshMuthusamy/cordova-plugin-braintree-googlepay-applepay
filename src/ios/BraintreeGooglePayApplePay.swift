/********* BraintreeGooglePayApplePay.swift Cordova Plugin Implementation *******/

import Foundation
import PassKit

@objc(BraintreeGooglePayApplePay) class BraintreeGooglePayApplePay: CDVPlugin, PKPaymentAuthorizationViewControllerDelegate {
  var paymentCallbackId: String?
  var successfulPayment = false

  @objc(coolMethod:)
  func coolMethod(command: CDVInvokedUrlCommand) {
    // Set the plugin result to fail.
    var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "The Plugin Failed")
    // Set the plugin result to succeed.
    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "The plugin succeeded")
    // Send the function result back to Cordova.
    commandDelegate!.send(pluginResult, callbackId: command.callbackId)
  }

  /**
   * Check device for ApplePay capability
   */
  @objc(canMakePayments:) func canMakePayments(command: CDVInvokedUrlCommand) {
    let callbackID = command.callbackId

    let canMakePayments = PKPaymentAuthorizationViewController.canMakePayments()

    let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: canMakePayments)
    commandDelegate.send(result, callbackId: callbackID)
  }

  /**
   * Request payment token
   */
  @objc(makePaymentRequest:) func makePaymentRequest(command: CDVInvokedUrlCommand) {
    paymentCallbackId = command.callbackId

    do {
      let countryCode = try getFromRequest(fromArguments: command.arguments, key: "countryCode") as! String
      let currencyCode = try getFromRequest(fromArguments: command.arguments, key: "currencyCode") as! String
      let merchantId = try getFromRequest(fromArguments: command.arguments, key: "merchantId") as! String

      let request = PKPaymentRequest()
      request.merchantIdentifier = merchantId
      request.supportedNetworks = [.visa, .masterCard, .amex, .chinaUnionPay]
      request.merchantCapabilities = .capability3DS
      request.countryCode = countryCode
      request.currencyCode = currencyCode

      let payPurpose = try getFromRequest(fromArguments: command.arguments, key: "purpose") as! String

      let amount = try getFromRequest(fromArguments: command.arguments, key: "amount") as! NSNumber
      let nsamount = NSDecimalNumber(decimal: amount.decimalValue)

      request.paymentSummaryItems = [PKPaymentSummaryItem(label: payPurpose, amount: nsamount)]

      if let c = PKPaymentAuthorizationViewController(paymentRequest: request) {
        c.delegate = self
        viewController.present(c, animated: true)
      }
    } catch let ValidationError.missingArgument(message) {
      failWithError(message)
    } catch {
      failWithError(error.localizedDescription)
    }
  }

  private func failWithError(_ error: String) {
    let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error)
    commandDelegate.send(result, callbackId: paymentCallbackId)
  }

  private func getFromRequest(fromArguments arguments: [Any]?, key: String) throws -> Any {
    let val = (arguments?[0] as? [AnyHashable: Any])?[key]

    if val == nil {
      throw ValidationError.missingArgument("\(key) is required")
    }

    return val!
  }

  /**
   * Delegate methods
   */
  func paymentAuthorizationViewController(_: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
    completion(PKPaymentAuthorizationResult(status: PKPaymentAuthorizationStatus.success, errors: nil))
    successfulPayment = true
    var braintreeClient: BTAPIClient?
    braintreeClient = BTAPIClient(authorization: "development_tokenization_key")
    let braintree = BTApplePayClient(apiClient: braintreeClient)
    // Tokenize the Apple Pay payment
    braintree!.tokenizeApplePay(payment) { (nonce, error) in
        if error != nil {
            // Received an error from Braintree.
            // Indicate failure via the completion callback.
            completion(PKPaymentAuthorizationResult(status: PKPaymentAuthorizationStatus.failure, errors: nil)
            return
        }
    let applePaymentString = String(data: payment.token.paymentData, encoding: .utf8)
    let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: applePaymentString)

    commandDelegate.send(result, callbackId: paymentCallbackId)
  }

  func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
    if !successfulPayment {
      let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Payment cancelled")
      commandDelegate.send(result, callbackId: paymentCallbackId)
    }

    controller.dismiss(animated: true, completion: nil)
  }
}

enum ValidationError: Error {
  case missingArgument(String)
}
