package model;

import com.google.gson.annotations.SerializedName;

public class FacebookUser {
    @SerializedName("id")
    private String id;

    @SerializedName("name")
    private String name;

    @SerializedName("email")
    private String email;

    // Facebook trả về ảnh dạng lồng nhau phức tạp, nhưng ta có thể lấy ảnh bằng ID
    // nên không cần khai báo field picture ở đây cho đỡ rối.

    public FacebookUser() {
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}