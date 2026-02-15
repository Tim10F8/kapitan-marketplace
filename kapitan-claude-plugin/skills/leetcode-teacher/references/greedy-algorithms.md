# Greedy Algorithms

Greedy algorithm framework and applications. For the optimization hierarchy (backtracking > DP > greedy) and proof techniques overview, see `algorithm-frameworks.md`. For interval scheduling quick-reference template, see `advanced-patterns.md`.

---

## Quick Reference Table

| Pattern | Recognition Signals | Key Problems | Section |
|---------|-------------------|--------------|---------|
| Greedy Framework | "Greedy choice property", local optimal = global optimal | -- (meta-framework) | 1 |
| Interval Scheduling | "Max non-overlapping intervals", "min removals", "min arrows" | Non-overlapping Intervals (435), Min Arrows (452) | 2 |
| Meeting Rooms (Scan Line) | "Min meeting rooms", "max overlapping events", "min platforms" | Meeting Rooms II (253), Max Profit Job Scheduling (1235) | 3 |
| Jump Game | "Can you reach the end", "min jumps to reach end" | Jump Game (55), Jump Game II (45) | 4 |
| Gas Station | "Circular route", "can complete circuit", "starting index" | Gas Station (134) | 5 |
| Video Stitching | "Min clips to cover range", "interval coverage" | Video Stitching (1024), Min Taps (1326) | 6 |

---

## 1. Greedy Framework

### What Makes Greedy Work

A greedy algorithm makes the **locally optimal choice** at each step, hoping to find the **global optimum**. This only works when the problem has the **greedy choice property**: the locally best choice is always part of some globally optimal solution.

### The Optimization Hierarchy

| Level | Technique | What It Enumerates | Typical Time |
|-------|-----------|-------------------|--------------|
| 1 | Backtracking | All valid solutions | O(2^n) or worse |
| 2 | Dynamic Programming | All subproblem states (no redundancy) | O(n^2) or O(n*k) |
| 3 | Greedy | One choice per step (no enumeration) | O(n) or O(n log n) |

Each level requires a stronger property. Greedy is fastest but most restrictive.

### When Greedy Works vs Fails

**Works (greedy choice property holds):**
- Fractional knapsack -- take highest value/weight ratio first
- Interval scheduling -- pick earliest-ending non-overlapping interval
- Huffman coding -- merge two lowest-frequency nodes
- Activity selection -- sort by end time, pick greedily

**Fails (must use DP instead):**
- 0/1 knapsack -- can't take fractions, greedy leads to suboptimal
- Longest increasing subsequence -- greedy "take the largest increase" fails
- Edit distance -- local character matches don't guarantee global minimum
- Coin change (arbitrary denominations) -- greedy "largest coin first" fails for some coin sets

*Socratic prompt: "Why does greedy work for fractional knapsack but not 0/1 knapsack? What specific property breaks?"*

### Proof Techniques

When you claim greedy works, you should have a proof sketch. Two standard approaches:

**Exchange Argument:**
1. Assume an optimal solution `OPT` that differs from the greedy solution `G`
2. Find the first point where they differ
3. Show you can "exchange" OPT's choice for G's choice without worsening the result
4. Repeat until OPT matches G -- therefore G is optimal

**Stays-Ahead Argument:**
1. Show that after each step, greedy's partial solution is at least as good as any other algorithm's partial solution
2. By induction, greedy "stays ahead" through the final step
3. Therefore the final greedy solution is optimal

*Socratic prompt: "For interval scheduling, if greedy picks the earliest-ending interval but the optimal picks a different one, can you swap them? Does the solution get worse?"*

### Greedy vs DP Decision Checklist

| Question | If Yes | If No |
|----------|--------|-------|
| Does the locally best choice always lead to a globally best solution? | Greedy | DP |
| Can you prove the exchange argument? | Greedy | DP |
| Are there overlapping subproblems? | DP (or greedy if above holds) | Maybe greedy or divide-and-conquer |
| Does the problem ask for count/all solutions? | DP or backtracking | Greedy (if asking for one optimal) |

---

## 2. Interval Scheduling

### Maximum Non-Overlapping Intervals

**Greedy strategy:** Sort by **end time**. Greedily pick the interval that finishes earliest and doesn't overlap with the last picked.

**Why sort by end time?** Picking the earliest-ending interval leaves the most room for future intervals. Sorting by start time doesn't guarantee this -- an early-starting but long interval can block many short ones.

```python
def interval_schedule(intervals):
    """Return maximum number of non-overlapping intervals."""
    intervals.sort(key=lambda x: x[1])  # Sort by end time
    count = 0
    end = float('-inf')
    for s, e in intervals:
        if s >= end:       # No overlap with last picked
            count += 1
            end = e
    return count
```

**Proof (exchange argument):** If OPT picks interval A instead of greedy's B (where B ends earlier), swapping A for B can't cause overlaps with later intervals (B ends earlier, so it leaves more room). Therefore OPT with the swap is still valid and has the same count.

### Non-overlapping Intervals -- LC 435

**Min removals** = `total intervals - max non-overlapping`.

```python
def erase_overlap_intervals(intervals):
    return len(intervals) - interval_schedule(intervals)
```

### Minimum Arrows to Burst Balloons -- LC 452

**Twist:** Find minimum points that pierce all intervals. Equivalent to finding groups of mutually overlapping intervals.

```python
def find_min_arrow_shots(points):
    if not points:
        return 0
    points.sort(key=lambda x: x[1])  # Sort by end
    arrows = 1
    end = points[0][1]
    for s, e in points[1:]:
        if s > end:  # No overlap: need new arrow
            arrows += 1
            end = e
        # If overlapping, current arrow still works (do nothing)
    return arrows
```

*Socratic prompt: "How is this different from max non-overlapping intervals? Why do we use `s > end` instead of `s >= end`?"*

### Merge Intervals -- LC 56

**Different goal:** Merge all overlapping intervals into non-overlapping ones. Sort by **start time**, then extend greedily.

```python
def merge(intervals):
    intervals.sort(key=lambda x: x[0])
    merged = [intervals[0]]
    for s, e in intervals[1:]:
        if s <= merged[-1][1]:  # Overlaps with last merged
            merged[-1][1] = max(merged[-1][1], e)  # Extend end
        else:
            merged.append([s, e])
    return merged
```

### Interval Problem Variants Summary

| Problem | Sort By | Greedy Action | Key |
|---------|---------|--------------|-----|
| Max non-overlapping (435) | End time | Pick earliest-ending | `s >= end` |
| Min arrows (452) | End time | New arrow when no overlap | `s > end` |
| Merge intervals (56) | Start time | Extend end when overlap | `s <= merged[-1][1]` |
| Insert interval (57) | Already sorted | Find overlap position | Binary search or linear scan |
| Remove covered (1288) | Start asc, end desc | Track max end | Skip if `end <= max_end` |

---

## 3. Meeting Rooms & Scan Line Technique

### Minimum Meeting Rooms -- LC 253

**Problem:** Given meeting intervals, find the minimum number of rooms needed.

**Approach 1: Scan Line (Difference Array)**

Mark `+1` at each meeting start and `-1` at each meeting end. The running sum at any point = simultaneous meetings. The maximum running sum = minimum rooms.

```python
def min_meeting_rooms(intervals):
    events = []
    for start, end in intervals:
        events.append((start, 1))   # Meeting starts: +1 room
        events.append((end, -1))    # Meeting ends: -1 room
    events.sort()  # Sort by time; ties: end (-1) before start (+1)
    max_rooms = curr_rooms = 0
    for time, delta in events:
        curr_rooms += delta
        max_rooms = max(max_rooms, curr_rooms)
    return max_rooms
```

**Approach 2: Two Sorted Arrays**

Sort starts and ends separately. Sweep through with two pointers.

```python
def min_meeting_rooms_v2(intervals):
    starts = sorted(i[0] for i in intervals)
    ends = sorted(i[1] for i in intervals)
    rooms = 0
    end_ptr = 0
    for start in starts:
        if start < ends[end_ptr]:
            rooms += 1          # Need a new room
        else:
            end_ptr += 1        # Reuse a freed room
    return rooms
```

**Approach 3: Min-Heap**

Sort by start time. Maintain a min-heap of end times. For each meeting, if it starts after the earliest ending meeting, pop that room (reuse it). Push new end time.

```python
import heapq

def min_meeting_rooms_heap(intervals):
    if not intervals:
        return 0
    intervals.sort(key=lambda x: x[0])
    heap = [intervals[0][1]]  # End time of first meeting
    for start, end in intervals[1:]:
        if start >= heap[0]:  # Can reuse the earliest-ending room
            heapq.heappop(heap)
        heapq.heappush(heap, end)
    return len(heap)
```

*Socratic prompt: "The scan line approach counts overlaps at each point in time. Why is the maximum overlap equal to the minimum rooms needed?"*

### Scan Line: General Pattern

The scan line technique works for any problem asking "what's the maximum number of overlapping events at any point?"

**Applications:**
- Minimum meeting rooms (LC 253)
- Maximum population year (LC 1854)
- Car pooling (LC 1094) -- uses difference array on a number line
- My Calendar (LC 729/731/732) -- dynamic event tracking

---

## 4. Jump Game

### Jump Game I -- LC 55 (Can Reach End?)

**Greedy insight:** Track the farthest reachable index. If at any point `i > farthest`, you're stuck.

```python
def can_jump(nums):
    farthest = 0
    for i in range(len(nums)):
        if i > farthest:
            return False  # Can't reach index i
        farthest = max(farthest, i + nums[i])
    return True
```

### Jump Game II -- LC 45 (Min Jumps)

**BFS-level insight:** Think of it as BFS where each "level" is the range of indices reachable in one more jump. Count levels until you reach the end.

```python
def jump(nums):
    n = len(nums)
    jumps = 0
    cur_end = 0     # End of current BFS level
    farthest = 0    # Farthest reachable in next level
    for i in range(n - 1):
        farthest = max(farthest, i + nums[i])
        if i == cur_end:  # Finished current level
            jumps += 1
            cur_end = farthest
            if cur_end >= n - 1:
                break
    return jumps
```

**Why this is greedy, not DP:** At each level boundary, we commit to jumping to the farthest point reachable. We never backtrack or reconsider. The BFS-level structure proves optimality: any solution needs at least as many "levels" as we use.

*Socratic prompt: "Draw the BFS tree for nums = [2,3,1,1,4]. What are the levels? Why does each level correspond to one jump?"*

---

## 5. Gas Station

### Gas Station -- LC 134

**Problem:** Circular route with `n` gas stations. `gas[i]` fuel gained, `cost[i]` fuel spent to next station. Find starting station to complete the circuit (or -1 if impossible).

**Key observations:**
1. If `sum(gas) < sum(cost)`, no solution exists (not enough total fuel)
2. If a solution exists, it's unique

### Approach 1: Greedy (Single Pass)

If starting from station `start`, the tank goes negative at station `i`, then no station between `start` and `i` can be a valid start either (they'd have even less fuel at `i`). So skip to `i + 1`.

```python
def can_complete_circuit(gas, cost):
    n = len(gas)
    total_tank = 0
    curr_tank = 0
    start = 0
    for i in range(n):
        diff = gas[i] - cost[i]
        total_tank += diff
        curr_tank += diff
        if curr_tank < 0:
            # Can't reach station i+1 from current start
            # Try starting from i+1
            start = i + 1
            curr_tank = 0
    return start if total_tank >= 0 else -1
```

**Proof:** If `total_tank >= 0`, a solution exists. The greedy finds it because: if starting from `start` never makes `curr_tank` go negative through the rest of the array, and `total_tank >= 0` guarantees the "wrap-around" portion also works.

### Approach 2: Graph/Prefix Sum Method

Compute `diff[i] = gas[i] - cost[i]`. The prefix sum of `diff` shows accumulated fuel surplus. The valid starting point is right after the minimum prefix sum (the "deepest valley").

```python
def can_complete_circuit_graph(gas, cost):
    n = len(gas)
    total = 0
    min_sum = float('inf')
    min_idx = 0
    for i in range(n):
        total += gas[i] - cost[i]
        if total < min_sum:
            min_sum = total
            min_idx = i
    if total < 0:
        return -1
    return (min_idx + 1) % n  # Start right after the deepest valley
```

*Socratic prompt: "Why does starting after the 'deepest valley' in the prefix sum work? What does the valley represent physically?"*

---

## 6. Video Stitching / Interval Coverage

### Video Stitching -- LC 1024

**Problem:** Given clips `[start, end]` and a target time `T`, find the minimum number of clips to cover `[0, T]`.

**Greedy strategy:** Sort by start time. At each step, among all clips that start at or before the current coverage end, pick the one that extends coverage the farthest.

```python
def video_stitching(clips, time):
    clips.sort()
    res = 0
    cur_end = 0     # Current coverage end
    next_end = 0    # Farthest reachable from current clips
    i = 0
    while cur_end < time:
        # Consider all clips starting at or before cur_end
        while i < len(clips) and clips[i][0] <= cur_end:
            next_end = max(next_end, clips[i][1])
            i += 1
        if next_end == cur_end:
            return -1   # Can't extend coverage
        cur_end = next_end
        res += 1
    return res
```

**Connection to Jump Game II:** This is structurally identical! Each "clip" is like a jump range. The greedy picks the farthest-reaching option at each step, exactly like the BFS-level approach in Jump Game II.

### Minimum Number of Taps -- LC 1326

Same problem, different framing: taps at positions `0..n`, each covers `[i - ranges[i], i + ranges[i]]`. Convert to intervals, then apply video stitching.

```python
def min_taps(n, ranges):
    # Convert to clips
    clips = []
    for i, r in enumerate(ranges):
        clips.append([max(0, i - r), i + r])
    return video_stitching(clips, n)
```

*Socratic prompt: "Can you see why Video Stitching, Jump Game II, and Minimum Taps are all the same problem in disguise? What's the common structure?"*

### The Interval Coverage Family

| Problem | Input | Target | Core Idea |
|---------|-------|--------|-----------|
| Video Stitching (1024) | Clips `[s, e]` | Cover `[0, T]` | Greedy extend coverage |
| Jump Game II (45) | `nums[i]` = max jump | Reach index `n-1` | BFS levels = greedy extend |
| Min Taps (1326) | Tap ranges | Cover `[0, n]` | Convert to clips |
| Set Cover | Sets | Cover universe | NP-hard in general (greedy is approximation) |

---

## Attribution

The frameworks and problem derivations in this file are inspired by and adapted from labuladong's algorithmic guides (labuladong.online), specifically the greedy algorithm chapter covering interval scheduling, jump game, gas station, scan line technique, and video stitching. Content has been restructured for Socratic teaching use with Python code templates and cross-references.
