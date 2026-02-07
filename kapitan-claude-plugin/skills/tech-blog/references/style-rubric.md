# Style Rubric (Gundersen Writing Style)

Draft evaluation rubric for technical blog posts following Gregory Gundersen's writing conventions. Use this to review and score drafts during Step 6 (Review and Polish).

## Table of Contents

- [Structure Evaluation](#structure-evaluation)
- [Intuition-First Method](#intuition-first-method)
- [Signposting and Reader Guidance](#signposting-and-reader-guidance)
- [Technical Content Quality](#technical-content-quality)
- [Visual Elements](#visual-elements)
- [Code Integration](#code-integration)
- [Voice and Tone](#voice-and-tone)
- [Scoring Rubric](#scoring-rubric)
- [Quick Reference Templates](#quick-reference-templates)

---

## Structure Evaluation

### Title Assessment

- **Specific** — names the exact concept, not a broad area ("Deriving the Evidence Lower Bound" not "Variational Inference")
- **No clickbait** — no "You Won't Believe...", no listicle numbers, no question-as-title
- **Action-oriented when appropriate** — "Deriving...", "Understanding...", "Implementing..."

### Subtitle Format

The subtitle is a single sentence that:

1. Starts with **"I"**
2. Contains an **action verb** (derive, explain, explore, prove, work through, discuss, show, review, implement)
3. States the **specific focus** of the post
4. Is **exactly one sentence** — no compound sentences

Examples:
- "I derive the evidence lower bound (ELBO) from scratch using Jensen's inequality."
- "I explain how Gaussian processes work by building intuition from weight-space to function-space views."
- "I work through the math behind logistic regression, starting from maximum likelihood."

Anti-examples:
- "A deep dive into ELBO" (no "I", no verb, vague)
- "I derive the ELBO and also discuss variational autoencoders and their applications" (too many topics)
- "In this post, I explore variational inference." (filler opening, vague)

### Opening Paragraph Formula

The first paragraph follows a predictable, effective structure:

1. **Context** (1-2 sentences) — What area are we in? What does the reader already know?
2. **Gap or problem** (optional, 1 sentence) — What's missing, confusing, or hard to find?
3. **Purpose statement** — "The goal of this post is to..." (explicit, always present)
4. **Roadmap** (brief) — What the post will cover, in what order

Never open with:
- A definition or equation
- A vague statement ("X is important in many fields...")
- A rhetorical question without immediate payoff
- History/background without a clear anchor to the post's purpose

### Table of Contents Requirement

For posts estimated at **> 1500 words**, include a table of contents after the opening paragraph:

> "This is a long post. Please feel free to jump around as desired:"

Followed by a numbered list with anchor links to each major section.

### Section Header Naming

Headers are **descriptive and action-oriented**. Never use generic labels.

| Bad | Good |
|-----|------|
| Introduction | Setting up the problem |
| Background | What we need from probability theory |
| Methods | Deriving the objective function |
| Results | Visualizing the learned representations |
| Discussion | Why this matters for practitioners |
| Conclusion | Summary and further reading |

### Conclusion Requirements

- Restate the key insight in 1-2 sentences
- Connect back to the purpose statement from the opening
- Suggest further reading (own posts, papers, textbooks)
- Optional: acknowledge limitations or open questions

---

## Intuition-First Method

### Core Principle

At least **20-30% of content** should be intuition-building before any formalization. The reader should understand the *idea* before seeing the *math*.

### The "Explain to a 14-Year-Old" Test

For each major concept, ask: could a smart 14-year-old follow the intuitive explanation (ignoring the math)? If not, add more intuition.

### Transition from Intuition to Formalism

Use explicit transition phrases:

- "Now that we understand X intuitively, let's formalize these ideas."
- "Now that we have a geometrical intuition for [topic], let's write this down mathematically."
- "With this picture in mind, we can be more precise."
- "Let's make this concrete with notation."

Acknowledge the shift in difficulty when it happens.

### "Naming Things" Technique

When introducing notation, use this pattern:

> "First, let's name things. Let $X$ denote our observed data, $Z$ the latent variables we want to infer, and $\theta$ our model parameters."

Rules:
- Every symbol defined **before or at first use**
- Connect symbols to the intuition already built ("$Z$ represents the hidden structure we discussed above")
- Group related notation together
- Don't introduce notation you won't use

### Progressive Disclosure

```
1. Concrete example with numbers
2. Intuitive explanation of what's happening
3. "Naming things" — introduce notation
4. Formal definition or derivation
5. Return to concrete example with the formal tools
```

---

## Signposting and Reader Guidance

### Purpose Statements

Begin key sections with an explicit goal:

- "The goal of this section is to..."
- "In this section, we will..."
- "Here, I want to show that..."

### Progress Markers

At section transitions, acknowledge what was accomplished:

- "Now that we understand X..."
- "With X established..."
- "Having derived X, we can now..."

### Previews

Signal what's coming next:

- "In the next section, we'll..."
- "We'll return to this point when we discuss..."
- "This will become important when..."

### Summaries

After complex derivations or multi-step arguments:

- "To summarize..."
- "The key takeaway from this section is..."
- "In short, X because Y."

### Preemptive Question Answering

Anticipate reader confusion:

- "You might ask why we chose X over Y..."
- "At this point, we may be wondering: why not just...?"
- "A natural question is whether..."
- "This might seem circular, but..."

### "And That's It!" Closure

After completing a complex explanation, provide explicit closure:

- "And that's it! That's the evidence lower bound."
- "And that's the key insight — X is just Y viewed differently."
- "That's all there is to it. The rest is details."

This signals to the reader that the hard part is done and they can relax.

---

## Technical Content Quality

### Equation Standards

- **Numbered** with `\tag{N}` for equations referenced later in the text
- **Derived step-by-step** — never jump more than one logical step
- **Non-obvious steps marked** — "Step * holds because..." or "where we used [identity/theorem]"
- **Plain-language sentence after each non-trivial equation** — explain what the equation *means*, not just what it *says*

### Notation Consistency

- Same symbol means the same thing throughout the post
- Define a notation table for posts with heavy math
- Distinguish between random variables (uppercase), realizations (lowercase), vectors (bold), matrices (uppercase bold)

### Worked Examples

- **Required** for each major concept — at least one worked example with actual numbers
- Show intermediate steps
- Connect back to the formula: "Plugging in our values, Equation 3 gives us..."

---

## Visual Elements

### Figure Standards

- **Numbered sequentially** — Figure 1, Figure 2, etc.
- **Captioned** — every figure has a caption starting with "Figure N."
- **Referenced in text** — "Consider Figure 3, which shows..." (never include an unreferenced figure)
- **Caption is self-contained** — reader should understand the figure from the caption alone

### Progressive Visual Complexity

- Simple visuals before complex ones
- Each subsequent diagram builds on previous visual conventions
- Use consistent colors, fonts, and line weights across all figures in a post

---

## Code Integration

### Standards

- **Imports included** — show the reader exactly what to install/import
- **Docstrings or comments** — explain the purpose, not the syntax
- **Theory-code connection** — "This implements Equation N" or "This is the X step from our derivation"
- **Runnable** — reader can copy, paste, and execute

### Anti-Patterns

- Code without context (no explanation of what it does or why)
- Code that silently depends on undefined variables or imports
- Code that duplicates the math without adding implementation insight

---

## Voice and Tone

### First Person Usage

- **"I"** for purpose, experience, and guidance: "I want to explain...", "My goal here is...", "In my experience..."
- **"We"** for walking through derivations together: "Let's derive...", "If we substitute..."
- **Never "we"** as false modesty for single-author work when stating opinions
- **No passive voice** for key statements: "The gradient points uphill" not "It is noted that the gradient points uphill"

### Intellectual Honesty

- "In my experience..." — own your perspective
- "I think..." — distinguish opinion from fact
- "My understanding is..." — signal uncertainty appropriately
- Acknowledge when something is beyond the post's scope
- Point to better resources: "For a rigorous treatment, see [reference]"

### Anti-Condescension

Never use:

| Banned | Use Instead |
|--------|-------------|
| "obviously" | "We can see that..." |
| "trivially" | "A quick calculation shows..." |
| "simply" (as minimizer) | "Recall that..." |
| "the reader should know" | "If you're unfamiliar with X, see [link]" |
| "it's easy to see" | "Notice that..." |
| "simple algebra shows" | (Show the algebra) |

### Cross-References

- Link to your own previous posts: "If you're unfamiliar with X, see my post on [topic]."
- Don't assume the reader has read other posts — provide enough context inline

---

## Scoring Rubric

Rate each criterion on a 1-5 scale. A publishable draft scores 4+ on all criteria.

| # | Criterion | 1 (Poor) | 3 (Adequate) | 5 (Excellent) |
|---|-----------|----------|-------------|---------------|
| 1 | **Intuition before formalism** | Jumps straight to math | Some intuition, then math | 20-30% intuition-building, clear transition |
| 2 | **Clear purpose** | No explicit goal | Goal implied but not stated | "The goal of this post is..." in opening |
| 3 | **Visual elements** | No figures | Figures present but unreferenced | Numbered, captioned, referenced, progressive |
| 4 | **Signposting** | No transitions | Some section intros | Purpose, progress, preview, summary throughout |
| 5 | **Worked examples** | None | One example, incomplete | Each concept has a worked example with numbers |
| 6 | **Code quality** | Missing imports, no context | Runnable but undocumented | Imports, comments, theory connection, runnable |
| 7 | **Voice** | Passive, impersonal | Mixed active/passive | First-person, direct, honest, no condescension |
| 8 | **Notation** | Undefined symbols | Mostly defined | All defined before use, "naming things" technique |
| 9 | **Structure** | Flat, unorganized | Sections present | Progressive depth, descriptive headers, ToC if long |
| 10 | **Conclusion** | Absent or restates intro | Summary present | Restates insight, connects to purpose, further reading |

### Score Interpretation

- **45-50**: Publication-ready
- **35-44**: Needs minor revisions (specific sections)
- **25-34**: Needs significant revision (structural issues)
- **Below 25**: Needs rethinking (fundamental approach issues)

---

## Quick Reference Templates

### Opening Paragraph

```markdown
[1-2 sentences of context — what area, what the reader likely knows.]
[Optional: what's missing, hard, or confusing about existing treatments.]
The goal of this post is to [specific action: derive, explain, demonstrate]
[specific topic]. [1 sentence roadmap: "I'll start with X, build up to Y,
and finish with Z."]
```

### Section Transition

```markdown
Now that we [what was accomplished in previous section], we can
[what this section will do]. [Optional: why this matters for the
overall goal.]
```

### Intuition-to-Formalism Transition

```markdown
Now that we have [an intuitive/geometric/visual] understanding of
[concept], let's formalize these ideas. First, let's name things.
[Define notation.]
```

### Example Introduction

```markdown
To make this concrete, let's work through an example. Suppose
[concrete setup with specific numbers/dimensions].
```

### Conclusion

```markdown
[Restate the key insight in 1-2 sentences, connecting to the
purpose statement from the opening.]

[Acknowledge limitations or open questions, if any.]

[Further reading: own posts, papers, textbooks.]
```

### Subtitle

```markdown
I [action verb] [specific topic] [optional: method or approach].
```

Examples:
- "I derive the variational lower bound using Jensen's inequality."
- "I explain how kernel methods generalize linear models to nonlinear settings."
- "I work through the derivation of backpropagation for a simple network."
