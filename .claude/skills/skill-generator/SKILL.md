---
name: skill-generator
description: Create a new Claude Code skill from scratch. Use when the user says "create a skill", "make a skill", "build a skill", "new skill", or "write a skill for [task]".
version: 0.1.0
---

# Skill Generator

You help users create new Claude Code skills. A skill is a SKILL.md file that gives Claude specialized instructions and a trigger description so it knows when to activate.

## Process

Follow these steps:

### 1. Clarify the skill's purpose
Ask the user:
- What should the skill do? (one sentence)
- When should it trigger? (what prompts or keywords should activate it?)
- Should it be global (all projects) or project-specific?

If the user gives a short answer (e.g. "python, global"), use sensible defaults and proceed without asking follow-up questions:
- Default trigger: the skill name and common synonyms
- Default location: global (`~/.claude/skills/`)
- Default version: `0.1.0`

### 2. Choose the install location
- **Global** (`~/.claude/skills/<skill-name>/SKILL.md`) — available in every project
- **Project** (`.claude/skills/<skill-name>/SKILL.md`) — only in the current project

### 3. Write the SKILL.md

Use this format:

```markdown
---
name: <kebab-case-name>
description: <one sentence — what it does AND the trigger phrases/conditions>
version: 0.1.0
---

# <Skill Title>

<Instructions for Claude when this skill is active. Be specific about:>
- What to do step by step
- What tools to use
- What output to produce
- Any constraints or rules to follow
```

### 4. Key rules for good skills
- The `description` field is what Claude reads to decide whether to activate the skill — make it explicit about trigger phrases
- Instructions should be actionable, not vague
- Reference specific tools (Read, Write, Bash, Edit) when relevant
- Keep it focused — one skill, one job

### 5. Create the file
Use Bash to create the directory first: `mkdir -p ~/.claude/skills/<skill-name>`
Then use the Write tool to create the SKILL.md at the chosen location.
Tell the user:
- Where it was created
- What phrase will trigger it
- To run `/reload-skills` to activate it without restarting

### 6. Offer to test it
Suggest a test prompt the user can type to verify the skill triggers correctly.

## Example Skills

**Simple command skill:**
```markdown
---
name: git-summary
description: Summarize recent git activity. Triggers when user asks "what changed", "git summary", or "recent commits".
version: 0.1.0
---
# Git Summary
Run `git log --oneline -20` and `git diff --stat HEAD~5` and provide a concise summary of what changed and why.
```

**Multi-step workflow skill:**
```markdown
---
name: pr-prep
description: Prepare a pull request by running tests, checking diff, and drafting a PR description. Use when user says "prep PR", "prepare pull request", or "ready to merge".
version: 0.1.0
---
# PR Prep
1. Run the test suite
2. Show `git diff main...HEAD --stat`
3. Draft a PR title and description based on the commits
4. Ask if the user wants to push and open the PR
```
