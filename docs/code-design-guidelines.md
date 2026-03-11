# Code Style and Design Principles

## Levels of Abstraction (The Master Principle)

- **All code in a given function must be at a single, consistent level of abstraction.** Do not mix high-level intent ("what") with low-level mechanics ("how") in the same function.
- **When adding new logic to an existing function, encapsulate it in a well-named helper** rather than inlining low-level code. If a function is already long, extract the new behavior into a separate function.
- **Data structures also have levels of abstraction.** Group lower-level attributes into their own sub-structures rather than having flat objects with mixed concerns.
- **Watch out for three abstraction anti-patterns:**
  - **Leaky abstractions**: the caller still has to know about the inside. Test: if the implementation were different, would the interface change?
  - **Bureaucratic abstractions**: the function hides nothing because it is at the same level as its implementation. Remove it if the encapsulation isn't meaningful.
  - **Premature abstractions**: introduced before patterns are clear. Tolerate duplication early; create abstractions iteratively as patterns emerge.

## Naming

- **Name things by what they represent, not how they are implemented.** Use `compute_employee_salaries()` not `compute_salaries_pair_vector()`. Use `age` not `i`. Use `temperatures` not `doubles`.
- **The right name is at its own level of abstraction.** Not how it is implemented (lower) and not the context where it is used (higher).
- **Avoid vague technical labels** like `data`, `info`, `manager`, `handler`, `helper`, `temp`, `result`. Replace with names that describe what the thing actually represents.
- **Avoid negative formulations.** Use `not is_valid(id)` instead of `is_not_valid(id)`.
- **If an entity is difficult to name, check if it's lacking cohesion and should be split.**

## Functions and Interfaces

- **Design the call site first, implementation after.** Write how you want to call the function before implementing it. This produces expressive, user-friendly APIs.
- **Prefer returning values over mutating parameters.**
- **Every parameter must be immediately obvious to an uninformed caller.** If a caller needs to read the implementation to know what to pass, the interface has failed.
- **Avoid bare boolean parameters.** `create_widget(True, False, True)` is unreadable. Use named constants, enums, keyword arguments, or descriptive wrappers.
- **Use Optional/None-returning types for operations that may not produce a result.**
- **Do not make interfaces deceptively simple.** An interface that hides significant cost (network calls, heavy computation) behind an innocent-looking getter misleads callers. `load_results` or `compute_results` is more honest than `get_results` when it's not just a get.

## High Cohesion

- **Each unit of code (function, class, module) should be focused around one thing.** Everything in it should contribute toward the same goal.
- **Split code into smaller components, each focused on one concern.** It is OK to create classes that do not map to domain objects (pure fabrications) if they improve cohesion.
- **Assign responsibilities to the class that already holds the data needed** (Information Expert). Prefer the design with the fewest interactions between objects.

## Low Coupling

Coupling is when one piece of code knows something about another.
- **Locality**: how far apart the coupled pieces are. If you cannot remove coupling, make the coupled pieces close to one another. Distant coupling is far worse.
- **Prefer immutability where possible.**

## Controlling Side Effects

Side effects are inputs and outputs of a function that are not its parameters or return values.

- **Environment variables and config**: read only at specific boundary points, then pass as normal parameters.
- **Global/shared state**: avoid it. If it exists, encapsulate it and limit its scope.
- **IO (files, external services)**: confine access to thin boundary layers; pass data via parameters and return values.
- **Do not use exceptions for control flow.** Keep exceptions for genuinely exceptional situations.
- **Prefer returning new values over mutating inputs.** Let the caller decide what to do with the result.
- **Separate commands (modify data) from queries (return data).** A function should ideally do one or the other, not both.

## Domain vs Technical Code (Hexagonal Architecture)

- **Domain code should not change for technical reasons.** Separate domain logic (business rules, what you discuss with the product team) from technical concerns (HTTP, database, frameworks, external services).
- **Make technical code depend on domain code, never the reverse.** Use dependency injection to pass technical layers into domain code rather than having domain code instantiate them.

## Algorithms Over Raw Loops

- **Use standard library or built-in collection operations** (map, filter, reduce, any, all, find, sort) instead of hand-written loops.
- **Compose operations** (filter then map) rather than inventing custom combined ones.
- **If you need mutable state inside a callback, you may be using the wrong operation.** A counter inside `for_each` means you should use `count`. An accumulator means you should use `reduce`.
- **Declarative over imperative.** Describe what you want, not the steps to get there. Declarative code reads as a specification of the result; imperative code reads as a sequence of machine instructions. When the language or library offers a declarative form, prefer it.

## DRY (With Nuance)

- **DRY targets knowledge, not syntax.** Every piece of business knowledge should have a single representation, but syntactically identical code serving different domain concepts should remain separate.
- **Do not eliminate duplication that serves different business purposes.** Code that looks identical but represents different domain concepts has different lifecycles and changes for different reasons.
- **Premature DRY creates coupling worse than the duplication it removes.** Wait for patterns to emerge before abstracting.

## Comments

- **Do not comment WHAT or HOW -- the code should say that.** If code needs a comment to explain what it does, rewrite the code.
- **Comment the WHY**: why a design was chosen over alternatives, why a workaround exists, why a seemingly wrong approach is correct.
- **The best comment is no comment** because the code is clear enough.

## Conditionals and Control Flow

- **Extract complex conditions into well-named functions.** `is_valid(index)` is clearer than `index.has_id() and index.is_quoted() and index.is_liquid()`.
- **Use guard clauses for special/error cases** to reduce nesting and separate error handling from core logic.

## Testing

- **Name tests descriptively** to communicate what behavior is being validated, not just which function is called.
- **Keep test bodies small and focused.** Extract setup into well-named helpers.
- **Test observable behavior, not implementation details.** Do not assert on SQL strings, internal method calls, or which stdlib functions were used. If the implementation changed but the behavior stayed the same, the test should still pass.
- **Focus on high-value tests:** correct results for valid inputs, edge cases that have bitten you before, and failure modes that matter to users. Skip trivial inverse tests (if "failures show red" passes, "no failures means no red" adds nothing).
- **Do not write tests that merely confirm the code was written as-is.** "SQL contains keyword X" or "uses connect not begin" break on refactors and catch nothing.
- **One test per behavior.** If a test name includes "and", it is probably two tests -- but if both halves are trivial, it is probably zero tests.
