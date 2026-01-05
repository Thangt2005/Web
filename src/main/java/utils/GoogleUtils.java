package utils;

import java.io.IOException;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import model.GoogleUser;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;

public class GoogleUtils {
    // Hàm lấy mã Token
    public static String getToken(String code) throws IOException {
        String response = Request.Post(GoogleConstants.GOOGLE_LINK_GET_TOKEN)
                .bodyForm(Form.form()
                        .add("client_id", GoogleConstants.GOOGLE_CLIENT_ID)
                        .add("client_secret", GoogleConstants.GOOGLE_CLIENT_SECRET)
                        .add("redirect_uri", GoogleConstants.GOOGLE_REDIRECT_URI)
                        .add("code", code)
                        .add("grant_type", GoogleConstants.GOOGLE_GRANT_TYPE)
                        .build())
                .execute().returnContent().asString();

        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        return jobj.get("access_token").getAsString();
    }

    // Hàm lấy thông tin User
    public static GoogleUser getUserInfo(String accessToken) throws IOException {
        String link = GoogleConstants.GOOGLE_LINK_GET_USER_INFO + accessToken;
        String response = Request.Get(link).execute().returnContent().asString();
        return new Gson().fromJson(response, GoogleUser.class);
    }
}