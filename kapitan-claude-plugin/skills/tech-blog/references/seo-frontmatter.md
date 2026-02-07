# SEO and Frontmatter for Technical Blogs

Platform-specific frontmatter templates, SEO title formulas, and meta description best practices.

## Table of Contents

- [Jekyll Frontmatter (Default)](#jekyll-frontmatter-default)
- [Other Platforms](#other-platforms)
- [SEO Title Formulas](#seo-title-formulas)
- [Meta Description Templates](#meta-description-templates)
- [Tag and Category Strategy](#tag-and-category-strategy)
- [URL Slug Best Practices](#url-slug-best-practices)

---

## Jekyll Frontmatter (Default)

The default blog platform uses a Gundersen-style Jekyll setup with a custom layout. For full Jekyll configuration details, see `references/jekyll-setup.md`.

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

### Field-by-Field Notes

| Field | Details |
|-------|---------|
| `title` | Specific, no clickbait. Rendered as `<h1>`. 50-60 characters ideal for SEO. |
| `subtitle` | Replaces `description`. Starts with "I" + action verb + specific focus. Exactly one sentence. Rendered as `<h4>` below the title. |
| `layout` | Always `default`. Single custom layout — not the standard Jekyll `post` layout. |
| `date` | `YYYY-MM-DD` format. No timezone offset needed. |
| `keywords` | Comma-separated string (not a YAML array). Populates `<meta name="keywords">`. 4-6 keywords recommended. |
| `published` | `true` to publish, `false` to hide. Inverse of Hugo's `draft` field. |

### Fields Not Used

- **`description`** — replaced by `subtitle`, which serves double duty as meta description and rendered subtitle
- **`categories`** — not used; the blog uses `keywords` for discoverability
- **`tags`** (array) — not used; replaced by `keywords` (comma-separated string)
- **`slug`** — derived from the filename (`YYYY-MM-DD-slug.md`), not a frontmatter field

### Subtitle Format

The subtitle follows a strict pattern. It functions as both a meta description and an on-page element:

1. Starts with **"I"**
2. Contains an **action verb** (derive, explain, explore, prove, work through, discuss, show, review)
3. States the **specific focus** of the post
4. Is **exactly one sentence** with a period

Examples:
- "I derive the evidence lower bound (ELBO) from scratch using Jensen's inequality."
- "I explain how Gaussian processes work by building intuition from weight-space to function-space views."
- "I work through the math behind logistic regression, starting from maximum likelihood."

---

## Other Platforms

### Hugo

```yaml
---
title: "Why Batch Normalization Actually Works"
date: 2025-01-15T10:00:00+08:00
draft: true
description: "The original explanation for batch norm was wrong. Here's what loss landscape smoothing reveals about why it actually helps training."
tags: ["deep-learning", "optimization", "batch-normalization"]
categories: ["machine-learning"]
slug: "why-batch-normalization-works"
cover:
  image: "images/cover.png"
  alt: "Loss landscape visualization with and without batch normalization"
  caption: ""
math: true
toc: true
---
```

Hugo-specific notes:
- `math: true` enables KaTeX/MathJax rendering (theme-dependent)
- `toc: true` generates table of contents (theme-dependent)
- `cover.image` path is relative to the post's directory in page bundles, or `static/` for flat structure
- Date format must include timezone offset

### Astro

```yaml
---
title: "Why Batch Normalization Actually Works"
pubDate: 2025-01-15
description: "The original explanation for batch norm was wrong. Here's what loss landscape smoothing reveals about why it actually helps training."
tags: ["deep-learning", "optimization", "batch-normalization"]
category: "machine-learning"
draft: true
heroImage: "./cover.png"
---
```

Astro-specific notes:
- `pubDate` instead of `date`
- Content collections may define custom schemas — check `src/content/config.ts`
- MDX files (`.mdx`) support component imports within content

### Next.js (MDX with contentlayer/next-mdx-remote)

```yaml
---
title: "Why Batch Normalization Actually Works"
date: "2025-01-15"
description: "The original explanation for batch norm was wrong. Here's what loss landscape smoothing reveals about why it actually helps training."
tags: ["deep-learning", "optimization", "batch-normalization"]
category: "machine-learning"
published: false
image: "/images/posts/batch-norm-cover.png"
---
```

Next.js-specific notes:
- Schema depends on content layer setup (contentlayer, velite, or custom)
- `published: false` instead of `draft: true` in some setups
- Image paths are typically from `public/`

---

## SEO Title Formulas

### Formula 1: Specific Claim

```
[What] [Surprising qualifier]: [Specifics]
```

Examples:
- "Why Batch Normalization Actually Works: It's Not Internal Covariate Shift"
- "Monte Carlo Simulation Is Overkill: When Analytical Solutions Suffice"

### Formula 2: How/What Explanation

```
How [Thing] Works: [Specific Angle]
```

Examples:
- "How Attention Mechanisms Work: A Visual Guide to Self-Attention"
- "How Options Are Priced: Black-Scholes from First Principles"

### Formula 3: Practical Guide

```
[Action]: A [Qualifier] Guide to [Topic]
```

Examples:
- "Implementing MCMC: A Practical Guide to Metropolis-Hastings"
- "Understanding Eigenvalues: A Visual Guide to Linear Transformations"

### Formula 4: Problem-Solution

```
[Problem Statement] with [Solution]
```

Examples:
- "Fixing Training Instability with Gradient Clipping"
- "Reducing Inference Latency with Quantization"

### Title Guidelines

| Rule | Rationale |
|------|-----------|
| 50-60 characters | Avoids truncation in search results |
| Lead with the topic | Readers scan from left to right |
| Include one keyword naturally | Improves discoverability without stuffing |
| Avoid clickbait | Technical readers punish misleading titles |
| Be specific | "Understanding Transformers" < "How Self-Attention Computes Contextual Embeddings" |

---

## Meta Description Templates

Descriptions appear in search results below the title. Target: 150-160 characters.

For the default Jekyll blog, the `subtitle` field doubles as the meta description. For other platforms, use the `description` field with these templates.

### Template 1: Problem-Solution

```
[Problem or question]. [What this post covers]. [Key insight or benefit].
```

Example (155 chars):
> "Most explanations of batch norm are wrong. This post explains the loss landscape smoothing theory and what it means for your training pipeline."

### Template 2: What You'll Learn

```
[Topic]: [specific aspect covered]. Includes [concrete deliverables].
```

Example (148 chars):
> "Self-attention explained with visual diagrams and NumPy code. Covers query-key-value mechanics and why attention enables in-context learning."

### Template 3: Direct Claim

```
[Bold claim]. [Supporting detail]. [What's covered].
```

Example (152 chars):
> "PCA is the most underrated tool in quantitative finance. Here's how to use eigendecomposition for risk factor analysis with worked Python examples."

### Description Guidelines

- Write complete sentences, not keyword lists
- Include one primary keyword naturally
- State the reader benefit — what will they understand or be able to do?
- Avoid "In this article..." openings — space is too limited
- End with specifics (code examples, diagrams, worked problems)

---

## Tag and Category Strategy

The default Jekyll blog uses `keywords` (comma-separated string) instead of tags or categories. This section applies to platforms that support tag/category taxonomy.

### Categories (Broad, 3-7 total across your blog)

Categories represent major topic areas. Keep them consistent:

```
Suggested category set:
- machine-learning
- statistics
- computer-science
- finance / quantitative-finance
- mathematics
- programming
```

Each post belongs to exactly one category.

### Tags (Specific, 2-5 per post)

Tags represent specific topics, techniques, or tools:

```
Tag examples:
- Techniques: gradient-descent, monte-carlo, backpropagation, regression
- Tools/frameworks: pytorch, numpy, pandas, scikit-learn
- Concepts: transformers, bayesian-inference, time-series, portfolio-theory
- Formats: tutorial, deep-dive, explainer
```

### Tag Naming Conventions

| Convention | Example | Reason |
|-----------|---------|--------|
| Lowercase | `deep-learning` | Consistency |
| Hyphenated | `batch-normalization` | URL-friendly |
| Singular preferred | `transformer` not `transformers` | Avoids duplicates |
| Specific over general | `self-attention` over `neural-networks` | Better filtering |

---

## URL Slug Best Practices

The slug is the URL-friendly version of the title:

```
Title: "Why Batch Normalization Actually Works"
Slug:  why-batch-normalization-works
URL:   yourblog.com/posts/why-batch-normalization-works
```

For the default Jekyll blog, the slug is derived from the filename (`_posts/YYYY-MM-DD-slug.md`) and is not set in frontmatter.

### Slug Rules

- Lowercase, hyphen-separated
- 3-6 words (shorter is better)
- Include primary keyword
- Remove filler words (a, the, is, and, of) when possible
- Never change a published slug (breaks links)

### Examples

| Title | Slug |
|-------|------|
| "How Self-Attention Computes Contextual Embeddings" | `self-attention-contextual-embeddings` |
| "A Practical Guide to Metropolis-Hastings" | `practical-guide-metropolis-hastings` |
| "Understanding Eigenvalues Through Geometry" | `eigenvalues-through-geometry` |
