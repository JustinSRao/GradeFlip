---
sprint: 14
title: "Web-enabled AI chat, study tokens, gifting, and usage metering"
type: fullstack
epic: 5
status: planning
created: 2026-03-26T16:02:34Z
started: null
completed: null
hours: null
workflow_version: "3.1.0"
---

# Sprint 14: Web-enabled AI chat, study tokens, gifting, and usage metering

## Overview

| Field | Value |
|-------|-------|
| Sprint | 14 |
| Title | Web-enabled AI chat, study tokens, gifting, and usage metering |
| Type | fullstack |
| Epic | 5 |
| Status | Planning |
| Created | 2026-03-26 |
| Started | - |
| Completed | - |

## Goal

Implement web-enabled AI chat billing, study token balances, gifting flows, and a deterministic usage-metering system that estimates cost without making a separate AI call.

## Background

The AI assistant is part of both the offline and online GradeFlip experience, but it needs a billing layer that users can understand and that protects product margins across multiple AI providers. If token estimation itself required another model call, every estimate would create avoidable cost and complexity. This sprint formalizes a token economy based on pricing tables, token counts, and post-response reconciliation instead.

## Requirements

### Functional Requirements

- [ ] Users can invoke AI chat in web-enabled mode when they have access to that mode
- [ ] Users can purchase and hold study tokens as an internal app currency for AI usage
- [ ] Users can gift study tokens to friends, with gift events appearing in the messaging experience
- [ ] The backend can estimate the study-token cost of a request before sending it to a provider
- [ ] The estimate must be computed from pricing rules, tokenizer counts, and configured surcharges, not by calling another AI model
- [ ] The backend can reconcile estimated cost against actual provider usage after the response is received
- [ ] The system can support provider-specific pricing differences for ChatGPT, Claude, Gemini, Grok, and DeepSeek
- [ ] Users can see a pre-send estimate such as "about X study tokens" before submitting a request
- [ ] The system records token debits, credits, gifts, and reconciliations in an auditable ledger

### Non-Functional Requirements

- [ ] Estimation must add negligible latency compared with the model request itself
- [ ] Pricing logic must be centrally configurable without client updates for every provider price change
- [ ] Ledger operations must be idempotent and safe against duplicate charges
- [ ] The system must preserve margin by avoiding systematic undercharging across providers
- [ ] The design must remain explainable enough to show predictable user-facing token estimates

## Dependencies

- **Sprints**: 11, 13
- **External**: Provider pricing data, tokenizer utilities, payment/product design decisions for token packs

## Scope

### In Scope

- Web-enabled AI usage mode
- Study-token balance model and transaction ledger
- Gift-token flow and message-surface event handling
- Deterministic estimation rules based on token counts and pricing tables
- Actual-usage reconciliation after provider responses
- Provider/model pricing abstraction and surcharge rules

### Out of Scope

- Final marketing copy and pricing amounts for token packs
- Building every provider integration from scratch if Sprint 13 has not already provided the abstraction layer
- Subscription pricing decisions unrelated to AI token consumption

## Technical Approach

Maintain a server-side pricing catalog keyed by provider and model, with input-token price, output-token price, optional cached-input rules, and feature surcharges such as web retrieval or image handling. Before dispatching a user request, count input tokens with the matching tokenizer, reserve an expected output ceiling, compute a preliminary cost, and convert that cost to internal study tokens using the app's pricing multiplier. Present that value as an estimate to the user.

When the provider returns, read actual usage from the provider response, compute the actual cost, and reconcile the transaction in the ledger. The product can either pre-authorize a maximum estimated token hold and settle the final amount afterward, or charge the estimate first and apply a corrective adjustment entry. The critical rule is that estimation is arithmetic performed in product code, not another LLM call.

## Tasks

### Phase 1: Planning

- [ ] Define the study-token ledger model and transaction types
- [ ] Define pre-send estimation inputs and reconciliation rules
- [ ] Define how token gifts surface in messaging

### Phase 2: Implementation

- [ ] Implement pricing catalog and model-capability configuration
- [ ] Implement tokenizer-based estimation logic and surcharge rules
- [ ] Implement token ledger entries for purchase, spend, gift, refund, and reconciliation
- [ ] Implement pre-send estimate responses for the client
- [ ] Implement post-response reconciliation against actual provider usage

### Phase 3: Validation

- [ ] Verify estimates stay within an acceptable variance from actual charges
- [ ] Verify duplicate requests cannot double-charge the same AI event
- [ ] Verify gift and spend history is auditable

### Phase 4: Documentation

- [ ] Document the token-pricing formula, rounding rules, and reconciliation behavior

## Acceptance Criteria

- [ ] AI request estimates are computed without calling an AI model for estimation
- [ ] A user can see an approximate study-token cost before sending a request
- [ ] Actual provider usage reconciles correctly into the token ledger
- [ ] Token gifts appear as ledger-backed events suitable for the messaging tab
- [ ] Pricing configuration can vary by provider and model without client-side logic changes

## Notes

Created: 2026-03-26
