# Dynamic Programming Core

Comprehensive DP reference covering the full framework, problem families, and deep-dive derivations. For quick-reference code templates, see `advanced-patterns.md`. For the high-level DP framework (state/choices/dp-definition), see `algorithm-frameworks.md`.

---

## Quick Reference Table

| DP Family | Recognition Signals | Key Problems | Section |
|-----------|-------------------|--------------|---------|
| Framework & Principles | "Overlapping subproblems", "optimal substructure", any DP problem | Fibonacci, Coin Change (322) | 1 |
| Subsequence & String DP | "Longest increasing/common subsequence", "edit distance", "word break", "regex matching" | LIS (300), LCS (1143), Edit Distance (72), Max Subarray (53), Word Break (139), Regex (10) | 2 |
| Knapsack Problems | "Select items with weight/value constraints", "subset sum", "partition equal subset" | Partition Equal Subset Sum (416), Target Sum (494), Coin Change (322), Ones and Zeroes (474) | 3 |
| Grid & Path DP | "Minimum path sum", "unique paths", "cost to reach destination" | Min Path Sum (64), Unique Paths (62), Freedom Trail (514), Cheapest Flights (787) | 4 |
| Game Theory DP | "Two players, optimal play", "stone game", "predict the winner" | Stone Game (877), Predict Winner (486) | 5 |
| Interval DP | "Burst balloons", "merge stones", "matrix chain multiplication" | Burst Balloons (312), Min Cost Merge Stones (1000) | 6 |
| Egg Drop | "Minimum attempts to find critical floor", "super egg drop" | Super Egg Drop (887) | 7 |
| House Robber & Stock | "No two adjacent", "buy/sell with constraints" | House Robber I/II/III (198/213/337), Stock I-VI (121/122/123/188/309/714) | 8 |
| Shortest Path DP | "All-pairs shortest path", "Floyd-Warshall" | Find City (1334), Network Delay (743) | 9 |

---

## 1. DP Framework Principles

### The Three-Step DP Process

Every DP problem is solved by answering three questions in order:

1. **Clarify the state** -- what variables change between subproblems? (index, remaining capacity, last choice, etc.)
2. **Clarify the choices** -- at each state, what decisions can you make?
3. **Define `dp` meaning** -- `dp[state]` = the answer to the subproblem defined by that state

Then find the base case and write the state transition equation.

*Socratic prompt: "What changes between subproblems? That's your state. What decisions do you make at each state? That's your choice list."*

### Overlapping Subproblems & Memoization

The hallmark of DP: the brute-force recursion recomputes the same subproblems exponentially many times.

**Fibonacci example:** Naive recursion computes `fib(18)` multiple times within `fib(20)`. The recursion tree has O(2^n) nodes.

**Fix:** Add a memo (hash map or array) to cache results. Each subproblem is solved exactly once.

```python
# Top-down with memoization
from functools import lru_cache

@lru_cache(maxsize=None)
def fib(n):
    if n <= 1:
        return n
    return fib(n - 1) + fib(n - 2)
```

**Time complexity drops from O(2^n) to O(n)** -- each of the n subproblems is solved once in O(1).

### Top-Down vs Bottom-Up

Two equivalent ways to implement DP:

| Approach | Direction | Implementation | When to Use |
|----------|-----------|---------------|-------------|
| **Top-down** (memoized recursion) | Start from target, recurse to base | `@lru_cache` or memo dict | Natural when recursion structure is clear |
| **Bottom-up** (tabulation) | Start from base cases, build up | Fill `dp` array iteratively | When you need space optimization or iterative control |

```python
# Bottom-up tabulation for Coin Change (LC 322)
def coin_change(coins, amount):
    dp = [float('inf')] * (amount + 1)
    dp[0] = 0  # Base case: 0 coins needed for amount 0
    for i in range(1, amount + 1):
        for coin in coins:
            if i - coin >= 0 and dp[i - coin] != float('inf'):
                dp[i] = min(dp[i], dp[i - coin] + 1)
    return dp[amount] if dp[amount] != float('inf') else -1
```

**Mathematical induction analogy:** Top-down DP IS mathematical induction. You assume smaller subproblems are correct (inductive hypothesis) and show how to combine them (inductive step). The base case is the base case.

*Socratic prompt: "Can you write the top-down version first? Once that works, can you convert it to bottom-up by reversing the direction?"*

### Space Optimization (Rolling Array)

When the state transition only depends on the previous row/column, you don't need the full DP table.

**Pattern:** If `dp[i]` only depends on `dp[i-1]` (and possibly `dp[i-2]`), replace the array with two variables:

```python
# Fibonacci: O(1) space
def fib(n):
    if n <= 1:
        return n
    prev2, prev1 = 0, 1
    for _ in range(2, n + 1):
        curr = prev1 + prev2
        prev2, prev1 = prev1, curr
    return prev1
```

**For 2D DP:** If `dp[i][j]` only depends on `dp[i-1][...]`, use a single 1D array and update it carefully (usually right-to-left for 0-1 knapsack, left-to-right for complete knapsack).

> **Tip:** Sometimes you do not need to store the entire DP table. If `dp[i]` only depends on `dp[i-1]` and `dp[i-2]`, two variables suffice. If `dp[i][j]` only depends on the previous row, a single 1D array suffices. Always check which previous states your transition actually needs before allocating the full table.

*Socratic prompt: "Look at your state transition. Which previous states does dp[i] actually need? Can you keep only those?"*

### Common DP Pitfalls

| Pitfall | Symptom | Fix |
|---------|---------|-----|
| Wrong base case | Off-by-one errors, wrong answer for small inputs | Trace through the smallest cases by hand |
| Wrong state definition | DP doesn't capture enough info to make transitions | Add dimensions (e.g., add a "holding stock" boolean) |
| Missing states | Some subproblems not covered | Ensure every reachable state has a transition |
| Integer overflow in memo | `dp[i] + dp[j]` overflows | Use `float('inf')` or check before adding |
| Forgetting to memoize | Top-down runs in exponential time | Always add `@lru_cache` or memo check |

---

## 2. Subsequence & String DP

### Two Fundamental Templates

**Template 1: `dp[i]` (single sequence)** -- answer involves elements ending at or up to index `i`.

**Template 2: `dp[i][j]` (two sequences or two pointers)** -- compares prefixes `s[:i]` and `t[:j]`, or a single sequence with two endpoints.

| Signal | Template | Example |
|--------|----------|---------|
| One array, "longest subsequence ending at i" | `dp[i]` | LIS (300) |
| Two strings, "similarity/distance/matching" | `dp[i][j]` | LCS (1143), Edit Distance (72) |
| One string, palindrome-related | `dp[i][j]` | Longest Palindromic Subsequence (516) |
| One string, "can it be segmented" | `dp[i]` (boolean) | Word Break (139) |

### Longest Increasing Subsequence (LIS) -- LC 300

**State:** `dp[i]` = length of LIS ending at `nums[i]`.

**Transition:** For each `j < i` where `nums[j] < nums[i]`: `dp[i] = max(dp[i], dp[j] + 1)`.

**Base case:** `dp[i] = 1` (every element is an LIS of length 1).

```python
def length_of_lis(nums):
    n = len(nums)
    dp = [1] * n
    for i in range(n):
        for j in range(i):
            if nums[j] < nums[i]:
                dp[i] = max(dp[i], dp[j] + 1)
    return max(dp)  # O(n^2)
```

**O(n log n) optimization -- Patience Sorting:**

Maintain a `tails` array where `tails[k]` = smallest tail element of all increasing subsequences of length `k+1`. Binary search for insertion point.

```python
import bisect

def length_of_lis_fast(nums):
    tails = []
    for num in nums:
        pos = bisect.bisect_left(tails, num)
        if pos == len(tails):
            tails.append(num)
        else:
            tails[pos] = num  # Replace with smaller tail
    return len(tails)
```

**Intuition:** Think of dealing cards into piles. Each pile's top is the `tails` array. You always place a card on the leftmost pile whose top is >= the card (binary search). If no pile works, start a new pile. The number of piles = LIS length.

*Socratic prompt: "Why does replacing tails[pos] with a smaller value not break the LIS? What invariant does the tails array maintain?"*

**Related:** Russian Doll Envelopes (354) -- sort by width ascending, height descending for same width, then find LIS on heights.

### Longest Common Subsequence (LCS) -- LC 1143

**State:** `dp[i][j]` = length of LCS of `s1[:i]` and `s2[:j]`.

**Transition:**
- If `s1[i-1] == s2[j-1]`: `dp[i][j] = dp[i-1][j-1] + 1` (both characters match, extend LCS)
- Else: `dp[i][j] = max(dp[i-1][j], dp[i][j-1])` (skip one character from either string)

```python
def longest_common_subsequence(s1, s2):
    m, n = len(s1), len(s2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if s1[i - 1] == s2[j - 1]:
                dp[i][j] = dp[i - 1][j - 1] + 1
            else:
                dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
    return dp[m][n]
```

*Socratic prompt: "When s1[i-1] != s2[j-1], why do we take the max of skipping from either string? What would happen if we skipped from both?"*

**Variations:**
- Delete Operation for Two Strings (583): min deletions = `m + n - 2 * LCS`
- Min ASCII Delete Sum (712): same structure but weighted by character ASCII values

### Edit Distance -- LC 72

**State:** `dp[i][j]` = minimum operations to convert `s[:i]` to `t[:j]`.

**Transition:** If `s[i-1] == t[j-1]`, no operation needed: `dp[i][j] = dp[i-1][j-1]`. Otherwise, take the min of three operations:
- **Insert:** `dp[i][j-1] + 1`
- **Delete:** `dp[i-1][j] + 1`
- **Replace:** `dp[i-1][j-1] + 1`

```python
def min_distance(word1, word2):
    m, n = len(word1), len(word2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    for i in range(m + 1):
        dp[i][0] = i  # Delete all characters
    for j in range(n + 1):
        dp[0][j] = j  # Insert all characters
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if word1[i - 1] == word2[j - 1]:
                dp[i][j] = dp[i - 1][j - 1]
            else:
                dp[i][j] = 1 + min(
                    dp[i - 1][j],      # Delete from word1
                    dp[i][j - 1],      # Insert into word1
                    dp[i - 1][j - 1]   # Replace in word1
                )
    return dp[m][n]
```

*Socratic prompt: "Can you trace through edit_distance('horse', 'ros') and fill in the DP table by hand? What path through the table gives the actual edit operations?"*

### Maximum Subarray -- LC 53

**State:** `dp[i]` = max sum of subarray ending at index `i`.

**Transition:** `dp[i] = max(nums[i], dp[i-1] + nums[i])` -- either start a new subarray at `i`, or extend the previous one.

```python
def max_subarray(nums):
    # Space-optimized: only need previous value
    max_sum = curr_sum = nums[0]
    for i in range(1, len(nums)):
        curr_sum = max(nums[i], curr_sum + nums[i])
        max_sum = max(max_sum, curr_sum)
    return max_sum
```

**Key insight:** If `dp[i-1]` is negative, it's better to start fresh at `nums[i]` than to extend a losing streak.

*Socratic prompt: "Why is this DP and not greedy? What's the 'choice' at each index?"*

### Word Break -- LC 139

**State:** `dp[i]` = True if `s[:i]` can be segmented into dictionary words.

**Transition:** `dp[i] = True` if there exists `j < i` where `dp[j]` is True and `s[j:i]` is in the dictionary.

```python
def word_break(s, word_dict):
    word_set = set(word_dict)
    n = len(s)
    dp = [False] * (n + 1)
    dp[0] = True  # Empty string is always valid
    for i in range(1, n + 1):
        for j in range(i):
            if dp[j] and s[j:i] in word_set:
                dp[i] = True
                break
    return dp[n]
```

*Socratic prompt: "This looks like it could be solved with backtracking too. Why is DP better here? What would the recursion tree look like?"*

### Regular Expression Matching -- LC 10

**State:** `dp[i][j]` = True if `s[:i]` matches pattern `p[:j]`.

**Transition:** Handle three cases for `p[j-1]`:
- **Normal character or `.`:** Match if `s[i-1]` matches `p[j-1]` and `dp[i-1][j-1]` is True
- **`*` (zero occurrences):** `dp[i][j-2]` -- skip the `char*` pattern entirely
- **`*` (one+ occurrences):** `dp[i-1][j]` if `s[i-1]` matches `p[j-2]` -- consume one character, keep the `*` available

```python
def is_match(s, p):
    m, n = len(s), len(p)
    dp = [[False] * (n + 1) for _ in range(m + 1)]
    dp[0][0] = True
    # Handle patterns like a*, a*b*, etc. matching empty string
    for j in range(2, n + 1):
        if p[j - 1] == '*':
            dp[0][j] = dp[0][j - 2]
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if p[j - 1] == '*':
                # Zero occurrences of p[j-2]
                dp[i][j] = dp[i][j - 2]
                # One or more occurrences
                if p[j - 2] == '.' or p[j - 2] == s[i - 1]:
                    dp[i][j] = dp[i][j] or dp[i - 1][j]
            elif p[j - 1] == '.' or p[j - 1] == s[i - 1]:
                dp[i][j] = dp[i - 1][j - 1]
    return dp[m][n]
```

### Subsequence DP: General Patterns

**Longest Palindromic Subsequence (LC 516):** `dp[i][j]` = LPS of `s[i..j]`. If `s[i] == s[j]`, extend by 2. Otherwise, `max(dp[i+1][j], dp[i][j-1])`. Note: fill diagonally or bottom-up since `dp[i]` depends on `dp[i+1]`.

**Minimum Insertions for Palindrome (LC 1312):** `len(s) - LPS(s)` = minimum insertions needed.

**Two Subsequence Templates Summary:**

| Template | When | Direction | Base |
|----------|------|-----------|------|
| `dp[i]` | Single sequence, ending at i | Left to right | `dp[i] = 1` or `dp[0] = base` |
| `dp[i][j]` | Two sequences or range `[i..j]` | Row by row or diagonal | `dp[i][i] = base` or `dp[0][j]`/`dp[i][0]` |

---

## 3. Knapsack Problems

### The Knapsack Family

All knapsack problems share the same structure: given items with weights and values, select items to maximize value within a weight capacity.

| Variant | Item Usage | Key Difference | Iteration Order |
|---------|-----------|----------------|-----------------|
| **0-1 Knapsack** | Each item used at most once | Standard DP with 2D table | Inner loop: right-to-left (1D optimization) |
| **Complete Knapsack** | Each item used unlimited times | Same structure, different loop direction | Inner loop: left-to-right (1D optimization) |
| **Bounded Knapsack** | Each item has a count limit | Binary representation trick | Convert to 0-1 knapsack |

### 0-1 Knapsack

**State:** `dp[i][w]` = max value using items `0..i-1` with capacity `w`.

**Transition:** For each item `i` with weight `wt[i]` and value `val[i]`:
- Don't take item `i`: `dp[i][w] = dp[i-1][w]`
- Take item `i` (if `w >= wt[i]`): `dp[i][w] = max(dp[i-1][w], dp[i-1][w - wt[i]] + val[i])`

```python
def knapsack_01(weights, values, capacity):
    n = len(weights)
    dp = [[0] * (capacity + 1) for _ in range(n + 1)]
    for i in range(1, n + 1):
        for w in range(capacity + 1):
            dp[i][w] = dp[i - 1][w]  # Don't take item i
            if w >= weights[i - 1]:
                dp[i][w] = max(dp[i][w],
                    dp[i - 1][w - weights[i - 1]] + values[i - 1])
    return dp[n][capacity]
```

**Space-optimized (1D array):** Iterate capacity **right-to-left** to avoid using item `i` twice:

```python
def knapsack_01_optimized(weights, values, capacity):
    dp = [0] * (capacity + 1)
    for i in range(len(weights)):
        for w in range(capacity, weights[i] - 1, -1):  # Right to left!
            dp[w] = max(dp[w], dp[w - weights[i]] + values[i])
    return dp[capacity]
```

*Socratic prompt: "Why must we iterate right-to-left in the 1D optimization? What goes wrong if we go left-to-right?"*

### Complete Knapsack

Same as 0-1, but each item can be used unlimited times. The only change: iterate capacity **left-to-right**:

```python
def knapsack_complete(weights, values, capacity):
    dp = [0] * (capacity + 1)
    for i in range(len(weights)):
        for w in range(weights[i], capacity + 1):  # Left to right!
            dp[w] = max(dp[w], dp[w - weights[i]] + values[i])
    return dp[capacity]
```

**Why left-to-right?** When computing `dp[w]`, we want `dp[w - weights[i]]` to already reflect taking item `i` (allowing reuse). Left-to-right ensures this.

**Coin Change (LC 322)** is a complete knapsack problem: coins are items with unlimited supply, "weight" is coin value, minimize number of coins to reach amount.

### Partition Equal Subset Sum -- LC 416

**Reframe as 0-1 knapsack:** Can we select a subset summing to `total_sum / 2`?

```python
def can_partition(nums):
    total = sum(nums)
    if total % 2:
        return False
    target = total // 2
    dp = [False] * (target + 1)
    dp[0] = True
    for num in nums:
        for w in range(target, num - 1, -1):  # 0-1: right-to-left
            dp[w] = dp[w] or dp[w - num]
    return dp[target]
```

### Target Sum -- LC 494

**Transform to knapsack:** If we split nums into positive set P and negative set N, then `sum(P) - sum(N) = target` and `sum(P) + sum(N) = total`. So `sum(P) = (target + total) / 2`. This becomes a 0-1 knapsack counting problem.

```python
def find_target_sum_ways(nums, target):
    total = sum(nums)
    if (target + total) % 2 or abs(target) > total:
        return 0
    bag = (target + total) // 2
    dp = [0] * (bag + 1)
    dp[0] = 1  # One way to make sum 0: take nothing
    for num in nums:
        for w in range(bag, num - 1, -1):
            dp[w] += dp[w - num]
    return dp[bag]
```

*Socratic prompt: "The brute-force is 2^n (try +/- for each element). How does the knapsack transformation reduce this to O(n * sum)?"*

### Knapsack Problem Recognition

| Problem | Knapsack Type | Items | Weight | Value |
|---------|--------------|-------|--------|-------|
| Coin Change (322) | Complete | Coins | Coin value | 1 (minimize count) |
| Coin Change II (518) | Complete | Coins | Coin value | Count combinations |
| Partition Equal Subset (416) | 0-1 | Numbers | Number value | Boolean reachability |
| Target Sum (494) | 0-1 | Numbers | Number value | Count ways |
| Ones and Zeroes (474) | 0-1 (2D) | Strings | (zeros, ones) | Max count |
| Last Stone Weight II (1049) | 0-1 | Stones | Stone weight | Min remaining |

---

## 4. Grid & Path DP

### Minimum Path Sum -- LC 64

**State:** `dp[i][j]` = minimum path sum from top-left to cell `(i, j)`.

**Transition:** `dp[i][j] = grid[i][j] + min(dp[i-1][j], dp[i][j-1])` (can only move right or down).

```python
def min_path_sum(grid):
    m, n = len(grid), len(grid[0])
    dp = [[0] * n for _ in range(m)]
    dp[0][0] = grid[0][0]
    for i in range(1, m):
        dp[i][0] = dp[i - 1][0] + grid[i][0]
    for j in range(1, n):
        dp[0][j] = dp[0][j - 1] + grid[0][j]
    for i in range(1, m):
        for j in range(1, n):
            dp[i][j] = grid[i][j] + min(dp[i - 1][j], dp[i][j - 1])
    return dp[m - 1][n - 1]
```

**Space optimization:** Use a 1D array of size `n`, updating left-to-right row by row.

*Socratic prompt: "Why can we only move right or down? What would change if we could move in all 4 directions?"*

### Dungeon Game -- LC 174

**Key twist:** Must solve **backwards** (from bottom-right to top-left) because the minimum HP needed at each cell depends on future cells, not past ones.

**State:** `dp[i][j]` = minimum HP needed to enter cell `(i, j)` and survive to the end.

```python
def calculate_minimum_hp(dungeon):
    m, n = len(dungeon), len(dungeon[0])
    dp = [[float('inf')] * (n + 1) for _ in range(m + 1)]
    dp[m][n - 1] = dp[m - 1][n] = 1  # Need at least 1 HP at the end
    for i in range(m - 1, -1, -1):
        for j in range(n - 1, -1, -1):
            dp[i][j] = max(1, min(dp[i + 1][j], dp[i][j + 1]) - dungeon[i][j])
    return dp[0][0]
```

### Freedom Trail -- LC 514

**State:** `dp[i][j]` = minimum steps to spell `key[i:]` when the ring pointer is at position `j`.

**Transition:** For each character `key[i]`, try all positions on the ring that match, compute rotation cost + 1 (button press) + `dp[i+1][new_pos]`.

```python
def find_rotate_steps(ring, key):
    from functools import lru_cache
    n = len(ring)
    # Precompute positions of each character
    char_pos = {}
    for i, c in enumerate(ring):
        char_pos.setdefault(c, []).append(i)

    @lru_cache(maxsize=None)
    def dp(i, j):  # Spell key[i:] with ring pointer at j
        if i == len(key):
            return 0
        res = float('inf')
        for k in char_pos[key[i]]:
            # Min rotation distance (clockwise or counterclockwise)
            diff = abs(j - k)
            cost = min(diff, n - diff) + 1  # +1 for button press
            res = min(res, cost + dp(i + 1, k))
        return res

    return dp(0, 0)
```

### Cheapest Flights Within K Stops -- LC 787

**State:** `dp[k][dst]` = cheapest price to reach `dst` using at most `k` edges.

**Transition:** For each flight `(u, v, price)`: `dp[k][v] = min(dp[k][v], dp[k-1][u] + price)`.

```python
def find_cheapest_price(n, flights, src, dst, k):
    INF = float('inf')
    dp = [[INF] * n for _ in range(k + 2)]
    dp[0][src] = 0
    for i in range(1, k + 2):
        dp[i][src] = 0
        for u, v, price in flights:
            if dp[i - 1][u] != INF:
                dp[i][v] = min(dp[i][v], dp[i - 1][u] + price)
    return dp[k + 1][dst] if dp[k + 1][dst] != INF else -1
```

*Socratic prompt: "This looks like Bellman-Ford with a twist. What does the k-stop limit add to the state space?"*

---

## 5. Game Theory DP

### Stone Game Framework

**Setup:** Two players pick from ends of an array. Both play optimally. Who wins, or by how much?

**State:** `dp[i][j]` = a tuple `(first_score, second_score)` representing the best outcome for the current player when stones `i..j` remain.

**Key insight (minimax):** When it's your turn, you maximize your score. Your opponent then plays optimally on the remaining subproblem.

```python
def stone_game(piles):
    n = len(piles)
    # dp[i][j] = (first_player_score, second_player_score) for piles[i..j]
    dp = [[(0, 0)] * n for _ in range(n)]

    # Base case: one pile left, first player takes it
    for i in range(n):
        dp[i][i] = (piles[i], 0)

    # Fill diagonally (increasing gap size)
    for gap in range(1, n):
        for i in range(n - gap):
            j = i + gap
            # First player picks left: gets piles[i], becomes second player
            pick_left = piles[i] + dp[i + 1][j][1]
            left_other = dp[i + 1][j][0]
            # First player picks right: gets piles[j], becomes second player
            pick_right = piles[j] + dp[i][j - 1][1]
            right_other = dp[i][j - 1][0]

            if pick_left >= pick_right:
                dp[i][j] = (pick_left, left_other)
            else:
                dp[i][j] = (pick_right, right_other)

    first, second = dp[0][n - 1]
    return first > second  # Does first player win?
```

**Simplified version for LC 877 (Stone Game):** First player always wins when n is even (mathematical proof exists), but the DP approach generalizes to all variants.

**LC 486 (Predict the Winner):** Same framework, return `first >= second`.

*Socratic prompt: "After the first player picks, why does the second player's score equal dp[subproblem][0] (the first player position of the subproblem)? Think about role switching."*

---

## 6. Interval DP

### Burst Balloons -- LC 312

**Key reframe:** Instead of thinking about which balloon to burst *first*, think about which balloon to burst *last* in the interval `[i, j]`.

**State:** `dp[i][j]` = max coins from bursting all balloons between indices `i` and `j` (exclusive).

**Transition:** For each `k` in `(i, j)` as the last balloon burst: `dp[i][j] = max(dp[i][k] + dp[k][j] + nums[i] * nums[k] * nums[j])`.

```python
def max_coins(nums):
    # Add boundary balloons with value 1
    nums = [1] + nums + [1]
    n = len(nums)
    dp = [[0] * n for _ in range(n)]

    # Fill by increasing interval length
    for length in range(2, n):  # length = j - i
        for i in range(n - length):
            j = i + length
            for k in range(i + 1, j):  # k is the last balloon burst
                dp[i][j] = max(dp[i][j],
                    dp[i][k] + dp[k][j] + nums[i] * nums[k] * nums[j])

    return dp[0][n - 1]
```

**Why "last burst" works:** If `k` is the last balloon in `[i, j]`, then when we burst `k`, only `nums[i]` and `nums[j]` are adjacent to it (all others in the interval are already gone). This makes subproblems `[i, k]` and `[k, j]` independent.

*Socratic prompt: "Why does thinking about the first balloon to burst make subproblems dependent? What changes when you think about the last?"*

**Related:** Minimum Cost to Merge Stones (1000), Matrix Chain Multiplication.

---

## 7. Egg Drop

### Super Egg Drop -- LC 887

**Problem:** With `k` eggs and `n` floors, what's the minimum number of drops needed to find the critical floor (worst case)?

**State:** `dp[k][n]` = minimum drops needed with `k` eggs and `n` floors.

**Transition:** Drop an egg from floor `x`:
- Egg breaks: search below with `dp[k-1][x-1]`
- Egg survives: search above with `dp[k][n-x]`
- Worst case: `max(dp[k-1][x-1], dp[k][n-x])`
- Best choice: minimize over all floors `x`

**Naive O(kn^2):**

```python
from functools import lru_cache

def super_egg_drop_naive(k, n):
    @lru_cache(maxsize=None)
    def dp(k, n):
        if k == 1:
            return n  # Must try every floor linearly
        if n == 0:
            return 0
        res = float('inf')
        for x in range(1, n + 1):
            worst = max(dp(k - 1, x - 1), dp(k, n - x))
            res = min(res, worst + 1)
        return res
    return dp(k, n)
```

**O(kn log n) optimization with binary search:** For fixed `k` and `n`, as `x` increases, `dp[k-1][x-1]` monotonically increases and `dp[k][n-x]` monotonically decreases. Binary search for the crossover point.

```python
def super_egg_drop(k, n):
    @lru_cache(maxsize=None)
    def dp(k, n):
        if k == 1:
            return n
        if n == 0:
            return 0
        lo, hi = 1, n
        while lo + 1 < hi:
            mid = (lo + hi) // 2
            breaks = dp(k - 1, mid - 1)   # Egg breaks
            survives = dp(k, n - mid)       # Egg survives
            if breaks < survives:
                lo = mid
            elif breaks > survives:
                hi = mid
            else:
                lo = hi = mid
        return 1 + min(
            max(dp(k - 1, lo - 1), dp(k, n - lo)),
            max(dp(k - 1, hi - 1), dp(k, n - hi))
        )
    return dp(k, n)
```

**Alternative O(kn) "reverse thinking":** Instead of "given k eggs and n floors, minimize drops", ask "given k eggs and m drops, maximize floors you can check". `dp[m][k] = dp[m-1][k-1] + dp[m-1][k] + 1`.

*Socratic prompt: "With 1 egg, why must you start from floor 1 and go up? With 2 eggs and 100 floors, what's your first drop and why?"*

---

## 8. House Robber & Stock Series (Deep Dive)

For quick-reference code templates, see `advanced-patterns.md` (State Machine DP, House Robber, Subsequence DP sections). This section provides the full derivations.

### House Robber: Derivation

**Core recurrence:** `dp[i] = max(dp[i-1], dp[i-2] + nums[i])` -- either skip house `i` or rob it.

**Why this works:** If you rob house `i`, you can't rob `i-1`, so the best you can do is `dp[i-2] + nums[i]`. If you skip house `i`, you keep `dp[i-1]`.

**Circular variant (LC 213):** Houses in a circle means house 0 and house n-1 are adjacent. Solution: run linear House Robber twice -- once on `nums[1:]`, once on `nums[:-1]`, take the max. This handles the constraint that you can't rob both first and last.

**Tree variant (LC 337):** Post-order DFS returning `(rob_this, skip_this)` for each node. Decomposition mode -- each subtree returns its own answer.

### Stock Problem: The Universal State Machine

**All 6 stock problems share one framework:**

```
dp[i][k][0/1]
  i = day index
  k = remaining transactions
  0 = not holding stock, 1 = holding stock
```

**Transitions:**
```
dp[i][k][0] = max(dp[i-1][k][0],           # rest
                   dp[i-1][k][1] + price[i]) # sell

dp[i][k][1] = max(dp[i-1][k][1],            # rest
                   dp[i-1][k-1][0] - price[i]) # buy (uses a transaction)
```

**How each variant simplifies:**

| Problem | k | Extra | Key Simplification |
|---------|---|-------|-------------------|
| LC 121 | 1 | -- | Track `min_price`, `max_profit` in one pass |
| LC 122 | infinity | -- | Drop k dimension; sum all positive diffs |
| LC 123 | 2 | -- | Full DP with k=2 (4 state variables) |
| LC 188 | given | -- | General DP |
| LC 309 | infinity | Cooldown 1 day | Buy references `dp[i-2]` instead of `dp[i-1]` |
| LC 714 | infinity | Fee per transaction | Subtract `fee` on sell |

**LC 121 simplified (k=1):**
```python
def max_profit_one(prices):
    min_price = float('inf')
    max_profit = 0
    for price in prices:
        min_price = min(min_price, price)
        max_profit = max(max_profit, price - min_price)
    return max_profit
```

**LC 122 simplified (k=infinity):**
```python
def max_profit_unlimited(prices):
    return sum(max(0, prices[i] - prices[i-1]) for i in range(1, len(prices)))
```

**LC 309 with cooldown:**
```python
def max_profit_cooldown(prices):
    n = len(prices)
    if n < 2:
        return 0
    dp_hold = -prices[0]       # Holding stock
    dp_sold = 0                # Just sold (cooldown next)
    dp_rest = 0                # Not holding, free to buy
    for i in range(1, n):
        new_hold = max(dp_hold, dp_rest - prices[i])
        new_sold = dp_hold + prices[i]
        new_rest = max(dp_rest, dp_sold)
        dp_hold, dp_sold, dp_rest = new_hold, new_sold, new_rest
    return max(dp_sold, dp_rest)
```

*Socratic prompt: "For the cooldown variant, draw the state machine diagram. How many states are there? What are the transitions?"*

---

## 9. Shortest Path DP: Floyd-Warshall

### All-Pairs Shortest Path

**Problem:** Given a weighted graph, find the shortest path between every pair of nodes.

**State:** `dp[i][j]` = shortest path weight from node `i` to node `j`.

**Transition (the k-loop):** For each intermediate node `k`, check if going through `k` improves the path: `dp[i][j] = min(dp[i][j], dp[i][k] + dp[k][j])`.

```python
def floyd_warshall(n, edges):
    INF = float('inf')
    # Initialize distance matrix
    dp = [[INF] * n for _ in range(n)]
    for i in range(n):
        dp[i][i] = 0
    for u, v, w in edges:
        dp[u][v] = w  # For directed graph
        # dp[v][u] = w  # Uncomment for undirected

    # The triple loop: k MUST be the outermost loop
    for k in range(n):
        for i in range(n):
            for j in range(n):
                if dp[i][k] != INF and dp[k][j] != INF:
                    dp[i][j] = min(dp[i][j], dp[i][k] + dp[k][j])

    return dp  # dp[i][j] = shortest path from i to j
```

**Why k must be outermost:** The DP builds up by considering paths that use only nodes `{0, 1, ..., k}` as intermediates. Each iteration of `k` adds one more possible intermediate node. This is the space-optimized version of a 3D DP: `dp[k][i][j]` = shortest path from `i` to `j` using intermediates from `{0..k-1}`.

**Complexity:** O(n^3) time, O(n^2) space. Suitable for `n <= 400` approximately.

**Comparison with other shortest path algorithms:**

| Algorithm | Problem Type | Negative Weights? | Complexity |
|-----------|-------------|-------------------|------------|
| BFS | Single-source, unweighted | N/A | O(V + E) |
| Dijkstra | Single-source, non-negative | No | O((V+E) log V) |
| Bellman-Ford | Single-source, any | Yes | O(VE) |
| Floyd-Warshall | All-pairs | Yes (no neg cycles) | O(V^3) |

*Socratic prompt: "When would you use Floyd-Warshall instead of running Dijkstra from every node? What if the graph has negative edges?"*

**Example problem:** Find the City With the Smallest Number of Neighbors at a Threshold Distance (LC 1334) -- run Floyd, then count reachable cities within threshold for each city.

---

## Practice Questions

### Essential

| Problem | DP Family | Key Concept |
|---------|-----------|-------------|
| Climbing Stairs (70) | Framework | Base case + Fibonacci-style transition |
| Coin Change (322) | Knapsack (Complete) | Minimize coins, complete knapsack pattern |
| Longest Increasing Subsequence (300) | Subsequence | `dp[i]` = LIS ending at i, O(n log n) optimization |
| House Robber (198) | House Robber | No-two-adjacent recurrence |

### Recommended

| Problem | DP Family | Key Concept |
|---------|-----------|-------------|
| Jump Game (55) | Grid/Greedy | Can reach end? Track farthest reachable index |
| Unique Paths (62) | Grid | 2D grid path counting |
| Decode Ways (91) | Subsequence | String segmentation with 1-2 digit chunks |
| House Robber II (213) | House Robber | Circular variant: two linear passes |
| Combination Sum IV (377) | Knapsack (Complete) | Count permutations (order matters) |
| Word Break (139) | Subsequence | Boolean segmentation DP |
| Longest Common Subsequence (1143) | Subsequence | Two-sequence `dp[i][j]` |
| Partition Equal Subset Sum (416) | Knapsack (0-1) | Reframe as subset sum = total/2 |

---

## Attribution

The frameworks and problem derivations in this file are inspired by and adapted from labuladong's algorithmic guides (labuladong.online) and the Tech Interview Handbook (techinterviewhandbook.org) dynamic programming cheatsheet, which provide a comprehensive framework-first approach to algorithm learning. Content has been restructured and annotated for Socratic teaching use with Python code templates, embedded prompts, and cross-references to the leetcode-teacher skill's reference system.
