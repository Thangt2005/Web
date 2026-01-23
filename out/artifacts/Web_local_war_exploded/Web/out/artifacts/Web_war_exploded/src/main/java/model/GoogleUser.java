package model;

import com.google.gson.annotations.SerializedName;

public class GoogleUser {
    @SerializedName("id")
    private String id;

    @SerializedName("email")
    private String email;

    @SerializedName("verified_email")
    private boolean verified_email;

    @SerializedName("name")
    private String name;

    @SerializedName("given_name")
    private String given_name;

    @SerializedName("family_name")
    private String family_name;

    @SerializedName("picture")
    private String picture;

    // Constructor rỗng (Bắt buộc cho Gson)
    public GoogleUser() {
    }

    public GoogleUser(String id, String email, boolean verified_email, String name, String given_name, String family_name, String picture) {
        this.id = id;
        this.email = email;
        this.verified_email = verified_email;
        this.name = name;
        this.given_name = given_name;
        this.family_name = family_name;
        this.picture = picture;
    }

    // Getter và Setter
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public boolean isVerified_email() {
        return verified_email;
    }

    public void setVerified_email(boolean verified_email) {
        this.verified_email = verified_email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getGiven_name() {
        return given_name;
    }

    public void setGiven_name(String given_name) {
        this.given_name = given_name;
    }

    public String getFamily_name() {
        return family_name;
    }

    public void setFamily_name(String family_name) {
        this.family_name = family_name;
    }

    public String getPicture() {
        return picture;
    }

    public void setPicture(String picture) {
        this.picture = picture;
    }

    @Override
    public String toString() {
        return "GoogleUser{" +
                "email='" + email + '\'' +
                ", name='" + name + '\'' +
                '}';
    }
}