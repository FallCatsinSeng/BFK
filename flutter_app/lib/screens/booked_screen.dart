import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';
import '../providers/providers.dart';

/// Ready Booked / History screen matching Figma Frame 11 "ready booked".
/// Now loads bookings from API via BookingProvider.
class BookedScreen extends StatefulWidget {
  const BookedScreen({super.key});

  @override
  State<BookedScreen> createState() => _BookedScreenState();
}

class _BookedScreenState extends State<BookedScreen> {
  int _selectedTab = 0;
  int _selectedDateIndex = 0;
  int _navIndex = 0;
  late List<DateTime> _weekDates;

  @override
  void initState() {
    super.initState();
    _weekDates = MockData.getWeekDates(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().loadBookings();
    });
  }

  void _onNavTap(int index) {
    if (index == 1) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/calendar');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(color: AppColors.white),
          Positioned(
            top: -20, right: -20,
            child: Container(width: 169, height: 169,
              decoration: BoxDecoration(shape: BoxShape.circle,
                color: AppColors.primaryLight.withOpacity(0.15))),
          ),
          Positioned(
            bottom: size.height * 0.3, left: -50,
            child: Container(width: 205, height: 205,
              decoration: BoxDecoration(shape: BoxShape.circle,
                color: AppColors.primaryLight.withOpacity(0.08))),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.sm),
                _buildTopBar(),
                const SizedBox(height: AppSpacing.lg),
                _buildTabToggle(),
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: DatePickerStrip(
                    dates: _weekDates,
                    selectedIndex: _selectedDateIndex,
                    onDateSelected: (i) => setState(() => _selectedDateIndex = i),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(child: _buildBookingList()),
              ],
            ),
          ),
          Positioned(left: 0, right: 0, bottom: 0,
            child: CustomNavBar(currentIndex: _navIndex, onTap: _onNavTap)),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(children: [
        const CustomBackButton(),
        const SizedBox(width: AppSpacing.md),
        Text('Already Booked', style: AppTypography.titleLarge),
        const Spacer(),
        Container(width: 28, height: 28,
          decoration: BoxDecoration(color: AppColors.greyBackground,
            shape: BoxShape.circle, border: Border.all(color: AppColors.greyLight)),
          child: const Icon(Icons.calendar_today, size: 14, color: AppColors.black)),
      ]),
    );
  }

  Widget _buildTabToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(children: [
        _buildTabChip(0, Icons.calendar_today, 'Upcoming'),
        const SizedBox(width: AppSpacing.md),
        _buildTabChip(1, Icons.history, 'History'),
      ]),
    );
  }

  Widget _buildTabChip(int index, IconData icon, String label) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.greyBackground,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: isSelected ? null : Border.all(color: AppColors.greyLight),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 14, color: isSelected ? AppColors.white : AppColors.grey),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: AppTypography.bodyMedium.copyWith(
            color: isSelected ? AppColors.white : AppColors.grey, fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }

  Widget _buildBookingList() {
    return Consumer<BookingProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final bookings = _selectedTab == 0
            ? provider.upcomingBookings
            : provider.completedBookings;

        if (bookings.isEmpty) {
          return Center(child: Text('No bookings found',
            style: AppTypography.bodyLarge.copyWith(color: AppColors.grey)));
        }

        return ListView.separated(
          padding: const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.lg, bottom: 100),
          itemCount: bookings.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            return BookingCard(
              booking: bookings[index],
              onTap: () => Navigator.pushNamed(context, '/detail', arguments: bookings[index].room),
            );
          },
        );
      },
    );
  }
}
