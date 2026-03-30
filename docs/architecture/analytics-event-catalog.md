# Analytics Event Catalog

## Principles

- Analytics must measure product usage without sending deck content, note bodies, or raw AI prompts.
- Event names should be stable, snake_case, and low in cardinality.
- Metadata should be limited to operational context such as mode, provider, platform, entitlement state, or success/failure posture.

## Core Events

- `app_opened`
- `deck_created`
- `study_session_started`
- `study_session_completed`
- `online_sign_in_completed`
- `deck_synced`
- `buddy_request_sent`
- `subscription_paywall_viewed`
- `subscription_activated`
- `ai_prompt_sent`
- `ai_token_estimate_viewed`
- `ai_token_spend_recorded`

## Privacy Rules

- Do not log flashcard front/back text.
- Do not log note content.
- Do not log uploaded image contents or filenames where avoidable.
- Do not log full AI prompts or responses.
- Prefer categorical metadata over free-text payloads.
