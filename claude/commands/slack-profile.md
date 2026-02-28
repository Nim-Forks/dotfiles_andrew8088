---
name: slack-profile
description: Generate a comprehensive profile of a Slack user from their message history
args:
  - name: person
    description: Name or username of the person to profile (e.g. 'chandra', 'andrew.burgess')
    required: true
---

Build a comprehensive profile of **{{person}}** by mining their Slack message history. Use the slack-curl wrapper at `/Users/andrew/.claude/plugins/cache/dojo-plugins/slack/1.0.0/bin/slack-curl.sh` for all API calls.

## Phase 1: Find the User

Search `users.list` for a user matching "{{person}}" by name, display_name, or real_name. Extract their Slack username (the `name` field) and user ID. Then fetch their full profile via `users.info`.

## Phase 2: Run Searches

Use `search.messages` with `from:<username>` queries. URL-encode query parameters. Sleep isn't needed — just run them.

Run ALL of the following searches. Use `count=50` and `sort=timestamp` unless noted. Capture the total count and message text (truncated to 300 chars) plus channel name and timestamp for each.

### Tenure & Volume
1. `from:<username>` with `sort_dir=asc` — earliest messages (start date)
2. `from:<username>` with `sort_dir=desc` — recent messages
3. `from:<username>` with `count=100` — extract channel distribution from results

### What They Work On
4. `from:<username> PR OR pull request OR merge` — code contributions
5. `from:<username> deploy OR canary OR precanary OR production` — deploy activity
6. `from:<username> test OR testing OR cypress OR playtest OR fixture` — testing
7. `from:<username> migration OR backfill OR database OR query OR mongo OR mysql` — data work
8. `from:<username> refactor OR architecture OR design OR pattern OR module` — architecture
9. `from:<username> alert OR monitor OR dashboard OR datadog OR sentry` — observability
10. `from:<username> experiment OR A/B OR feature switch OR feature flag` — experimentation

### How They Think & Communicate
11. `from:<username> I think we should OR suggestion OR proposal OR we could` — proposals
12. `from:<username> FYI OR heads up OR I fixed OR just merged` — proactive ownership
13. `from:<username> pair OR pairing OR mob OR huddle` — collaboration style
14. `from:<username> doc OR notion OR runbook OR wrote up` — documentation habits
15. `from:<username> how do I OR anyone know OR does anyone OR can someone` — help-seeking
16. `from:<username> stuck OR blocked OR confused OR stumped OR not sure` — struggles
17. `from:<username> bug OR debug OR investigate OR broken OR error` — debugging

### How Others See Them
18. `"<display_name>" in:outward-shouts` — public recognition
19. `"<display_name>" kudos OR thank OR great OR awesome OR shoutout` — praise from others

### Personal
20. `from:<username> childcare OR sick OR vacation OR daughter OR son OR family` — life context

For each search, also run the same search scoped to their most active channels (from the channel distribution) to get deeper signal. Do `from:<username> in:<channel>` for the top 3-5 channels.

## Phase 3: Synthesize

Write a markdown file to `./people/<first_name_lowercase>-profile.md` with the following sections. DO NOT just dump raw messages — synthesize, analyze, and identify patterns. Quote specific messages as evidence.

### Structure:

```
# <Full Name> — Profile

## Basics
Table with: name, title, timezone, slack ID, total messages, start date

## Team History & Domain Expertise
Identify which teams they've been on based on channel activity and message content.
For each team/phase: what they worked on, key projects, timeline.

## Personality & Communication Style
- Tone (formal/casual, humor, emoji usage)
- Decision-making style (cautious/bold, consensus-seeking/independent)
- Collaboration patterns (do they seek pairing? propose mob sessions? work solo?)
- Transparency (do they share when stuck? or go quiet?)

## Technical Strengths
Identify 5-8 strengths with specific message evidence for each.
Look for patterns like:
- What do they proactively fix or improve?
- What topics do they confidently answer others' questions on?
- Where do they show good judgment or architectural thinking?
- What do others praise them for?

## Technical Weaknesses
Identify 5-8 weakness areas with specific message evidence for each.
Look for patterns like:
- What do they repeatedly ask for help with?
- Where do they make mistakes or break things?
- What topics do they avoid or defer to others on?
- Where do they get stuck longest?

## Key Collaborators
Who do they interact with most? Who do they pair with? Who do they go to for help?

## Personal
Family context, timezone habits, anything that affects their work patterns.

## Overall Assessment
2-3 paragraph synthesis of who this person is as an engineer.
```

## Important

- Be thorough. Run ALL the searches. The raw data is the foundation — don't skip searches to save time.
- Quote specific messages as evidence for every claim. Use the format: `"message text" — #channel`
- Identify PATTERNS, not one-offs. A single message isn't a strength or weakness. Look for repeated behaviors.
- Be honest and direct. Don't soften weaknesses into strengths. Don't manufacture issues where none exist.
- The goal is a document that someone could use for a performance review, team placement decision, or mentoring plan.
