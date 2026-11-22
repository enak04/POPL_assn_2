---
name: scheme-dev
description: Implement, test, and review one restricted Scheme/Racket function or test file at a time for CS F301 Assignment 2 (S1 and S2).
---

# Scheme Development Skill — CS F301 Assignment 2, Group 61

## 1. Source of truth and scope

- Treat `PPL_Assignment_2_Final.pdf` as authoritative. Do not fill in missing requirements by assuming general Racket conveniences are permitted.
- Target **Racket 8.x** grading behavior. The user's machine currently runs Racket 9.3; use only the explicitly listed subset so that newer-only features are not needed. This is a compatibility precaution, not proof of 8.x compatibility.
- Target `code/61_q3.rkt` (S1) and `code/61_q4.rkt` (S2). Both must begin with `#lang racket/base` and contain **only definitions**, with no executed demonstration calls or output at load time. The grader appends calls itself.
- **Decomposition rule:** One prompt authorizes only **one function, one test file, or one review**. Never implement an entire problem, introduce unrelated helpers, or rewrite unrequested functions. Identify missing dependencies for a subsequent atomic prompt.
- Keep each Claude prompt word-for-word in `prompts/S1.md` or `prompts/S2.md` (the user maintains these logs). Share nothing with other groups.

## 2. Strict allowed-language whitelist

The **only built-ins and special forms** permitted for S1 and S2 are:

- Definitions and control: `define`, `lambda`, `let`, `let*`, `letrec`, named `let`, `if`, `cond` (with `else`), `and`, `or`, `not`, `begin`, `quote` (`'`).
- Lists and access: `cons`, `car`, `cdr`, `list`, every `car`/`cdr` composition up to four levels (such as `cadr`, `caddr`, `cdddr`, `cadddr`), `null?`, `pair?`, `eq?`, `assq`, `assoc`.
- Arithmetic and comparisons: `+`, `-`, `*`, `<`, `>`, `<=`, `>=`, `=`, `max`.
- Output: `display`, `newline`.
- **S2 only:** `read`.

No other `racket/base` built-ins are allowed. In particular, do **not** use: `set!` or other mutation; vectors, hash tables, strings, loops (`do`, `for`, etc.); `length`, `append`, `reverse`, `map`, `filter`, `member`, `memq`, `list-ref`, `list-tail`; `equal?`, `number?`, `list?`, `printf`, `format`, `foldl`, `apply`, `require`, `provide`, `module+`, or `/`. If a needed utility is absent, write a new helper using only the permitted subset, as a separately requested function.

## 3. Coding conventions and functional reasoning

- Use descriptive `kebab-case` function names, following the assignment's public identifiers exactly.
- For every function, add a short comment with its input, output or printed side effect, structural recursion invariant, and base case.
- No mutable variables or global state. Pass state through arguments or use lexical closures; prefer tail recursion when it naturally fits the function.
- Use `null?` for empty-list cases and `pair?` to distinguish a nested list from an atom. Do not treat an empty list as an atom in S2.
- Avoid repeated full-list traversal or quadratic intermediate list construction where large inputs are possible.
- Keep all output to the specifically requested public printing functions. Helpers should return values rather than print.

## 4. S1-specific contract (`code/61_q3.rkt`)

- A tree is either `'()` or a three-element list `(value left right)`; children are themselves trees. Values can be numbers or single-character symbols.
- Inorder traversal: left, node, right. Preorder: node, left, right. Postorder: left, right, node.
- `print-inorder` outputs one `display`-formatted list and a newline.
- `print-all-traversals` outputs **three** lines, in this order: inorder, preorder, postorder; every line ends with `newline`.
- The height of an empty tree is 0; a node's height is `1 + max(left-height, right-height)`.
- A leaf has two empty children; an empty tree has 0 leaves. `print-height-and-leaves` outputs the two-element list `(height leaf-count)` and a newline.
- Visit the left subtree before the right subtree; handle empty, single-node, skewed and balanced trees.
- Do not make the submitted file define the grader's sample trees or call functions at top level.

## 5. S2-specific contract (`code/61_q4.rkt`)

- `insert-if-short` takes an atom `x`, a proper possibly nested list `lst`, and integer `n >= 0`. For **every** list at every nesting level whose **original top-level length** is `< n`, insert `x` at its front.
- Process the top-level list too. Empty lists have length 0 and become `(x)` when `n > 0`; when `n = 0`, no list qualifies.
- Input lists contain atoms (digits or symbols) and proper sublists; there are no dotted pairs. Preserve original element order and the full nested structure.
- Write original, explicitly named `my-length` and `my-map` functions using only the allowed subset. These must be used in the final implementation where required.
- `make-inserter x len-ok?` returns **one function of one list argument** that recursively inserts `x` into lists for which `(len-ok? original-length)` is true.
- The **single final definition** of `insert-if-short` must use `make-inserter`. Do not leave a previous preliminary definition in the file.
- `print-insert-result` takes no arguments, performs three `read` calls in this exact order (`x`, `lst`, `n`), and prints only the resulting list followed by one newline. No prompts or debug output.
- Hidden tests include **nesting depth 100** and **10,000-element lists**: avoid needless repeated traversal; check recursive stack behavior and performance.

## 6. How to run and test

From the repository root in VS Code PowerShell:

```powershell
racket --version
racket code/61_q3.rkt
racket code/61_q4.rkt
```

The last two commands should produce **no output** by themselves, because submitted files contain definitions only.

- Put test harnesses in `tests/S1_tests.rkt` and `tests/S2_tests.rkt`. To test public functions without changing submission files, create a **temporary copy** of the solution source and append test calls to the copy, then execute that copy with `racket`. Do not rely on `require`/`provide` in the submitted files.
- Check the PDF's examples, exact parenthesized list rendering, all required newlines, empty trees/lists, single nodes, skewed trees, `n = 0`, nested empty lists, original-versus-resulting length, 100-deep nesting, and 10,000-element input.
- The Claude website may not execute the local Racket environment. Never say tests *passed* unless they actually ran; give exact commands and expected results otherwise.

## 7. Known AI failure modes — proactively check

1. Using common but disallowed conveniences (`append`, `length`, `map`, `reverse`, `set!`, `equal?`, `printf`, etc.).
2. Putting example calls, test definitions, sample trees, or executable expressions into submitted source files.
3. Using an incorrect tree representation or changing the required traversal order.
4. Off-by-one height (empty tree is height 0) or miscounting empty nodes as leaves.
5. Forgetting a newline or printing extra messages.
6. Treating nested empty lists as atoms or failing to transform the outermost list.
7. Computing S2 length after insertion instead of from the original list.
8. Processing only one level of nesting, reversing elements, or applying insertion more than once.
9. Returning a function of the wrong arity from `make-inserter`, or retaining multiple `insert-if-short` definitions.
10. Quadratic list processing or stack/performance failures on 10,000 elements.
11. Claiming execution on Racket 8.x despite testing only on 9.3, or claiming to have run tools not available on the Claude website.

## 8. Mandatory self-review before every answer

- [ ] Did I implement only the **single requested function / one test file / one review**?
- [ ] Are *all* forms and functions on the strict whitelist, including helpers and tests where applicable?
- [ ] Does the implementation obey `#lang racket/base`, definition-only submission, no global mutation and no load-time output?
- [ ] Can I explain base cases, recursive steps, and (when needed) tail-recursion invariants?
- [ ] Is traversal / nested-list ordering unchanged?
- [ ] Are output format, newline count, empty cases and large-case requirements correct?
- [ ] Did I preserve unrequested code, and clearly distinguish tested from untested behavior?

## 9. Response format for each atomic request

Return only: (1) the requested function or test unit; (2) a concise recursive/functional explanation; (3) narrowly relevant edge-case notes; and (4) commands for the user to verify the result. Do **not** add implementations of other functions or a whole-problem solution.
