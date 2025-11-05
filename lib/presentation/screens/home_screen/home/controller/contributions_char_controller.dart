import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inilab/core/utils/api_services/api_service.dart';
import 'package:inilab/presentation/screens/home_screen/home/widgets/contribution_chart.dart';

class ContributionChartController extends GetxController {
  final ApiService _apiService = ApiService();
  
  final RxList<ContributionDay> contributions = <ContributionDay>[].obs;
  final RxBool isLoading = true.obs;
  final Rxn<String> error = Rxn<String>();
  
  String? _currentUsername;
  
  Future<void> fetchContributions(String username) async {
    if (_currentUsername == username && contributions.isNotEmpty) {
      return; // Already loaded for this user
    }
    
    _currentUsername = username;
    isLoading.value = true;
    error.value = null;
    
    try {
      final query = '''
        query {
          user(login: "$username") {
            contributionsCollection {
              contributionCalendar {
                totalContributions
                weeks {
                  contributionDays {
                    contributionCount
                    date
                  }
                }
              }
            }
          }
        }
      ''';
      
      debugPrint('Fetching contributions for: $username');
      
      final response = await _apiService.graphql(query);
      
      debugPrint('Response: ${response.data}');
      
      if (response.data['errors'] != null) {
        final errorMsg = response.data['errors'][0]['message'];
        debugPrint('GraphQL Error: $errorMsg');
        error.value = errorMsg;
        isLoading.value = false;
        return;
      }
      
      if (response.data['data'] == null || response.data['data']['user'] == null) {
        debugPrint('No user data found');
        error.value = 'User not found';
        isLoading.value = false;
        return;
      }
      
      final weeks = response.data['data']['user']['contributionsCollection']
          ['contributionCalendar']['weeks'] as List;
      
      debugPrint('Weeks found: ${weeks.length}');
      
      final List<ContributionDay> allContributions = [];
      for (var week in weeks) {
        final days = week['contributionDays'] as List;
        for (var day in days) {
          allContributions.add(
            ContributionDay(
              count: day['contributionCount'],
              date: DateTime.parse(day['date']),
            ),
          );
        }
      }
      
      debugPrint('Total contributions: ${allContributions.length}');
      
      contributions.value = allContributions;
      isLoading.value = false;
    } catch (e) {
      debugPrint('Error fetching contributions: $e');
      error.value = e.toString();
      isLoading.value = false;
    }
  }
}