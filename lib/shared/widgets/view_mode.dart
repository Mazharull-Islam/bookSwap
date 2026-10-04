import 'package:flutter/material.dart';

/// How a list of books is laid out: a column of rows, or a grid of covers.
enum ViewMode { list, grid }

/// The app-bar button that flips between list and grid. It shows the layout
/// you would switch *to*.
class ViewModeButton extends StatelessWidget {
  const ViewModeButton({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  final ViewMode mode;
  final ValueChanged<ViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final isGrid = mode == ViewMode.grid;
    return IconButton(
      tooltip: isGrid ? 'Switch to list view' : 'Switch to grid view',
      icon: Icon(isGrid ? Icons.view_list_outlined : Icons.grid_view_outlined),
      onPressed: () => onChanged(isGrid ? ViewMode.list : ViewMode.grid),
    );
  }
}
