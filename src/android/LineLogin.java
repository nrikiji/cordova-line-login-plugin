package plugin.line;

import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.linecorp.linesdk.LineAccessToken;
import com.linecorp.linesdk.LineApiResponse;
import com.linecorp.linesdk.LineApiResponseCode;
import com.linecorp.linesdk.LineProfile;
import com.linecorp.linesdk.api.LineApiClient;
import com.linecorp.linesdk.api.LineApiClientBuilder;
import com.linecorp.linesdk.auth.LineLoginApi;
import com.linecorp.linesdk.auth.LineLoginResult;

import org.apache.cordova.*;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class LineLogin extends CordovaPlugin {

    String channelId;
    CallbackContext callbackContext;
    private static LineApiClient lineApiClient;

    @Override
    public boolean execute(String action, JSONArray data, CallbackContext callbackContext) throws JSONException {

        if (action.equals("initialize")) {
            JSONObject params = data.getJSONObject(0);
            channelId = params.get("channel_id").toString();

            LineApiClientBuilder apiClientBuilder = new LineApiClientBuilder(this.cordova.getActivity().getApplicationContext(), channelId);
            lineApiClient = apiClientBuilder.build();

            return true;
        } else if (action.equals("login")) {
            Context context = this.cordova.getActivity().getApplicationContext();
            Intent loginIntent = LineLoginApi.getLoginIntent(context, channelId);
            this.cordova.startActivityForResult((CordovaPlugin) this, loginIntent, 0);
            this.callbackContext = callbackContext;
            return true;
        } else if (action.equals("logout")) {
            try {
                lineApiClient.logout();
                callbackContext.success();
            } catch (Exception e) {
                callbackContext.error(-1);
            }
            return true;
        } else if (action.equals("getAccessToken")) {
            JSONObject json = new JSONObject();
            LineAccessToken lineAccessToken = lineApiClient.getCurrentAccessToken().getResponseData();
            try {
                json.put("accessToken", lineAccessToken.getAccessToken());
                json.put("expireTime", lineAccessToken.getEstimatedExpirationTimeMillis());
                callbackContext.success(json);
            } catch (JSONException e) {
                callbackContext.error(-1);
            }
            return true;
        } else if (action.equals("verifyAccessToken")) {
            LineApiResponse verifyResponse = lineApiClient.verifyToken();
            if (verifyResponse.isSuccess()) {
                callbackContext.success();
            } else {
                callbackContext.error(-1);
            }
            return true;
        } else if (action.equals("refreshAccessToken")) {
            try {
                lineApiClient.refreshAccessToken();
                String accessToken = lineApiClient.getCurrentAccessToken().getResponseData().getAccessToken();
                callbackContext.success(accessToken);
            } catch (Exception e) {
                callbackContext.error(-1);
            }
            return true;
        } else {
            return false;
        }
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        LineLoginResult result = LineLoginApi.getLoginResultFromIntent(data);
        JSONObject json = new JSONObject();
        if (result.getResponseCode() == LineApiResponseCode.SUCCESS) {
            LineProfile profile = result.getLineProfile();
            try {
                json.put("userID", profile.getUserId());
                json.put("displayName", profile.getDisplayName());
                json.put("pictureURL", profile.getPictureUrl());
                callbackContext.success(json);
            } catch (JSONException e) {
                callbackContext.error(-1);
            }
        } else {
            callbackContext.error(-1);
        }
    }
}
