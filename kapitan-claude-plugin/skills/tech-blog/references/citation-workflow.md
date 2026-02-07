# Citation Verification for Blog Posts

This reference provides a complete workflow for managing citations in blog posts, preventing AI-generated citation hallucinations, and maintaining clean BibTeX bibliographies with jekyll-scholar.

---

## Contents

- [Why Verification Matters for Blog Credibility](#why-verification-matters-for-blog-credibility)
- [jekyll-scholar Citation Workflow](#jekyll-scholar-citation-workflow)
- [API-Based Verification (5-Step)](#api-based-verification-5-step)
- [Python Implementation](#python-implementation)
- [BibTeX Entry Formats](#bibtex-entry-formats)
- [Hallucination Prevention Rules](#hallucination-prevention-rules)
- [Troubleshooting](#troubleshooting)
- [Additional Resources](#additional-resources)

---

## Why Verification Matters for Blog Credibility

### The Hallucination Problem

Research has documented significant issues with AI-generated citations:
- **~40% error rate** in AI-generated citations (Enago Academy research)
- NeurIPS 2025 found **100+ hallucinated citations** slipped through review
- Common errors include:
  - Fabricated paper titles with real author names
  - Wrong publication venues or years
  - Non-existent papers with plausible metadata
  - Incorrect DOIs or arXiv IDs

### Why It's Worse for Blog Posts

Blog posts have risks that academic papers don't:

| Risk | Why It Matters |
|------|---------------|
| **Posts persist indefinitely** | No retraction process — wrong citations stay live for years |
| **Readers propagate errors** | Blog readers cite your post in their own work, spreading hallucinated references |
| **No peer review** | No reviewer will catch a fabricated citation before publication |
| **Credibility is personal** | A hallucinated citation damages *your* reputation, not an institution's |
| **Search engines amplify** | Google indexes blog posts and surfaces them to people searching for the cited work |

### Solution

**Never generate citations from memory — always verify programmatically.** When you cannot verify, use an explicit placeholder pattern so the author knows to check.

---

## jekyll-scholar Citation Workflow

### Basic Syntax

jekyll-scholar provides academic-style citations for Jekyll blogs:

```liquid
<!-- Inline citation (renders as "(Author, Year)") -->
{% cite vaswani_2017_attention %}

<!-- Multiple citations -->
{% cite vaswani_2017_attention hochreiter_1997_long %}

<!-- Bibliography at end of post (only cited works) -->
{% bibliography --cited %}
```

### Bibliography File

Store references in `_bibliography/references.bib` (or per-post `.bib` files):

```
_bibliography/
├── references.bib      # Shared bibliography
├── variational.bib     # Per-topic (optional)
└── transformers.bib    # Per-topic (optional)
```

### Jekyll Configuration

In `_config.yml`:

```yaml
scholar:
  style: apa
  locale: en
  sort_by: year
  order: descending
  source: ./_bibliography
  bibliography: references.bib
  bibliography_template: bib
  replace_strings: true
```

### Citation Key Format

Use consistent keys: `author_year_firstword`

```
vaswani_2017_attention
hochreiter_1997_long
kingma_2014_auto
gundersen_2021_deriving
```

### Placeholder Pattern

When you cannot verify a citation, use this pattern so the author knows:

```liquid
{% cite PLACEHOLDER_author2024_verify %}
<!-- TODO: Could not verify this citation exists. Please confirm before publishing. -->
```

**Always tell the author**: "I've marked [X] citations as placeholders that need verification. I could not confirm these references exist."

---

## API-Based Verification (5-Step)

### Process Overview

```
1. SEARCH → Query Semantic Scholar or Exa MCP with specific keywords
     ↓
2. VERIFY → Confirm paper exists in 2+ sources (Semantic Scholar + arXiv/CrossRef)
     ↓
3. RETRIEVE → Get BibTeX via DOI content negotiation
     ↓
4. VALIDATE → Confirm the claim you're citing actually appears in the source
     ↓
5. ADD → Add verified entry to _bibliography/references.bib
```

### Step 1: Search

Use Exa MCP (if available) for initial discovery, then Semantic Scholar for verification:

```
# Exa MCP search examples:
Search: "variational inference evidence lower bound tutorial"
Search: "attention mechanism transformers Vaswani"
Search: "gaussian processes introduction machine learning"
```

Or use Semantic Scholar directly:

```python
from semanticscholar import SemanticScholar

sch = SemanticScholar()
results = sch.search_paper("attention mechanism transformers", limit=10)

for paper in results:
    print(f"Title: {paper.title}")
    print(f"Year: {paper.year}")
    print(f"DOI: {paper.externalIds.get('DOI', 'N/A')}")
    print(f"arXiv: {paper.externalIds.get('ArXiv', 'N/A')}")
    print(f"Citations: {paper.citationCount}")
    print("---")
```

### Step 2: Verify Existence

Confirm paper appears in at least two sources:

```python
import requests

def verify_paper(doi=None, arxiv_id=None):
    """Verify paper exists in multiple sources."""
    sources_found = []

    # Check Semantic Scholar
    if doi:
        resp = requests.get(
            f"https://api.semanticscholar.org/graph/v1/paper/DOI:{doi}",
            timeout=10
        )
        if resp.status_code == 200:
            sources_found.append("Semantic Scholar")

    # Check CrossRef (via DOI)
    if doi:
        resp = requests.get(
            f"https://api.crossref.org/works/{doi}",
            timeout=10
        )
        if resp.status_code == 200:
            sources_found.append("CrossRef")

    # Check arXiv
    if arxiv_id:
        resp = requests.get(
            f"http://export.arxiv.org/api/query?id_list={arxiv_id}",
            timeout=10
        )
        if "<entry>" in resp.text and "<title>" in resp.text:
            sources_found.append("arXiv")

    return len(sources_found) >= 2, sources_found
```

### Step 3: Retrieve BibTeX

Use DOI content negotiation for guaranteed accuracy:

```python
def doi_to_bibtex(doi: str) -> str:
    """Get verified BibTeX from DOI via CrossRef content negotiation."""
    response = requests.get(
        f"https://doi.org/{doi}",
        headers={"Accept": "application/x-bibtex"},
        allow_redirects=True,
        timeout=10
    )
    response.raise_for_status()
    return response.text

# Example
bibtex = doi_to_bibtex("10.48550/arXiv.1706.03762")
print(bibtex)
```

### Step 4: Validate Claims

Before citing a paper for a specific claim, verify the claim exists:

```python
def get_paper_abstract(doi):
    """Get abstract to verify claims."""
    resp = requests.get(
        f"https://api.semanticscholar.org/graph/v1/paper/DOI:{doi}",
        params={"fields": "abstract"},
        timeout=10
    )
    if resp.status_code == 200:
        return resp.json().get("abstract")
    return None
```

### Step 5: Add to Bibliography

Add the verified BibTeX entry to `_bibliography/references.bib`:

```bash
# Append to bibliography file
cat >> _bibliography/references.bib << 'EOF'

@inproceedings{vaswani_2017_attention,
  title = {Attention Is All You Need},
  author = {Vaswani, Ashish and Shazeer, Noam and ...},
  booktitle = {Advances in Neural Information Processing Systems},
  volume = {30},
  year = {2017}
}
EOF
```

If ANY step fails, mark as placeholder and inform the author.

---

## Python Implementation

### BlogCitationManager

A lighter version of the academic CitationManager, adapted for blog writing:

```python
"""
Blog Citation Manager - Verified citation workflow for technical blog posts.
Adapted from the ML Paper Writing skill's CitationManager.
"""

import re
import requests
import time
from typing import Optional, List, Dict, Tuple
from dataclasses import dataclass
from pathlib import Path

try:
    from semanticscholar import SemanticScholar
except ImportError:
    print("Install: pip install semanticscholar")
    SemanticScholar = None


@dataclass
class Reference:
    title: str
    authors: List[str]
    year: int
    doi: Optional[str]
    arxiv_id: Optional[str]
    venue: Optional[str]
    citation_count: int
    url: Optional[str] = None


class BlogCitationManager:
    """Manage citations for jekyll-scholar blog posts."""

    def __init__(self, bib_path: str = "_bibliography/references.bib"):
        self.sch = SemanticScholar() if SemanticScholar else None
        self.bib_path = Path(bib_path)
        self.verified: Dict[str, Reference] = {}

    def search(self, query: str, limit: int = 5) -> List[Reference]:
        """Search for papers using Semantic Scholar."""
        if not self.sch:
            raise RuntimeError("Install: pip install semanticscholar")

        results = self.sch.search_paper(query, limit=limit)
        refs = []
        for r in results:
            ref = Reference(
                title=r.title,
                authors=[a.name for a in (r.authors or [])],
                year=r.year or 0,
                doi=r.externalIds.get("DOI") if r.externalIds else None,
                arxiv_id=r.externalIds.get("ArXiv") if r.externalIds else None,
                venue=r.venue,
                citation_count=r.citationCount or 0,
            )
            refs.append(ref)
        return refs

    def verify(self, ref: Reference) -> Tuple[bool, List[str]]:
        """Verify reference exists in multiple sources."""
        sources = ["Semantic Scholar"]  # Already found via search

        if ref.doi:
            try:
                resp = requests.get(
                    f"https://api.crossref.org/works/{ref.doi}", timeout=10
                )
                if resp.status_code == 200:
                    sources.append("CrossRef")
            except requests.RequestException:
                pass

        if ref.arxiv_id:
            try:
                resp = requests.get(
                    f"http://export.arxiv.org/api/query?id_list={ref.arxiv_id}",
                    timeout=10,
                )
                if "<entry>" in resp.text and "<title>" in resp.text:
                    sources.append("arXiv")
            except requests.RequestException:
                pass

        return len(sources) >= 2, sources

    def get_bibtex(self, ref: Reference) -> Optional[str]:
        """Get BibTeX for a verified reference."""
        if ref.doi:
            try:
                resp = requests.get(
                    f"https://doi.org/{ref.doi}",
                    headers={"Accept": "application/x-bibtex"},
                    timeout=10,
                    allow_redirects=True,
                )
                if resp.status_code == 200:
                    return resp.text
            except requests.RequestException:
                pass

        return self._generate_bibtex(ref)

    def _make_key(self, ref: Reference) -> str:
        """Generate citation key: author_year_firstword."""
        first_author = (
            ref.authors[0].split()[-1].lower() if ref.authors else "unknown"
        )
        first_word = re.sub(r"[^a-z]", "", ref.title.split()[0].lower())
        return f"{first_author}_{ref.year}_{first_word}"

    def _generate_bibtex(self, ref: Reference) -> str:
        """Generate BibTeX from reference metadata (fallback)."""
        key = self._make_key(ref)
        authors = " and ".join(ref.authors) if ref.authors else "Unknown"
        entry_type = "article" if ref.venue else "misc"

        lines = [f"@{entry_type}{{{key},"]
        lines.append(f"  title = {{{ref.title}}},")
        lines.append(f"  author = {{{authors}}},")
        lines.append(f"  year = {{{ref.year}}},")
        if ref.doi:
            lines.append(f"  doi = {{{ref.doi}}},")
        if ref.arxiv_id:
            lines.append(f"  eprint = {{{ref.arxiv_id}}},")
            lines.append("  archiveprefix = {arXiv},")
        if ref.venue:
            lines.append(f"  journal = {{{ref.venue}}},")
        if ref.url:
            lines.append(f"  url = {{{ref.url}}},")
        lines.append("}")
        return "\n".join(lines)

    def cite(self, query: str) -> Optional[str]:
        """Full workflow: search → verify → return BibTeX."""
        refs = self.search(query, limit=5)
        if not refs:
            return None

        ref = refs[0]
        verified, sources = self.verify(ref)
        if not verified:
            print(f"Warning: Only verified in {sources}. Mark as placeholder.")

        bibtex = self.get_bibtex(ref)
        if bibtex:
            self.verified[ref.title] = ref
        return bibtex

    def append_to_bib(self, bibtex: str) -> None:
        """Append a verified BibTeX entry to the bibliography file."""
        self.bib_path.parent.mkdir(parents=True, exist_ok=True)
        with open(self.bib_path, "a") as f:
            f.write(f"\n\n{bibtex}")


# Usage example
if __name__ == "__main__":
    cm = BlogCitationManager()
    bibtex = cm.cite("attention is all you need transformer")
    if bibtex:
        print(bibtex)
        cm.append_to_bib(bibtex)
```

---

## BibTeX Entry Formats

### Conference Paper

```bibtex
@inproceedings{vaswani_2017_attention,
  title = {Attention Is All You Need},
  author = {Vaswani, Ashish and Shazeer, Noam and Parmar, Niki and
            Uszkoreit, Jakob and Jones, Llion and Gomez, Aidan N and
            Kaiser, Lukasz and Polosukhin, Illia},
  booktitle = {Advances in Neural Information Processing Systems},
  volume = {30},
  year = {2017},
  publisher = {Curran Associates, Inc.}
}
```

### Journal Article

```bibtex
@article{hochreiter_1997_long,
  title = {Long Short-Term Memory},
  author = {Hochreiter, Sepp and Schmidhuber, J{\"u}rgen},
  journal = {Neural Computation},
  volume = {9},
  number = {8},
  pages = {1735--1780},
  year = {1997},
  publisher = {MIT Press}
}
```

### arXiv Preprint

```bibtex
@misc{kingma_2014_auto,
  title = {Auto-Encoding Variational Bayes},
  author = {Kingma, Diederik P and Welling, Max},
  year = {2014},
  eprint = {1312.6114},
  archiveprefix = {arXiv},
  primaryclass = {stat.ML}
}
```

### Blog Post

```bibtex
@misc{gundersen_2021_deriving,
  title = {Deriving the Evidence Lower Bound},
  author = {Gundersen, Gregory},
  year = {2021},
  url = {https://gregorygundersen.com/blog/2021/04/16/variational-inference/},
  note = {Blog post}
}
```

### Textbook

```bibtex
@book{bishop_2006_pattern,
  title = {Pattern Recognition and Machine Learning},
  author = {Bishop, Christopher M},
  year = {2006},
  publisher = {Springer},
  isbn = {978-0-387-31073-2}
}
```

---

## Hallucination Prevention Rules

### The Golden Rule

```
IF you cannot programmatically fetch a citation:
    → Mark it with {% cite PLACEHOLDER_author2024_verify %}
    → Add <!-- TODO: Verify --> comment
    → Tell the author explicitly
    → NEVER invent a plausible-sounding reference
```

### Verification Checklist

Before adding any citation to `_bibliography/references.bib`:

- [ ] Paper found in at least 2 sources (Semantic Scholar + CrossRef/arXiv)
- [ ] DOI or arXiv ID verified
- [ ] BibTeX retrieved programmatically (not generated from memory)
- [ ] Entry type correct (@inproceedings, @article, @misc, @book)
- [ ] Author names complete and correctly formatted
- [ ] Year and venue verified
- [ ] Citation key follows `author_year_firstword` format
- [ ] The specific claim you're citing actually appears in the source

### Summary Table

| Situation | Action |
|-----------|--------|
| Found paper, got DOI, fetched BibTeX | Use the citation |
| Found paper, no DOI | Use arXiv BibTeX or manual entry from paper metadata |
| Paper exists but can't fetch BibTeX | Mark placeholder, inform author |
| Uncertain if paper exists | Mark `PLACEHOLDER`, inform author |
| "I think there's a paper about X" | **NEVER cite** — search first or mark placeholder |
| Blog post or textbook (no DOI) | Use @misc or @book with URL, verify URL resolves |

---

## Troubleshooting

### Common Issues

**Issue: Semantic Scholar returns no results**
- Try more specific keywords
- Check spelling of author names
- Use quotation marks for exact phrases

**Issue: DOI doesn't resolve to BibTeX**
- DOI may be registered but not linked to CrossRef
- Try arXiv ID instead if available
- Generate BibTeX from metadata manually

**Issue: `{% cite key %}` renders as raw text**
- Verify jekyll-scholar is installed: `gem install jekyll-scholar`
- Check `_config.yml` has the `scholar:` section
- Ensure bibliography file path matches config

**Issue: `{% bibliography --cited %}` shows nothing**
- Citation keys must match exactly between `{% cite %}` and `.bib` file
- Check for typos in citation keys
- Verify `.bib` file is valid BibTeX (no syntax errors)

**Issue: Rate limiting errors from APIs**
- Add delays between requests (1-3 seconds)
- Use API key if available
- Cache results to avoid repeat queries

**Issue: Encoding problems in BibTeX**
- Use proper LaTeX escaping: `{\"u}` for ü
- Ensure `.bib` file is UTF-8 encoded
- jekyll-scholar handles most Unicode, but LaTeX escaping is safer

---

## Additional Resources

**APIs:**
- Semantic Scholar: https://api.semanticscholar.org/api-docs/
- CrossRef: https://www.crossref.org/documentation/retrieve-metadata/rest-api/
- arXiv: https://info.arxiv.org/help/api/basics.html
- OpenAlex: https://docs.openalex.org/

**Python Libraries:**
- `semanticscholar`: https://pypi.org/project/semanticscholar/
- `arxiv`: https://pypi.org/project/arxiv/
- `habanero` (CrossRef): https://github.com/sckott/habanero

**Jekyll:**
- jekyll-scholar: https://github.com/inukshuk/jekyll-scholar
- jekyll-scholar configuration: https://github.com/inukshuk/jekyll-scholar#configuration

**Verification Tools:**
- Citely: https://citely.ai/citation-checker
- ReciteWorks: https://reciteworks.com/

**Source Bibliography:** See `references/sources.md` for the complete list of sources behind this skill.
