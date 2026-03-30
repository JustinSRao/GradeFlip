# GradeFlip Development and Testing Environments

## Purpose

This document defines what can and cannot be validated from a Windows-based development machine for GradeFlip, and what environment is required before the app is considered release-ready.

## Working Assumption

GradeFlip is being developed from VS Code on Windows, but the shipping product is a native Apple app for:

- iPhone
- iPad
- macOS

That means the project should stay friendly to Windows-based planning and implementation work where possible, while acknowledging that Apple runtime validation still requires macOS.

## What Windows Can Cover

Windows is acceptable for:

- backlog and sprint planning
- documentation and architecture work
- backend and service code that does not depend on Apple SDK runtimes
- shared Swift package authoring where the toolchain supports it
- repo automation, linting, and non-Apple workflow scripts

Windows is also a practical place to scaffold app structure, even when the final Apple app target cannot be executed locally.

## What Windows Cannot Reliably Cover

Windows is not a native environment for:

- iOS Simulator
- iPadOS Simulator
- macOS app execution
- Xcode builds
- App Store packaging and submission validation

Emulating an Apple device on Windows is not a realistic release workflow for this project. It would still leave major gaps in SDK behavior, signing, StoreKit behavior, accessibility verification, and platform UI correctness.

## Required Apple Validation Path

Before GradeFlip is considered release-ready, the project needs access to one of these:

1. A local Mac with Xcode and Apple simulators
2. A remote Mac used for builds and simulator/device testing
3. macOS CI capable of building, testing, archiving, and signing the app

For practical purposes, a real Mac environment should be treated as required infrastructure for the later UI, StoreKit, and release sprints.

## Repository Rule

Every sprint should improve one or both of these:

- shared code that can be developed from Windows
- Apple app scaffolding that can later be exercised on macOS without rework

The repo should not accumulate isolated package work that leaves the eventual app target behind.

## Release Readiness Standard

The final project should include:

- buildable Apple app targets
- platform-specific QA coverage for iPhone, iPad, and Mac
- StoreKit and entitlement validation on Apple tooling
- App Store submission materials and privacy metadata

Windows remains a valid authoring environment, but not the sole validation environment for release.

## Optional Windows Preview Harness

If a Windows-runnable preview harness is added later, it should be treated as:

- a local development aid
- a smoke-test surface for interaction checks
- a supplement to shared-package tests

It should not be treated as evidence that iPhone, iPad, or macOS runtime behavior has been validated for release.
