# Hella Labs — slide deck

A self-contained reveal.js deck introducing the Hella Lab environment: the
physical and platform topology, and the security boundary between the owner
(and their interactive agents) and the delegated agent, Ember.

## Viewing

Open `index.html` in a browser, or serve the directory:

```sh
python3 -m http.server -d content/blob/hella-lab
```

Published at <https://qrk.us/blob/hella-lab/>.

## Portability

The deck is deliberately self-contained — no build step, no network access
required at view time:

- `dist/` — reveal.js 5.2.1 core and its stylesheets
- `vendor/mermaid.min.js` — Mermaid 11.4.1, for the diagrams
- `plugin/notes/notes.js` — reveal's speaker-notes plugin
- `fonts/` — Inter, Space Grotesk and JetBrains Mono (latin subset, WOFF2)
- `css/hella.css` — the deck's theme

Every slide carries speaker notes. Press `S` in the browser to open the
speaker view.

## Notes for maintainers

- **Do not use `//` line comments in inline `<script>` blocks.** The site's
  publish pipeline minifies HTML and collapses newlines inside inline
  scripts, which makes a line comment swallow the remainder of the script.
  Use `/* ... */` block comments.
- **Keep Mermaid diagrams flat.** Nested `subgraph` groups inflate the
  drawing's bounding box; the diagram is then scaled down to fit and the
  labels become too small to read. Prefer a flat node list and let the
  caption carry the grouping. The deck's theme uses a legend-chip style for
  exactly this reason.
- **The deck's HTML is minified at publish time** by `pelican-minification`.
  That plugin passes `keep_pre=True` to `htmlmin`, so `<pre class="mermaid">`
  blocks survive intact, and it does not touch standalone `.js` files.
- The vendored JavaScript must stay as published upstream. A general-purpose
  JS minifier will corrupt reveal.js and Mermaid.

## Content

The deck is derived from the authoritative sources in the Hella repositories:

- `bingnet/hella-core` — `PLAN.md` (architecture, trust zones, terminology)
- `bingnet/hella-nodes` — `inventory.yml`, `docs/automation-horizons.md`
- `bingnet/hella-k8s-yaml` — `clusters/hella/{apps,platform}`
- `delegated/hermes-runtime` — Ember's implementation
