/// ルート名定数 (Prototype.html の useRouter 相当)
class Routes {
  Routes._();

  static const splash = '/';
  static const onbWelcome = '/onboarding/welcome';
  static const onbHowItWorks = '/onboarding/how';
  static const onbExamType = '/onboarding/exam-type';
  static const onbReminder = '/onboarding/reminder';
  static const onbGoal = '/onboarding/goal';
  static const notificationPermission = '/onboarding/notification';

  static const home = '/home';
  static const calendar = '/calendar';
  static const review = '/review';
  static const settings = '/settings';
  static const examSelector = '/exam-selector';

  static const question = '/quiz/question';
  static const feedback = '/quiz/feedback';
  static const result = '/quiz/result';
  static const explanation = '/quiz/explanation';

  static const paywall = '/paywall';
  static const purchased = '/purchased';
  static const day14Complete = '/day14';
}
