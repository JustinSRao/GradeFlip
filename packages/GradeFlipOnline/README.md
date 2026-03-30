# GradeFlipOnline

This package will host backend-facing services for GradeFlip's online mode.

Planned responsibilities:

- authentication
- cloud sync
- study buddy relationships
- messaging events
- deck sharing and likes
- streak tracking
- cloud storage integration

Current implementation:

- backend selection contract with a recommended `Supabase + PostgreSQL` profile
- auth account and session models
- local/cloud sync planning with conflict suggestions
- study buddy request, relationship, share, request, like, and social-event models
- subscription entitlement mapping and deterministic streak calculation
