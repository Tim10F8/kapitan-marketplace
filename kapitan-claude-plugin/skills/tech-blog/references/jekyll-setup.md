# Jekyll Setup (Gundersen-Style Blog)

Configuration reference for a Jekyll blog following Gregory Gundersen's architecture. This is the default platform for the tech-blog skill.

## Table of Contents

- [Plugins](#plugins)
- [Layout and Structure](#layout-and-structure)
- [CSS Design Conventions](#css-design-conventions)
- [Design Philosophy](#design-philosophy)
- [File Organization](#file-organization)

---

## Plugins

### jekyll-katex

Pre-processed math rendering. KaTeX runs at build time, producing static HTML+CSS. No client-side JavaScript, no reflow on page load.

- Use `{% katex %}` / `{% endkatex %}` for display math
- Use `{% katex inline %}` / `{% endkatex %}` for inline math
- Alternatively, configure to parse `$$...$$` and `$...$` via a custom plugin or Kramdown math engine
- Numbered equations use `\tag{N}` inside the math block

**Not MathJax.** MathJax renders client-side and causes visible reflow. KaTeX is the default for this blog.

### jekyll-scholar

BibTeX-based academic citations.

- Store references in a `.bib` file (e.g., `_bibliography/references.bib`)
- Cite inline with `{% cite key %}` — renders as `(Author, Year)` with hyperlink
- Auto-generates bibliography in the footer with `{% bibliography --cited %}`
- Configure in `_config.yml`:

```yaml
scholar:
  style: apa
  bibliography: references
  source: ./_bibliography
  sort_by: author
```

### jekyll-feed

Generates an Atom/RSS feed at `/feed.xml`. No configuration beyond adding the plugin.

### jekyll-sitemap

Generates `sitemap.xml` for search engine indexing. No configuration beyond adding the plugin.

---

## Layout and Structure

### Frontmatter Format

```yaml
---
title: "Deriving the Evidence Lower Bound"
subtitle: "I derive the evidence lower bound (ELBO) from scratch using Jensen's inequality."
layout: default
date: 2024-03-15
keywords: variational-inference, elbo, bayesian-inference, jensens-inequality
published: true
---
```

Field notes:

| Field | Format | Notes |
|-------|--------|-------|
| `title` | String | Specific, no clickbait. Rendered as `<h1>`. |
| `subtitle` | String | Starts with "I" + action verb + specific focus. Exactly one sentence. Rendered as `<h4>`. |
| `layout` | `default` | Single custom layout. Not the standard `post` layout. |
| `date` | `YYYY-MM-DD` | No timezone offset needed. |
| `keywords` | Comma-separated string | Not a YAML array. Used for `<meta name="keywords">`. |
| `published` | `true` / `false` | Inverse of Hugo's `draft`. Set `false` to hide from build. |

**Not used:** `categories`, `tags` (array), `slug` (derived from filename), `description` (replaced by `subtitle`).

### Post Header Rendering Order

The layout renders the post header in this exact sequence:

1. `<h1>` title
2. `<h4>` subtitle (lighter weight, below title)
3. Published date (formatted, below subtitle)
4. Post body (Markdown content)

### File Naming

Posts use Jekyll's standard naming convention:

```
_posts/YYYY-MM-DD-slug.md
```

The slug is derived from the filename, not a frontmatter field. Example:

```
_posts/2024-03-15-deriving-the-elbo.md
```

---

## CSS Design Conventions

These define the visual identity. Follow them for consistency.

### Typography

- **Font stack:** System fonts — `-apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif`
- **Body:** `15px`, `line-height: 1.6em`
- **Max width:** `700px` content column, centered
- **Text color:** `rgba(0, 0, 0, 0.8)` — slightly softened black

### Headings

- `<h2>` has a subtle `border-bottom` (1px) to separate sections visually
- Headings are not numbered — they use descriptive, action-oriented text

### Tables

Academic-style tables:

- Top border: `2px solid`
- Bottom border: `1px solid`
- Header bottom: `1px solid`
- No vertical lines
- No alternating row colors

### Code Blocks

- `13px` monospace font
- Light bordered container (subtle background or border, not heavy syntax highlighting)
- Inline code uses backtick styling with slight background

### Links

- Colored but not underlined by default
- Underlined on hover

---

## Design Philosophy

> "Make things consistent as a rule and differentiate for emphasis."

This single principle governs all visual decisions:

- **Same colors** within a post — do not vary link colors, heading colors, or accent colors across sections
- **Same fonts** — one serif/sans-serif for body, one monospace for code. No variation.
- **Same line weights** — borders, separators, and rules use consistent weights
- **Vary only for emphasis** — bold, color change, or weight change signals importance, not decoration
- **Whitespace over decoration** — spacing and alignment create hierarchy, not backgrounds or borders

Apply this principle to diagrams and figures as well: consistent colors, consistent label fonts (arial), consistent line weights. Use visual differentiation only to highlight the key element.

---

## File Organization

```
blog-root/
  _posts/                    # All blog posts (YYYY-MM-DD-slug.md)
  _bibliography/             # BibTeX files for jekyll-scholar
    references.bib
  _layouts/
    default.html             # Single custom layout
  _includes/                 # Reusable HTML partials
  css/
    blog.css                 # Blog-specific styles
    main.css                 # Base styles
    code.css                 # Code block and syntax styles
    math.css                 # KaTeX overrides and math display
  image/
    [topic-slug]/            # Images grouped by post topic
      figure-1.png
      figure-2.png
  js/                        # Minimal JS (KaTeX handled at build time)
  _config.yml                # Jekyll + plugin configuration
```

### Image Path Convention

Images are stored in `/image/[topic-slug]/` and referenced with absolute paths:

```html
<img src='/image/variational-inference/elbo-diagram.png' />
```

The topic slug matches the post's conceptual topic, not necessarily the filename slug. Multiple related posts can share an image directory.
