---
name: Technical Blog Writer
description: This skill should be used when the user asks to "write a blog post", "draft a blog post", "create a technical blog", "write a deep dive", "write an explainer", "blog about", "write a tutorial post", "turn this into a blog post", or wants to create technical content for a personal blog or static site. Default platform is Jekyll (Gundersen-style) with KaTeX math, BibTeX citations via jekyll-scholar, and custom figure HTML. Covers deep dives, explainers, tutorials, and project showcases on ML, statistics, computer science, finance, math, and quantitative topics. Generates Markdown with SEO frontmatter, code examples, and diagram suggestions.
---

# Technical Blog Writer

Produce publication-ready technical blog posts as Markdown files. The default platform is a Gundersen-style Jekyll blog with KaTeX math, jekyll-scholar citations, and custom HTML figures. For other platforms (Hugo, Astro, Next.js), consult `references/seo-frontmatter.md` for platform-specific frontmatter and conventions.

## Core Workflow

Follow this sequence for every blog post:

```
Blog Post Workflow:
1. Clarify scope and audience
2. Research and outline
3. Generate frontmatter
4. Write the draft
5. Add code examples, figures, and citations
6. Review and polish
```

### Step 1: Clarify Scope and Audience

Before writing, establish:

- **Topic boundary** — What specific aspect to cover (not "transformers" but "how multi-head attention computes contextual embeddings")
- **Target reader** — Assumed background level (beginner, intermediate, advanced practitioner)
- **Key takeaway** — The one thing the reader should understand after reading
- **Estimated length** — Short (800-1200 words), Medium (1500-2500 words), Long (3000+ words). If > 1500 words, plan a table of contents.

If the user provides a codebase, paper, or project as source material, explore it first to identify the most interesting angle for a blog post.

### Step 2: Research and Outline

Build a structured outline before drafting:

1. **Opening paragraph** — Context (1-2 sentences) → gap/problem (optional) → purpose statement ("The goal of this post is to...") → roadmap (brief)
2. **Table of contents** — Plan one if estimated length > 1500 words
3. **Core sections** — 3-5 sections building understanding progressively (concrete → abstract → concrete)
4. **Practical application** — Code, examples, or worked problems
5. **Conclusion** — Key takeaway restated, further reading

Present the outline for user approval before writing the full draft. Adjust based on feedback.

For detailed structure patterns (deep dive, tutorial, explainer formats), consult `references/writing-patterns.md`.

### Step 3: Generate Frontmatter

Generate YAML frontmatter for the user's blog platform. The default Jekyll format:

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

Key fields:

- **`title`** — Clear, specific, SEO-friendly (50-60 characters ideal)
- **`subtitle`** — Starts with "I" + action verb (derive, explain, explore, prove, work through) + specific focus. Exactly one sentence with a period. Doubles as meta description.
- **`layout`** — `default` (single custom layout)
- **`date`** — `YYYY-MM-DD`
- **`keywords`** — Comma-separated string (not an array), 4-6 keywords
- **`published`** — `true` to publish, `false` to hide from build

For other platforms, consult `references/seo-frontmatter.md`.

### Step 4: Write the Draft

#### Opening Paragraph

Every post opens with context → purpose → roadmap. Include an explicit purpose statement: "The goal of this post is to..." Avoid generic openings like "In this post, we will explore..." or "X has become increasingly popular..." For specific patterns, consult `references/writing-patterns.md`.

#### Body Sections

For each section:

- **Lead with the intuition** before formulas or code
- **Use concrete examples** — Numbers, scenarios, visualizations over abstract descriptions
- **Build progressively** — Each section should depend on the previous one
- **Include transition sentences** between sections connecting ideas
- **Signpost at transitions** — Use purpose statements, progress markers, previews, and summaries (see `references/writing-patterns.md`)

#### Writing Philosophy

- **Intuition before formalism** — At least 20-30% of content should be intuition-building before formalization
- **"Naming things"** — When introducing notation, use "First, let's name things." Define every symbol before or at first use, connected to previously built intuition
- **Progressive explanation** — Follow the concrete → abstract → concrete cycle
- **Subtitle as summary** — The subtitle captures the entire post's purpose in one sentence
- **Cross-reference own posts** — Link to previous posts for background: "If you're unfamiliar with X, see my post on [topic]"
- **Acknowledge analogy limitations** — When using analogies, state where they break down
- **Explicit closure** — After complex explanations, provide closure: "And that's it! That's the [concept]."

#### Math and Formulas

When including mathematical content (KaTeX is the default, MathJax as legacy fallback):

- Introduce notation before using it ("First, let's name things...")
- Provide intuitive explanation alongside formal definitions
- Use inline math (`$x$`) for variables in prose, display math (`$$...$$`) for key equations
- **Number equations** with `\tag{N}` for equations referenced later in the text
- **Derive step-by-step** — never jump more than one logical step
- **Justify non-obvious steps** — "Step * holds because..." or "where we used [identity/theorem]"
- Add a "what this means" sentence after every non-trivial equation

#### Writing Style

- **Active voice** — "The gradient descent algorithm updates weights" not "Weights are updated by..."
- **Short paragraphs** — 3-5 sentences maximum for screen readability
- **Concrete over abstract** — "A 3x3 matrix" not "a matrix of arbitrary dimensions"
- **No filler** — Cut "basically", "essentially", "it's worth noting that", "it should be mentioned"
- **First person naturally** — Use "I" for purpose, experience, opinions, and guidance. Use "we" for walking through derivations together.
- **Anti-condescension** — Never use "obviously", "trivially", "simple algebra shows", "the reader should know." Use instead: "We can see that...", "A quick calculation shows...", "Recall that..."
- **Signposting** — Purpose statements at section starts, progress markers at transitions, summaries after complex sections

### Step 5: Code Examples, Figures, and Citations

#### Code Examples

Include code when it reinforces understanding:

- **Minimal and focused** — Show only the relevant concept, strip boilerplate
- **Imports included** — Show exactly what to install/import
- **Annotated** — Add comments explaining non-obvious lines, connect to theory ("This implements Equation N")
- **Runnable** — Reader should be able to copy-paste and execute
- **Language-appropriate** — Python for ML/data, TypeScript/Rust for systems, pseudocode for algorithms

Structure code blocks as:

```markdown
Brief explanation of what this code does:

\`\`\`python
# Clear, annotated code here
\`\`\`

Explanation of the output or key insight from running this.
```

#### Figures

Use the HTML figure convention for the default Jekyll blog. For other platforms, use standard Markdown images.

```html
<div class='figure'>
    <img src='/image/[topic-slug]/[filename].png'
         style='width: 60%; min-width: 250px;' />
    <div class='caption'>
        <span class='caption-label'>Figure N.</span> Caption text that
        fully describes what the figure shows.
    </div>
</div>
```

Figure rules:
- **Number sequentially** — Figure 1, Figure 2, etc.
- **Caption is self-contained** — Reader understands the figure from caption alone
- **Reference in text** — "Consider Figure 3, which shows..."
- **Consistent design** — Same colors, fonts (Arial), and line weights across all figures
- **Progressive complexity** — Simple visuals before complex ones

For detailed figure conventions and Mermaid patterns, consult `references/diagrams.md`.

#### Citations

For the default Jekyll blog using jekyll-scholar:

- Cite inline with `{% cite key %}` — renders as (Author, Year)
- Store references in `_bibliography/references.bib`
- Add bibliography at the post's end with `{% bibliography --cited %}`
- Cite sources when making claims about prior work, theoretical results, or experimental findings

For setup details, see `references/jekyll-setup.md`.

### Step 6: Review and Polish

Before delivering the final draft, verify:

- [ ] **Purpose statement present** — Opening includes "The goal of this post is..."
- [ ] **Subtitle format correct** — Starts with "I" + action verb + specific focus, one sentence
- [ ] **Intuition before formalism** — At least 20-30% intuition-building before math/formal content
- [ ] **Signposting at transitions** — Purpose, progress, preview, and summary markers throughout
- [ ] **Worked examples** — Each major concept has a worked example with concrete numbers
- [ ] **Anti-condescension check** — No "obviously", "trivially", "simple algebra shows"
- [ ] **Progressive structure** — Each section builds on the last (concrete → abstract → concrete)
- [ ] **Code is runnable** — Examples include imports, comments, and work if copy-pasted
- [ ] **Math is introduced** — No undefined notation, "naming things" technique used
- [ ] **Figures numbered and referenced** — Every figure has a caption and is referenced in text
- [ ] **Frontmatter is complete** — Title, subtitle, layout, date, keywords, published
- [ ] **No filler language** — Every sentence adds value
- [ ] **Conclusion connects to purpose** — Restates insight, further reading included
- [ ] **Table of contents** — Present if post > 1500 words
- [ ] **Length matches scope** — Not padded, not rushed

For a detailed scoring rubric (10 criteria, 1-5 scale), consult `references/style-rubric.md`.

## Adapting by Post Type

| Type | Focus | Length | Code | Diagrams |
|------|-------|--------|------|----------|
| **Deep dive** | Thorough exploration of one concept | 2000-4000 words | Supporting | Architecture, flow |
| **Explainer** | Make complex topic accessible | 1200-2500 words | Illustrative | Concept maps |
| **Tutorial** | Step-by-step building | 1500-3000 words | Central | Setup, flow |
| **Project showcase** | Walk through a build | 1500-2500 words | Central | Architecture |

For detailed patterns per post type, see `references/writing-patterns.md`.

## Quantitative Content Guidelines

When writing about ML, statistics, finance, or math:

- **Ground formulas in intuition** — Explain what an equation "is doing" before showing it
- **Use worked examples** — Walk through a calculation with actual numbers
- **Connect to practice** — Show how theory maps to code or real-world application
- **Cite sources** — Use `{% cite key %}` for jekyll-scholar, or link to papers and textbooks
- **Be precise about assumptions** — State when results require specific conditions (i.i.d., stationarity, etc.)

## Additional Resources

### Reference Files

For detailed guidance beyond this core workflow:

- **`references/writing-patterns.md`** — Gundersen writing style defaults. Blog structure templates for deep dives, explainers, and tutorials. Opening paragraph formula, transition techniques, signposting patterns, conclusion formulas.
- **`references/seo-frontmatter.md`** — Jekyll frontmatter (default) and other platforms (Hugo, Astro, Next.js). SEO title formulas, meta description templates, tag strategies.
- **`references/diagrams.md`** — HTML figure convention (Jekyll default). Mermaid diagram syntax for common patterns. When to use diagrams vs. prose. Figure design rules and caption conventions.
- **`references/jekyll-setup.md`** — Jekyll configuration reference. Plugins (jekyll-katex, jekyll-scholar), CSS design conventions, file organization, design philosophy.
- **`references/style-rubric.md`** — Draft evaluation rubric with 10-criteria scoring. Quick reference templates for openings, transitions, conclusions, and subtitles.
