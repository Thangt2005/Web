package utils;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import model.FacebookUser;
import org.apache.http.client.fluent.Request;
import java.io.IOException;

public class FacebookUtils {

    // 1. Lấy Token từ Code
    public static String getToken(String code) throws IOException {
        String link = String.format("%s?client_id=%s&client_secret=%s&redirect_uri=%s&code=%s",
                FacebookConstants.FACEBOOK_LINK_GET_TOKEN,
                FacebookConstants.FACEBOOK_APP_ID,
                FacebookConstants.FACEBOOK_APP_SECRET,
                FacebookConstants.FACEBOOK_REDIRECT_URI,
                code);

        // Facebook dùng phương thức GET để lấy token (Google dùng POST)
        String response = Request.Get(link).execute().returnContent().asString();

        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        return jobj.get("access_token").getAsString();
    }

    // 2. Lấy thông tin User từ Token
    public static FacebookUser getUserInfo(String accessToken) throws IOException {
        String link = FacebookConstants.FACEBOOK_LINK_GET_USER_INFO + accessToken;
        String response = Request.Get(link).execute().returnContent().asString();
        return new Gson().fromJson(response, FacebookUser.class);
    }
}