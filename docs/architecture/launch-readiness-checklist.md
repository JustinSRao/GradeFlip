# Launch Readiness Checklist

## Offline Core

- Deck CRUD works end to end.
- Per-card notes work end to end.
- Image attachment flows work end to end.
- Study flows exist for phone, iPad, and Mac layouts.
- Protected local storage defaults are documented.

## Online Layer

- Sign-in and session models exist.
- Sync planning and conflict rules are documented.
- Social event model covers requests, shares, likes, and token gifts.
- Subscription entitlements and streak rules are documented.

## AI Layer

- Provider abstraction supports the planned multi-provider model list.
- Deck grounding is deterministic.
- Web-enabled estimation is arithmetic, not another model call.
- Token ledger and reconciliation models exist.

## Launch Assets

- App Store listing copy exists.
- Privacy disclosures exist.
- Analytics event catalog exists.
- Screenshot capture plan exists.

## Final Validation

- Shared Swift package tests pass on Windows.
- Apple runtime validation remains required on macOS before release submission.
- Signing, TestFlight, and App Store Connect setup still require a Mac environment.
