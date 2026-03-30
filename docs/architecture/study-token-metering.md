# Study Token Metering

## Purpose

This document records the deterministic pricing and reconciliation model introduced for Sprint 14.

## Estimation Rules

- Token estimates are computed from:
  - tokenizer-based input token counts
  - reserved output token ceilings
  - provider/model pricing entries
  - optional web-mode surcharges
- Estimation is arithmetic in product code, not another AI call.
- The client can show a user-facing message such as "about X study tokens" before send.

## Reconciliation Rules

- After the provider responds, actual input and output usage is reconciled against the estimate.
- The system computes a final token charge and a delta adjustment.
- Ledger adjustments must be idempotent and auditable.

## Ledger Rules

- Ledger entry kinds currently include purchase, spend, gift sent, gift received, and reconciliation adjustment.
- Duplicate references for the same transaction kind should not be double-applied.
- Token gifting in the messaging layer should reuse this ledger model plus the social event stream.
