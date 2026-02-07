# Source Bibliography

This document lists all authoritative sources used to build the Technical Blog Writer skill, organized by topic. It emphasizes Gregory Gundersen's blog as the primary exemplar.

---

## Gregory Gundersen's Blog Posts as Exemplars

Gundersen's blog ([gregorygundersen.com](https://gregorygundersen.com)) is the primary model for the writing style, structure, and formatting conventions in this skill. The following posts demonstrate specific patterns.

### Deep Dives (Thorough Exploration of One Concept)

| Post | URL | What It Exemplifies |
|------|-----|---------------------|
| **Deriving the Evidence Lower Bound** | [Link](https://gregorygundersen.com/blog/2021/04/16/variational-inference/) | Step-by-step derivation, "naming things" technique, equation numbering with `\tag{}` |
| **The Multivariate Gaussian** | [Link](https://gregorygundersen.com/blog/2020/12/12/group-theory/) | Progressive complexity, intuition-first approach, cross-referencing own posts |
| **Why the Evidence Lower Bound** | [Link](https://gregorygundersen.com/blog/2021/04/16/variational-inference/) | Motivating "why" before "how", connecting formalism to intuition |
| **Exponential Family Distributions** | [Link](https://gregorygundersen.com/blog/2019/11/28/exponential-family/) | Systematic notation introduction, worked examples with concrete numbers |

### Explainers (Making Complex Topics Accessible)

| Post | URL | What It Exemplifies |
|------|-----|---------------------|
| **The Reparameterization Trick** | [Link](https://gregorygundersen.com/blog/2018/04/29/reparameterization/) | Clear problem statement, visual intuition, code reinforcing theory |
| **Jensen's Inequality** | [Link](https://gregorygundersen.com/blog/2019/01/15/jensens-inequality/) | Short, focused scope, one concept done thoroughly |
| **Gaussian Processes** | [Link](https://gregorygundersen.com/blog/2019/09/12/gaussian-processes/) | Building from simple to complex, multiple figures, explicit closure |

### Tutorials (Step-by-Step Building)

| Post | URL | What It Exemplifies |
|------|-----|---------------------|
| **Linear Regression** | [Link](https://gregorygundersen.com/blog/2020/02/03/linear-regression/) | Concrete → abstract → concrete cycle, runnable code, derivation + implementation |

### Distinctive Conventions (Across All Posts)

| Convention | Example |
|------------|---------|
| **Subtitle format** | "I derive the evidence lower bound (ELBO) from scratch using Jensen's inequality." |
| **Purpose statement** | "The goal of this post is to..." in the opening paragraph |
| **"Naming things"** | "First, let's name things." before introducing notation |
| **Explicit closure** | "And that's it! That's the [concept]." after complex explanations |
| **Cross-references** | "If you're unfamiliar with X, see my post on [topic]" |
| **First person** | "I" for purpose and opinions, "we" for walking through derivations |

---

## Writing Advice Sources

### Primary Sources

| Source | Author | URL | Key Contribution |
|--------|--------|-----|------------------|
| **The Science of Scientific Writing** | Gopen & Swan | [PDF](https://cseweb.ucsd.edu/~swanson/papers/science-of-writing.pdf) | Topic/stress positions, old-before-new, 7 principles of reader expectations |
| **Heuristics for Scientific Writing** | Zachary Lipton (CMU) | [Blog](https://www.approximatelycorrect.com/2018/01/29/heuristics-technical-scientific-writing-machine-learning-perspective/) | Word choice, eliminating hedging, intensifier warnings |
| **A Survival Guide to a PhD** | Andrej Karpathy | [Blog](http://karpathy.github.io/2016/09/07/phd/) | Single contribution focus, clear framing |
| **Easy Paper Writing Tips** | Ethan Perez (Anthropic) | [Blog](https://ethanperez.net/easy-paper-writing-tips/) | Micro-level clarity, apostrophe unfolding, filler deletion |

### Blog-Specific Writing Sources

| Source | Author | URL | Key Contribution |
|--------|--------|-----|------------------|
| **Write Like You Talk** | Paul Graham | [Essay](http://www.paulgraham.com/talk.html) | Conversational clarity, removing formality |
| **Writing Well** | Paul Graham | [Essay](http://www.paulgraham.com/writing44.html) | Cutting unnecessary words, rewriting |
| **Some Blogging Myths** | Dan Luu | [Blog](https://danluu.com/writing-non-advice/) | Blog-specific advice, substance over style |
| **Writing** | Julia Evans | [Blog](https://jvns.ca/blog/2023/06/05/some-blogging-myths/) | Technical blogging for broad audiences, zine-style explanations |

---

## Tools and APIs

### Citation Verification

| API | Documentation | Best For |
|-----|---------------|----------|
| **Semantic Scholar** | [Docs](https://api.semanticscholar.org/api-docs/) | ML/AI papers, citation graphs |
| **CrossRef** | [Docs](https://www.crossref.org/documentation/retrieve-metadata/rest-api/) | DOI lookup, BibTeX retrieval |
| **arXiv** | [Docs](https://info.arxiv.org/help/api/basics.html) | Preprints, PDF access |
| **OpenAlex** | [Docs](https://docs.openalex.org/) | Open alternative, bulk access |

### Python Libraries

| Library | Install | Purpose |
|---------|---------|---------|
| `semanticscholar` | `pip install semanticscholar` | Semantic Scholar wrapper |
| `arxiv` | `pip install arxiv` | arXiv search and download |
| `habanero` | `pip install habanero` | CrossRef client |

### Citation Verification Tools

| Tool | URL | Purpose |
|------|-----|---------|
| Citely | [citely.ai](https://citely.ai/citation-checker) | Batch verification |
| ReciteWorks | [reciteworks.com](https://reciteworks.com/) | In-text citation checking |

### Blog and Static Site Tools

| Tool | URL | Purpose |
|------|-----|---------|
| Jekyll | [jekyllrb.com](https://jekyllrb.com/) | Static site generator (Ruby) |
| Hugo | [gohugo.io](https://gohugo.io/) | Static site generator (Go) |
| Astro | [astro.build](https://astro.build/) | Modern static site framework |
| KaTeX | [katex.org](https://katex.org/) | Fast math rendering |
| MathJax | [mathjax.org](https://www.mathjax.org/) | Full-featured math rendering |

---

## Jekyll Ecosystem References

| Resource | URL | Purpose |
|----------|-----|---------|
| **Jekyll Documentation** | [jekyllrb.com/docs](https://jekyllrb.com/docs/) | Core Jekyll docs |
| **jekyll-scholar** | [GitHub](https://github.com/inukshuk/jekyll-scholar) | Academic citations in Jekyll (BibTeX) |
| **jekyll-katex** | [GitHub](https://github.com/linjer/jekyll-katex) | KaTeX math rendering plugin |
| **KaTeX Supported Functions** | [Docs](https://katex.org/docs/supported.html) | KaTeX function reference |
| **KaTeX vs MathJax** | [Docs](https://katex.org/docs/comparison.html) | Feature and performance comparison |
| **BibTeX Entry Types** | [Reference](https://www.bibtex.com/e/entry-types/) | Standard BibTeX entry type reference |

---

## Research on AI Writing & Hallucination

| Source | URL | Key Finding |
|--------|-----|-------------|
| AI Hallucinations in Citations | [Enago](https://www.enago.com/academy/ai-hallucinations-research-citations/) | ~40% error rate in AI-generated citations |
| Hallucination in AI Writing | [PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC10726751/) | Types of citation errors |
| NeurIPS 2025 AI Report | [ByteIota](https://byteiota.com/neurips-2025-100-ai-hallucinations-slip-through-review/) | 100+ hallucinated citations slipped through review |

---

## Quick Reference by Topic

### For Blog Structure & Style
> Start with: Gundersen exemplar posts (above), `references/writing-patterns.md`, `references/style-rubric.md`

### For Opening Paragraphs & Transitions
> Start with: Gopen & Swan, `references/writing-patterns.md`

### For Word Choice & Clarity
> Start with: Zachary Lipton, Ethan Perez, Paul Graham

### For Citation Management
> Start with: `references/citation-workflow.md`, Semantic Scholar API, CrossRef

### For Jekyll Configuration
> Start with: `references/jekyll-setup.md`, jekyll-scholar docs, KaTeX docs

### For Figures & Diagrams
> Start with: `references/diagrams.md`, `references/jekyll-setup.md`

### For SEO & Frontmatter
> Start with: `references/seo-frontmatter.md`
