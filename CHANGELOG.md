# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1] — 2026-04-24

### Fixed
- Hook no longer false-triggers when the assistant *references* the word inside fenced code blocks, inline code spans, blockquotes, or quoted string literals. Detector now strips those contexts before matching.

### Added
- Regression test cases covering code/quote/blockquote/intra-word contexts.

## [0.1.0] — 2026-04-23

### Added
- Stop hook (`hooks/detect-cant.sh`) that scans the last assistant turn for `can't` / `cannot` / `can not` and emits a block decision instructing Claude to invoke the bundled reframe skill.
- Bundled `reframe` skill — four-move chief-of-staff workflow (name constraint → list options → surface tradeoffs → recommend).
- Self-contained: no external plugin dependencies.
