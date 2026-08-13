# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-08-13

### Added

- `scripts/sync-portfolio.sh`: distributes template code to an instance
  (portfolio). `sync` copies the code preserving injected data (data/, assets/,
  messages/, CVs, name/version) and adjusts the local photo; `--update
--message` runs the full publish pipeline (cv + format + check + build +
  commit + push + deploy). Instance config via gitignored `.env`
  (`PORTFOLIO_DIR`, `DOCS_DIR`), with a versioned `.env.example`.

### Fixed

- README/README.pt-BR aligned with the Workers deploy (was still saying Pages).
- CONTRIBUTING/ct-BR dropped the non-existent `bun run test` step.
- `package.json` version `0.1.0` matches the `v0.1.0` release tag.

## [0.1.0] - 2026-08-13

### Added

- Initial template: data-driven structure (`src/lib/data/<feature>/<locale>.json`),
  configurable sections (`src/lib/data/sections.ts`), CV generation via Typst
  (`cv.typ`, profiles `dev`/`tutor`/`all`), TabelaWebUI theme, PT-BR/EN i18n
  via Paraglide, and Cloudflare Workers deploy.
- Page metadata (title, description, canonical, sitemap, robots.txt).
- Locale resolution from the URL (`--strategy url cookie preferredLanguage baseLocale`).
