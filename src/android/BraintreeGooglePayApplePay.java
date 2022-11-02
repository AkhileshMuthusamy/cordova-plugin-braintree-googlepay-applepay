package cordova-plugin-braintree-googlepay-applepay;

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

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("coolMethod")) {
            String message = args.getString(0);
            this.coolMethod(message, callbackContext);
            return true;
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

    private BraintreeClient getBraintreeClient() {
        if (braintreeClient == null) {
            braintreeClient = new BraintreeClient(this, "sandbox_ykcx4r45_4cwxd9ftmkjcm955");
        }
    }


}
