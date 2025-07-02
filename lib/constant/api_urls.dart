class ApiUrl {
  static String baseUrl = "https://reg-card-v3.assortcloud.com";

  // Auth
  static String signUp = "$baseUrl/api/v1/Authentication/Signup";
  static String login = "$baseUrl/api/v1/Authentication/Login";
  static String logout = "$baseUrl/api/v1/Authentication/Logout";
  static String otpGenerate = "$baseUrl/api/v1/Authentication/SendOTP";
  static String verifyAccount = "$baseUrl/api/v1/Authentication/VerifyAccount";
  static String resetPass = "$baseUrl/api/v1/Authentication/ResetPassword";

  // Complete Profile Forms
  static String form1 = "$baseUrl/api/v1/CompleteProfile/UpdateStep1";
  static String form2 = "$baseUrl/api/v1/CompleteProfile/UpdateStep2";
  static String form3 = "$baseUrl/api/v1/CompleteProfile/UpdateStep3";
  static String form4 = "$baseUrl/api/v1/CompleteProfile/UpdateStep4";
  static String form5 = "$baseUrl/api/v1/CompleteProfile/UpdateStep5";
  static String form6 = "$baseUrl/api/v1/CompleteProfile/UpdateStep6";
  static String form7 = "$baseUrl/api/v1/CompleteProfile/UpdateStep7";
  static String getPersonalizationOptions({required int id}) =>
      "$baseUrl/api/v1/shared/PersonalizationOptions?personalizationType=$id";
  static String profileWithSteps =
      "$baseUrl/api/v1/CompleteProfile/ProfileWithSteps";

  // Settings
  static String getSocialLinks = "$baseUrl/api/v1/Settings/SocialLinks";
  static String createHelpRequest =
      "$baseUrl/api/v1/Settings/CreateHelpRequest";
  static String getLegalDocs = "$baseUrl/api/v1/Settings/LegalDocument";
  static String deleteAccount = "$baseUrl/api/v1/Settings/DeleteAccount";
  static String getAllConnectionRequest(
          {required int pageNumber,
          required int pageSize,
          required String searchText}) =>
      "$baseUrl/api/v1/Settings/GetAllConnectionRequest?PageNumber=$pageNumber&PageSize=$pageSize&SearchText=$searchText";

  static String sendConnectionRequest =
      "$baseUrl/api/v1/Settings/SendConnectionRequest";
  static String acceptOrRejectConnectionRequest =
      "$baseUrl/api/v1/Settings/AcceptOrRejectConnectionRequest";
  static String removeConnection(num id) =>
      "$baseUrl/api/v1/Settings/RemoveConnection/$id";
  static String userSettingsToggle =
      "$baseUrl/api/v1/Settings/UserSettingsToggle";
  static String reportUser = "$baseUrl/api/v1/Settings/ReportUser";

  // Profile
  static String getProfile = "$baseUrl/api/v1/Settings/Profile";
  static String contactDetails = "$baseUrl/api/v1/MyProfile/Contact";
  static String billingDetails = "$baseUrl/api/v1/MyProfile/Billing";
  static String getPreferences = "$baseUrl/api/v1/MyProfile/Preference";
  static String getPersonalized = "$baseUrl/api/v1/MyProfile/Personalization";
  static String getProfilePic = "$baseUrl/api/v1/MyProfile/Picture";

  // Upload File
  static String uploadFile = "$baseUrl/api/v1/shared/UploadFile";

  // Documents
  static String documents = "$baseUrl/api/v1/Documents";
  static String deleteDocument({required int id}) =>
      "$baseUrl/api/v1/Documents/$id";

  //My Regcard
  static String myRegcard({required bool isEditable}) =>
      "$baseUrl/api/v1/MyRegCard/RegCard?isEditable=$isEditable";
  static String getsShareMyRegCard = "$baseUrl/api/v1/MyRegCard/Share";
  static String getInfoMyRegCard = "$baseUrl/api/v1/MyRegCard/Info";
  static String getQrCodeData(
          {required int pageNumber, required int pageSize}) =>
      "$baseUrl/api/v1/MyRegCard/GetQrCodeData?PageNumber=$pageNumber&PageSize=$pageSize";
  static String getQrCodeDataById({required int id}) =>
      "$baseUrl/api/v1/MyRegCard/GetQrCodeDataById?id=$id";
  static String getDuration = "$baseUrl/api/v1/MyRegCard/GetDuration";
  static String shareQRCodeData = "$baseUrl/api/v1/MyRegCard/ShareQRCodeData";

  // Home
  static String getProfileCompletionPercentage =
      "$baseUrl/api/v1/Home/ProfileCompletionPercentage";
  static String getAllMembers = "$baseUrl/api/v1/Home/Members/List";
  static String getTravelGuides(
          {required int pageNumber,
          required int pageSize,
          required String searchText}) =>
      "$baseUrl/api/v1/Home/TravelGuides/Paginated?PageNumber=$pageNumber&PageSize=$pageSize&SearchText=$searchText";
  static String getMembers(
          {required int pageNumber,
          required int pageSize,
          required String searchText}) =>
      "$baseUrl/api/v1/Home/Members/Paginated?PageNumber=$pageNumber&PageSize=$pageSize&SearchText=$searchText";
  static String getAllNotifications({
    required int pageNumber,
    required int pageSize,
  }) =>
      "$baseUrl/api/v1/Home/Notifications/Paginated?PageNumber=$pageNumber&PageSize=$pageSize";
  static String markAsSeen({required int id}) =>
      "$baseUrl/api/v1/Home/Notifications/$id/Read";

  //My Records
  static String getRecords({required int pageNumber, required int pageSize}) =>
      "$baseUrl/api/v1/Records/Paginated?PageNumber=$pageNumber&PageSize=$pageSize";
  static String createRecord = "$baseUrl/api/v1/Records";
  static String deleteRecord({required int id}) =>
      "$baseUrl/api/v1/Records/$id";

  //Chat
  static String createChatHead = "$baseUrl/api/v1/Chat/CreateChatHead";
  static String deleteChatHead(num id) =>
      "$baseUrl/api/v1/Chat/DeleteChatHead?ChatHeadId=$id";
  static String getChatHead = "$baseUrl/api/v1/Chat/GetChatHead";
  static String getChatById = "$baseUrl/api/v1/Chat/GetChatById";
  static String sendMessage = "$baseUrl/api/v1/Chat/SendMessage";
  static String blockUser = "$baseUrl/api/v1/Chat/BlockUser";
  static String readChat = "$baseUrl/api/v1/Chat/ReadChat";
  static String chatHub = "$baseUrl/hub";
}
