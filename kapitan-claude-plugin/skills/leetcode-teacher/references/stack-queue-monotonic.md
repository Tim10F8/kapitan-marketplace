# Stack, Queue & Monotonic Structures

Four pattern families covering stack-queue implementations, monotonic data structures, and expression evaluation. These structures transform brute-force O(N^2) scanning into elegant O(N) solutions.

---

## Quick Reference Table

| Pattern | Key Insight | When to Use | Complexity |
|---------|-------------|-------------|------------|
| Queue using Stacks | Two stacks simulate FIFO — amortized O(1) | "Implement queue with stacks" | Amortized O(1) per op |
| Stack using Queues | One queue with rotation | "Implement stack with queues" | O(N) push or O(N) pop |
| Monotonic Stack | Maintain sorted order to find next greater/smaller | "Next greater element", "daily temperatures", "largest rectangle" | O(N) total |
| Monotonic Queue | Deque maintaining max/min for sliding window | "Sliding window maximum", "max in every window of size k" | O(N) total |
| Calculator | Stack-based parsing with operator precedence | "Evaluate expression", "basic calculator" | O(N) |

---

## 1. Stack-Queue Mutual Implementation

### Queue Using Two Stacks (LC 232)

**Key insight:** Use one stack for push (inbox) and another for pop (outbox). When outbox is empty, pour all elements from inbox into outbox — this reverses the order, giving FIFO behavior.

```python
class MyQueue:
    def __init__(self):
        self.inbox = []     # Push here
        self.outbox = []    # Pop from here

    def push(self, x):
        self.inbox.append(x)

    def pop(self):
        self._transfer()
        return self.outbox.pop()

    def peek(self):
        self._transfer()
        return self.outbox[-1]

    def empty(self):
        return not self.inbox and not self.outbox

    def _transfer(self):
        """Move inbox to outbox only when outbox is empty."""
        if not self.outbox:
            while self.inbox:
                self.outbox.append(self.inbox.pop())
```

**Why amortized O(1)?** Each element is pushed to inbox once and popped to outbox once. Over N operations, total transfers = O(N), so amortized cost per operation = O(1).

*Socratic prompt: "Why do we only transfer when outbox is empty? What breaks if we transfer every time?"*

### Stack Using Two Queues (LC 225)

**Key insight:** After pushing to the queue, rotate all previous elements behind the new one. This makes the most recent element always at the front.

```python
from collections import deque

class MyStack:
    def __init__(self):
        self.queue = deque()

    def push(self, x):
        self.queue.append(x)
        # Rotate: move all elements before x to after x
        for _ in range(len(self.queue) - 1):
            self.queue.append(self.queue.popleft())

    def pop(self):
        return self.queue.popleft()

    def top(self):
        return self.queue[0]

    def empty(self):
        return not self.queue
```

**Trade-off:** Push is O(N), but pop and top are O(1). Alternative: make pop O(N) and push O(1).

---

## 2. Monotonic Stack

### Key Insight

A **monotonic stack** maintains elements in sorted (monotonically increasing or decreasing) order. When a new element arrives, pop all elements that violate the monotonicity. The popped elements have found their "answer" (next greater/smaller).

**Why O(N)?** Each element is pushed once and popped at most once. Total operations = 2N = O(N).

### Template: Next Greater Element

For each element, find the next element to its right that is greater.

```python
def next_greater_element(nums):
    n = len(nums)
    result = [-1] * n
    stack = []  # Stack of indices, values are monotonically decreasing

    for i in range(n):
        # Pop elements smaller than current — they found their next greater
        while stack and nums[stack[-1]] < nums[i]:
            idx = stack.pop()
            result[idx] = nums[i]
        stack.append(i)

    return result
```

### Traversal Direction

You can traverse **left to right** (pushing, popping when new element breaks monotonicity) or **right to left** (for each element, peek at the stack to find the answer).

```python
# Right-to-left variant: for each element, the stack holds candidates to its right
def next_greater_rtl(nums):
    n = len(nums)
    result = [-1] * n
    stack = []  # Stack of values (not indices)

    for i in range(n - 1, -1, -1):
        # Pop elements that are not greater than current
        while stack and stack[-1] <= nums[i]:
            stack.pop()
        result[i] = stack[-1] if stack else -1
        stack.append(nums[i])

    return result
```

*Socratic prompt: "For the array [2, 1, 2, 4, 3], trace through the stack. When element 4 arrives, which elements get popped and why?"*

### Circular Array Handling

For circular arrays (e.g., Next Greater Element II), traverse the array twice using modulo indexing:

```python
def next_greater_circular(nums):
    n = len(nums)
    result = [-1] * n
    stack = []

    # Traverse 2N elements: simulates circular array
    for i in range(2 * n - 1, -1, -1):
        while stack and stack[-1] <= nums[i % n]:
            stack.pop()
        result[i % n] = stack[-1] if stack else -1
        stack.append(nums[i % n])

    return result
```

### Monotonic Stack Variants

| Variant | Stack Order | What It Finds |
|---------|-------------|---------------|
| Decreasing stack | Top is smallest | Next **greater** element |
| Increasing stack | Top is largest | Next **smaller** element |

### Problems

| Problem | Variant | Key Twist |
|---------|---------|-----------|
| Next Greater Element I (496) | Decreasing, R-to-L | Hash map to map nums1 → answer from nums2 |
| Next Greater Element II (503) | Decreasing, circular | 2N traversal with modulo |
| Daily Temperatures (739) | Decreasing | Result is index difference, not value |
| Largest Rectangle in Histogram (84) | Increasing | Find left and right boundaries for each bar |
| Trapping Rain Water (42) | Decreasing | Water trapped between bars = min(left_max, right_max) - height |

---

## 3. Monotonic Queue

### Key Insight

A **monotonic queue** (deque) maintains elements in decreasing order. The front always holds the maximum of the current window. When the window slides, remove elements from the back that are smaller than the new element (they can never be the maximum) and remove from the front if they've left the window.

### Template: Sliding Window Maximum (LC 239)

```python
from collections import deque

def max_sliding_window(nums, k):
    dq = deque()   # Stores indices; values are monotonically decreasing
    result = []

    for i in range(len(nums)):
        # Remove elements outside the window from the front
        while dq and dq[0] < i - k + 1:
            dq.popleft()

        # Remove elements smaller than current from the back
        # (they can never be the window max while current is in the window)
        while dq and nums[dq[-1]] < nums[i]:
            dq.pop()

        dq.append(i)

        # Window is full — record the maximum (front of deque)
        if i >= k - 1:
            result.append(nums[dq[0]])

    return result
```

**Why O(N)?** Each element enters and leaves the deque at most once. Total operations = 2N.

### Why Not Just Use a Heap?

A max-heap gives the maximum in O(1), but removing an element that has left the window is O(N) (unless you use lazy deletion, which is O(log N) amortized). The monotonic deque achieves O(1) amortized for all operations.

*Socratic prompt: "If we have a window [3, 1, 2] and the next element is 5, which elements in the deque become useless? Why?"*

### Monotonic Queue Variants

| Variant | Deque Order | What It Provides |
|---------|-------------|------------------|
| Decreasing deque | Front is maximum | Sliding window maximum |
| Increasing deque | Front is minimum | Sliding window minimum |

### Problems

| Problem | Key Twist |
|---------|-----------|
| Sliding Window Maximum (239) | Direct monotonic deque application |
| Constrained Subsequence Sum (1425) | DP + monotonic deque for max in window |
| Shortest Subarray with Sum at Least K (862) | Monotonic deque + prefix sum (handles negatives) |
| Jump Game VI (1696) | DP where each state depends on max of previous k states |

---

## 4. Calculator / Expression Evaluation

### The Incremental Approach

Build the calculator in stages, each adding one feature:

1. **Addition and subtraction only** (no parentheses)
2. **Add multiplication and division** (operator precedence)
3. **Add parentheses** (recursive handling)

### Stage 1: + and - Only

```python
def calculate_basic(s):
    stack = []
    num = 0
    sign = '+'

    for i, ch in enumerate(s):
        if ch.isdigit():
            num = num * 10 + int(ch)

        if ch in '+-' or i == len(s) - 1:
            if sign == '+':
                stack.append(num)
            elif sign == '-':
                stack.append(-num)
            sign = ch
            num = 0

    return sum(stack)
```

### Stage 2: Add * and / (LC 227)

**Key insight:** Multiplication and division have higher precedence. Handle them immediately (pop the top, compute, push result). Addition and subtraction just push to the stack.

```python
def calculate(s):
    stack = []
    num = 0
    sign = '+'

    for i, ch in enumerate(s):
        if ch.isdigit():
            num = num * 10 + int(ch)

        if (ch in '+-*/' and ch != ' ') or i == len(s) - 1:
            if sign == '+':
                stack.append(num)
            elif sign == '-':
                stack.append(-num)
            elif sign == '*':
                stack.append(stack.pop() * num)
            elif sign == '/':
                # Truncate toward zero (Python's // truncates toward -inf)
                stack.append(int(stack.pop() / num))
            sign = ch
            num = 0

    return sum(stack)
```

### Stage 3: Add Parentheses (LC 224 / LC 772)

**Key insight:** When we see `(`, recursively evaluate the sub-expression. When we see `)`, return the result to the caller.

```python
def calculate_full(s):
    def helper(s, idx):
        stack = []
        num = 0
        sign = '+'

        while idx < len(s):
            ch = s[idx]

            if ch.isdigit():
                num = num * 10 + int(ch)

            if ch == '(':
                # Recursively evaluate sub-expression
                num, idx = helper(s, idx + 1)

            if ch in '+-*/)' or idx == len(s) - 1:
                if sign == '+':
                    stack.append(num)
                elif sign == '-':
                    stack.append(-num)
                elif sign == '*':
                    stack.append(stack.pop() * num)
                elif sign == '/':
                    stack.append(int(stack.pop() / num))
                num = 0
                sign = ch

                if ch == ')':
                    break

            idx += 1

        return sum(stack), idx

    result, _ = helper(s, 0)
    return result
```

### The Unified Insight

All three stages use the same core pattern:
1. **Accumulate digits** into `num`
2. **When an operator (or end) is reached**, apply the PREVIOUS operator to `num`
3. **Stack holds pending additions** — sum at the end

The only differences: Stage 2 handles `*` and `/` by popping immediately. Stage 3 handles `(` and `)` by recursing.

*Socratic prompt: "Why do we apply the PREVIOUS sign when we encounter a new operator, not the current one? Trace through `3 + 2 * 4` to see why."*

### Problems

| Problem | Features |
|---------|----------|
| Basic Calculator II (227) | `+`, `-`, `*`, `/` (no parentheses) |
| Basic Calculator (224) | `+`, `-`, `(`, `)` (no `*` `/`) |
| Basic Calculator III (772) | All: `+`, `-`, `*`, `/`, `(`, `)` |

---

## Pattern Connections

| Pattern | Related To |
|---------|-----------|
| Monotonic Stack | Histogram problems → extend to maximal rectangle in matrix (LC 85) |
| Monotonic Queue | DP optimization → when transition depends on max/min of a window |
| Calculator | Tree evaluation → expression trees are the recursive structure |
| Stack-Queue impl | Understanding amortized analysis → each element moved O(1) times |

---

## Attribution

The patterns and techniques in this file are inspired by and adapted from labuladong's algorithmic guides (labuladong.online), particularly the monotonic stack, monotonic queue, and calculator implementation articles from Chapter 1 "Data Structure Algorithms." Templates have been restructured and annotated for Socratic teaching use.
