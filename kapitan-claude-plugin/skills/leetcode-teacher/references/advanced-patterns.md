# Advanced Patterns

Thirteen advanced patterns beyond the core 10 in `problem-patterns.md`. Each includes recognition signals, key insights, and code templates.

---

## Quick Reference Table

| Pattern | Recognition Signals | Key Problems |
|---------|-------------------|--------------|
| N-Sum Generalized | "Find all unique quadruplets/n-tuples that sum to target" | 3Sum (15), 4Sum (18), kSum variants |
| LRU Cache | "Design a cache with O(1) get/put, evict least recently used" | LRU Cache (146) |
| LFU Cache | "Design a cache with O(1) get/put, evict least frequently used" | LFU Cache (460) |
| Random Set O(1) | "Insert, delete, getRandom all in O(1)" | Insert Delete GetRandom O(1) (380) |
| Find Median from Stream | "Median of a stream of numbers", "running median" | Find Median from Data Stream (295) |
| Remove Duplicate Letters | "Smallest result after removing duplicates", "remove to make monotonic" | Remove Duplicate Letters (316) |
| Exam Room | "Maximize distance to closest person", "seat assignment" | Exam Room (855) |
| State Machine DP | "Buy/sell stock with constraints" | Stock I-VI (121/122/123/188/309/714) |
| Subsequence DP | "Longest increasing/common subsequence", "edit distance" | LIS (300), LCS (1143), Edit Distance (72) |
| House Robber | "Max sum with no two adjacent", circular/tree variants | House Robber I/II/III (198/213/337) |
| Interval Scheduling | "Max non-overlapping intervals", "min arrows to burst balloons" | Non-overlapping Intervals (435), Merge Intervals (56) |
| Bipartite Graph | "2-colorable", "possible bipartition", "is graph bipartite" | Is Graph Bipartite (785), Possible Bipartition (886) |
| Dijkstra's Algorithm | "Shortest path in weighted graph", "cheapest flights" | Network Delay Time (743), Cheapest Flights (787) |

---

## N-Sum Generalized

### Key Insight

Reduce N-Sum to (N-1)-Sum recursively until you hit 2Sum as the base case. Sort once, then skip duplicates at every recursion level.

### Template

```python
def n_sum(nums, n, target):
    nums.sort()
    results = []

    def helper(start, n, target, path):
        # Base case: 2Sum with two pointers
        if n == 2:
            lo, hi = start, len(nums) - 1
            while lo < hi:
                s = nums[lo] + nums[hi]
                if s == target:
                    results.append(path + [nums[lo], nums[hi]])
                    lo += 1
                    while lo < hi and nums[lo] == nums[lo - 1]:
                        lo += 1  # Skip duplicates
                elif s < target:
                    lo += 1
                else:
                    hi -= 1
            return

        # Recursive case: fix one element, reduce to (n-1)Sum
        for i in range(start, len(nums) - n + 1):
            if i > start and nums[i] == nums[i - 1]:
                continue  # Skip duplicates
            # Pruning: if smallest possible sum > target, stop
            if nums[i] * n > target:
                break
            # Pruning: if largest possible sum < target, skip
            if nums[i] + nums[-1] * (n - 1) < target:
                continue
            helper(i + 1, n - 1, target - nums[i], path + [nums[i]])

    helper(0, n, target, [])
    return results
```

### Why This Works

Each level fixes one number and reduces the problem. Sorting enables both two-pointer base case and duplicate skipping. The pruning bounds prevent wasted work.

---

## LRU Cache

### Key Insight

Combine a hash map (O(1) key lookup) with a doubly linked list (O(1) insert/remove at both ends). Most recently used items go to the front; evict from the tail.

### Template

```python
class Node:
    def __init__(self, key=0, val=0):
        self.key = key
        self.val = val
        self.prev = None
        self.next = None

class LRUCache:
    def __init__(self, capacity):
        self.cap = capacity
        self.cache = {}           # key -> Node
        self.head = Node()        # Dummy head (most recent)
        self.tail = Node()        # Dummy tail (least recent)
        self.head.next = self.tail
        self.tail.prev = self.head

    def _remove(self, node):
        node.prev.next = node.next
        node.next.prev = node.prev

    def _add_to_front(self, node):
        node.next = self.head.next
        node.prev = self.head
        self.head.next.prev = node
        self.head.next = node

    def get(self, key):
        if key not in self.cache:
            return -1
        node = self.cache[key]
        self._remove(node)
        self._add_to_front(node)  # Mark as recently used
        return node.val

    def put(self, key, value):
        if key in self.cache:
            self._remove(self.cache[key])
        node = Node(key, value)
        self._add_to_front(node)
        self.cache[key] = node
        if len(self.cache) > self.cap:
            lru = self.tail.prev
            self._remove(lru)
            del self.cache[lru.key]  # Need key stored in node for this
```

### Why Dummy Nodes?

Dummy head and tail eliminate all null-pointer checks for edge cases (empty list, single element). Every real node always has a valid `prev` and `next`.

---

## LFU Cache

### Key Insight

Maintain a frequency-to-list mapping. Each frequency has its own doubly linked list (ordered by recency). Track `min_freq` globally. Evict from the `min_freq` list's tail.

### Template

```python
from collections import defaultdict

class LFUCache:
    def __init__(self, capacity):
        self.cap = capacity
        self.min_freq = 0
        self.key_to_val = {}
        self.key_to_freq = {}
        self.freq_to_keys = defaultdict(list)  # freq -> list of keys (LRU order)
        self.key_to_pos = {}  # For O(1) removal, use OrderedDict in practice

    def _increase_freq(self, key):
        freq = self.key_to_freq[key]
        self.key_to_freq[key] = freq + 1
        # Remove from old frequency list
        self.freq_to_keys[freq].remove(key)
        if not self.freq_to_keys[freq]:
            del self.freq_to_keys[freq]
            if self.min_freq == freq:
                self.min_freq += 1
        # Add to new frequency list (most recent = end)
        self.freq_to_keys[freq + 1].append(key)

    def get(self, key):
        if key not in self.key_to_val:
            return -1
        self._increase_freq(key)
        return self.key_to_val[key]

    def put(self, key, value):
        if self.cap == 0:
            return
        if key in self.key_to_val:
            self.key_to_val[key] = value
            self._increase_freq(key)
            return
        if len(self.key_to_val) >= self.cap:
            # Evict from min_freq list (least recent = front)
            evict_key = self.freq_to_keys[self.min_freq].pop(0)
            if not self.freq_to_keys[self.min_freq]:
                del self.freq_to_keys[self.min_freq]
            del self.key_to_val[evict_key]
            del self.key_to_freq[evict_key]
        self.key_to_val[key] = value
        self.key_to_freq[key] = 1
        self.freq_to_keys[1].append(key)
        self.min_freq = 1  # New key always has freq=1
```

**Note:** For true O(1), use `OrderedDict` per frequency instead of plain lists. The template above prioritizes clarity.

### LRU vs LFU Comparison

| Property | LRU | LFU |
|----------|-----|-----|
| Eviction criterion | Least recently used | Least frequently used (ties broken by recency) |
| Data structures | HashMap + 1 DLL | HashMap + freq-to-DLL map + minFreq counter |
| `get` updates | Move to front of list | Increase frequency, move between lists |
| Implementation complexity | Moderate | High |

---

## Random Set O(1)

### Key Insight

To support `insert`, `delete`, and `getRandom` all in O(1), combine a **hash map** (key → index) with a **dynamic array** (values). The trick for O(1) deletion: swap the element to delete with the last element, then pop from the end.

### Template

```python
import random

class RandomizedSet:
    def __init__(self):
        self.val_to_idx = {}    # value -> index in self.vals
        self.vals = []           # values in arbitrary order

    def insert(self, val):
        if val in self.val_to_idx:
            return False
        self.val_to_idx[val] = len(self.vals)
        self.vals.append(val)
        return True

    def remove(self, val):
        if val not in self.val_to_idx:
            return False
        idx = self.val_to_idx[val]
        last = self.vals[-1]
        # Swap target with last element
        self.vals[idx] = last
        self.val_to_idx[last] = idx
        # Remove last element
        self.vals.pop()
        del self.val_to_idx[val]
        return True

    def getRandom(self):
        return random.choice(self.vals)
```

### Why the Swap-to-End Trick?

Arrays support O(1) random access (needed for `getRandom`) but O(N) arbitrary deletion. By swapping the target with the last element, deletion becomes O(1) — we only remove from the end.

*Socratic prompt: "Why can't you just use a hash set for getRandom? What operation does a hash set NOT support in O(1)?"*

**Example problems:** Insert Delete GetRandom O(1) (380), Insert Delete GetRandom O(1) - Duplicates (381)

---

## Find Median from Data Stream

### Key Insight

Maintain two heaps that split the data into a smaller half and a larger half:
- **Max-heap (left):** stores the smaller half (top = largest of small half)
- **Min-heap (right):** stores the larger half (top = smallest of large half)

The median is either the top of the max-heap (odd total) or the average of both tops (even total).

### Template

```python
import heapq

class MedianFinder:
    def __init__(self):
        self.small = []    # Max-heap (negate values for Python's min-heap)
        self.large = []    # Min-heap

    def addNum(self, num):
        # Push to max-heap first
        heapq.heappush(self.small, -num)
        # Balance: largest of small half should be <= smallest of large half
        heapq.heappush(self.large, -heapq.heappop(self.small))
        # Maintain size: small >= large (small can have at most 1 more)
        if len(self.large) > len(self.small):
            heapq.heappush(self.small, -heapq.heappop(self.large))

    def findMedian(self):
        if len(self.small) > len(self.large):
            return -self.small[0]
        return (-self.small[0] + self.large[0]) / 2
```

### Invariants

1. `len(small)` is equal to or one more than `len(large)`
2. Every element in `small` ≤ every element in `large`
3. The median is always accessible from the heap tops in O(1)

*Socratic prompt: "If you just sorted the stream each time, that's O(N log N) per query. How do the two heaps give you O(log N) insert and O(1) median?"*

**Example problems:** Find Median from Data Stream (295), Sliding Window Median (480)

---

## Remove Duplicate Letters

### Key Insight

Combine **greedy** + **monotonic stack**: build the smallest possible string by keeping a monotonically increasing stack of characters, but only pop a character if it appears later in the string (so we won't lose it).

### Template

```python
def remove_duplicate_letters(s):
    last_occurrence = {ch: i for i, ch in enumerate(s)}
    stack = []
    in_stack = set()

    for i, ch in enumerate(s):
        if ch in in_stack:
            continue                # Already in result — skip

        # Pop characters that are larger AND appear later
        while stack and stack[-1] > ch and last_occurrence[stack[-1]] > i:
            in_stack.remove(stack.pop())

        stack.append(ch)
        in_stack.add(ch)

    return ''.join(stack)
```

### The Three Conditions for Popping

A character on the stack gets popped only when ALL three hold:
1. The current character is smaller (greedy: we want lexicographically smallest)
2. The stack-top character appears again later (safe to remove)
3. The current character is not already in the stack

*Socratic prompt: "Why is condition 2 essential? What happens if we pop a character that doesn't appear later?"*

**Example problems:** Remove Duplicate Letters (316), Smallest Subsequence of Distinct Characters (1081)

---

## Exam Room

### Key Insight

Model the problem as choosing the longest "gap" between seated students. When a new student sits, they choose the midpoint of the longest gap (maximizing their minimum distance to the nearest neighbor).

### Template

```python
import bisect

class ExamRoom:
    def __init__(self, n):
        self.n = n
        self.students = []    # Sorted list of seated positions

    def seat(self):
        if not self.students:
            self.students.append(0)
            return 0

        # Check gap from seat 0 to first student
        max_dist = self.students[0]
        best_seat = 0

        # Check gaps between consecutive students
        for i in range(1, len(self.students)):
            dist = (self.students[i] - self.students[i - 1]) // 2
            if dist > max_dist:
                max_dist = dist
                best_seat = self.students[i - 1] + dist

        # Check gap from last student to seat n-1
        if self.n - 1 - self.students[-1] > max_dist:
            best_seat = self.n - 1

        bisect.insort(self.students, best_seat)
        return best_seat

    def leave(self, p):
        self.students.remove(p)
```

**Trade-off:** This implementation is O(N) per operation due to `insort` and `remove`. For O(log N), use a sorted set (e.g., `SortedList` from `sortedcontainers`) or a segment-based approach with a heap.

*Socratic prompt: "Why do we pick the midpoint of the largest gap? What would happen if we always sat at the leftmost empty seat?"*

**Example problems:** Exam Room (855), Maximize Distance to Closest Person (849)

---

## State Machine DP (Stock Problems)

> **Deep dive:** For full derivation of all 6 stock variants with simplified implementations and cooldown/fee handling, see `dynamic-programming-core.md` section 8.

### Framework

See `algorithm-frameworks.md` for the full state machine derivation. Here is the generic template:

```python
def max_profit(prices, k, cooldown=0, fee=0):
    n = len(prices)
    if n == 0:
        return 0

    # dp[i][j][s]: day i, j transactions remaining, s=0 not holding / s=1 holding
    dp = [[[-float('inf')] * 2 for _ in range(k + 1)] for _ in range(n + 1)]
    dp[0][k][0] = 0  # Start with k transactions, not holding, 0 profit

    for i in range(1, n + 1):
        for j in range(k + 1):
            # Not holding
            dp[i][j][0] = max(
                dp[i - 1][j][0],                              # Rest
                dp[i - 1][j][1] + prices[i - 1] - fee         # Sell
            )
            # Holding
            if j > 0:
                buy_from = i - 1 - cooldown  # Cooldown after selling
                if buy_from >= 0:
                    dp[i][j][1] = max(
                        dp[i - 1][j][1],                      # Rest
                        dp[buy_from][j - 1][0] - prices[i - 1]  # Buy
                    )

    return max(dp[n][j][0] for j in range(k + 1))
```

### Variant Simplifications

- **k=1:** Track `min_price` and `max_profit` in one pass — no DP needed.
- **k=infinity:** Drop the `k` dimension. `dp[i][0] = max(rest, sell)`, `dp[i][1] = max(rest, buy)`.
- **Cooldown:** Change buy transition to reference `dp[i-2]` instead of `dp[i-1]`.
- **Fee:** Subtract `fee` on sell (or buy, not both).

---

## Subsequence DP

> **Deep dive:** For comprehensive subsequence/string DP coverage including word break, regex matching, palindromic subsequences, and O(n log n) LIS, see `dynamic-programming-core.md` section 2.

### Template 1: `dp[i]` (Single Sequence)

Use when the answer involves elements ending at or up to index `i` in one sequence.

```python
# Longest Increasing Subsequence (LIS)
def lis(nums):
    n = len(nums)
    dp = [1] * n  # dp[i] = length of LIS ending at nums[i]
    for i in range(n):
        for j in range(i):
            if nums[j] < nums[i]:
                dp[i] = max(dp[i], dp[j] + 1)
    return max(dp)
```

**O(n log n) optimization:** Maintain a `tails` array where `tails[k]` is the smallest tail of all increasing subsequences of length `k+1`. Binary search for insertion point.

### Template 2: `dp[i][j]` (Two Sequences)

Use when comparing two sequences or a sequence against itself.

```python
# Longest Common Subsequence (LCS)
def lcs(s, t):
    m, n = len(s), len(t)
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if s[i - 1] == t[j - 1]:
                dp[i][j] = dp[i - 1][j - 1] + 1
            else:
                dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
    return dp[m][n]

# Edit Distance
def edit_distance(s, t):
    m, n = len(s), len(t)
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    for i in range(m + 1):
        dp[i][0] = i
    for j in range(n + 1):
        dp[0][j] = j
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if s[i - 1] == t[j - 1]:
                dp[i][j] = dp[i - 1][j - 1]
            else:
                dp[i][j] = 1 + min(dp[i - 1][j],      # Delete
                                    dp[i][j - 1],      # Insert
                                    dp[i - 1][j - 1])  # Replace
    return dp[m][n]
```

### How to Choose

| Signal | Template | Reason |
|--------|----------|--------|
| One array/string, answer about a subsequence | `dp[i]` | State is position in single sequence |
| Two strings, similarity/distance/matching | `dp[i][j]` | State is position in both sequences |
| One string, palindrome-related | `dp[i][j]` | Compare string against itself (two pointers) |

---

## House Robber Pattern

> **Deep dive:** For full derivation of linear, circular, and tree variants with proofs, see `dynamic-programming-core.md` section 8.

### Core Pattern

Linear DP with an adjacency constraint: cannot take two consecutive elements.

```python
def rob(nums):
    if not nums:
        return 0
    if len(nums) <= 2:
        return max(nums)
    prev2, prev1 = nums[0], max(nums[0], nums[1])
    for i in range(2, len(nums)):
        curr = max(prev1, prev2 + nums[i])
        prev2, prev1 = prev1, curr
    return prev1
```

**Recurrence:** `dp[i] = max(dp[i-1], dp[i-2] + nums[i])` — either skip house `i` (take previous best) or rob house `i` (add to best before previous).

### Variant: Circular (LC 213)

Houses are in a circle — first and last are adjacent. Solution: run linear House Robber twice — once excluding the first house, once excluding the last. Take the max.

```python
def rob_circular(nums):
    if len(nums) == 1:
        return nums[0]
    return max(rob(nums[1:]), rob(nums[:-1]))
```

### Variant: Tree (LC 337)

Houses form a binary tree — cannot rob a node and its direct children.

```python
def rob_tree(root):
    def dfs(node):
        if not node:
            return (0, 0)  # (rob_this, skip_this)
        left = dfs(node.left)
        right = dfs(node.right)
        rob_this = node.val + left[1] + right[1]   # Rob node, must skip children
        skip_this = max(left) + max(right)          # Skip node, free to rob or skip children
        return (rob_this, skip_this)
    return max(dfs(root))
```

---

## Interval Scheduling (Greedy)

> **Deep dive:** For the complete greedy framework including proof techniques, scan line, jump game, gas station, and video stitching, see `greedy-algorithms.md` section 2.

### Key Insight

Sort by **end time**. Greedily pick the interval that finishes earliest and doesn't overlap with the last picked. This maximizes the number of non-overlapping intervals.

### Why Sort by End Time?

Picking the earliest-ending interval leaves the most room for future intervals. Sorting by start time does not guarantee this — an early-starting but long interval can block many short ones.

### Template: Maximum Non-Overlapping Intervals

```python
def max_non_overlapping(intervals):
    intervals.sort(key=lambda x: x[1])  # Sort by end time
    count = 0
    end = float('-inf')
    for s, e in intervals:
        if s >= end:       # No overlap
            count += 1
            end = e
    return count
```

**Minimum removals to make non-overlapping** = `total - max_non_overlapping`.

### Variations

| Problem | Twist | Key Difference |
|---------|-------|----------------|
| Merge Intervals (56) | Merge overlapping | Sort by start, extend end greedily |
| Non-overlapping Intervals (435) | Min removals | `total - max_non_overlapping` |
| Minimum Arrows (452) | Points that pierce all balloons | Track intersection of overlapping intervals |
| Meeting Rooms II (253) | Min rooms needed | Sort starts and ends separately, sweep line |

---

## Bipartite Graph Detection

### Key Insight

A graph is bipartite if and only if it is 2-colorable: you can assign each node one of two colors such that no edge connects two same-colored nodes. Equivalently, the graph has no odd-length cycles.

### Template (DFS)

```python
def is_bipartite(graph):
    n = len(graph)
    color = [0] * n  # 0 = uncolored, 1 = color A, -1 = color B

    def dfs(node, c):
        color[node] = c
        for neighbor in graph[node]:
            if color[neighbor] == c:
                return False         # Same color = not bipartite
            if color[neighbor] == 0:
                if not dfs(neighbor, -c):
                    return False
        return True

    # Handle disconnected components
    for i in range(n):
        if color[i] == 0:
            if not dfs(i, 1):
                return False
    return True
```

### Common Applications

- **Possible Bipartition (LC 886):** Can you split people into two groups where no two in the same group dislike each other? Build a graph of dislikes, check bipartiteness.
- **Is Graph Bipartite (LC 785):** Direct application of the template.

---

## Dijkstra's Algorithm

### Key Insight

BFS finds shortest paths when all edges have equal weight. Dijkstra generalizes BFS to non-negative weighted graphs by replacing the FIFO queue with a priority queue (min-heap). At each step, process the unvisited node with the smallest known distance.

### Template

```python
import heapq

def dijkstra(graph, start):
    # graph: adjacency list, graph[u] = [(v, weight), ...]
    dist = {start: 0}
    heap = [(0, start)]

    while heap:
        d, u = heapq.heappop(heap)
        if d > dist.get(u, float('inf')):
            continue  # Stale entry, skip

        for v, w in graph[u]:
            new_dist = d + w
            if new_dist < dist.get(v, float('inf')):
                dist[v] = new_dist
                heapq.heappush(heap, (new_dist, v))

    return dist
```

### When NOT to Use Dijkstra

- **Negative edge weights:** Use Bellman-Ford instead. Dijkstra's greedy assumption (closest unvisited node has final distance) breaks with negative edges.
- **Unweighted graphs:** Use plain BFS — simpler and faster (O(V+E) vs O((V+E) log V)).

### Common Applications

| Problem | Setup |
|---------|-------|
| Network Delay Time (743) | Dijkstra from source, answer = max distance |
| Cheapest Flights Within K Stops (787) | Modified Dijkstra/BFS with stop count in state |
| Path with Maximum Probability (1514) | Max-heap Dijkstra (negate log-probabilities or use max-heap) |
| Swim in Rising Water (778) | Dijkstra where edge weight = max elevation on path |
