import 'package:flutter/material.dart';

class AppSheet extends StatelessWidget {
  const AppSheet({
    required this.title, required this.child, super.key,
    this.actionIcon,
    this.onAction,
    this.unFocus = false,
    this.bottom,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 16,
    ),
    this.isLoading = false,
    this.fab,
    this.fabLocation,
  });

  final String title;
  final Widget? bottom;
  final IconData? actionIcon;
  final void Function()? onAction;
  final Widget child;
  final bool unFocus;
  final bool isLoading;
  final EdgeInsets padding;
  final Widget? fab;
  final FloatingActionButtonLocation? fabLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            if (unFocus) FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SimpleAppBar(
              //   title: title,
              //   actionIcon: actionIcon,
              //   onAction: onAction,
              // ),
              if (bottom != null) ...[
                bottom!,
                const SizedBox(height: 16),
              ],
              Expanded(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : child,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: fab,
      floatingActionButtonLocation:
          fabLocation ?? FloatingActionButtonLocation.centerFloat,
    );
  }
}
