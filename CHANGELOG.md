# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-08-13

### Added

- Initial template: data-driven structure (`src/lib/data/<feature>/<locale>.json`),
  configurable sections (`src/lib/data/sections.ts`), CV generation via Typst
  (`cv.typ`, profiles `dev`/`tutor`/`all`), TabelaWebUI theme, PT-BR/EN i18n
  via Paraglide, and Cloudflare Workers deploy.
- Page metadata (title, description, canonical, sitemap, robots.txt).
- Locale resolution from the URL (`--strategy url cookie preferredLanguage baseLocale`).
