package utils;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import model.FacebookUser;
import org.apache.http.client.fluent.Request;
import java.io.IOException;

public class FacebookUtils {

    // 1. Lấy Token từ Code (Đã sửa lại để dùng đúng Constants)
    public static String getToken(String code) throws IOException {
        // Lưu ý: Hàm String.format này sẽ điền ID, Secret, URL vào các chỗ %s trong file Constants
        String link = String.format(FacebookConstants.FACEBOOK_LINK_GET_TOKEN,
                FacebookConstants.FACEBOOK_APP_ID,
                FacebookConstants.FACEBOOK_APP_SECRET,
                FacebookConstants.FACEBOOK_REDIRECT_URI,
                code);

        // Gửi request lên Facebook để lấy Token
        String response = Request.Get(link).execute().returnContent().asString();

        // Xử lý kết quả trả về
        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        return jobj.get("access_token").getAsString();
    }

    // 2. Lấy thông tin User từ Token
    public static FacebookUser getUserInfo(String accessToken) throws IOException {
        String link = String.format(FacebookConstants.FACEBOOK_LINK_GET_USER_INFO, accessToken);
        String response = Request.Get(link).execute().returnContent().asString();
        return new Gson().fromJson(response, FacebookUser.class);
    }
}