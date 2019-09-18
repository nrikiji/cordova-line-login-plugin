package plugin.line;

import com.linecorp.linesdk.LineAccessToken;
import com.linecorp.linesdk.LineApiResponse;
import com.linecorp.linesdk.LineApiResponseCode;
import com.linecorp.linesdk.LineIdToken;
import com.linecorp.linesdk.LineProfile;
import com.linecorp.linesdk.Scope;
import com.linecorp.linesdk.api.LineApiClient;
import com.linecorp.linesdk.api.LineApiClientBuilder;
import com.linecorp.linesdk.auth.LineLoginApi;
import com.linecorp.linesdk.auth.LineAuthenticationParams;
import com.linecorp.linesdk.auth.LineLoginResult;

import android.content.Intent;
import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Arrays;

public class LineLogin extends CordovaPlugin {

    private static final int REQUEST_CODE = 1;
    private static final int PARAMETER_ERROR = -1;
    private static final int SDK_ERROR = -2;
    private static final int UNKNOWN_ERROR = -3;

    String channelId;
    CallbackContext callbackContext;
    private static LineApiClient lineApiClient;

    @Override
    public boolean execute(String action, JSONArray data, CallbackContext callbackContext) throws JSONException {

        this.callbackContext = callbackContext;

        if (action.equals("initialize")) {
            this.initialize(data, callbackContext);
            return true;
        } else if (action.equals("login")) {
            this.login(callbackContext);
            return true;
        } else if (action.equals("logout")) {
            this.logout(callbackContext);
            return true;
        } else if (action.equals("getAccessToken")) {
            this.getAccessToken(callbackContext);
            return true;
        } else if (action.equals("verifyAccessToken")) {
            this.verifyAccessToken(callbackContext);
            return true;
        } else if (action.equals("refreshAccessToken")) {
            this.refreshAccessToken(callbackContext);
            return true;
        } else {
            return false;
        }
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode != REQUEST_CODE) {
            return;
        }

        LineLoginResult result = LineLoginApi.getLoginResultFromIntent(data);
        if (result.getResponseCode() == LineApiResponseCode.SUCCESS) {
            JSONObject json = new JSONObject();
            try {
                LineProfile profile = result.getLineProfile();
                json.put("userID", profile.getUserId());
                json.put("displayName", profile.getDisplayName());
                json.put("pictureURL", profile.getPictureUrl().toString());

                LineIdToken lineIdToken = result.getLineIdToken();
                json.put("email", lineIdToken.getEmail());

                callbackContext.success(json);
            } catch (JSONException e) {
                this.UnknownError(e.toString());
            }
        } else if (result.getResponseCode() == LineApiResponseCode.CANCEL) {
            this.SDKError(result.getResponseCode().toString(), "user cancel");
        } else {
            this.SDKError(result.getResponseCode().toString(), result.toString());
        }
    }

    private void initialize(JSONArray data, CallbackContext callbackContext) throws JSONException {
        JSONObject params = data.getJSONObject(0);
        channelId = params.get("channel_id").toString();
        if (channelId.length() == 0) {
            this.parameterError("channel_id is required.");
        } else {
            LineApiClientBuilder apiClientBuilder = new LineApiClientBuilder(this.cordova.getActivity().getApplicationContext(), channelId);
            lineApiClient = apiClientBuilder.build();
        }
    }

    private void login(CallbackContext callbackContext) {
        try {
            Intent loginIntent = LineLoginApi.getLoginIntent(
                    this.cordova.getActivity().getApplicationContext(),
                    channelId,
                    new LineAuthenticationParams.Builder()
                            .scopes(Arrays.asList(Scope.PROFILE, Scope.OPENID_CONNECT, Scope.OC_EMAIL))
                            .build()
            );
            this.cordova.startActivityForResult((CordovaPlugin) this, loginIntent, REQUEST_CODE);
        } catch (Exception e) {
            this.UnknownError(e.toString());
        }
    }

    private void logout(CallbackContext callbackContext) {
        try {
            lineApiClient.logout();
            callbackContext.success();
        } catch (Exception e) {
            this.UnknownError(e.toString());
        }
    }

    private void getAccessToken(CallbackContext callbackContext) {
        try {
            JSONObject json = new JSONObject();
            LineAccessToken lineAccessToken = lineApiClient.getCurrentAccessToken().getResponseData();
            json.put("accessToken", lineAccessToken.getTokenString());
            json.put("expireTime", lineAccessToken.getEstimatedExpirationTimeMillis());
            callbackContext.success(json);
        } catch (Exception e) {
            this.UnknownError(e.toString());
        }
    }

    private void verifyAccessToken(CallbackContext callbackContext) {
        LineApiResponse verifyResponse = lineApiClient.verifyToken();
        if (verifyResponse.isSuccess()) {
            callbackContext.success();
        } else {
            this.SDKError(verifyResponse.getResponseCode().toString(), verifyResponse.getErrorData().toString());
        }
    }

    private void refreshAccessToken(CallbackContext callbackContext) {
        try {
            lineApiClient.refreshAccessToken();
            LineAccessToken lineAccessToken = lineApiClient.getCurrentAccessToken().getResponseData();
            callbackContext.success(lineAccessToken.getTokenString());
        } catch (Exception e) {
            this.UnknownError(e.toString());
        }
    }

    private void parameterError(String description) {
        try {
            JSONObject json = new JSONObject();
            json.put("code", PARAMETER_ERROR);
            json.put("description", description);
            callbackContext.error(json);
        } catch (JSONException e) {
            this.UnknownError(e.toString());
        }
    }

    private void SDKError(String sdkErrorCode, String description) {
        try {
            JSONObject json = new JSONObject();
            json.put("code", SDK_ERROR);
            json.put("sdkErrorCode", sdkErrorCode);
            json.put("description", description);
            callbackContext.error(json);
        } catch (JSONException e) {
            this.UnknownError(e.toString());
        }
    }

    private void UnknownError(String description) {
        try {
            JSONObject json = new JSONObject();
            json.put("code", UNKNOWN_ERROR);
            json.put("description", description);
            callbackContext.error(json);
        } catch (JSONException e) {
            callbackContext.error(-1);
        }
    }
}
