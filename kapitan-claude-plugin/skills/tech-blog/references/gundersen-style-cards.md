# Gundersen Sub-Style Reference Cards

> These cards extend the default Gundersen Writing Style by codifying four
> distinct sub-styles observed across his blog. Use the default style conventions
> (voice, anti-condescension, equation conventions, signposting) as the
> baseline — see `references/writing-patterns.md` for the full baseline
> reference — then layer on the sub-style-specific instructions below.
>
> **Selection heuristic:** Ask "What is the reader's goal?"
> - *Understand a general pattern and see instances* → **Cataloging Explainer**
> - *See a familiar concept from a new angle* → **Interpretive Reframer**
> - *Understand why something works the way it does* → **First-Principles Narrative**
> - *Get a complete reference on a foundational topic* → **Comprehensive Treatment**

## Table of Contents

- [The Cataloging Explainer](#the-cataloging-explainer)
- [The Interpretive Reframer](#the-interpretive-reframer)
- [The First-Principles Narrative](#the-first-principles-narrative)
- [The Comprehensive Treatment](#the-comprehensive-treatment)

---

## The Cataloging Explainer

### When to Use

Use when introducing a mathematical object, distribution, or framework that has a **general form and multiple specific instances or properties**. The reader's goal is to understand the general pattern and see it applied to concrete examples. Typical topics: a family of distributions (exponential family, location-scale), a class of models (GLMs), a set of related identities or transforms. Also appropriate for compact "property sheets" that systematically derive all key facts about a single object (e.g., lognormal distribution properties). If the post requires multiple mathematical perspectives (algebraic, geometric, probabilistic) on the same object, use the Comprehensive Treatment instead — the Cataloging Explainer is for one general form with multiple instances, not one object with multiple viewpoints.

### System Instructions

```
You are writing a technical blog post in the Cataloging Explainer style. Follow
these instructions precisely:

OPENING: Begin with a 1-3 sentence definition or setup of the general form.
Immediately follow with a purpose statement: "I want to start by [providing/
deriving] the general form and then [demonstrating/working through] several
[examples/properties]." Do NOT open with a question, anecdote, or rhetorical
hook.

SUBTITLE: Format as "I [derive/provide/work through] [specific content]
[and discuss/and derive] [additional properties]." Exactly one sentence
with a period.

BODY ORGANIZATION: Structure as a sequence of self-contained units — either
examples of the general form or properties of the object:
- For EXAMPLE-DRIVEN posts: use H3 headers of the form "### [Specific instance]
  in [general form] form" (e.g., "### Bernoulli distribution in exponential
  family form").
- For PROPERTY-DRIVEN posts: use bold inline labels at paragraph start
  ("**Non-negativity.** Perhaps the first thing to observe is...").

EQUATION HANDLING: Every major equation gets a \tag{N} number. After each
non-trivial algebraic result, provide a plain-language translation: "In words,
we do not need to store all the data, only ∑u(xᵢ), which we can think of as
a compact summarization of our data."

NOTATION: Introduce notation formally in a "naming things" block early in the
post. Use bullet lists for symbol definitions.

DERIVATIONS: Keep main-body derivations concise. Defer long proofs to a
numbered Appendix (A1, A2, ...). Reference as "See [A1] for details."

TONE: Neutral-pedagogical. Use "I" sparingly and functionally ("I want to
start by...", "I believe this formulation is used so that..."). Use "we" for
derivation walkthroughs ("Let's try to get this into standard form...").
No aesthetic judgments ("beautiful", "elegant"). Occasional casual aside is
acceptable ("I don't want to take the derivative of Equation A5.2").

CODE: If present, place in the appendix as a "sanity check" — never in the
main body.

CONCLUSION: A brief summary paragraph restating the 3-4 most important
properties or results. No personal reflection. Optionally note properties
not proven in this post with a citation.

Apply all baseline Gundersen conventions: anti-condescension, step-by-step
derivations, explicit signposting, and numbered equations.
```

### Structural Template

```
1. Title + Subtitle ("I [verb] [content].")
2. Opening paragraph (1-3 sentences: definition → purpose statement → roadmap)
3. General form
   - Key equation with \tag{1}
   - Notation definitions (bullet list: "η is the natural parameter", etc.)
4. Examples OR Properties (3-5 self-contained units)
   a. Unit header (H3 for examples, bold inline label for properties)
   b. Setup (what we're about to show)
   c. Derivation (step-by-step algebraic manipulation)
   d. Result (boxed or summarized with notation mapping)
   e. "In words, ..." sentence
5. Key implications (1-2 sections: sufficient statistics, conjugacy, etc.)
   - Why the general form matters
   - Practical consequences
6. Conclusion (summary paragraph, no personal reflection)
7. Appendix (A1, A2, ... — detailed derivations, code sanity checks)
8. References
```

### Few-Shot Excerpt

> The gamma distribution is a two-parameter family of continuous probability distributions. I derive its moment generating function, compute its mean and variance, and show its relationship to the exponential and chi-squared distributions.
>
> The probability density function of a gamma random variable $X$ with shape $\alpha > 0$ and rate $\beta > 0$ is
>
> $$f(x \mid \alpha, \beta) = \frac{\beta^\alpha}{\Gamma(\alpha)} x^{\alpha - 1} e^{-\beta x} \tag{1}$$
>
> for $x > 0$, where $\Gamma(\alpha)$ is the gamma function, which ensures $f$ integrates to one.
>
> **Mean and variance.** The mean of $X$ is $\mathbb{E}[X] = \alpha / \beta$ and the variance is $\text{Var}(X) = \alpha / \beta^2$. See [A1] for a derivation using the moment generating function. In words, the shape parameter $\alpha$ controls the "peakedness" of the distribution, while the rate $\beta$ controls the scale.
>
> **Special cases.** When $\alpha = 1$, the gamma distribution reduces to the exponential distribution with rate $\beta$. When $\alpha = \nu/2$ and $\beta = 1/2$, we recover the chi-squared distribution with $\nu$ degrees of freedom. In words, both the exponential and chi-squared distributions are members of the gamma family, and any result we derive for the gamma distribution applies to them as special cases.

### Anti-Patterns

- **Opening with a question or anecdote** — this style opens with definitions and purpose. If you want a question-driven opening, use the First-Principles Narrative instead.
- **Including personal opinions or aesthetic judgments** — no "I find this beautiful" or "In my mind, this is a deep result." Reserve those for the Interpretive Reframer.
- **Putting full derivations in the main body** — anything over 5 lines of algebra should go in the appendix with a "See [AN] for details" reference.
- **Using narrative transitions between examples** — do NOT write "This naturally leads us to ask..." Between catalog units, a simple "As a final example..." or a new H3 header is sufficient.
- **Omitting "In words, ..." translations** — every non-trivial equation must be followed by a plain-language sentence explaining what it means.
- **Covering the same object from multiple mathematical perspectives** (algebraic + geometric + probabilistic) — that's a Comprehensive Treatment, not a catalog of instances.

---

## The Interpretive Reframer

### When to Use

Use when a well-known concept has a **lesser-known interpretation, connection, or dual characterization** that yields new insight. The reader already has basic familiarity with the concept; the goal is to see it from a new angle that unifies or explains something previously mysterious. Typical topics: why a particular loss function is standard (MSE as expectation), connections between seemingly different estimators, geometric interpretations of algebraic results, information-theoretic readings of statistical procedures.

### System Instructions

```
You are writing a technical blog post in the Interpretive Reframer style. Follow
these instructions precisely:

OPENING: Begin by stating the FAMILIAR interpretation in 2-3 sentences,
attributing it to general knowledge: "When most people first learn about [X],
they are given [standard definition/interpretation]." Then PIVOT: "However,
another interpretation of [X] is that it is [new frame]." This pivot is the
defining move of this style and MUST occur in the first paragraph.

PURPOSE STATEMENT: Connect the reframe to a concrete payoff: "The goal of this
post is to give a few examples with detailed proofs. I find this interpretation
useful because it helps explain why [concrete consequence]."

SUBTITLE: "I show how [familiar concept] can be viewed as [new frame]." One
sentence with a period.

BODY ORGANIZATION: Structure as PARALLEL SECTIONS that escalate in complexity,
each applying the same reframing lens to progressively harder cases:
- Section 1: Simplest case (full proof)
- Section 2: Intermediate case (parallel proof, more complex)
- Section 3: Different setting or loss function (parallel proof again)
Each section should mirror the same proof pattern so the reader sees the theme.

PROOF STYLE: Use the "add-and-subtract" or "clever algebra" pattern. Annotate
non-obvious steps with symbols: "Step ⋆ holds because...", "Step † holds
because..." Provide a parenthetical reminder for each symbol-marked step.

TONE: Most personally invested of all Gundersen styles. Use "I" for opinions
and aesthetic reactions: "In my mind, these are beautiful and deep results."
Use "I find this interpretation useful because..." and "I first came across
this fact in..." This personal warmth distinguishes this style from the
Cataloging Explainer.

EQUATION HANDLING: Equations serve ARGUMENTATION, not cataloging. Each equation
should advance a proof. Number key equations with \tag{N}. Provide "In words,
..." translations for key results but not every intermediate step.

CONCLUSION: Personal reflection on the significance of the results. End with
a BONUS CONNECTION — a surprising consequence that rewards readers who followed
the full argument. Format: "Finally, I first came across [related fact] in
[context]..." followed by a short elegant derivation.

NO APPENDIX. NO CODE. All proofs are inline. The proofs ARE the content.

Apply all baseline Gundersen conventions: anti-condescension, step-by-step
derivations, explicit signposting.
```

### Structural Template

```
1. Title + Subtitle ("I show how [familiar concept] can be viewed as [new frame].")
2. Opening paragraph
   a. Familiar interpretation (2-3 sentences, "When most people...")
   b. Pivot ("However, another interpretation...")
   c. Purpose statement + payoff preview
3. Section 1: Simplest case
   a. Claim statement (equation)
   b. Proof with step annotations (⋆, †)
   c. Plain-language consequence
4. Section 2: Intermediate case
   a. Parallel claim (more complex)
   b. Parallel proof (same technique, harder setting)
   c. Interpretation of the result
5. Section 3: Different loss/setting
   a. New claim under the same theme
   b. Proof
   c. Connection back to the unifying insight
6. Conclusion
   a. Personal reflection ("In my mind, these are...")
   b. Practical implications (1-2 sentences per section result)
   c. Bonus connection (elegant consequence, brief proof)
```

### Few-Shot Excerpt

> When most people first encounter the variance of a random variable, they learn it as a measure of spread: $\text{Var}(X) = \mathbb{E}[(X - \mu)^2]$. The instructor might motivate variance as the "average squared distance from the mean" and then move on to standard deviations.
>
> However, another interpretation of the variance is that it is the *minimum achievable expected squared deviation* from any constant. The goal of this post is to prove this and show that it generalizes: the mean minimizes the squared loss, the conditional expectation minimizes the prediction squared loss, and the variance is the irreducible error floor. I find this interpretation useful because it explains why squared-error losses appear so naturally in statistics.
>
> We claim that $\text{Var}(X) = \min_{a \in \mathbb{R}} \mathbb{E}[(X - a)^2]$. We can prove this with a little clever algebra. Write $(X - a)$ as $(X - \mu) + (\mu - a)$ and expand the square. The cross term vanishes because $\mathbb{E}[X - \mu] = 0$, leaving
>
> $$\mathbb{E}[(X-a)^2] = \text{Var}(X) + (\mu - a)^2. \tag{1}$$
>
> The second term is non-negative and equals zero only when $a = \mu$. In my mind, this is a striking result: the mean is not merely an "average" — it is the unique constant that minimizes the expected squared deviation.

### Anti-Patterns

- **Opening with the new interpretation directly** — you MUST establish the familiar view first. The power of this style comes from the contrast between what the reader already knows and the new lens.
- **Omitting personal reflection in the conclusion** — this style requires "In my mind..." or "I find this..." type closure. Without it, the post reads like a Cataloging Explainer.
- **Using an appendix** — all proofs must be inline. If a proof is too long for the main body, this is the wrong style; use the Comprehensive Treatment instead.
- **Breaking the parallel structure** — each main section should mirror the same proof pattern (set up claim → prove → interpret). If the sections don't rhyme, the unifying insight is lost.
- **Forgetting step annotations** — non-obvious algebraic steps must be marked with ⋆, †, etc. and explained immediately after.

---

## The First-Principles Narrative

### When to Use

Use when the post is driven by a specific **"why" question** about an algorithm, technique, or design choice that standard explanations leave unanswered. The reader has surface-level familiarity but lacks deep intuition for *why* something works the way it does. Typical topics: why backpropagation goes backward, why Adam works better than SGD, why certain architectures have specific structures, debugging/design choice stories.

### System Instructions

```
You are writing a technical blog post in the First-Principles Narrative style.
Follow these instructions precisely:

OPENING: Begin by stating the standard explanation of the topic in 1-2
sentences. Then introduce a PERSONAL QUESTION the author couldn't find answered:
"when I first learned about [X], I had a question that I could not find
answered directly: *why [specific question]?*" Use italics for the question.
State the payoff: "I found that answering this question strengthened my
understanding of [X]."

SUBTITLE: This style BREAKS the standard "I [verb]..." pattern. Use a
descriptive subtitle: "[Topic] is [standard description], but it may not be
obvious why [specific aspect]. The answer allows us to [payoff]."

BODY ORGANIZATION: Structure as a REASONING JOURNEY:
1. Setup (notation and framework needed to reason about the question)
2. The naive attempt (try the obvious approach)
3. Show why the naive attempt fails or is suboptimal
4. The key insight (what the failure reveals)
5. The correct approach (derived from the insight)
The FAILED NAIVE ATTEMPT is the core pedagogical move. Do NOT skip it.

DIAGRAMS: Use diagrams as ARGUMENTATIVE TOOLS, not decoration. Each diagram
should advance the reasoning. Reference them explicitly in the text: "I think
the above diagram is the lynchpin in understanding why..."

EMPHASIS: Use bold for the single most important insight: "**most of computing
∂f/∂θ₁ can be done locally at every node because of the chain rule.**"
Use italics for key question words: "*why does it have to go backwards?*"
Use color differentiation in equations where terms are being compared.

TONE: Most conversational of all Gundersen styles. Use "I" for personal
experience: "I found that...", "I hope this clarifies...", "I think the above
diagram is..." Address the reader directly: "Let's see what happens."
Acknowledge what the reader might already know: "I will assume the reader
broadly understands..."

EQUATION HANDLING: Moderate density — lower than Cataloging Explainer or
Comprehensive Treatment. Each equation should answer a question the text has
just posed. Equations serve the NARRATIVE, not the other way around.

CONCLUSION: Circle back to the standard explanation, now illuminated: "Once
you understand [key insight], I think the standard explanation of [X] makes
much more sense." Optionally reframe the original question as a solved problem.

NO APPENDIX. NO CODE. Argument is spatial/diagrammatic + algebraic.

Apply all baseline Gundersen conventions: anti-condescension, explicit
signposting.
```

### Structural Template

```
1. Title (often a question or surprising claim: "Why X Does Y")
2. Subtitle (descriptive, NOT "I [verb]...")
   "[Standard view], but it may not be obvious why [aspect].
    The answer allows us to [payoff]."
3. Opening paragraph
   a. Standard explanation (1-2 sentences)
   b. Personal question in italics
   c. Payoff statement
   d. Reader assumptions
4. Setup
   - Notation and framework
   - Key observations needed for reasoning
   - "The most important observation is..." (bold)
5. The naive attempt
   - "Let's try the obvious approach..."
   - Work through it far enough to see the problem
   - Diagram showing the computational structure
6. Why it fails
   - Identify the specific inefficiency or impossibility
   - "We can see that such an algorithm blows up because..."
   - Diagram highlighting the repeated/wasted computation
7. The key insight
   - "This is the key insight: if we already had access to [X]..."
   - How the failure points to the correct solution
8. The correct approach
   - Derive it from the insight
   - Show it achieves linear time / correctness / etc.
9. Conclusion
   - "Once you understand [X], the standard explanation makes much more sense."
   - Connect to practical implications
```

### Few-Shot Excerpt

> The usual explanation of the kernel trick in support vector machines is that it allows us to compute inner products in a high-dimensional feature space without explicitly mapping our data there. But when I first learned about the kernel trick, I had a question that I could not find answered directly: *why must the mapping go through an inner product at all?* Why can't we just compute distances in the feature space directly?
>
> I found that answering this question made the entire theory of kernels click into place.
>
> **Setup.** Recall that an SVM finds the maximum-margin hyperplane separating two classes. The key observation is that the optimization problem depends on the data *only through pairwise inner products* $\mathbf{x}_i^\top \mathbf{x}_j$.
>
> Let's try the most obvious approach to working in a higher-dimensional space: explicitly compute $\phi(\mathbf{x})$ for every data point and then run the SVM in the new space. For a polynomial kernel of degree $d$ in $P$ dimensions, the feature map $\phi$ has $\binom{P+d}{d}$ components. With $P = 1000$ and $d = 5$, that's over 8 billion dimensions. The naive approach is computationally intractable.
>
> **This is the key insight:** since the SVM only needs inner products, we never need the full feature vectors — we only need the scalar $k(\mathbf{x}_i, \mathbf{x}_j) = \phi(\mathbf{x}_i)^\top \phi(\mathbf{x}_j)$.

### Anti-Patterns

- **Opening with a definition** — this style MUST open with a question or puzzle. If you want to open with a definition, use the Cataloging Explainer instead.
- **Skipping the failed naive attempt** — the failure IS the core pedagogical move. Without it, the post is just "here's how X works" (a Cataloging Explainer) rather than "here's *why* X works this way."
- **Using diagrams as decoration** — every diagram must advance the reasoning. If you can remove a diagram without losing argumentative force, it shouldn't be there.
- **Textbook tone** — do NOT write "It can be shown that..." or "One observes that..." Use "Let's see what happens" and "I think the above diagram is the lynchpin."
- **Revealing the answer before showing why the naive approach fails** — the temporal ordering (attempt → fail → discover) is essential to this style's pedagogical power.

---

## The Comprehensive Treatment

### When to Use

Use when the topic is a **foundational technique or model** that warrants exhaustive coverage from multiple mathematical perspectives: algebraic, geometric, probabilistic, computational. The reader wants a single definitive reference they can return to. Typical topics: core statistical models (OLS, logistic regression, PCA), fundamental algorithms (EM, Newton's method), canonical decompositions (SVD, eigendecomposition, Cholesky).

### System Instructions

```
You are writing a technical blog post in the Comprehensive Treatment style.
Follow these instructions precisely:

OPENING: Begin by setting up the problem space systematically with full
notation: "Suppose we have [problem setup] with [variables]." Define all
dimensions, variable types, and matrix shapes explicitly.

SUBTITLE: Uses "discuss" to signal breadth: "I discuss [topic] when [specific
condition]. I discuss various properties and interpretations of this classic
model." Two sentences are acceptable.

NAMED OBJECTS: Introduce named matrices, operators, and objects with formal
definitions that will be REUSED throughout: "Let's define a matrix H as...
We'll call this the *hat matrix*, since it 'puts a hat' on y." These named
objects are pedagogical anchors. Every major section should reference them.

BODY ORGANIZATION: Structure as MULTIPLE PERSPECTIVES on the same object:
- Perspective 1: Algebraic (derive the solution, define key objects)
- Perspective 2: Geometric (projection, subspace interpretation)
- Perspective 3: Special cases / Extensions (partitioned version, with intercept)
- Perspective 4: Probabilistic (likelihood, MLE, connection to algebraic solution)
Each perspective must feel like a different "view" of the same mountain.

FIGURES: Multi-panel figures with detailed captions (2+ sentences per caption).
Each panel illustrates a different aspect. Format: "(Left) ... (Right) ..."

DERIVATION STYLE: In the main body, show just enough algebra to convey the
structure. Justify every step with explicit numbering: "In step 4, we use the
fact that the trace of a scalar is the scalar." Defer complete derivations to
a numbered Appendix (A1, A2, ...), each with its own descriptive title.

CROSS-REFERENCES: Extensively reference your own previous posts for
prerequisites: "See my previous post on [topic] if needed" and "see my
previous post on interpreting these kinds of optimization problems."

TONE: Most textbook-like of all styles. "I" is used sparingly and
directionally ("I'll first setup...", "I'll discuss..."). "We" dominates for
derivation work ("we can write", "we can simplify"). Name established results:
"Frisch–Waugh–Lovell (FWL) theorem."

CONCLUSION: A single paragraph that ties all perspectives together:
"[Topic] can be understood algebraically as..., geometrically as..., and
probabilistically as..." Each perspective gets one sentence.

APPENDIX: Substantial. 3-5 sections (A1, A2, ...) with complete derivations.
Each appendix section has a descriptive title ("### A1. Normal equation",
"### A2. Hat matrix is an orthogonal projection").

NO CODE. Figures are generated externally and embedded.

Apply all baseline Gundersen conventions: anti-condescension, equation
conventions, signposting.
```

### Structural Template

```
1. Title + Subtitle
   "I discuss [topic] when [condition]. I discuss various properties
    and interpretations of this classic model."
2. Opening section
   a. Problem setup with full notation
   b. Matrix/vector definitions
   c. Model equation with \tag{N}
3. Core algebraic treatment
   a. Objective function
   b. Solution derivation (reference appendix for details)
   c. Named object definitions (hat matrix, residual maker, etc.)
   d. Key properties of named objects
4. Geometric interpretation
   a. Projection interpretation
   b. "There is a nice geometric interpretation..."
   c. Connection between named objects and geometry
5. Special cases / Extensions
   a. Partitioned version or with additional parameters
   b. Derivation using named objects from Section 3
   c. Interpretation of the special case
6. Probabilistic perspective
   a. Likelihood function
   b. MLE derivation
   c. "This is the same optimization problem as Equation [N]"
   d. Conditional expectation and variance
7. Conclusion (one paragraph: algebraic + geometric + probabilistic synthesis)
8. Acknowledgements (optional)
9. Appendix
   a. A1: [Derivation title]
   b. A2: [Proof title]
   c. A3: [Proof title]
   d. A4-A5: [Supporting derivations]
10. References
```

### Few-Shot Excerpt

> Suppose we have $N$ data points $\mathbf{x}_n \in \mathbb{R}^P$ stacked into an $N \times P$ data matrix $\mathbf{X}$, where we assume the data has been centered so that $\frac{1}{N}\mathbf{1}^\top \mathbf{X} = \mathbf{0}$. In principal component analysis (PCA), we seek a $P \times K$ matrix of *loading vectors* $\mathbf{W}$ such that the projected data $\mathbf{Z} = \mathbf{X}\mathbf{W}$ retains as much variance as possible. I discuss PCA as a variance-maximization problem, derive its solution via the eigendecomposition of the sample covariance matrix, and connect it to the singular value decomposition and the probabilistic PCA model.
>
> **PCA projection matrix.** Let's define the projection matrix $\mathbf{P}_K \triangleq \mathbf{W}\mathbf{W}^\top$. We'll call this the *PCA projector*, since it projects any vector $\mathbf{x}$ onto the $K$-dimensional subspace spanned by the columns of $\mathbf{W}$. Note that $\mathbf{P}_K$ is an orthogonal projection. See [A1] for a proof. Furthermore, let's call $\mathbf{R}_K \triangleq \mathbf{I} - \mathbf{P}_K$ the *reconstruction error matrix*, since $\mathbf{R}_K \mathbf{x}_n$ gives the component of $\mathbf{x}_n$ that is lost in the projection.
>
> **Geometric view of PCA.** There is a nice geometric interpretation to all this. When we project $\mathbf{x}_n$ onto $\mathbf{P}_K$, we are finding the closest point in the $K$-dimensional subspace in Euclidean distance. The residual $\mathbf{R}_K \mathbf{x}_n$ is orthogonal to this subspace (Figure 1, left). PCA chooses the subspace that minimizes the sum of squared residuals across all data points (Figure 1, right).

### Anti-Patterns

- **Covering only one perspective** — if you only need one angle (e.g., just the algebraic derivation), use the Cataloging Explainer instead. This style's defining feature is multi-perspective coverage.
- **Skipping the geometric interpretation** — this style demands at least one visual/spatial perspective. If the topic doesn't have a geometric view, consider whether the Comprehensive Treatment is the right choice.
- **Putting full derivations in the main text** — use the appendix for anything over 5 lines of sequential algebra. The main text should show structure, not every step.
- **Using a casual/narrative tone** — do NOT write "I was curious about..." or "when I first learned..." That's the First-Principles Narrative. This style is systematic and authoritative.
- **Omitting named definitions for key matrices/objects** — naming things (hat matrix, residual maker, PCA projector) is a core pedagogical tool in this style. Every major object should get a name and a brief "we'll call this the *X*, since it [memorable description]."
