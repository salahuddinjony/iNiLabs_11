import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/presentation/screens/home_screen/home/controller/contributions_char_controller.dart';

/// Controller for managing contribution chart state


/// GitHub-style Contribution Chart Widget with Real GraphQL Data
class ContributionChart extends StatelessWidget {
  final String username;
  
  const ContributionChart({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Initialize controller and fetch data
    final controller = Get.put(
      ContributionChartController(),
      tag: username,
    );
    
    // Fetch contributions when widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchContributions(username);
    });

    
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 20.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Contribution Activity',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: AppConstants.paddingMedium),
            
            Obx(() {
              if (controller.isLoading.value) {
                return SizedBox(
                  height: 85.h,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              
              if (controller.error.value != null) {
                return SizedBox(
                  height: 85.h,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Could not load contributions',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              return _buildContributionGrid(context, isDarkMode, controller.contributions);
            }),
          ],
        ),
      ),
    );
  }
  
  Widget _buildContributionGrid(
    BuildContext context,
    bool isDarkMode,
    List<ContributionDay> contributions,
  ) {
    if (contributions.isEmpty) {
      return SizedBox(
        height: 85.h,
        child: const Center(child: Text('No contribution data')),
      );
    }
    
    // Organize contributions into weeks
    final weeks = <List<ContributionDay>>[];
    for (var i = 0; i < contributions.length; i += 7) {
      final end = (i + 7 < contributions.length) ? i + 7 : contributions.length;
      weeks.add(contributions.sublist(i, end));
    }
    
    // Get month labels
    final monthLabels = _getMonthLabels(weeks);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month labels
        Padding(
          padding: EdgeInsets.only(left: 32.w, bottom: 4.h),
          child: SizedBox(
            height: 12.h,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: monthLabels.entries.map((entry) {
                  return SizedBox(
                    width: entry.value * 12.w,
                    child: Text(
                      entry.key,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 9.sp,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        
        // Contribution grid
        SizedBox(
          height: 85.h,
          child: Row(
            children: [
              // Day labels
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 10.h),
                  _buildDayLabel(context, 'Mon'),
                  SizedBox(height: 2.h),
                  _buildDayLabel(context, 'Wed'),
                  SizedBox(height: 2.h),
                  _buildDayLabel(context, 'Fri'),
                  SizedBox(height: 2.h),
                ],
              ),
              
              SizedBox(width: 8.w),
              
              // Contribution boxes
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: weeks.map((week) {
                      return Padding(
                        padding: EdgeInsets.only(right: 2.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: week.map((day) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 2.h),
                              child: _buildContributionBox(
                                context,
                                day.count,
                                isDarkMode,
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Map<String, int> _getMonthLabels(List<List<ContributionDay>> weeks) {
    final monthLabels = <String, int>{};
    String? currentMonth;
    int weekCount = 0;
    
    for (var week in weeks) {
      if (week.isEmpty) continue;
      
      final firstDay = week.first;
      final monthName = _getMonthName(firstDay.date.month);
      
      if (currentMonth != monthName) {
        if (currentMonth != null && weekCount > 0) {
          monthLabels[currentMonth] = weekCount;
        }
        currentMonth = monthName;
        weekCount = 1;
      } else {
        weekCount++;
      }
    }
    
    // Add the last month
    if (currentMonth != null && weekCount > 0) {
      monthLabels[currentMonth] = weekCount;
    }
    
    return monthLabels;
  }
  
  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
  
  Widget _buildDayLabel(BuildContext context, String day) {
    return Text(
      day,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontSize: 9.sp,
      ),
    );
  }
  
  Widget _buildContributionBox(BuildContext context, int count, bool isDarkMode) {
    final level = _getContributionLevel(count);
    final color = _getContributionColor(level, isDarkMode);
    
    return Container(
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: isDarkMode 
              ? const Color(0xFF30363D)
              : const Color(0xFFD0D7DE),
          width: 0.5,
        ),
      ),
    );
  }
  
  int _getContributionLevel(int count) {
    if (count == 0) return 0;
    if (count <= 3) return 1;
    if (count <= 6) return 2;
    if (count <= 9) return 3;
    return 4;
  }
  
  Color _getContributionColor(int level, bool isDarkMode) {
    if (isDarkMode) {
      // GitHub dark mode colors
      switch (level) {
        case 0:
          return const Color(0xFF161B22); // No contributions
        case 1:
          return const Color(0xFF0E4429); // Low
        case 2:
          return const Color(0xFF006D32); // Medium-low
        case 3:
          return const Color(0xFF26A641); // Medium-high
        case 4:
          return const Color(0xFF39D353); // High
        default:
          return const Color(0xFF161B22);
      }
    } else {
      // GitHub light mode colors
      switch (level) {
        case 0:
          return const Color(0xFFEBEDF0); // No contributions
        case 1:
          return const Color(0xFF9BE9A8); // Low
        case 2:
          return const Color(0xFF40C463); // Medium-low
        case 3:
          return const Color(0xFF30A14E); // Medium-high
        case 4:
          return const Color(0xFF216E39); // High
        default:
          return const Color(0xFFEBEDF0);
      }
    }
  }
}

class ContributionDay {
  final int count;
  final DateTime date;
  
  ContributionDay({
    required this.count,
    required this.date,
  });
}


