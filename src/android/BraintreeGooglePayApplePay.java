package com.cordova.plugin.braintree.googlepay.applepay;

import android.content.Context;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.braintreepayments.api.BraintreeClient;
import com.braintreepayments.api.GooglePayClient;

/**
 * This class echoes a string called from JavaScript.
 */
public class BraintreeGooglePayApplePay extends CordovaPlugin {

    private BraintreeClient braintreeClient;
    Context context = this.cordova.getActivity().getApplicationContext(); 

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("coolMethod")) {
            String message = args.getString(0);
            this.coolMethod(message, callbackContext);
            return true;
        } else if (action.equals("isGooglePayAvailable")) {
            String message = args.getString(0);
            this.isGooglePayAvailable(message, callbackContext);
        }
        return false;
    }

    private void coolMethod(String message, CallbackContext callbackContext) {
        if (message != null && message.length() > 0) {
            callbackContext.success(message);
        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
    }

    private void isGooglePayAvailable(String message, CallbackContext callbackContext) {
        if (message != null && message.length() > 0) {
            callbackContext.success("Success");
        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
    }

    private BraintreeClient getBraintreeClient() {
        if (braintreeClient == null) {
            braintreeClient = new BraintreeClient(context, "sandbox_key");
        }

        return braintreeClient;
    }


}
