---
name: frontend-craft
description: >-
  Max's portable defaults for building React / frontend / design-system work - the stack,
  component and state patterns, a Tailwind token system, and quality bar he reaches for on any
  project. Use this WHENEVER starting or working on a React, TypeScript, or frontend project;
  scaffolding an app or repo; choosing a stack (state, styling, data, forms, routing); building
  UI components, primitives, or a design system; setting up Tailwind, tokens, or theming; or
  wiring lint/format/CI for a frontend. Apply it even when Max doesn't name it explicitly - if
  the task produces frontend code or UI, this skill is in scope. These are general conventions;
  a given product will layer its own domain patterns and visual language on top.
---

# Frontend craft - Max's house style

Max's default way to build a frontend. Follow it as strong defaults, not laws.

Scope note: this skill is deliberately **general** - it is the foundation any of his React
projects share. Product-specific concerns (optimistic-editing machinery, canvas/editor
shells, a particular visual language, realtime/undo) are **not** here; they belong to the
individual project. If you catch yourself encoding something that is only true for one
product, leave it in that product's own docs, not in this skill.

## The one principle that explains everything

**Keep the proven shadcn-lineage *architecture*; author the *visual skin* yourself.** Build on
Radix headless primitives + Tailwind + CVA variants + a `cn()` class merger + `data-slot`
composition - that architecture is excellent and stays. What differentiates the result is the
skin: tokens, radii, shadows, motion, typography. So the goal is never "avoid Radix/Tailwind/CVA";
it is to **not ship the recognizable stock-shadcn look** (neutral gray ramps, default
`shadow-sm`/`rounded-md`, `border bg-background` primitives), which reads as a template.

This resolves the usual false choice between a component library (fast, generic) and
hand-rolling everything (slow, bespoke): borrow the library's ergonomics and accessibility,
author the look yourself.

## Start from the canonical template

Do not hand-assemble a new frontend from scratch - **scaffold from the starter, then modernize on
use.** It is the stack below already wired and CI-green: configs, the two-pass token system, the
primitive pattern, providers (theme/query/toast/error-boundary), a Ladle gallery, and git hooks.

- **Repo:** `github.com/mxfng/frontend-starter` (source of truth). Pinned known-good: **`1069a5d`**.
- **Scaffold:** `pnpm dlx degit mxfng/frontend-starter <app>` → `pnpm install` → `pnpm refresh`
  (bumps the whole stack to latest, dedupes, re-runs typecheck/lint/build/test) → fix whatever the
  bump surfaces → build. The refresh step is not optional - it is how a new app is born current.
- **Why refresh-on-use:** the template only has to stay *directionally* current; bump-on-scaffold
  (plus Renovate on the repo) makes every new project current even if the seed lags.
- **Conflict rule:** if this skill and the template's actual working config disagree, **the
  template wins** - update this skill to match rather than trusting stale prose.

Everything below is the rationale the template encodes - read it to work *within* a scaffolded app,
not to recreate the setup by hand.

## Stack defaults

Reach for these unless the project has a specific reason not to.

| Concern | Default | Notes |
|---|---|---|
| Framework | **React 19** + Vite 8 (Rolldown/Oxc) | React Compiler **on** → drop most manual `useMemo`/`useCallback`. On Vite 8 the compiler wires via `@rolldown/plugin-babel` + `reactCompilerPreset()` (plugin-react is Oxc-based; the old `babel` option is gone). Swap to `plugin-react-swc` only when you need raw build speed over auto-memoization. |
| Language | **TypeScript, strict-max** | exact tsconfig flags in `references/architecture.md`. Paths are baseUrl-free (deprecated in TS7); Vite 8 resolves them natively (`resolve.tsconfigPaths`). |
| Global state | **zustand** | one store per feature; `devtools(persist(immer()))` |
| Server cache | **TanStack Query** | `enabled` gating; prefer mutation response over stale cache |
| Styling | **Tailwind v4, CSS-first** (`@tailwindcss/vite`, no JS config) | token system in `references/styling.md` |
| Primitives | **Radix** (headless) + **CVA** + `cn()` | behavior from Radix, look from your tokens |
| Forms | react-hook-form + `@hookform/resolvers` + **zod** | validate at the boundary → `z.infer` the type |
| Routing | react-router v7 data-router | when the app needs routing |
| Icons | one library (lucide) | using two is a smell to unify |
| Motion | **motion** (the package formerly named framer-motion) for continuous; CSS transitions otherwise | always via named constants, never magic numbers |
| Toasts | **sonner** behind a typed `showError/Success/Warning/Info` wrapper | uniform call sites; swap the lib in one file |
| Theming | **next-themes**, class-based `.dark` | light `:root`, dark `.dark`; pre-paint script kills the flash |
| Gallery | **Ladle** | lighter than Storybook; a theme decorator drives `.dark` |
| Package manager | pnpm | |

## The core primitive pattern

Every UI primitive follows one shape. It keeps the *behavior* file about behavior and lets the
*look* live in swappable variant classes - exactly the seam you want to differentiate from a
stock component library.

```tsx
const fooVariants = cva("<base classes>", { variants: { variant: {...}, size: {...} }, defaultVariants: {...} })

type FooProps = React.ComponentProps<"button"> & VariantProps<typeof fooVariants> & { asChild?: boolean }

function Foo({ className, variant, size, asChild, ...props }: FooProps) {
  const Comp = asChild ? Slot : "button"
  return <Comp data-slot="foo" data-variant={variant} className={cn(fooVariants({ variant, size, className }))} {...props} />
}

export { Foo, fooVariants }
```

Habits baked in, and why:
- **`function` declarations, no `React.FC`.** React 19 makes `forwardRef` unnecessary for most
  components; use it only when a ref genuinely needs forwarding, and set `displayName`.
- **`className` is always the *last* arg to `cn()`** so a caller can override - the load-bearing
  composability rule.
- **`data-slot` / `data-variant` / `data-size`** are styling and composition hooks.
- **Compound components over mega-prop components** (`Card`/`CardHeader`/`CardTitle`/...). For
  genuinely config-driven UI, feed a declarative spec object to one generic engine.
- **Controlled-or-uncontrolled dual API** for reusable widgets: `const open = controlledOpen ?? internalOpen`.
- **Bottom-of-file named export block; no default exports** (except lazy-route roots).
- Optionally extract the `cva` config to `variants/fooVariants.ts` when it grows - a clean
  skin/behavior split.

## Code, TypeScript, and structure

Essentials here; full detail (tsconfig flags, store shape, folder tree) in
**`references/architecture.md`** - read it when scaffolding a repo or a store.

- **Named `function` declarations with exports at the bottom - a firm house rule, for
  components *and* plain TS modules alike.** Write `function foo() { ... }` (reserve `const` for
  actual values/config), then a single `export { foo, bar }` block at the end of the file, with
  `export type { Baz }` alongside. No inline `export function`, no `export const Foo = () => {}`,
  no default exports (except lazy-route roots and data modules). Keep this consistent
  everywhere - the file reads top-to-bottom as definitions, and the public surface is one
  glance at the bottom.
- **`type` for component props** (intersection with `React.ComponentProps`); **`interface` for
  domain shapes and zustand store state.**
- **Const-object enums** (`const Mode = { A: 0 } as const; type Mode = (typeof Mode)[keyof typeof Mode]`)
  over TS `enum`; **discriminated unions keyed on `type`** for state that has distinct shapes.
- **Feature-first folders**: `src/features/<domain>/{components,store,hooks,lib,types}` with
  colocated tests, plus `src/shared/` (cross-cutting, incl. `ui/` primitives). Files
  **kebab-case** universally; `@/*` → `./src/*`; barrels only at subsystem roots.
- **zustand**: one store per feature, per-value selector subscriptions (never destructure the
  whole store), `partialize` to persist only user data, versioned `migrate()`.
- **`import type` everywhere**; **zod validates at the boundary**, then `z.infer` the type.

## Styling and the token system

Tailwind v4, CSS-first. The mechanism (two-pass `:root` → `@theme` token file, OKLCH, semantic
layering, one base `--radius`, class-based dark mode, `cn()`) has its own file: **read
`references/styling.md` before setting up Tailwind or authoring tokens.**

## The quality bar

The craft signals that separate finished work from a scaffold - branded loading/empty/error
states, real ARIA and one global focus ring, granular error boundaries, motion via named
constants, restraint and a dense/legible type scale - are in **`references/design.md`**. Read
it when building anything a user sees. (A specific *visual language* is a per-product choice
layered on top; this file is the portable craft floor, not a house aesthetic.)

## Tooling

Lint/format/hooks/CI/testing defaults are in **`references/tooling.md`** - read when wiring a
repo's quality gates. Highlights: strict type-checked lint (oxlint, or ESLint flat +
`tseslint recommendedTypeChecked`), Prettier **with `prettier-plugin-tailwindcss`** plus an
import-sort plugin, Husky pre-commit lint-staged and pre-push typecheck+test, CI of
format-check → lint → typecheck + build.

## Verifying and handing off a change

When a change to a running app is done, do not stop at "typecheck passes." Take it through this
sequence, in order, so Max gets something he can see and click - not a diff he has to trust:

1. **Verify headless first.** Drive the app in a headless browser (Playwright - already in the
   stack) against the affected flow, and screenshot the changed UI in both light and dark. This is
   the real-behavior check: the component mounts, the interaction works, nothing renders unstyled
   or throws. Fix what the screenshots expose before going further - a green typecheck over a blank
   mount is a false pass.
2. **Run the local CI gate.** The exact sequence CI runs: format-check → lint → typecheck → build →
   test, via the repo's `pnpm` scripts. It must be clean end to end, not "clean except." If lint or
   a test the change did not touch is red, fix it on the way through - same engineering-excellence
   bar as everything else.
3. **Hoist a dev server for Max to demo.** Start Vite (`pnpm dev`) wired to the right data, and
   leave it running:
   - **Real backend** when one is reachable (dev/staging API) - point the app's runtime env at it.
   - **Mock backend** otherwise - MSW handlers for the touched endpoints, so the flow is fully
     demoable with no live service.

   State which of the two you used and why. Then hand back **the localhost link** plus a short
   **verification plan**: the exact steps to reproduce the change (route → what to click → expected
   result), which backend it is pointed at, and any edges worth poking. Max should be able to open
   the link and confirm the change in under a minute.

This is the frontend-specific flavor of the general verify-then-ship gate; run it before calling a
UI change done.
