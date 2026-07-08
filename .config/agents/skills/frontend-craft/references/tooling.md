# Tooling: lint, format, hooks, CI, testing, deploy

Read when wiring up a repo's quality gates. These are his defaults; the newer repos are the
tiebreaker.

## Lint

- The **template ships ESLint flat, type-checked** (`recommendedTypeChecked`), with
  `projectService: true`, `react-hooks`, `react-refresh`, and **`eslint-config-prettier` last**
  (turns off stylistic rules that fight Prettier). **oxlint** `--max-warnings 0` remains a fine
  fast alternative (`eslint`/`typescript`/`unicorn`/`oxc`/`react` plugins) when you don't need
  type-checked rules.
- **Import sort has a single owner: Prettier** (`@ianvs/prettier-plugin-sort-imports`). Do *not*
  also run eslint `simple-import-sort` - two sorters fight. (Older repos used the eslint one; the
  template moved it into Prettier alongside the Tailwind class sorter.)
- **Gotcha (eslint 10 + react-hooks 7):** the plugin's `configs['recommended-latest']` still ships
  legacy **array-style `plugins`**, which the flat parser rejects. Don't spread that config into
  `extends`; instead register `plugins: { 'react-hooks': reactHooks }` and spread only its
  `.rules`. Same for any plugin whose config predates flat.
- Keep rule relaxations **narrowly scoped and commented** (e.g. `unbound-method` off for test
  files; `react-refresh/only-export-components` off for `shared/ui/**` where primitives co-export
  their `*Variants`). Watch-outs: do not globally disable `react-hooks/exhaustive-deps` or strip
  `react/prop-types` without cause.

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

## Component gallery

**Ladle** is the gallery (lighter than Storybook). **Gotcha on the Vite 8 / Rolldown stack:**
Ladle 5 bundles its own Vite 6, and if it loads the app's `vite.config.ts` (Vite 8 `plugin-react`
oxc + `@rolldown/plugin-babel`) it drags Rolldown's react-refresh wrapper into Vite 6 and dies -
`Missing field moduleType`, an unresolved `@react-refresh`, and a **blank mount** in both `serve`
and `build`. Two-part fix (already in the template):

1. **Isolate Ladle's Vite config.** Add `.ladle/vite.config.ts` with only `@tailwindcss/vite`
   (Ladle supplies its own React handling), and point `.ladle/config.mjs` at it via
   `viteConfig: '.ladle/vite.config.ts'`.
2. **Explicit `@source`.** Ladle builds from a different root, so Tailwind v4's auto-scan misses
   `src/` and every component renders unstyled. Add `@source '../../';` in `globals.css` so both
   the app and Ladle scan the source tree.

If Ladle ever fights the toolchain harder than this, an **in-app `/kitchen-sink` route** (rendered
by the app's own working Vite pipeline) is the zero-second-toolchain fallback.

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
