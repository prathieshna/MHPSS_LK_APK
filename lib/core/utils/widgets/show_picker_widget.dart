import 'package:beprepared/core/resources/all_imports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PickerWidget<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final String Function(T) itemToString;
  final ValueChanged<T> onItemSelected;
  final Function()? onConfirm;

  const PickerWidget({
    super.key,
    required this.title,
    required this.items,
    required this.itemToString,
    required this.onItemSelected,
    this.onConfirm,
  });

  @override
  State<PickerWidget<T>> createState() => _PickerWidgetState<T>();
}

class _PickerWidgetState<T> extends State<PickerWidget<T>> {
  int? selectedIndex; // Tracks the currently selected index

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          _buildBottomSheetHeader(context, widget.title),
          Expanded(
            child: Platform.isIOS
                ? CupertinoPicker(
                    selectionOverlay: _buildSelectionOverlay(),
                    
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      widget.onItemSelected(widget.items[index]);
                    },
                    children: widget.items
                        .map((item) => Center(
                              child: Text(
                                widget.itemToString(item),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ))
                        .toList(),
                  )
                : ListView.separated(
                    itemCount: widget.items.length,
                    separatorBuilder: (context, index) => Divider(
                      color: AppColors.searchFieldBorderColor.withOpacity(0.4),
                    ),
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(
                          vertical: VisualDensity.minimumDensity,
                        ),
                        title: Center(
                          child: Text(
                            widget.itemToString(widget.items[index]),
                            style: TextStyle(
                              fontSize: 14,
                              color: selectedIndex == index
                                  ? Colors.blue // Highlight selected item
                                  : Colors.black, // Default color
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            selectedIndex = index; // Update selected index
                          });
                          widget.onItemSelected(widget.items[index]);
                        },
                        // tileColor: selectedIndex == index
                        //     ? Colors.blue
                        //         .withOpacity(0.1) // Highlight background
                        //     : Colors.transparent, // Default background
                      );
                    },
                  ),
          ),
          _buildBottomSheetFooter(context),
        ],
      ),
    );
  }

  Widget _buildBottomSheetHeader(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18)),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.blue),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Container _buildSelectionOverlay() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1),
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
    );
  }

  Widget _buildBottomSheetFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade200,
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () => widget.onConfirm != null
            ? widget.onConfirm!()
            : Navigator.pop(context),
        child: Text(
          'confirm'.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.blue, fontSize: 15),
        ),
      ),
    );
  }
}
