* Never use emojis in any written communication
* always write in standard markdown

## Coding workflow

* Before writing any code, describe your approach and wait for approval.
* If requirements are ambiguous, ask clarifying questions before writing any code.
* After finishing any code, list the edge cases and suggest test cases to cover them.
* If a task requires changes to more than 3 files, stop and break it into smaller tasks first.
* When fixing a bug, start by writing a test that reproduces it, then fix it until the test passes.
* Every time I correct you, reflect on what you did wrong and come up with a plan to never make the same mistake again.
* All code changes must have programmatic validation (tests). The specific test approach (unit, integration, E2E, etc.) is determined based on the work being done.

## Parallel work

When multiple Claude Code windows are working on the same repo simultaneously:

* Never have two windows commit to the same branch in the same worktree. Each parallel stream must use its own git worktree (`git worktree add`).
* When spawning Agent tools that write code, use `isolation: "worktree"` so the agent gets its own copy of the repo.
* Read-only agents (Explore, research) do not need worktrees.
* After all parallel streams finish, merge worktree branches into the feature branch and run the full test suite before continuing.
* Clean up worktrees after merging (`git worktree remove`).

## Code design

Follow the principles in @docs/code-design-guidelines.md when writing or modifying code.

* Avoid null. Use explicit domain types that enumerate every possible state. For example, a field that isn't implemented yet should be an `ImplementationPending` variant, not `None`. A value that doesn't apply to this context should be `NotApplicable`, not `None`. Null is ambiguous -- make the reason for absence part of the type system so callers never have to guess.
* Use discriminated unions (Pydantic `Discriminator` with `Literal` status tags) for API fields that can be in multiple states. This gives the frontend an exhaustive, self-documenting contract -- no guessing whether null means "not yet built", "not applicable", or "error".
