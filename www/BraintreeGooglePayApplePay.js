var exec = require('cordova/exec');

exports.coolMethod = function (arg0, success, error) {
    exec(success, error, 'BraintreeGooglePayApplePay', 'coolMethod', [arg0]);
};

exports.isGooglePayAvailable = function(arg0, success, error) {
    exec(success, error, 'BraintreeGooglePayApplePay', 'isGooglePayAvailable', [arg0]);
}

exports.isApplePayAvailable = function(arg0, success, error) {
    exec(success, error, 'BraintreeGooglePayApplePay', 'isApplePayAvailable', [arg0]);
}