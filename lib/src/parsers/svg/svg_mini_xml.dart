/// Minimal XML element model for SVG parsing.
///
/// Represents a single XML element with its tag name, attributes, child
/// elements, and text content. Only handles the XML subset that SVG uses.
class XElement {
  const XElement({required this.tag, this.attrs = const {}, this.children = const [], this.text = ''});

  final String tag;
  final Map<String, String> attrs;
  final List<XElement> children;
  final String text;
}

/// Minimal XML parser tailored for SVG content.
///
/// Handles elements (opening/closing tags, self-closing), attributes
/// (double and single quoted), text content, XML comments, CDATA sections,
/// basic XML entities, numeric entities, and namespace prefix stripping.
///
/// This parser exists instead of using the `xml` package because the
/// `xml` package's transitive dependency `petitparser` triggers a Dart
/// 3.12.0 VM bug in the AOT FFI transformer during `build_runner`
/// script compilation.
class XParser {
  XParser(this._source);

  final String _source;
  int _pos = 0;

  static XElement parse(String xml) {
    final parser = XParser(xml).._skip();
    return parser._parseElement();
  }

  void _skip() {
    while (_pos < _source.length &&
        (_source[_pos] == ' ' || _source[_pos] == '\t' || _source[_pos] == '\n' || _source[_pos] == '\r')) {
      _pos++;
    }
  }

  XElement _parseElement() {
    // Expect '<'
    if (_pos >= _source.length || _source[_pos] != '<') {
      throw FormatException('Expected <', _source, _pos);
    }
    _pos++; // skip '<'

    // Check for comment
    if (_pos + 3 < _source.length && _source.substring(_pos, _pos + 3) == '!--') {
      _skipComment();
      // After comment, expect more content
      _skip();
      return _parseElement();
    }

    // Check for CDATA (not expected at element level, but handle)
    if (_pos + 8 < _source.length && _source.substring(_pos, _pos + 8) == '![CDATA[') {
      _pos += 8;
      final end = _source.indexOf(']]>', _pos);
      if (end == -1) throw FormatException('Unclosed CDATA', _source, _pos);
      final text = _source.substring(_pos, end);
      _pos = end + 3;
      _skip();
      // Return text as element
      return XElement(tag: '', text: text);
    }

    // Parse tag name
    final tagStart = _pos;
    while (_pos < _source.length &&
        _source[_pos] != '>' &&
        _source[_pos] != ' ' &&
        _source[_pos] != '\t' &&
        _source[_pos] != '\n' &&
        _source[_pos] != '\r' &&
        _source[_pos] != '/') {
      _pos++;
    }
    if (_pos == tagStart) throw FormatException('Empty tag', _source, _pos);
    var tag = _source.substring(tagStart, _pos);

    // Strip namespace prefix
    final colonIdx = tag.indexOf(':');
    if (colonIdx != -1) tag = tag.substring(colonIdx + 1);

    // Parse attributes
    final attrs = <String, String>{};
    var selfClosing = false;

    while (_pos < _source.length) {
      _skip();
      if (_pos >= _source.length) throw FormatException('Unclosed tag', _source, _pos);

      if (_source[_pos] == '>') {
        _pos++;
        break;
      }
      if (_source[_pos] == '/') {
        _pos++;
        if (_pos < _source.length && _source[_pos] == '>') {
          _pos++;
          selfClosing = true;
          break;
        }
        throw FormatException('Expected />', _source, _pos);
      }

      // Attribute name
      final attrStart = _pos;
      while (_pos < _source.length &&
          _source[_pos] != '=' &&
          _source[_pos] != '>' &&
          _source[_pos] != ' ' &&
          _source[_pos] != '\t' &&
          _source[_pos] != '\n' &&
          _source[_pos] != '\r' &&
          _source[_pos] != '/') {
        _pos++;
      }
      if (_pos == attrStart) throw FormatException('Expected attribute name', _source, _pos);
      final attrName = _source.substring(attrStart, _pos);

      // Strip namespace prefix from attribute name
      final attrColon = attrName.indexOf(':');
      final cleanAttrName = attrColon != -1 ? attrName.substring(attrColon + 1) : attrName;

      _skip();
      if (_pos < _source.length && _source[_pos] == '=') {
        _pos++;
        _skip();

        if (_pos >= _source.length) throw FormatException('Expected attribute value', _source, _pos);
        final quote = _source[_pos];
        if (quote != '"' && quote != "'") throw FormatException('Expected quote', _source, _pos);
        _pos++;
        final valStart = _pos;
        while (_pos < _source.length && _source[_pos] != quote) {
          _pos++;
        }
        if (_pos >= _source.length) throw FormatException('Unclosed attribute', _source, _pos);
        var value = _source.substring(valStart, _pos);
        _pos++; // skip closing quote

        // Decode XML entities
        value = _decodeEntities(value);

        attrs[cleanAttrName] = value;
      }
    }

    if (selfClosing) {
      return XElement(tag: tag, attrs: attrs);
    }

    // Parse children
    final children = <XElement>[];
    final textParts = <String>[];

    while (_pos < _source.length - 2) {
      _skip();
      if (_pos >= _source.length) break;

      if (_source[_pos] == '<') {
        // Check for closing tag
        if (_source[_pos + 1] == '/') {
          _pos += 2; // skip </
          while (_pos < _source.length &&
              _source[_pos] != '>' &&
              _source[_pos] != ' ' &&
              _source[_pos] != '\t' &&
              _source[_pos] != '\n' &&
              _source[_pos] != '\r') {
            _pos++;
          }
          _skip();
          if (_pos < _source.length && _source[_pos] == '>') _pos++;
          _skip();
          final text = textParts.join();
          return XElement(tag: tag, attrs: attrs, children: children, text: _decodeEntities(text));
        }

        // Check for comment
        if (_pos + 3 < _source.length && _source.substring(_pos + 1, _pos + 4) == '!--') {
          _pos++;
          _skipComment();
          continue;
        }

        // Child element
        children.add(_parseElement());
      } else {
        // Text content — accumulate
        final textStart = _pos;
        while (_pos < _source.length && _source[_pos] != '<') {
          _pos++;
        }
        final rawText = _source.substring(textStart, _pos);
        textParts.add(rawText);
      }
    }

    return XElement(tag: tag, attrs: attrs, children: children, text: '');
  }

  void _skipComment() {
    final end = _source.indexOf('-->', _pos);
    if (end == -1) throw FormatException('Unclosed comment', _source, _pos);
    _pos = end + 3;
  }

  String _decodeEntities(String value) {
    return value
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll('&#39;', "'")
        .replaceAll('&#34;', '"');
  }
}
