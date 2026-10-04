import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fixgeo_app/app.dart';
import 'package:fixgeo_app/core/constants/app_strings.dart';

Future<void> finishSplash(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 500)),
  );
  await tester.pump(const Duration(milliseconds: 2500));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows splash and then opens onboarding', (tester) async {
    await tester.pumpWidget(const FixGeoApp());

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.tagline), findsOneWidget);

    await finishSplash(tester);

    expect(find.text(AppStrings.onboardingWelcomeTitle), findsOneWidget);
    expect(find.textContaining(AppStrings.continueLabel), findsOneWidget);
  });

  testWidgets('onboarding remains usable on a compact phone', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const FixGeoApp());
    await finishSplash(tester);

    final expectedTitles = [
      AppStrings.onboardingWelcomeTitle,
      AppStrings.onboardingHowTitle,
      AppStrings.onboardingProviderTitle,
      AppStrings.onboardingRealityTitle,
      AppStrings.onboardingAboutTitle,
    ];

    for (final title in expectedTitles) {
      expect(find.text(title), findsOneWidget);
      if (title != expectedTitles.last) {
        await tester.drag(find.byType(PageView), const Offset(-300, 0));
        await tester.pumpAndSettle();
      }
    }

    await tester.tap(find.textContaining(AppStrings.continueLabel));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.chooseAccountType), findsOneWidget);
  });

  testWidgets('skip opens account type selection', (tester) async {
    await tester.pumpWidget(const FixGeoApp());
    await finishSplash(tester);

    await tester.tap(find.text(AppStrings.skip));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.chooseAccountType), findsOneWidget);
    expect(find.text(AppStrings.client), findsOneWidget);
    expect(find.text(AppStrings.provider), findsOneWidget);
    expect(find.text(AppStrings.company), findsOneWidget);
  });
}
