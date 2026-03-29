# GradeFlip Product Access Matrix

## Purpose

This document defines the monetization and capability matrix delivered by Sprint 3.

## Product Layers

GradeFlip separates access into three independently-modeled layers:

1. Paid core unlock
2. Online monthly subscription
3. AI study token packs

The app must never assume that a subscription includes AI usage, and it must never assume that AI token ownership unlocks subscription-only social features.

## App Modes

`GradeFlipAppMode` is the top-level presentation model:

- `locked`
- `offlineCore`
- `onlineUpsell`
- `onlineSubscriber`

These modes are derived from:

- paid-core entitlement
- account state
- subscription state

## Capability Matrix

| Capability | Paid Core | Account | Subscription | Tokens |
|---|---|---|---|---|
| `offlineDecks` | Required | No | No | No |
| `onlineSync` | Required | Required | Required | No |
| `studyBuddies` | Required | Required | Required | No |
| `messaging` | Required | Required | Required | No |
| `friendStreaks` | Required | Required | Required | No |
| `spendAITokens` | Required | No | No | Required |
| `webEnabledAI` | Required | No | No | Required |

## Placeholder Product IDs

The current placeholder StoreKit-facing catalog is:

- `com.gradeflip.app.core`
- `com.gradeflip.subscription.online.monthly`
- `com.gradeflip.tokens.study.25`
- `com.gradeflip.tokens.study.100`

These are intentionally placeholders and can be replaced later without changing the capability model.

## Purchase Surface Rules

Each locked capability maps to a lock reason:

- `paidCoreRequired`
- `accountRequired`
- `onlineSubscriptionRequired`
- `studyTokensRequired`

The app should present a purchase or sign-in surface from that lock reason instead of sprinkling raw entitlement checks throughout the UI.

## StoreKit Planning Rule

Sprint 3 provides the product catalog and purchase-surface scaffolding. Final StoreKit 2 runtime integration, sandbox validation, and App Store product activation still belong to later Apple-platform implementation and launch work.
