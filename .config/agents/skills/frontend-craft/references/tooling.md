# Tooling: lint, format, hooks, CI, testing, deploy

Read when wiring up a repo's quality gates. These are his defaults; the newer repos are the
tiebreaker.

## Lint

- **oxlint** `--max-warnings 0` is the current preference - fast, with `eslint` / `typescript`
  / `unicorn` / `oxc` / `react` plugins. Inline exceptions via `// oxlint-disable-next-line`.
- If ESLint instead: **flat config** with `typescript-eslint` **type-checked** presets
  (`recommendedTypeChecked` + `stylisticTypeChecked`), `react-hooks`, `react-refresh`, and
  **`simple-import-sort`** (as an error - automate import order). Keep rule relaxations
  **narrowly scoped and commented** (e.g. disable `no-unsafe-*` only for one file whose
  third-party types leak `any`). Watch-outs from his past repos: do not globally disable
  `react-hooks/exhaustive-deps` or strip `react/prop-types` without cause.

## Format

- **Prettier** with **`prettier-plugin-tailwindcss`** (auto-sorts class lists) + an import-sort
  plugin (`@ianvs/prettier-plugin-sort-imports` or the eslint one). Missing the Tailwind class
  sorter is his single most recurring tooling gap - always add it. 2-space, double quotes,
  trailing commas, semicolons.

## Hooks

- **Husky**: `pre-commit` → `lint-staged` (prettier `--write`, then eslint/oxlint `--fix` on
  staged files). `pre-push` → **type-check + test** - a real gate that keeps broken code off
  the branch. `prepare: husky`.

## TypeScript

Strict-max (see `architecture.md` for the flag list). `build = tsc -b && vite build`; a
separate `tsc` type-check script; do not let the bundler be the only type check.

## Testing

- **Vitest + Testing Library + happy-dom** for units (pure logic and components), colocated
  as `*.test.ts(x)` next to source. **Playwright** cross-browser for E2E in a top-level `e2e/`
  (`trace: "on-first-retry"`, CI `retries: 2`, `forbidOnly` on CI).
- Do not let "typecheck + lint + build" become the only gate. Anywhere logic is load-bearing
  (data transforms, derivations, store migrations), test it - that is worth the time even on a
  small project.

## CI

Format-check → lint → typecheck + build, on push/PR to the main branches. `pnpm install
--frozen-lockfile`. Dependabot on.

## Deploy

Multi-stage Dockerfile (node build → nginx serve, `--platform=linux/amd64`), SPA `try_files
… /index.html`, gzip, long immutable asset caching but `no-cache` on a runtime-injected
`env.js`. **Runtime env injection** via `window.env` (an `entrypoint.sh` writes `env.js` at
container start) with a `getEnvVariable` helper that reads `window.env?.[k] ?? import.meta.env[k]`
- so the same image runs in any environment without a rebuild. PWA where offline/installable
matters (`manifest.webmanifest`, service worker).
