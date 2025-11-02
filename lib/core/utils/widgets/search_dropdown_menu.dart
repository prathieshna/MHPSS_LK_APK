import 'package:beprepared/core/resources/all_imports.dart';
import 'package:beprepared/core/utils/widgets/network_image_widget.dart';
import 'package:beprepared/features/data/models/responses/search_response.dart';
import 'package:beprepared/features/presentation/providers/debouncing_provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class SearchDropdown extends ConsumerStatefulWidget {
  const SearchDropdown({super.key});

  @override
  ConsumerState<SearchDropdown> createState() => _SearchDropdownState();
}

class _SearchDropdownState extends ConsumerState<SearchDropdown> {
  final TextEditingController _menuController = TextEditingController();
  List<Hit> _menuItems = [];
  // Hit? _selectedMenu;

  @override
  void initState() {
    super.initState();

    // Listen for text changes with debounce.
    _menuController.addListener(() {
      final value = _menuController.text;
      final debounce = ref.watch(debounceProvider);
      if (value.isNotEmpty) {
        debounce(() {
          ref.read(searchResourcesProvider.notifier).fetchResources(value);
        });
      }
    });
  }

  final dropDownKey = GlobalKey<DropdownSearchState>();

  @override
  Widget build(BuildContext context) {
    // Watch the provider state here.
    final searchState = ref.watch(searchResourcesProvider);

    // Update menu items based on provider state.
    searchState.when(
      data: (response) {
        setState(() {
          _menuItems = response.hits ?? [];
        });
        print("menuItems updated: ${_menuItems.length}");
      },
      loading: () {
        setState(() {
          _menuItems = []; // Clear menu items while loading.
        });
      },
      error: (error, stack) {
        setState(() {
          _menuItems = []; // Clear menu items on error.
        });
      },
    );

    return DropdownMenu<Hit>(
      controller: _menuController,
      width: MediaQuery.of(context).size.width * 0.85,
      hintText: "search".tr(),
      requestFocusOnTap: true,
      enableFilter: false,
      enableSearch: false,
      menuHeight: 400.h,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
      ),
      trailingIcon: SvgPicture.asset(
        AppImages.searchIcon,
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        side: WidgetStateProperty.all(BorderSide(
            width: 0.5,
            color: AppColors.searchFieldBorderColor,
            style: BorderStyle.solid,
            strokeAlign: BorderSide.strokeAlignCenter)),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
      ),
      dropdownMenuEntries:
          // _menuItems.isEmpty
          //     ? [
          //         DropdownMenuEntry<Hit>(
          //           value: Hit(title: "No results"),
          //           label: "No results",
          //         )
          //       ]
          //     :
          _menuItems.map((hit) {
        return DropdownMenuEntry<Hit>(
          value: hit,
          label: hit.title ?? "Unknown",
          labelWidget: Column(
            children: [
              Text(
                hit.title ?? "Unknown",
                maxLines: 2,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Divider(
                thickness: 1.0,
                height: 5.0,
              )
            ],
          ),
          leadingIcon: NetworkImageWidget(
            imageURL: hit.imageHit?.url,
            height: 40,
            width: 40,
            boxFit: BoxFit.cover,
          ),
        );
      }).toList(),
      onSelected: (Hit? menu) {
        if (menu != null && menu.objectID != null) {
          navigator.navigateToWithBottomNavBar(
            context,
            ResourceDetailsScreen(
              id: menu.objectID,
            ),
          );
          _menuController.clear();
          _menuItems.clear();

          print("Selected menu: ${menu.title}");
        } else {
          // Handle the case where menu is null or objectID is null
          print("No valid selection made or objectID is missing.");
        }
      },
    );
  }
}
