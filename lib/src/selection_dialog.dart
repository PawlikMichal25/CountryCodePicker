import 'package:flutter/material.dart';

import 'package:country_code_picker/src/country_code.dart';
import 'package:country_code_picker/src/country_localizations.dart';

class SelectionDialog extends StatefulWidget {
  final List<CountryCode> elements;
  final double flagWidth;
  final List<CountryCode> favoriteElements;
  final String searchHint;

  const SelectionDialog(
    this.elements,
    this.favoriteElements,
    this.flagWidth,
    this.searchHint,
  );

  @override
  State<StatefulWidget> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  late List<CountryCode> _filteredElements;

  @override
  void initState() {
    super.initState();
    _filteredElements = widget.elements;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Color(0xFF090A0A),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              onChanged: _onQueryChanged,
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF090A0A),
              ),
              decoration: InputDecoration(
                icon: const Icon(Icons.search),
                hintText: widget.searchHint,
                hintStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6C7072),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 12),
              children: [
                ...widget.favoriteElements.map(
                  (code) => SimpleDialogOption(
                    child: _Option(code, widget.flagWidth),
                    onPressed: () {
                      _selectItem(code);
                    },
                  ),
                ),
                const Divider(),
                if (_filteredElements.isEmpty)
                  Center(
                    child: Text(CountryLocalizations.of(context)?.translate('no_country') ?? 'No country found'),
                  )
                else
                  ..._filteredElements.map(
                    (code) => SimpleDialogOption(
                      child: _Option(code, widget.flagWidth),
                      onPressed: () {
                        _selectItem(code);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onQueryChanged(String query) {
    final upper = query.toUpperCase();
    setState(() {
      _filteredElements = widget.elements
          .where((e) => e.code.contains(upper) || e.dialCode.contains(upper) || e.name.toUpperCase().contains(upper))
          .toList();
    });
  }

  void _selectItem(CountryCode code) {
    Navigator.pop(context, code);
  }
}

class _Option extends StatelessWidget {
  final CountryCode _countryCode;
  final double _flagWidth;

  const _Option(
    this._countryCode,
    this._flagWidth,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          _countryCode.flagUri,
          package: 'country_code_picker',
          width: _flagWidth,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            _countryCode.toLongString(),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
