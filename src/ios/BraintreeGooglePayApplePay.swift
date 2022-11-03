/********* BraintreeGooglePayApplePay.swift Cordova Plugin Implementation *******/

@objc(BraintreeGooglePayApplePay) class BraintreeGooglePayApplePay : CDVPlugin {
  @objc(coolMethod:) 
  func coolMethod(command: CDVInvokedUrlCommand) {
    // Set the plugin result to fail.
    var pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: "The Plugin Failed");
    // Set the plugin result to succeed.
    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "The plugin succeeded");
    // Send the function result back to Cordova.
    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
  }
}
