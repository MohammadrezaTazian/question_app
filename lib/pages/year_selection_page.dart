import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:question_app/blocs/year_selection/year_selection_bloc.dart';
import 'package:question_app/blocs/year_selection/year_selection_event.dart';
import 'package:question_app/blocs/year_selection/year_selection_state.dart';
import 'package:question_app/widgets/custom_navigation_bottom.dart';
import 'package:question_app/models/year.dart';

class YearSelectionPage extends StatefulWidget {
  final String fieldName;

  const YearSelectionPage({
    super.key,
    required this.fieldName,
  });

  @override
  State<YearSelectionPage> createState() => _YearSelectionPageState();
}

class _YearSelectionPageState extends State<YearSelectionPage> {
  final TextEditingController _searchController = TextEditingController();
  final int _currentIndex = -1; // No item selected by default
  late YearSelectionBloc _yearSelectionBloc;

  @override
  void initState() {
    super.initState();
    _yearSelectionBloc = YearSelectionBloc();
    _yearSelectionBloc.add(LoadYears(widget.fieldName));
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _yearSelectionBloc.add(FilterYears(_searchController.text));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _yearSelectionBloc.close();
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    // Handle navigation based on index
    if (index == 0) {
      // Home
      Navigator.pushReplacementNamed(context, '/field_selection');
    } else if (index == 1) {
      // Questions
      debugPrint('Navigate to questions page');
    } else if (index == 2) {
      // Settings
      Navigator.pushReplacementNamed(context, '/settings');
    } else if (index == 3) {
      // Profile
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _yearSelectionBloc,
      child: BlocConsumer<YearSelectionBloc, YearSelectionState>(
        listener: (context, state) {
          if (state is YearSelectionLoaded && state.shouldNavigate) {
            final selectedYear = state.filteredYears[state.selectedIndex!];
            Navigator.pushNamed(
              context,
              '/course_selection',
              arguments: {
                'fieldName': widget.fieldName,
                'year': selectedYear.year,
              },
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                // Blue header with title and back button
                Container(
                  width: double.infinity,
                  color: const Color(0xFF2962FF),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const Text(
                          'لیست سال‌ها',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        hintText: 'جستجوی سال',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                    ),
                  ),
                ),

                // Years list
                Expanded(
                  child: _buildYearsList(state),
                ),

                // Use CustomNavigationBottom with no item selected
                CustomNavigationBottom(
                  currentIndex: _currentIndex,
                  onTap: _onNavItemTapped,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildYearsList(YearSelectionState state) {
    if (state is YearSelectionLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is YearSelectionError) {
      return Center(
          child:
              Text(state.message, style: const TextStyle(color: Colors.red)));
    } else if (state is YearSelectionLoaded) {
      return ListView.builder(
        itemCount: state.filteredYears.length,
        itemBuilder: (context, index) {
          return _buildYearItem(
              state.filteredYears[index], index, state.selectedIndex == index);
        },
      );
    }
    return const Center(child: Text('لطفا یک سال تحصیلی را انتخاب کنید'));
  }

  Widget _buildYearItem(Year year, int index, bool isSelected) {
    return InkWell(
      onTap: () {
        _yearSelectionBloc.add(SelectYear(year, index));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: Colors.green, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.chevron_left,
                color: isSelected ? Colors.green : Colors.grey,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    year.year,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.green : Colors.black,
                    ),
                  ),
                  Text(
                    year.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected
                          ? Colors.green.shade700
                          : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
