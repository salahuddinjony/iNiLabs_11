import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inilab/core/utils/api_service.dart';
import 'package:inilab/data/models/github_repository.dart' as repo_model;
import 'package:inilab/data/models/github_user.dart';
import 'package:inilab/data/repositories/github_repository.dart';

enum ViewType { list, grid }
enum SortType { name, date, stars, updated }

/// Home Controller
class HomeController extends GetxController {
  final GithubRepository _repository = GithubRepository(ApiService());
  
  // Observable variables
  final _isLoading = false.obs;
  final _isLoadingRepos = false.obs;
  final _errorMessage = ''.obs;
  final _user = Rxn<GithubUser>();
  final _repositories = <repo_model.GithubRepository>[].obs;
  final _filteredRepositories = <repo_model.GithubRepository>[].obs;
  final _viewType = ViewType.list.obs;
  final _sortType = SortType.updated.obs;
  final _searchQuery = ''.obs;
  
  // Getters
  bool get isLoading => _isLoading.value;
  bool get isLoadingRepos => _isLoadingRepos.value;
  String get errorMessage => _errorMessage.value;
  GithubUser? get user => _user.value;
  List<repo_model.GithubRepository> get repositories => _filteredRepositories;
  ViewType get viewType => _viewType.value;
  SortType get sortType => _sortType.value;
  String get searchQuery => _searchQuery.value;
  
  String? _username;
  
  @override
  void onInit() {
    super.onInit();
    _username = Get.arguments as String?;
    if (_username != null) {
      fetchUserData(_username!);
      fetchRepositories(_username!);
    }
  }
  
  /// Initialize with username (for go_router)
  void initialize(String username) {
    // Always reload data to ensure fresh data when navigating
    _username = username;
    fetchUserData(username);
    fetchRepositories(username);
  }
  
  /// Fetch user data
  Future<void> fetchUserData(String username) async {
    _isLoading.value = true;
    _errorMessage.value = '';
    
    try {
      final user = await _repository.fetchUser(username);
      _user.value = user;
      _isLoading.value = false;
    } catch (e) {
      _isLoading.value = false;
      _errorMessage.value = e.toString();
      EasyLoading.showError(e.toString());
    }
  }
  
  /// Fetch repositories
  Future<void> fetchRepositories(String username) async {
    _isLoadingRepos.value = true;
    _errorMessage.value = '';
    
    try {
      final repos = await _repository.fetchUserRepositories(username);
      _repositories.value = repos;
      _applyFilters();
      _isLoadingRepos.value = false;
    } catch (e) {
      _isLoadingRepos.value = false;
      _errorMessage.value = e.toString();
      EasyLoading.showError(e.toString());
    }
  }
  
  /// Toggle view type
  void toggleViewType() {
    _viewType.value = _viewType.value == ViewType.list 
        ? ViewType.grid 
        : ViewType.list;
  }
  
  /// Change sort type
  void changeSortType(SortType type) {
    _sortType.value = type;
    _applyFilters();
  }
  
  /// Search repositories
  void searchRepositories(String query) {
    _searchQuery.value = query;
    _applyFilters();
  }
  
  /// Apply filters and sorting
  void _applyFilters() {
    var filtered = List<repo_model.GithubRepository>.from(_repositories);
    
    // Apply search filter
    if (_searchQuery.value.isNotEmpty) {
      filtered = filtered.where((repo) {
        return repo.name.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
            (repo.description?.toLowerCase().contains(_searchQuery.value.toLowerCase()) ?? false);
      }).toList();
    }
    
    // Apply sorting
    switch (_sortType.value) {
      case SortType.name:
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortType.date:
        filtered.sort((a, b) {
          final dateA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(1970);
          final dateB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(1970);
          return dateB.compareTo(dateA);
        });
        break;
      case SortType.stars:
        filtered.sort((a, b) => b.stargazersCount.compareTo(a.stargazersCount));
        break;
      case SortType.updated:
        filtered.sort((a, b) {
          final dateA = DateTime.tryParse(a.updatedAt ?? '') ?? DateTime(1970);
          final dateB = DateTime.tryParse(b.updatedAt ?? '') ?? DateTime(1970);
          return dateB.compareTo(dateA);
        });
        break;
    }
    
    _filteredRepositories.value = filtered;
  }
  
  /// Refresh data
  Future<void> refresh() async {
    if (_username != null) {
      await Future.wait([
        fetchUserData(_username!),
        fetchRepositories(_username!),
      ]);
    }
  }
}
