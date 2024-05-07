import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/login_signup_imports.dart';
import 'package:lottie/lottie.dart';
import '../settings_menu/settings_controller.dart';

class SignUpScreen extends StatefulWidget {
  final String userName;

  const SignUpScreen({Key? key, required this.userName}) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  SettingsController settingsController = Get.find();

  String countryCode = '+1';
  final LoginController loginController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
              height: Get.height * 0.1,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: AppThemeBackButton(),
            ),
            SizedBox(
              height: Get.height * 0.05,
            ),
            SizedBox(
                height: Get.height * 0.12,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Heading3Text(createAnAccountString.tr,
                            weight: TextWeight.bold)
                        .rp(100),
                    Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Lottie.asset(
                          'assets/lottie/syahi.json',
                        ))
                  ],
                )),
            SizedBox(
              height: Get.height * 0.05,
            ),
            AppTextField(
              icon: ThemeIcon.email,
              controller: email,
              hintText: emailString,
            ),
            SizedBox(
              height: Get.height * 0.015,
            ),
            AppPasswordTextField(
              controller: password,
              hintText: passwordString.tr,
              icon: ThemeIcon.lock,
              onChanged: (value) {
                loginController.checkPassword(value);
              },
            ),
            Obx(() {
              return loginController.passwordStrength.value < 0.8 &&
                      password.text.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        LinearProgressIndicator(
                          value: loginController.passwordStrength.value,
                          backgroundColor: Colors.grey[300],
                          color: loginController.passwordStrength.value <= 1 / 4
                              ? Colors.red
                              : loginController.passwordStrength.value == 2 / 4
                                  ? Colors.yellow
                                  : loginController.passwordStrength.value ==
                                          3 / 4
                                      ? Colors.blue
                                      : Colors.green,
                          minHeight: 5,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        BodySmallText(
                          loginController.passwordStrengthText.value,
                        ),
                      ],
                    )
                  : Container();
            }),
            SizedBox(
              height: Get.height * 0.015,
            ),
            addSignUpBtn(),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Wrap(
              spacing: 2,
              children: [
                BodySmallText(alreadyHaveAccString),
                BodySmallText(
                  signInString,
                  weight: TextWeight.bold,
                ),
              ],
            ).ripple(() {
              Get.to(() => const LoginScreen());
            }),
            divider(height: 1).vp(40),
            BodyMediumText(continueWithAccountsString),
            SizedBox(
              height: Get.height * 0.04,
            ),
            SocialLogin(
              hidePhoneLogin: false,
              userName: widget.userName,
            ).setPadding(left: 45, right: 45),
            SizedBox(
              height: Get.height * 0.2,
            ),
          ]),
        ).setPadding(left: 25, right: 25),
      ),
    );
  }

  addSignUpBtn() {
    return AppThemeButton(
      onPress: () {
        FocusScope.of(context).requestFocus(FocusNode());
        AppUtil.showTermsAndConditionConfirmationAlert(
            title: confirmString,
            subTitle:
                '${signingInTermsString.tr} ${termsOfServiceString.tr} ${andString.tr} ${privacyPolicyString.tr}',
            termsHandler: () {
              loginController.launchUrlInBrowser(
                  settingsController.setting.value!.termsOfServiceUrl!);
            },
            privacyPolicyHandler: () {
              loginController.launchUrlInBrowser(
                  settingsController.setting.value!.privacyPolicyUrl!);
            },
            okHandler: () {
              loginController.register(
                name: widget.userName,
                email: email.text,
                password: password.text,
              );
            });
      },
      text: signUpString.tr,
    );
  }
}
