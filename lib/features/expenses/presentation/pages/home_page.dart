import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_budget/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:smart_budget/features/expenses/presentation/bloc/expense_bloc.dart';
import 'package:smart_budget/features/expenses/presentation/pages/add_expense_page.dart';
import 'package:smart_budget/features/expenses/presentation/widgets/expense_list.dart';

import '../widgets/expense_summary.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(LoadExpenses());
  }

  void _navigateToAnalytics() {
   /*  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<AnalyticsBloc>(),
          child: AnalyticsPage(),
        ),
      ),
    ); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Budget'),
        actions: [
          IconButton(
            onPressed: _navigateToAnalytics,
            icon: Icon(Icons.bar_chart),
            tooltip: 'Analytics',
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              // onSelected==>activates when the user selects an item from the menu
              WidgetsBinding.instance.addPostFrameCallback((_) {      // "Wait until the UI build is complete, then execute the code."
                if (!mounted)return; //This checks that the page is still there (not closed) before you do anything.
                switch (value) {
                  case 'profile':
                    _navigateToProfile();
                    break;
                  case 'settings':
                    _navigateToSettings();
                    break;
                  case 'logout':
                    _showLogoutDialog();
                    break;
                  default:
                }
              });
            },
          ),
        ],
      ),
      body: BlocConsumer<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is ExpenseOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ExpenseLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ExpenseBloc>().add(LoadExpenses());
              },
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: ExpenseSummary(expenses: state.expenses),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.all(16),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Recent Transactions',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (state.expenses.isNotEmpty)
                            TextButton.icon(
                              onPressed: _navigateToAnalytics,
                              icon: const Icon(Icons.analytics, size: 16),
                              label: const Text('Analytics'),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  ExpenseList(expenses: state.expenses),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Something went wrong'),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<ExpenseBloc>().add(LoadExpenses());
                    },
                    label: const Text('Retry'),
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                // Passing the same existing bloc to the new page, you don't create a new one.
                value: context.read<ExpenseBloc>(),
                child: AddExpensePage(),
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }

  void _navigateToProfile() {
    // TODO: Create profile page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile page - Coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToSettings() {
    // TODO: Create settings page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settings page - Coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            child: Text('Logout'),
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(SignOutRequested());
            },
          ),
        ],
      ),
    );
  }
}
