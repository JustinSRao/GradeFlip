# GradeFlipAI

This package will host AI orchestration for GradeFlip.

Planned responsibilities:

- provider abstraction
- deck-grounded context building
- web-enabled AI orchestration
- request usage metadata capture
- pricing-input preparation for token estimation

Current implementation:

- shared provider and model catalog for ChatGPT, Claude, Gemini, Grok, and DeepSeek
- deck-grounding package builder using selected GradeFlip decks
- deterministic study-token estimation and post-response reconciliation
- token ledger primitives for purchase, spend, gift, and adjustment entries
