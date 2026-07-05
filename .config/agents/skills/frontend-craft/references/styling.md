# Styling and the token system (Tailwind v4, CSS-first)

Read this before setting up Tailwind or authoring a token file. The *mechanism* here is
consistent across Max's newer repos; the *values* are per-project (that is the whole point of
a token layer - the architecture is fixed, the skin is bespoke).

## Table of contents
- Setup and file layout
- The two-pass token file (the core trick)
- Color: OKLCH and semantic layering
- Radius and elevation
- Dark mode
- `cn()` and class conventions
- Where raw CSS is allowed

## Setup and file layout

Tailwind v4 via `@tailwindcss/vite` - there is **no `tailwind.config.js`**. Everything lives in
CSS. One `globals.css` imports Tailwind then a set of modular partials, each with a clear job:

```css
@import "tailwindcss";
@import "tw-animate-css";
@import "./theme.css";      /* tokens */
@import "./base.css";       /* element defaults, scrollbars, focus ring */
@import "./utilities.css";  /* a few semantic utility classes for repeated recipes */
@import "./layout.css";
@import "./animations.css";
@custom-variant dark (&:is(.dark *));
```

Keeping tokens, base, utilities, and animations in separate partials makes the token layer
easy to find and re-skin without hunting through component files.

## The two-pass token file (the core trick)

Define every raw value **once** in `:root`, then **mirror** each into an `@theme` block so
Tailwind generates matching utilities (`bg-primary`, `shadow-neu`, `text-foreground`). Use
`@theme inline` for the indirection layer so utilities resolve to runtime-swappable variables.

```css
:root {
  --primary: oklch(0.72 0.19 51);
  --background: oklch(0.85 0.016 74);
  --radius: 1rem;
}

@theme inline {
  --color-primary: var(--primary);          /* so bg-primary → the swappable var */
  --color-background: var(--background);
  --radius-lg: var(--radius);
  --radius-md: calc(var(--radius) - 2px);
  --radius-sm: calc(var(--radius) - 4px);
}

@theme {
  --breakpoint-xs: 30rem;                    /* raw scale tokens: breakpoints, fonts */
  --font-sans: "Inter Variable", system-ui, sans-serif;
}
```

Why two passes: the `:root` layer is the single source of truth you edit to rebrand; the
`@theme` layer is what makes Tailwind emit utilities. Overriding `:root` under `.dark` (or a
`[data-theme="x"]` wrapper) then re-skins everything for free.

## Color: OKLCH and semantic layering

- **OKLCH everywhere** - perceptually uniform, so tints/shades and alpha steps stay visually
  even. Avoid hex except a rare fixed material color.
- **Layer semantically**, do not scatter raw colors: base → `primary`/`accent`/`secondary` →
  per-surface aliases (`--color-screen`, `--color-popover`, `--color-card`, `--color-track`) →
  per-state. Components reference the semantic token, never a raw ramp step.
- **Add editor-state tokens stock shadcn lacks**: `--selected` / `--highlight` (for selection
  in an editor/canvas), and status tokens `--success` / `--warning` / `--in-progress`, each
  with a `-foreground` pair and registered in `@theme inline` so `bg-selected`,
  `text-success`, `bg-warning/10` all work. Define the *role*, not the color.
- Annotate token intent with a short `/* comment */` - a good habit from his repos.

## Radius and elevation

- **One base `--radius`** with `sm/md/lg/xl` derived via `calc()`. Do not sprinkle literal
  radii. (Pick the base to taste - a product's roundness/softness is one of its most legible
  brand signals.)
- **Elevation as tokens, not ad-hoc shadows.** Define a small shadow scale as tokens
  (`--shadow-sm/md/lg`, and an `--shadow-inset` for pressed/well surfaces) so elevation stays
  consistent and re-skinnable. The specific shadow language (soft/neumorphic vs crisp/flat) is
  a per-product visual choice - what is portable is that it comes from named tokens.

## Dark mode

Class-based: `@custom-variant dark (&:is(.dark *))`, tokens overridden under `.dark {}`,
toggled at runtime. Declare it explicitly as class-based - a past repo set Tailwind's
`darkMode: "media"` while actually toggling a `.dark` class, which is a latent bug. Scoping a
theme to a subtree via `[data-theme="x"]` on a wrapper is a fine extra pattern.

## `cn()` and class conventions

- `cn()` = `twMerge(clsx(inputs))` in `lib/utils.ts`. Universal component signature is
  `cn(fooVariants({ ... }), className)` with the caller's `className` **last**.
- Conditional classes via clsx object syntax inside `cn()`:
  `cn("base", { "h-full w-full": variant === "default" })`.
- Use `prettier-plugin-tailwindcss` for automatic class ordering - do not hand-order.

## Where raw CSS is allowed

Confine raw CSS to `styles/*` and only where utilities cannot express it: `@font-face`,
keyframes, scrollbar styling, and the base element layer. Set base typography **globally** in
`@layer base` (`h1..h6 { @apply ... }`, `p { @apply ... }`) rather than repeating type styles
per component - it establishes the rhythm once. Everything else is utilities. No CSS modules,
no CSS-in-JS.
