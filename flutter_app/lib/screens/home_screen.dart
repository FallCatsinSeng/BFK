import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';
import '../providers/providers.dart';

/// Home screen matching Figma Frame 2 "home".
/// Now loads rooms from API via RoomProvider.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  int _navIndex = 1;

  @override
  void initState() {
    super.initState();
    // Load rooms and categories on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RoomProvider>().loadRooms();
      context.read<RoomProvider>().loadCategories();
    });
  }

  void _onCategorySelected(int index) {
    setState(() => _selectedCategoryIndex = index);
    final categories = context.read<RoomProvider>().categories;
    final type = index == 0 ? null : categories[index].toLowerCase();
    context.read<RoomProvider>().loadRooms(type: type);
  }

  void _onNavTap(int index) {
    setState(() => _navIndex = index);
    if (index == 0) {
      Navigator.pushNamed(context, '/booked');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/calendar');
    }
  }

  void _onRoomTap(Room room) {
    Navigator.pushNamed(context, '/detail', arguments: room);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(color: AppColors.white),
          Positioned(
            top: -40, right: -40,
            child: Container(
              width: 169, height: 169,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient.scale(0.3),
              ),
            ),
          ),
          Positioned(
            bottom: size.height * 0.15, left: -60,
            child: Container(
              width: 242, height: 247,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight.withOpacity(0.08),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.sm),
                _buildHeader(),
                const SizedBox(height: AppSpacing.lg),
                Consumer<RoomProvider>(
                  builder: (context, roomProvider, _) {
                    return CategoryTabs(
                      categories: roomProvider.categories,
                      selectedIndex: _selectedCategoryIndex,
                      onSelected: _onCategorySelected,
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(child: _buildRoomList()),
              ],
            ),
          ),
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: CustomNavBar(currentIndex: _navIndex, onTap: _onNavTap),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    final dateFormatted = DateFormat('d MMMM yyyy').format(now);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final username = auth.user?.username ?? 'user';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello, $username.', style: AppTypography.headlineLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(dateFormatted, style: AppTypography.bodyLarge.copyWith(color: AppColors.grey)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRoomList() {
    return Consumer<RoomProvider>(
      builder: (context, roomProvider, _) {
        if (roomProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final rooms = roomProvider.rooms;

        if (rooms.isEmpty) {
          return Center(
            child: Text('No rooms found', style: AppTypography.bodyLarge.copyWith(color: AppColors.grey)),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.lg, bottom: 100),
          itemCount: rooms.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            return RoomCard(
              room: rooms[index],
              onTap: () => _onRoomTap(rooms[index]),
            );
          },
        );
      },
    );
  }
}

/// Extension to scale gradient opacity
extension on LinearGradient {
  LinearGradient scale(double factor) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors.map((c) => c.withOpacity(factor)).toList(),
    );
  }
}
