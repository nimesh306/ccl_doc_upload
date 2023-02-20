class ApiConstants {
  // private static Context context;
  String SERVER;

  ApiConstants(this.SERVER);
  // {
  // this.context = context;
  // SharedPreferences sharedPreferences = this.context.getSharedPreferences(SharedValue.MYSESSION, Context.MODE_PRIVATE);
  // String baseUrl = sharedPreferences.getString(SharedValue.SESS_SERVER, "");
  // SERVER = baseUrl;
  // SERVER = 'baseUrl';
  // }

  // -------------   local/development server   ----------------------
//    public static String SERVER = "http://203.115.15.85"; public and last live
//    public static String SERVER = "http://192.168.200.43";

  //-------------------    live server  ----------------------------------
  //          192.168.2.221
//      public static String SERVER = "http://192.168.2.221"; apn
//    public static String SERVER = "http://lkcopossw01.cclk.lk";

//    public final String BASE_URL = SERVER + ":8080/cc-switch/api/";
//    public final String NIC_IMAGE_URL = SERVER + ":8080/cc-switch/findFile?issuerCode=CCL&filName=";

  String getBaseUrl() {
    return SERVER + "/cc-switch/api/";
  }

  String getImageUrl() {
    return SERVER + "/cc-switch/findFile?issuerCode=CCL&filName=";
  }

  final String FILE_UPLOAD_BASE_URL = "";

  // Live servera
//    public static final String BASE_URL = "";
  // Live server - File Upload
//    public static final String FILE_UPLOAD_BASE_URL = "";

  String RESPONSE_VALUE_SUCCESS = "00";
  String MOBILE_APP_NAME = "cc_mobile.apk";

  //----------- QA----------------------
  String PUBLIC_SERVER = "http://116.12.90.20";
  String VPN_SERVER = "http://10.20.0.3:8080";

//--------------- LIVE----------
//    String PUBLIC_SERVER = "http://203.115.15.85:8080";
//    String VPN_SERVER = "http://192.168.2.221:8080";

}
