umask 077

# ── Relocate tool directories out of ~ ────────────────────────────────
set -gx HERMES_HOME ~/.config/hermes
set -gx BUNDLE_USER_CACHE ~/.cache/bundle
set -gx BUNDLE_USER_CONFIG ~/.config/bundle
