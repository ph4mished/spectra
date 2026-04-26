# Changelog

## [unversioned] 

### Added

### Changed

### Fixed
## [0.5.0] - 2026-04-24

### Added
- True color to 256 color palette fallback
- Full color fallback chain (truecolor ==> 256 ==> 16)
- Changed syntax of light colors (lightred ==> lred)
- Dumb terminal detection

### Changed
- Hex validation now properly requires '#' prefix
- Fixed parse256ColorCode undefined variable bug
- Improved parseRGB length and int validation

### Fixed
- Unclosed bracket handling in templates


## [0.4.0] - 2026-04-06

### Added
- Inline padding in placeholders

---

## [0.3.0] - 2026-04-06

### Added
- Color support on windows
