import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  void navigateToSearchScreen(String query) {}

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 42.h,
        margin: EdgeInsets.only(left: 15.w),
        child: Material(
          borderRadius: BorderRadius.circular(7.r),
          elevation: 1,
          child: TextFormField(
            onFieldSubmitted: navigateToSearchScreen,
            style: const TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              prefixIcon: InkWell(
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.only(
                    left: 6,
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.only(top: 10.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(7.r),
                ),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(7.r),
                ),
                borderSide: const BorderSide(
                  color: Colors.black38,
                  width: 1,
                ),
              ),
              hintText: 'Search Apex',
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
