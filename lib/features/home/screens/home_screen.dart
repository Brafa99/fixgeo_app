import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../data/home_mock_data.dart';
import '../widgets/home_bottom_navigation.dart';
import '../widgets/home_content_sections.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavigationIndex = 0;

  void _openAccountMenu() {
    Navigator.pushNamed(context, RouteNames.accountMenu);
  }

  void _openLogin() {
    Navigator.pushNamed(context, RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    final categories = HomeMockData.categories;
    final quickCategories = [categories[0], categories[1], categories.last];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSizes.maxContentWidth,
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Stack(
                        children: [
                          HomeHeader(
                            onEnter: _openLogin,
                            onMenu: _openAccountMenu,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 118),
                            child: HomeSearchCard(
                              categories: quickCategories,
                              onSearchTap: () {},
                              onSearchChanged: (_) {},
                              onSearchSubmit: _openLogin,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 42)),
                    const SliverToBoxAdapter(child: SuccessStoriesSection()),
                    const SliverToBoxAdapter(child: SizedBox(height: 38)),
                    const SliverToBoxAdapter(child: HowFixGeoWorksSection()),
                    const SliverToBoxAdapter(child: SizedBox(height: 40)),
                    const SliverToBoxAdapter(child: SocialNetworksSection()),
                    const SliverToBoxAdapter(child: SizedBox(height: 44)),
                    const SliverToBoxAdapter(child: DiscoverSection()),
                    const SliverToBoxAdapter(child: SizedBox(height: 128)),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.maxContentWidth,
              ),
              child: HomeBottomNavigation(
                currentIndex: _selectedNavigationIndex,
                onDestinationSelected: (index) {
                  if (index == 1) {
                    Navigator.pushReplacementNamed(context, RouteNames.orders);
                    return;
                  }
                  if (index == 2) {
                    _openAccountMenu();
                    return;
                  }
                  setState(() => _selectedNavigationIndex = index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
