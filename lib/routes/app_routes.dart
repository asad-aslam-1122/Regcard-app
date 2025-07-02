import 'package:get/get.dart';
import 'package:regcard/src/auth/view/change_pass_view.dart';
import 'package:regcard/src/auth/view/complete_profile/complete_profile_form.dart';
import 'package:regcard/src/auth/view/forgot_pass_view.dart';
import 'package:regcard/src/auth/view/otp_view.dart';
import 'package:regcard/src/auth/view/signup_view.dart';
import 'package:regcard/src/base/view/account/view/add_documents_view.dart';
import 'package:regcard/src/base/view/account/view/billing_detail_view.dart';
import 'package:regcard/src/base/view/account/view/contact_detail_view.dart';
import 'package:regcard/src/base/view/account/view/documents_view.dart';
import 'package:regcard/src/base/view/account/view/family_member.dart';
import 'package:regcard/src/base/view/account/view/my_profile_view.dart';
import 'package:regcard/src/base/view/account/view/my_regcard_document_view.dart';
import 'package:regcard/src/base/view/account/view/personalized_view.dart';
import 'package:regcard/src/base/view/account/view/preferences_view.dart';
import 'package:regcard/src/base/view/base_view.dart';
import 'package:regcard/src/base/view/explore/view/my_records_view.dart';
import 'package:regcard/src/base/view/explore/view/travel_guide_view.dart';
import 'package:regcard/src/base/view/explore/view/travel_guides_gridview.dart';
import 'package:regcard/src/base/view/home/view/chats_view.dart';
import 'package:regcard/src/base/view/home/view/connect_member_view.dart';
import 'package:regcard/src/base/view/home/view/connect_with_members.dart';
import 'package:regcard/src/base/view/home/view/conversation_view.dart';
import 'package:regcard/src/base/view/home/view/notification_view.dart';
import 'package:regcard/src/base/view/home/view/search_view.dart';
import 'package:regcard/src/base/view/my_regcard/view/regcard_history_view.dart';
import 'package:regcard/src/base/view/my_regcard/view/regcard_webview.dart';
import 'package:regcard/src/base/view/settings/view/admin_support_view.dart';
import 'package:regcard/src/base/view/settings/view/biometric_view.dart';
import 'package:regcard/src/base/view/settings/view/connection_view.dart';
import 'package:regcard/src/base/view/settings/view/legal_documents_view.dart';
import 'package:regcard/src/base/view/settings/view/notification_settings_view.dart';
import 'package:regcard/src/base/view/settings/view/settings_view.dart';
import 'package:regcard/src/base/view/settings/view/sharing_view.dart';
import 'package:regcard/src/landing/view/splash_view.dart';

import '../src/auth/view/login_view.dart';
import '../src/base/view/explore/view/expense_details/expense_details_view.dart';
import '../src/base/view/explore/view/expense_details/payment_history_view.dart';
import '../src/base/view/explore/view/split_payment/add_expense_view.dart';
import '../src/base/view/explore/view/split_payment/add_members_view.dart';
import '../src/base/view/explore/view/split_payment/split_payments_view.dart';
import '../src/base/view/my_regcard/view/my_regcard_view.dart';
import '../src/base/view/my_regcard/view/reg_card_list_view.dart';

abstract class AppRoutes {
  static final List<GetPage> pages = [
    GetPage(name: SplashView.route, page: () => const SplashView()),
    GetPage(name: LoginView.route, page: () => const LoginView()),
    GetPage(name: ForgotPassView.route, page: () => const ForgotPassView()),
    GetPage(name: OTPView.route, page: () => const OTPView()),
    GetPage(name: SignupView.route, page: () => const SignupView()),
    GetPage(name: ChangePassView.route, page: () => const ChangePassView()),
    GetPage(
        name: CompleteProfileForm.route,
        page: () => const CompleteProfileForm()),
    GetPage(name: BaseView.route, page: () => const BaseView()),
    GetPage(name: NotificationView.route, page: () => const NotificationView()),
    GetPage(name: ChatsView.route, page: () => const ChatsView()),
    GetPage(name: ConversationView.route, page: () => const ConversationView()),
    GetPage(name: MyRecordsView.route, page: () => const MyRecordsView()),
    GetPage(name: SettingsView.route, page: () => const SettingsView()),
    GetPage(name: TravelGuideView.route, page: () => const TravelGuideView()),
    GetPage(
        name: NotificationSettingView.route,
        page: () => const NotificationSettingView()),
    GetPage(name: ConnectionView.route, page: () => const ConnectionView()),
    GetPage(
        name: ConnectWithMembers.route, page: () => const ConnectWithMembers()),
    GetPage(name: SharingView.route, page: () => const SharingView()),
    GetPage(name: PersonalizedView.route, page: () => const PersonalizedView()),
    GetPage(name: PreferencesView.route, page: () => const PreferencesView()),
    GetPage(
        name: MyRegcardDocumentView.route,
        page: () => const MyRegcardDocumentView()),
    GetPage(name: AddDocumentsView.route, page: () => const AddDocumentsView()),
    GetPage(name: DocumentsView.route, page: () => const DocumentsView()),
    GetPage(name: MyProfileView.route, page: () => const MyProfileView()),
    GetPage(
        name: ContactDetailsView.route, page: () => const ContactDetailsView()),
    GetPage(
        name: BillingDetailView.route, page: () => const BillingDetailView()),
    GetPage(name: SearchView.route, page: () => const SearchView()),
    GetPage(name: RegcardWebView.route, page: () => const RegcardWebView()),
    GetPage(
        name: ConnectMemberView.route, page: () => const ConnectMemberView()),
    GetPage(name: FamilyMemberView.route, page: () => const FamilyMemberView()),
    GetPage(
        name: TravelGuideGridView.route,
        page: () => const TravelGuideGridView()),
    GetPage(
        name: LegalDocumentsView.route, page: () => const LegalDocumentsView()),
    GetPage(
        name: SplitPaymentsView.route, page: () => const SplitPaymentsView()),
    GetPage(name: AddExpenseView.route, page: () => AddExpenseView()),
    GetPage(name: AddMembersView.route, page: () => AddMembersView()),
    GetPage(name: PaymentHistoryView.route, page: () => PaymentHistoryView()),
    GetPage(name: ExpenseDetailsView.route, page: () => ExpenseDetailsView()),
    GetPage(name: BiometricView.route, page: () => BiometricView()),
    GetPage(name: AdminSupportView.route, page: () => AdminSupportView()),
    GetPage(name: RegCardListView.route, page: () => RegCardListView()),
    GetPage(name: RegcardHistoryView.route, page: () => RegcardHistoryView()),
    GetPage(name: MyRegCardView.route, page: () => MyRegCardView()),
  ];
}
