import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';

/// Home screen matching Figma Frame 2 "home".
/// Shows greeting, date, category tabs, room list, and bottom navigation.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  int _navIndex = 1; // Home is center

  List<Room> get _filteredRooms {
    final category = MockData.roomCategories[_selectedCategoryIndex];
    if (category == 'All') return MockData.rooms;
    return MockData.rooms.where((room) {
      switch (category) {
        case 'Room':
          return room.type == RoomType.room;
        case 'Lab':
          return room.type == RoomType.lab;
        case 'Auditorium':
          return room.type == RoomType.auditorium;
        default:
          return true;
      }
    }).toList();
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
          // White background
          Container(color: AppColors.white),

          // Decorative ellipses (background)
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 169,
              height: 169,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient.scale(0.3),
              ),
            ),
          ),
          Positioned(
            bottom: size.height * 0.15,
            left: -60,
            child: Container(
              width: 242,
              height: 247,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight.withOpacity(0.08),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status bar area spacing
                const SizedBox(height: AppSpacing.sm),

                // Header section
                _buildHeader(),

                const SizedBox(height: AppSpacing.lg),

                // Category tabs
                CategoryTabs(
                  categories: MockData.roomCategories,
                  selectedIndex: _selectedCategoryIndex,
                  onSelected: (index) {
                    setState(() => _selectedCategoryIndex = index);
                  },
                ),

                const SizedBox(height: AppSpacing.lg),

                // Room list
                Expanded(child: _buildRoomList()),
              ],
            ),
          ),

          // Bottom navigation bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomNavBar(
              currentIndex: _navIndex,
              onTap: _onNavTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final now = DateTime(2026, 4, 27); // Using mock date
    final dateFormatted = DateFormat('d MMMM yyyy').format(now);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, ${MockData.currentUser.username}.',
            style: AppTypography.headlineLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            dateFormatted,
            style: AppTypography.bodyLarge.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomList() {
    final rooms = _filteredRooms;

    if (rooms.isEmpty) {
      return Center(
        child: Text(
          'No rooms found',
          style: AppTypography.bodyLarge.copyWith(color: AppColors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: 100, // Space for nav bar
      ),
      itemCount: rooms.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        return RoomCard(
          room: rooms[index],
          onTap: () => _onRoomTap(rooms[index]),
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
