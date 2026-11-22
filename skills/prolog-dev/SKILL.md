---
name: prolog-dev
description: Implement, test, and review one Prolog predicate or test file at a time for CS F301 Assignment 2 (P1 and P2), following the assignment's strict constraints.
---

# Prolog Development Skill — CS F301 Assignment 2, Group 61

## 1. Source of truth and scope

- Treat `PPL_Assignment_2_Final.pdf` as the authoritative specification. If a request conflicts with it, identify the conflict rather than silently changing the requirement.
- Target **SWI-Prolog 9.x** grading behavior. Development may occur on SWI-Prolog 11.0.0; avoid relying on newer-only behavior and report the version mismatch when relevant.
- Target files: `code/61_q1.pl` (P1) and `code/61_q2.pl` (P2).
- **Decomposition rule:** Each user prompt authorizes only **one predicate, one test file, or one review**. Do not implement an entire problem, combine multiple unrequested predicates, or rewrite other sections. If the requested predicate depends on an absent helper, explain the dependency and request a separate atomic task.
- Do not share code, prompts, or skills outside the group. Keep actual Claude prompts word-for-word in `prompts/P1.md` or `prompts/P2.md` (the user maintains these logs).

## 2. Coding and commentary conventions

- Prefer clear declarative relations over procedural shortcuts. Each predicate should have a short comment stating its meaning, modes/expected groundness where applicable, and success/failure behavior.
- Predicate and helper names: descriptive `snake_case`; Prolog variables: meaningful capitalized identifiers; anonymous variables only when truly unused.
- Favor explicit base cases, finite search spaces, correct backtracking, and no unintended multiple proofs of the same logical assignment.
- Keep source files to definitions and comments. Never add `:- initialization(...)`, call `halt/0` in source, or print during load.
- No `assert`, `retract`, or global state (`b_setval`, `nb_setval`, etc.). Only these external libraries are permitted: `lists`, `apply`, `yall`, `aggregate`. Do not add another library.
- Keep outputs minimal and exact: P1 prints only through `main/0` as specified; P2 predicates do not print.
- Do not replace a logical search with a hard-coded answer, a memorized expected output, or a list of precomputed equations.

## 3. P1-specific contract (`code/61_q1.pl`)

- A candidate solution is exactly four terms in **Alex, Ben, Carla, Dana** order:
  `p('Alex',Dept,Lang,Project)`, `p('Ben',...)`, `p('Carla',...)`, `p('Dana',...)`.
- Use exactly once each department: `research`, `development`, `design`, `testing`; language: `python`, `java`, `'c++'`, `javascript`; project: `'AI'`, `web`, `embedded`, `data`.
- Implement every numbered clue as its **own clause** of `clue(N, Solution)`; its truth conditions must match the PDF for a fully assigned solution.
- `count_solutions(Active, N)` must count distinct assignments that satisfy **exactly** the clue numbers in `Active`, ignoring inactive clues, using `findall/3` or `aggregate_all/3`.
- `main/0` must **derive** and print one assignment satisfying clues 1–8, with exactly four lines, in name order, each of the form `Alex = [department, language, project]` (without extra chatter).
- For the agreed ninth clue, use precisely this natural-language requirement: **“The friend working in the design department prefers embedded projects.”** Put a line starting `% CLUE 9:` immediately above the corresponding `clue(9, Solution)` clause. The clause must not identify anyone by name; verify that clues 1–9 leave exactly one solution.
- The final value for original clues 1–8 and its interpretation belong in `P1_REPORT.md`, based on executed tests (not an unsupported claim).

## 4. P2-specific contract (`code/61_q2.pl`)

- Use each input **non-negative integer** exactly once, in order. Insert exactly one `=` at a boundary between numbers; use only binary `+`, `-`, `*`, `/` and optional grouping. No unary minus and no digit concatenation.
- Every subtree must have an integer value. Every division requires a **nonzero divisor** and **zero remainder at that node**; negative intermediate values are allowed.
- Prefer representing expression *structure* separately from arithmetic *evaluation* and canonical *rendering*. Do not create strings and parse them back to evaluate.
- Return equations as **SWI-Prolog strings**, no spaces; not atoms or code lists.
- Canonical parentheses: precedence `*`/`/` above `+`/`-`; left associative. Parenthesize a left child only when its top operator has lower precedence; parenthesize a right child when its top operator has equal or lower precedence. Never parenthesize a number.
- Distinct expression trees must remain distinguishable in printed equations (for example, `1+2+3` versus `1+(2+3)`).
- `generate_equation(List, Equation)` must produce a valid answer, or finitely **fail** for no solution (including length 0 or 1); it must not throw an error or loop.
- `all_equations(List, Equations)` must return all valid strings, unique and sorted by `sort/2`; when no valid equation exists, it returns `[]`. `count_equations(List, N)` is the length of that resulting list.

## 5. How to run and test

Run from the repository root in VS Code PowerShell. The exact grader-compatible commands are:

```powershell
swipl -q -f code/61_q1.pl -g main -t halt
swipl -q -f code/61_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8],N),writeln(N)" -t halt
swipl -q -f code/61_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8,9],N),writeln(N)" -t halt
swipl -q -f code/61_q2.pl -g "all_equations([4,2,5,3],Es),writeln(Es)" -t halt
```

The `-t halt` command-line option is allowed; a `halt/0` call **inside the submitted source** is not. Tests can print values through the command-line goal; the solution predicates themselves must follow the output rules.

- Place P1 tests in `tests/P1_tests.pl` and P2 tests in `tests/P2_tests.pl`.
- Include the PDF examples and edge cases: inactive clue subsets, 1–8 count, 1–9 uniqueness, zero divisor, negative intermediate values, no-solution inputs, length 0/1, duplicates, canonical parentheses and sorted output.
- Compare the full P2 result with the provided seven-element `[4,2,5,3]` example, `[]` for `[2,3,4]`, and the singleton list for `[2,4,8]`.
- The Claude website may not be able to run local code. **Never claim tests were executed without tool evidence.** If execution is unavailable, provide exact commands and describe results as *expected*, not *observed*.

## 6. Known AI failure modes — proactively check

1. Accidentally using the displayed P1 formatting example as the answer, or hard-coding the solution.
2. Misquoting atoms `'Alex'`, `'c++'`, or `'AI'`; changing the required order of people.
3. Letting optional clues influence a count that should ignore them; double-counting due to duplicate derivations.
4. Giving clue 9 a named-person reference, omitting its required comment, or failing to prove uniqueness by execution.
5. Using floating-point `/` instead of exact integer division checks, or checking divisibility only for the final expression.
6. Accidentally changing number order, joining digits, or allowing unary minus.
7. Removing meaningful parentheses, treating different expression trees as identical, or producing atoms instead of strings.
8. Failing to terminate for too-short or unsatisfiable P2 inputs.
9. Extra debug output, initialization directives, forbidden library imports, or mutable global state.
10. Claiming a test passed despite not running it.

## 7. Mandatory self-review before every answer

- [ ] Is the response strictly limited to the requested **single predicate / one test file / one review**?
- [ ] Does the implementation use only permitted language features and libraries?
- [ ] Can I explain the predicate declaratively, including intended input/output modes?
- [ ] Are base cases, failure cases, backtracking and termination correct?
- [ ] Are all relevant edge cases and exact output requirements addressed?
- [ ] Did I preserve all existing unrelated code and assignment-specific file names?
- [ ] Did I distinguish **tested observations** from **untested expectations**?

## 8. Response format for each atomic request

Respond with: (1) the exact predicate or test unit requested; (2) a brief declarative explanation; (3) any narrowly relevant review concerns; and (4) exact commands to verify it. Do **not** proactively implement the next unit or provide a complete problem solution.
