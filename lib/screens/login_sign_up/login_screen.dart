import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/login_signup_imports.dart';
import 'package:foap/screens/login_sign_up/set_user_name.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final LoginController controller = Get.find();

  bool showPassword = false;

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
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: Get.height * 0.1,
                ),
                // const Align(
                //   alignment: Alignment.centerLeft,
                //   child: AppThemeBackButton(),
                // ),
                // SizedBox(
                //   height: Get.height * 0.05,
                // ),
                SizedBox(
                    height: Get.height * 0.12,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Heading3Text(signInMessageString.tr,
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
                  controller: email,
                  hintText: emailOrUsernameString.tr,
                  icon: ThemeIcon.email,
                ),
                SizedBox(
                  height: Get.height * 0.015,
                ),
                AppPasswordTextField(
                  controller: password,
                  hintText: passwordString.tr,
                  icon: ThemeIcon.lock,
                  onChanged: (value) {},
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => const ForgotPasswordScreen());
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: BodySmallText(
                      forgotPwdString.tr,
                      weight: TextWeight.semiBold,
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.015,
                ),
                addLoginBtn(),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Wrap(
                  spacing: 2,
                  children: [
                    BodySmallText(dontHaveAccountString),
                    BodySmallText(
                      createAnAccountString,
                      weight: TextWeight.bold,
                    ),
                  ],
                ).ripple(() {
                  Get.to(() => const SetUserName());
                }),
                divider(height: 1).vp(40),
                BodyMediumText(continueWithAccountsString),
                SizedBox(
                  height: Get.height * 0.04,
                ),
                const SocialLogin(hidePhoneLogin: false)
                    .setPadding(left: 65, right: 65),

                SizedBox(
                  height: Get.height * 0.05,
                ),
                // bioMetricView(),
                // const Spacer(),
              ]),
        ).setPadding(left: 25, right: 25),
      ),
    );
  }

  Widget addLoginBtn() {
    return AppThemeButton(
      onPress: () {
        controller.login(email.text.trim(), password.text.trim());
      },
      text: signInString.tr,
    );
  }
}
