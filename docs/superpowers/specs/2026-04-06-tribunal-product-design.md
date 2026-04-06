# Tribunal — Product Design Specification

**Date:** April 6, 2026
**Status:** Approved — ready for implementation planning
**Author:** Product planning session (human + AI collaboration)

---

## Table of Contents

1. [Product Overview](#1-product-overview)
2. [Product Positioning](#2-product-positioning)
3. [Target Audience](#3-target-audience)
4. [Brand Identity](#4-brand-identity)
5. [Courtroom Metaphor Guidelines](#5-courtroom-metaphor-guidelines)
6. [Core Feature Set](#6-core-feature-set)
7. [User Flows](#7-user-flows)
8. [UX and UI Specification](#8-ux-and-ui-specification)
9. [Information Architecture](#9-information-architecture)
10. [Trust, Safety, and Credibility](#10-trust-safety-and-credibility)
11. [Technical Architecture](#11-technical-architecture)
12. [Platform Strategy](#12-platform-strategy)
13. [Monetization Strategy](#13-monetization-strategy)
14. [Competitive Positioning](#14-competitive-positioning)
15. [Implementation Phases](#15-implementation-phases)

---

## 1. Product Overview

**Name:** Tribunal

**One-sentence pitch:** Paste any claim, watch it go to trial.

**What it is:** A structured claim analysis tool that frames every input as a courtroom hearing — with prosecution, defense, evidence weighing, and a verdict — turning the casual "is this bullshit?" instinct into a satisfying, repeatable experience.

**What it is not:**
- Not a fact-checker (too much implied authority)
- Not a chatbot (too unstructured)
- Not a summarizer (summaries condense; Tribunal cross-examines)

**Product shape:** The Analysis Session — fast input, streaming courtroom hearing that unfolds in real time, auto-saved case library that builds without effort. Each use feels like an event, not a transaction.

**Closest analog:** Wolfram Alpha's relationship to calculators — same input (a question), radically different output structure and depth.

---

## 2. Product Positioning

### Why someone would use this instead of asking ChatGPT

- ChatGPT gives an essay. Tribunal gives a **structured adversarial analysis** — prosecution AND defense, not just "here's what I think."
- ChatGPT doesn't explicitly flag rhetorical tricks, evidence gaps, or confidence levels.
- ChatGPT doesn't save and organize analyses into a searchable case library.
- The courtroom framing forces the AI to argue both sides, which a neutral chatbot avoids.
- The output format is scannable and shareable, not a wall of text.

### Emotional hook

The satisfaction of watching a viral claim get cross-examined. The feeling of "I knew something was off about that" — validated and articulated.

### Product category

Critical thinking tool / structured AI analysis.

### Why now

- LLMs are strong enough at structured reasoning to produce genuinely useful adversarial analysis
- Trust in media and online content is at historic lows — people want tools, not opinions
- AI-native apps are an emerging App Store category
- GPT-5.4 family is specifically strong at nuanced reasoning — output quality can carry the product

### The difference between a toy and a real product

A toy gives a funny verdict and you close it. A real product makes you want to test another claim. The difference is:
- **Output quality** — does the analysis surface things you didn't notice?
- **Structural clarity** — can you scan it in 15 seconds?
- **Accumulation effect** — does the case library become interesting over time?

If the analysis is genuinely insightful, it's a product. If it's GPT in a gavel costume, it's a toy.

---

## 3. Target Audience

### Primary: The "Is This Bullshit?" Skeptic

Someone who sees a viral post or headline and wants a quick, structured teardown. Casual, curiosity-driven. Uses it a few times a week when something smells off.

### Secondary audiences (served but not optimized for in v1)

- **The Hobbyist Analyst** — actively enjoys dissecting claims as entertainment (UFO content, conspiracy threads, political rhetoric). High frequency, collects cases.
- **The Content Creator / Debunker** — needs structured analysis for content production (YouTube, podcast, newsletter). Needs export and shareability.
- **The Educator** — media literacy advocate who wants to demonstrate claim evaluation.

### Day-one user profile

Tech-savvy Mac users who already use AI tools. Comfortable pasting an API key. The kind of people who use Arc, Raycast, and have opinions about typefaces. The app should not require this sophistication long-term, but it's the launch audience.

---

## 4. Brand Identity

### Direction: Modern Skeptic

Clean, contemporary, Apple-native. The courtroom metaphor lives in the language and structure, not the visual chrome.

### Visual vibe

Like the NYT Opinion section crossed with a premium macOS utility. Sharp typography, great spacing, a single warm accent. The restraint IS the personality.

### Typography

- **Headers:** SF Pro Display (system). One serif accent (Georgia or New York) for legal moments — verdict headers, case numbers.
- **Body:** SF Pro Text (system).
- **Monospace:** SF Mono for case IDs and technical details.

### Color palette

| Role | Color | Usage |
|------|-------|-------|
| Background | Zinc/near-black (`#18181b`) | Primary surface |
| Surface | Slightly lighter (`#111114`) | Sidebar, cards |
| Text primary | Off-white (`#f5f5f5`) | Body text, headers |
| Text secondary | `rgba(245,245,245,0.4)` | Labels, timestamps |
| Accent (warm) | Amber/cognac (`#d4a574`) | Buttons, links, interactive elements |
| Verdict: Supported | Green (`#22c55e`) | Verdict badge only |
| Verdict: Mixed/Insufficient | Amber (`#f59e0b`) | Verdict badge only |
| Verdict: Unsupported/Disproven | Red (`#ef4444`) | Verdict badge only |
| Prosecution marker | Red (`#ef4444`) | Section indicator bar |
| Defense marker | Blue (`#3b82f6`) | Section indicator bar |
| Evidence gaps marker | Amber (`#f59e0b`) | Section indicator bar |

- Dark mode is the default.
- Light mode supported (respect system appearance setting).
- Verdict colors used sparingly — just badges and sidebar labels.

### Icon/logo direction

Abstract scales or gavel — geometric, not literal. SF Symbols weight, not clip art. Gold/amber on dark background.

### Motion and interaction

- Native SwiftUI springs and transitions.
- Content reveals that feel like opening a folder.
- Streaming text IS the primary animation.
- No bouncy animations, no gavel sounds, no theatrics.
- Subtle, fast, never distracting.

---

## 5. Courtroom Metaphor Guidelines

### Calibration: Medium-light

The metaphor is structural and linguistic, not visual or decorative.

### Use the metaphor for

| Element | Term | Rationale |
|---------|------|-----------|
| An analysis session | **Hearing** | Implies process, not finality. Less heavy than "trial." |
| A saved analysis | **Case** | Universally understood. Natural for a library. |
| Output sections | **Prosecution / Defense** | The adversarial framing IS the differentiator. |
| The conclusion | **Verdict** | Clear, satisfying, the payoff moment. |
| Confidence qualifier | **Confidence level** | Plain language. Not "beyond reasonable doubt." |
| What would change outcome | **What Would Change the Verdict** | Natural, useful, clear. |
| Case identifier | **Case #YYYY-MMDD-NNN** | Adds texture without weight. Auto-generated. |
| Main action button | **Open Hearing** | Sets tone on every use. |

### Do not use the metaphor for

| Avoid | Reason |
|-------|--------|
| "Docket" for case library | Too jargon-y. "Cases" or "Library" is clearer. |
| "Your Honor" or role-play language | Crosses into gimmick territory. |
| Judge character / avatar | The app IS the judge. Personifying it cheapens output. |
| "Exhibit A, B, C" for evidence items | Cute once, annoying on the 10th use. |
| Gavel animations or sound effects | One-time novelty, long-term annoyance. |
| "Court is now in session" loading text | Gets stale. A subtle pulse indicator is better. |
| "Sustained" / "Overruled" for follow-ups | Forces metaphor where it doesn't add clarity. |

### Guiding principle

The courtroom metaphor should make the output more understandable, not more theatrical. "Prosecution" and "Defense" are genuinely clearer than "Arguments For" and "Arguments Against" because they imply adversarial rigor. The moment the metaphor makes something less clear or more cute, drop it.

---

## 6. Core Feature Set

### Phase 1 (v1) — The Minimum Compelling Product

| Feature | Description | Priority |
|---------|-------------|----------|
| **Paste-and-analyze** | Paste text, URL, or typed claim. One input, one action. | Must-have |
| **Courtroom session output** | Structured sections: Claim Summary, Prosecution, Defense, Evidence Gaps, Rhetorical Analysis, What Would Change the Verdict, Final Verdict + Confidence | Must-have |
| **Streaming output** | Sections stream in sequentially, creating the "hearing unfolds" feel | Must-have |
| **Auto-saved case library** | Every completed analysis saves automatically with timestamp, claim summary, verdict | Must-have |
| **Case detail view** | Tap a saved case to review the full session | Must-have |
| **API key setup** | Settings screen to enter OpenAI API key with Keychain storage | Must-have |
| **Confidence labeling** | Every verdict includes confidence level (High / Moderate / Low / Insufficient) with explanation | Must-have |
| **Copy/share verdict** | Copy full analysis or verdict summary as formatted text | Must-have |
| **Delete cases** | Remove cases from the library | Must-have |
| **Model selection** | Choose between gpt-5.4-mini (default) and gpt-5.4 in settings | Nice-to-have |
| **Keyboard shortcuts** | ⌘+Return to submit, ⌘+N for new hearing | Nice-to-have |
| **Token usage display** | Show token count per case for cost awareness | Nice-to-have |

### Phase 2 (v1.5) — Depth and Polish

| Feature | Description |
|---------|-------------|
| **URL content extraction** | Auto-fetch and parse article content from a pasted URL (native, not LLM-dependent) |
| **Screenshot/image input** | Paste or drop a screenshot, OCR via GPT-5.4 vision, analyze the claim |
| **Follow-up questioning** | After a verdict, ask "What if X?" or "What about Y?" — conversational layer |
| **Rhetoric/fallacy inline tagging** | Specific fallacies tagged inline with individual labels and explanations (strawman, appeal to authority, etc.) — upgrading the v1 prose section to structured, clickable tags |
| **Source quality grading** | Rate cited sources on a quality scale (peer-reviewed → news → blog → anonymous) |
| **Case search and filtering** | Search saved cases by keyword, verdict, date, confidence level |
| **Export as PDF/Markdown** | Export a case as a formatted document |
| **Per-hearing model toggle** | Choose model per hearing, not just globally |
| **"What is unknown vs. unsupported vs. disproven"** | Explicit three-way classification in the verdict section |

### Phase 3 (Future / Stretch)

| Feature | Notes |
|---------|-------|
| Side-by-side claim comparison | Compare two competing claims on the same topic |
| "Bullshit detector" training mode | App presents claims, user guesses verdict before reveal |
| Claim tracking / "case reopened" | Re-analyze when new information emerges |
| Multi-provider support (Claude, Gemini, local) | Architecture supports it from v1; UI exposes it later |
| Social sharing cards | Generate image cards with verdict for social media |
| Browser extension companion | Highlight text on any page, send to Tribunal |
| Collaborative cases | Share case links (requires backend) |
| CloudKit sync | Sync cases across devices |
| iPad and iPhone apps | Expand from macOS |

### Explicitly excluded from all near-term phases

- User accounts / authentication
- Any server-side component you operate
- Community features
- Onboarding tutorial (if the app needs one, the UX is wrong)

---

## 7. User Flows

### Flow 1: First Launch

1. App opens → clean empty state with Tribunal wordmark and centered input area
2. User sees placeholder: "Paste a claim, link, or text to open a hearing"
3. User submits → app detects no API key → slides to Settings with focused setup
4. Settings shows: "Tribunal uses OpenAI to analyze claims. Paste your API key to get started." with direct link to OpenAI's API key page
5. Key entered → validated with a lightweight test call → confirmed → returns to input
6. User submits their first claim → first hearing begins

**Friction point:** The API key step. Mitigate with clear copy, a direct link to OpenAI's key page, and a "Why do I need this?" expandable explanation.

### Flow 2: Analyzing a Pasted Text Claim

1. User pastes text or types a claim into the input field
2. Hits "Open Hearing" button or ⌘+Return
3. View transitions to the session screen
4. Sections stream sequentially: Claim Summary → Prosecution → Defense → Evidence Gaps → Rhetorical Analysis → What Would Change the Verdict → Final Verdict
5. Streaming indicator shows the LLM is still working between sections
6. Session completes → verdict badge appears with confidence level
7. Case auto-saves to sidebar library

**Friction point:** None if prompt engineering is solid. The streaming IS the experience.

### Flow 3: Analyzing a URL (v1)

1. User pastes a URL into the input field
2. App includes the URL in the prompt (GPT-5.4 can process URLs)
3. Same session flow as Flow 2
4. Case saves with the URL stored as metadata

**Friction point:** LLM URL fetching can be unreliable. v1.5 adds native content extraction as a fallback/upgrade.

### Flow 4: Reviewing a Completed Case

1. User clicks a case in the sidebar library
2. Full session loads in the detail view
3. User scrolls through all sections
4. Can copy text or trigger share from the verdict card

**Friction point:** None.

### Flow 5: Saving and Revisiting

1. Cases auto-save on session completion. No save button. No prompt.
2. Library is always visible in the sidebar
3. Data persists locally via SwiftData
4. User can delete unwanted cases via right-click or swipe

**Friction point:** No organization beyond chronological in v1. v1.5 adds search/filter.

### Flow 6: Sharing a Case

1. From completed case, user clicks share button or uses keyboard shortcut
2. Options: Copy Full Analysis (Markdown), Copy Verdict Summary, macOS Share Sheet
3. Formatted text lands on clipboard

**Friction point:** Text-only in v1. No image cards. Adequate for early adopters.

---

## 8. UX and UI Specification

### App Structure

**Pattern:** macOS two-column `NavigationSplitView` (sidebar + detail).

**Window:**
- Resizable
- Minimum size: ~800×600
- Default size: ~1100×750
- Sidebar collapsible via toolbar button or ⌘+S (standard macOS behavior)

### Key Screens

#### Sidebar

- **App title** ("Tribunal") at top
- **"+ New Hearing" button** — prominent, uses accent color (amber)
- **"Recent Cases" section label** — small, uppercase, muted
- **Case list items** — each shows:
  - Claim summary (truncated to one line)
  - Date
  - Verdict badge (color-coded: green/amber/red)
- **Settings link** at bottom

#### Input State (Detail Panel — No Active Case)

- Centered layout
- Tribunal wordmark in serif font
- Subtitle: "Paste a claim, link, or text to open a hearing"
- Large text input area (multi-line, resizable)
- "Open Hearing ⌘↵" button in accent color
- This is the home screen. No dashboard, no landing page.

#### Active Session State (Detail Panel — Hearing in Progress)

- **Case header:** Case number, claim text in serif, timestamp, input type
- **Sections stream in order, each with:**
  - Colored left-border indicator (red for prosecution, blue for defense, amber for evidence gaps)
  - Section label (bold)
  - Content (body text, streaming in)
- **Streaming indicator:** Small pulsing dot with italic text ("Analyzing rhetorical techniques...")
- Evidence gaps rendered as individual cards with left-border accent

#### Completed Session State (Detail Panel — Hearing Complete)

- All session sections visible and scrollable
- **Verdict card** at the bottom:
  - Verdict badge (e.g., "UNSUPPORTED" in red, serif font)
  - Confidence level label
  - Verdict summary paragraph
  - "What Would Change the Verdict" block (blue-accented)
  - Action links: Copy Analysis, Copy Verdict, Share

#### Settings Screen

- Accessible from sidebar footer
- **API Configuration:**
  - OpenAI API key field (secure entry, Keychain-backed)
  - Key validation status indicator
  - Link to OpenAI API key page
- **Model Selection:**
  - Picker: gpt-5.4-mini (default, recommended) / gpt-5.4 (deeper analysis)
- **Appearance:**
  - System / Dark / Light toggle
- **About:**
  - App version
  - Trust disclaimer: "Tribunal uses AI to structure claim analysis. It is not a fact-checker, court of law, or source of truth."

### State Design

| State | Behavior |
|-------|----------|
| **Empty library** | Sidebar shows soft placeholder: "Your case library will appear here" |
| **Loading / streaming** | Streaming text IS the loading state. Pulsing dot indicator between sections. |
| **Error (API)** | Inline in detail panel where content would stream: "Hearing could not proceed — check your API key or connection." Retry button. |
| **Error (no key)** | Redirects to Settings with focused API key field |
| **Error (network)** | Inline: "No connection. Tribunal requires internet access to conduct hearings." |

### Navigation Model

- **Primary:** Sidebar selection drives detail panel content
- **New hearing:** Clears detail panel to input state (or opens in current detail if no active session)
- **No tabs, no modal dialogs, no multi-window** in v1
- Standard macOS menu bar integration (File > New Hearing, Edit > Copy, etc.)

---

## 9. Information Architecture

### Data Entities

```
User Settings (singleton, persisted in UserDefaults + Keychain)
├── apiKey: String (Keychain — never plain text, never UserDefaults)
├── defaultModel: String ("gpt-5.4-mini" | "gpt-5.4")
├── appearance: AppearanceMode (system | dark | light)
└── hasCompletedSetup: Bool

Case (core entity, persisted in SwiftData)
├── id: UUID
├── caseNumber: String (format: "YYYY-MMDD-NNN", auto-generated)
├── createdAt: Date
├── status: CaseStatus (inProgress | completed | failed)
├── input
│   ├── type: InputType (text | url)
│   ├── rawContent: String (the original pasted input)
│   └── sourceURL: URL? (if input was a URL)
├── claimSummary: String (LLM-extracted short summary of the claim)
├── session
│   ├── prosecution: String
│   ├── defense: String
│   ├── evidenceGaps: [String] (array of individual gap descriptions)
│   ├── rhetoricalAnalysis: String (prose analysis of techniques used)
│   ├── whatWouldChange: String
│   └── verdict
│       ├── judgment: VerdictJudgment
│       │   (supported | mostlyTrue | mixed | insufficientEvidence
│       │    | unsupported | disproven)
│       ├── confidence: ConfidenceLevel (high | moderate | low | insufficient)
│       ├── summary: String (one-paragraph explanation)
│       └── unknowns: [String] (explicitly unresolved items)
├── modelUsed: String (which GPT model produced this)
├── tokenUsage
│   ├── promptTokens: Int
│   └── completionTokens: Int
└── rawResponse: String (full API response for debugging, optional)
```

### Key Relationships

- A **Case** is the atomic unit. Everything revolves around it.
- Cases are independent — no cross-referencing in v1.
- The **Session** is embedded in the Case, not a separate entity. One case = one session.
- **User Settings** is a singleton. No accounts, no profiles.
- All data is local. No sync, no server, no cloud storage.

### Verdict Judgment Scale

This is intentionally NOT binary true/false:

| Judgment | Meaning |
|----------|---------|
| **Supported** | Strong evidence in favor, no significant counter-evidence |
| **Mostly True** | Core claim holds, but with caveats or missing nuance |
| **Mixed** | Substantial evidence on both sides |
| **Insufficient Evidence** | Not enough information to evaluate meaningfully |
| **Unsupported** | No strong evidence in favor; counter-evidence exists |
| **Disproven** | Clear, well-established evidence contradicts the claim |

### Confidence Scale

| Level | Meaning |
|-------|---------|
| **High** | Well-studied topic, strong consensus, clear evidence |
| **Moderate** | Evidence exists but is incomplete, contested, or evolving |
| **Low** | Limited evidence, highly contested, or novel claim |
| **Insufficient** | Cannot meaningfully assess confidence |

---

## 10. Trust, Safety, and Credibility

### Core principle

Tribunal should feel like a sharp analyst who knows what they don't know — not an oracle that pretends to have answers.

### Uncertainty communication

- Every verdict displays a **confidence level** prominently — not buried in text
- The **Insufficient** level exists for cases where no meaningful judgment is possible
- The verdict scale avoids binary true/false (see section 9)
- "What Would Change the Verdict" explicitly models what evidence doesn't exist yet

### Source transparency

- The LLM prompt instructs the model to cite specific sources by name when possible
- The model must flag when reasoning from general knowledge vs. specific evidence
- v1.5 adds source quality grading (peer-reviewed → news → blog → anonymous)

### Handling weak evidence

- If a claim is too vague: "This claim is too broad for meaningful analysis. Try a more specific version."
- If evidence is overwhelmingly one-sided, the Defense section still exists but states: "The defense finds limited grounds for this claim. The strongest available argument is..."
- The app never manufactures a balanced-looking debate where none exists

### Evidence labeling (v1.5)

Inline labels in output text:
- `[Verified]` — established fact, widely corroborated
- `[Inference]` — logical conclusion drawn from available evidence
- `[Speculation]` — plausible but not evidence-based
- `[Unknown]` — explicitly unresolved

### Political and conspiratorial content

- The app analyzes, not editorializes. The courtroom frame ensures both sides speak.
- For politically charged content, Evidence Gaps and Rhetorical Tricks do the heavy lifting without the app taking a position.
- Conspiracy content is a **core use case**, not an edge case. Handle with the same rigor as a science claim.
- **No content refusal.** If someone wants to analyze a flat earth claim, the app does it well. The value is in analysis quality, not in refusing to engage.

### Preventing overconfidence

- Never says "this is true" or "this is false" — only "the available evidence supports/does not support this claim"
- Confidence level and "What Would Change" are structural guardrails
- Persistent disclaimer in Settings/About: "Tribunal uses AI to structure claim analysis. It is not a fact-checker, court of law, or source of truth. All analyses reflect the model's reasoning at the time of the hearing."

### Disclaimers without ruining the experience

- No pop-up disclaimers. No terms-of-service walls.
- The verdict confidence level IS the primary disclaimer — built into the product.
- "What Would Change the Verdict" inherently communicates uncertainty.
- A single line in About/Settings covers the legal side.

---

## 11. Technical Architecture

### Architecture pattern

MVVM with SwiftUI. Standard, well-documented, solo-developer friendly.

### Project structure

```
Tribunal/
├── App/
│   ├── TribunalApp.swift          # App entry, window config, environment
│   └── AppState.swift             # Global app state if needed
├── Models/
│   ├── Case.swift                 # SwiftData model
│   ├── Verdict.swift              # Verdict value types
│   ├── CaseStatus.swift           # Enums
│   └── UserSettings.swift         # Settings model (UserDefaults wrapper)
├── ViewModels/
│   ├── HearingViewModel.swift     # Session orchestration, streaming
│   ├── CaseLibraryViewModel.swift # Case list management
│   └── SettingsViewModel.swift    # API key validation, model selection
├── Views/
│   ├── ContentView.swift          # NavigationSplitView shell
│   ├── Sidebar/
│   │   ├── SidebarView.swift
│   │   └── CaseRowView.swift
│   ├── Hearing/
│   │   ├── InputView.swift        # Claim input state
│   │   ├── SessionView.swift      # Streaming session state
│   │   ├── SectionView.swift      # Individual section rendering
│   │   └── VerdictCardView.swift  # Final verdict display
│   ├── Settings/
│   │   └── SettingsView.swift
│   └── Shared/
│       ├── ConfidenceBadge.swift
│       └── VerdictBadge.swift
├── Services/
│   ├── LLM/
│   │   ├── LLMProvider.swift      # Protocol (provider-agnostic)
│   │   ├── OpenAIService.swift    # OpenAI implementation
│   │   └── StreamingParser.swift  # SSE stream parsing
│   ├── PromptEngine/
│   │   ├── HearingPrompt.swift    # Prompt template construction
│   │   └── ResponseParser.swift   # Structured output → model mapping
│   └── KeychainService.swift      # Secure API key storage
└── Utilities/
    ├── CaseNumberGenerator.swift  # YYYY-MMDD-NNN format
    └── DateFormatters.swift
```

### LLM orchestration

- Lives behind an `LLMProvider` protocol. OpenAI is the only conformance in v1.
- Single structured API call per hearing — not chained calls. One prompt produces all sections.
- Streaming via OpenAI's Server-Sent Events (SSE) format.
- Use `AsyncThrowingStream` for SwiftUI-friendly streaming.
- Structured output via JSON mode or function calling to parse sections reliably.
- The prompt is the most important asset in the project. It must instruct the model to:
  - Produce all sections in order (Claim Summary, Prosecution, Defense, Evidence Gaps, Rhetorical Analysis, What Would Change, Verdict)
  - Argue prosecution and defense genuinely (not straw-man the losing side)
  - Grade its own confidence honestly
  - Cite sources by name when possible
  - Flag reasoning type (established fact vs. inference vs. speculation)
  - Identify specific rhetorical techniques, manipulation patterns, and logical fallacies in the Rhetorical Analysis section
  - State what would change the conclusion

### Model strategy

| Model | Usage | When |
|-------|-------|------|
| `gpt-5.4-mini` | Default for all hearings | v1 default |
| `gpt-5.4` | Deeper analysis, complex claims | v1 settings option |
| `gpt-5.4-nano` | Claim classification, pre-screening | Future |
| `gpt-5.4-pro` | Maximum quality analysis | Future premium option |

### Network

- Swift `URLSession` with async/await. No third-party HTTP libraries.
- SSE stream parsing for real-time output.
- No third-party dependencies in v1 unless absolutely necessary.

### Storage

- **SwiftData** for case persistence. Apple's modern persistence layer, great SwiftUI integration, supports schema migration.
- **Keychain** for API key. Never UserDefaults, never plain text.
- **UserDefaults** for non-sensitive settings (appearance, default model, setup flag).

### What is NOT in v1

- No local/on-device analysis
- No CloudKit sync
- No third-party dependencies (aim for zero)
- No server-side component
- No accounts or authentication
- No image/screenshot processing
- No multi-window support

---

## 12. Platform Strategy

### Launch platform: macOS only

**Rationale:**
- Primary audience (tech-savvy skeptics) lives on Mac
- Two-panel sidebar+detail layout is native macOS pattern
- macOS App Store has less competition than iOS
- Paste-heavy input workflows are better with keyboard
- Faster to ship: one window size, one interaction model
- Mac App Store supports premium utility pricing ($10-15)

### Expansion path

1. **macOS** — launch platform
2. **iPad** — second (sidebar+detail layout translates directly via NavigationSplitView)
3. **iPhone** — last (requires different navigation: stack-based or tab bar)

SwiftUI makes cross-platform realistic. Most views work on all platforms. But do not attempt universal on day one.

### UI framework

- SwiftUI throughout
- `NavigationSplitView` (two-column)
- Standard macOS toolbar
- Menu bar integration (File > New Hearing, Edit > Copy, etc.)
- No AppKit bridging unless absolutely necessary

---

## 13. Monetization Strategy

### Phase 1 (launch): Free, BYO API key

- No payment infrastructure. No accounts. No server costs.
- Users pay OpenAI directly for API usage.
- Correct model for a solo dev shipping a side project to early adopters.

### Phase 2 (if traction): One-time purchase

- Price: $12.99 on the Mac App Store
- BYO API key still required
- Value proposition: "You're paying for the app, not the AI."
- This is the natural model for a premium Mac utility.

### Phase 3 (if real business): Premium features

- Free core: basic hearings, limited case history
- Paid unlock: export, advanced model options (gpt-5.4-pro), unlimited history
- Only pursue if user base justifies the complexity

### Models explicitly rejected

| Model | Why not |
|-------|---------|
| Subscription ($X/mo) | Only makes sense with a proxy server bundling API costs. Adds massive complexity. |
| Freemium with rate limiting | Awkward with BYO key — "I'm paying for the API, why am I rate-limited?" |
| Ad-supported | Destroys the premium feel. Incompatible with the brand. |

---

## 14. Competitive Positioning

| Alternative | What It Does | Why Tribunal Is Different |
|------------|-------------|--------------------------|
| **ChatGPT (direct)** | Free-form response, no structure | Tribunal forces adversarial framing. Structured output surfaces things essays bury. Case library accumulates history. |
| **AI summarizers** (Arc, Kagi) | Condense content | Summarizers tell you what was said. Tribunal tells you what's wrong with it, what's missing, and what would change the conclusion. |
| **Fact-checking sites** (Snopes, PolitiFact) | Human-written verdicts | Slow (days/weeks). Limited catalog. Binary true/false. Tribunal is instant, works on ANY claim, and models uncertainty. |
| **Note-taking + AI** (Notion, Obsidian) | General-purpose AI tools | General-purpose. Tribunal is purpose-built for adversarial claim analysis. You can't replicate the quality with a generic prompt template. |
| **Browser extensions** | Contextual page analysis | Extensions work on pages you're viewing. Tribunal is intentional — you bring claims to it. Can't build a case library or deliver the session experience. |

### Unique product shape

Tribunal occupies a space that doesn't currently exist: a **structured adversarial analysis tool** with a satisfying output format, automatic case archiving, and explicit uncertainty modeling. The output format is the moat — encoding specific, tested prompt engineering into a native product experience.

---

## 15. Implementation Phases

### Phase 1: Foundation (Days 1-5)

**Goal:** App shell with data layer and working LLM integration.

#### Phase 1A: Project Setup (Day 1)

- Create Xcode project (macOS, SwiftUI, SwiftData)
- Set up project structure (folders per architecture section)
- Configure SwiftData schema: Case model with all fields
- Build UserSettings wrapper (UserDefaults + Keychain)
- Implement KeychainService for secure API key storage
- Create CaseNumberGenerator utility

#### Phase 1B: LLM Service Layer (Days 2-3)

- Define `LLMProvider` protocol with streaming interface
- Implement `OpenAIService` conforming to protocol
  - Authentication with API key from Keychain
  - Streaming via SSE (Server-Sent Events) parsing
  - `AsyncThrowingStream` for SwiftUI consumption
  - Error handling: invalid key, network failure, rate limiting, malformed response
- Implement `StreamingParser` for SSE format
- Write the hearing prompt template in `HearingPrompt`
  - This is the single most important piece of work in the project
  - Must produce all sections (Claim Summary, Prosecution, Defense, Evidence Gaps, What Would Change, Verdict) in structured JSON
  - Must instruct the model to argue both sides genuinely
  - Must instruct confidence grading and source citation
  - Iterate and test extensively against diverse claim types
- Implement `ResponseParser` to map structured output to Case model fields

#### Phase 1C: Data Layer (Day 4)

- SwiftData model container configuration
- Case CRUD operations (create on hearing start, update on stream completion, delete)
- Case query: sorted by date descending, filtered by status
- Verify persistence across app launches

#### Phase 1D: Integration Verification (Day 5)

- Wire LLM service to SwiftData: submit claim → stream response → save case
- Test with 5+ diverse claims (conspiracy, science, political, viral post, mundane)
- Verify streaming works end-to-end
- Verify case saves correctly with all fields populated
- Profile token usage across claim types

### Phase 2: Core UI (Days 6-9)

**Goal:** Complete, usable interface for the primary workflow.

#### Phase 2A: App Shell and Navigation (Day 6)

- `ContentView` with `NavigationSplitView` (two-column)
- Sidebar width and collapsibility configuration
- Window sizing (min 800×600, default 1100×750)
- macOS toolbar setup
- Menu bar items (File > New Hearing, keyboard shortcuts)
- Dark mode as default, respect system appearance

#### Phase 2B: Sidebar and Case Library (Day 7)

- `SidebarView` with case list
- `CaseRowView`: claim summary (truncated), date, verdict badge (color-coded)
- "+" New Hearing button in accent color
- Empty state: "Your case library will appear here"
- Case selection drives detail panel
- Right-click context menu: Delete Case
- Settings link at sidebar bottom

#### Phase 2C: Input and Session Views (Day 8)

- `InputView`: centered layout, Tribunal wordmark (serif), subtitle, text input area, "Open Hearing ⌘↵" button
- `SessionView`: streaming output with section-by-section reveal
- `SectionView`: colored left-border indicator per section type, section label, streaming body text
- Streaming indicator: pulsing dot with italic status text
- Case header: case number, claim text (serif), timestamp
- Transition from input → session on submission

#### Phase 2D: Verdict and Completion (Day 9)

- `VerdictCardView`: verdict badge (colored, serif), confidence level, summary paragraph, "What Would Change" block (blue-accented), action buttons
- `ConfidenceBadge` and `VerdictBadge` shared components
- Copy actions: Copy Full Analysis (Markdown formatted), Copy Verdict Summary
- macOS Share Sheet integration
- Session completion state: all sections rendered, verdict card at bottom, auto-save triggered

### Phase 3: Settings and Error Handling (Day 10)

**Goal:** Complete settings experience and robust error states.

- `SettingsView`: API key entry (secure field), validation indicator, link to OpenAI key page
- Model picker: gpt-5.4-mini (default, labeled "Recommended") / gpt-5.4 (labeled "Deeper analysis")
- Appearance toggle: System / Dark / Light
- About section with trust disclaimer
- "Why do I need an API key?" expandable explanation
- First-launch detection: redirect to settings if no key configured
- Error states (all inline, not modal):
  - No API key → redirect to Settings
  - Invalid API key → error in Settings with re-validation
  - Network failure → "Hearing could not proceed — check your connection" with retry
  - API error (rate limit, server error) → descriptive inline message with retry
  - Streaming interruption → partial case saved, error indicator, retry option

### Phase 4: Polish and Ship (Days 11-14)

**Goal:** Refined experience ready for daily use.

#### Phase 4A: Prompt Refinement (Day 11)

- Test hearing prompt against 20+ diverse claims across categories:
  - Conspiracy (5G, flat earth, moon landing)
  - Science headlines ("study shows X causes Y")
  - Political rhetoric (campaign claims, policy arguments)
  - Viral social media posts
  - Mundane/obviously true claims (to verify the app doesn't always skepticize)
  - Vague or malformed input
- Tune prompt for:
  - Genuine adversarial balance (neither side straw-manned)
  - Appropriate confidence calibration
  - Source citation quality
  - "What Would Change" specificity
  - Consistent output structure

#### Phase 4B: Visual Polish (Day 12)

- Typography refinement: serif accent on case numbers and verdict headers
- Color calibration: verdict badge colors, section indicators, accent consistency
- Spacing and alignment audit across all views
- Light mode styling (if supporting)
- Window resizing behavior: content reflow, minimum viable sizes
- Sidebar collapse/expand animation

#### Phase 4C: Interaction Polish (Day 13)

- Keyboard shortcuts: ⌘+Return (submit), ⌘+N (new hearing), ⌘+C (context-aware copy)
- Focus management: input field auto-focused on new hearing
- Scroll behavior during streaming: auto-scroll to latest content, stop if user scrolls up
- Text selection in session output
- Token usage display per case (subtle, in case header)
- Case deletion confirmation

#### Phase 4D: Ship Preparation (Day 14)

- App icon design (geometric scales or gavel, amber on dark)
- Final end-to-end testing of all flows
- Build for release configuration
- Create a .gitignore appropriate for Xcode/Swift project
- README with project description and setup instructions
- First release build — ready for personal use and sharing

---

## Appendix A: Prompt Engineering Notes

The hearing prompt is the most critical asset in this project. It must be treated as a first-class artifact, versioned, and iterated on extensively.

### Prompt goals

The single API call must produce a structured JSON response containing:

1. **claim_summary** — A neutral, concise restatement of the claim
2. **prosecution** — The strongest case AGAINST the claim (or FOR it being misleading/false)
3. **defense** — The strongest case FOR the claim (genuinely argued, not straw-manned)
4. **evidence_gaps** — Specific pieces of evidence that don't exist or weren't provided
5. **rhetorical_analysis** — Manipulation techniques, logical fallacies, framing tricks, and persuasion patterns identified in the original claim
6. **what_would_change** — Specific, concrete things that would alter the verdict
7. **verdict** — Judgment, confidence level, summary, and list of unknowns

### Prompt constraints

- Must instruct the model to argue both sides with genuine effort
- Must prevent the "both sides" false equivalence when evidence is overwhelmingly one-sided
- Must instruct honest confidence calibration (not defaulting to "moderate")
- Must request specific source citations where possible
- Must flag reasoning type (established fact vs. inference vs. speculation)
- Must handle edge cases: vague claims, obviously true statements, questions disguised as claims, multiple claims in one input

### Testing matrix

| Category | Example Claims |
|----------|---------------|
| Conspiracy | "5G causes cancer," "Moon landing was faked," "Birds aren't real" |
| Science | "A glass of red wine equals an hour at the gym," "Humans only use 10% of their brain" |
| Political | "Country X spends more on Y than Z," campaign-trail statistics |
| Viral/Social | Screenshots of viral tweets, "I heard that..." claims |
| Obviously true | "Water boils at 100°C at sea level" (calibration test — should return Supported, High confidence) |
| Vague/malformed | "Everything is a lie," single words, questions |

---

## Appendix B: Risk Assessment

| Risk | Severity | Likelihood | Mitigation |
|------|----------|-----------|------------|
| **Output quality is shallow or generic** | Critical | Medium | Extensive prompt engineering. This is the make-or-break. Test against 20+ diverse claims before shipping. |
| **API costs surprise users** | Medium | Medium | Display token count per case. Add estimated cost in settings. Default to gpt-5.4-mini. |
| **Streaming parsing breaks on unexpected output** | Medium | Medium | Robust error handling in StreamingParser. Save partial results. Retry option. |
| **Courtroom metaphor feels gimmicky** | Medium | Low | Medium-light calibration per section 5. The metaphor serves structure, not theater. |
| **Users expect fact-checking accuracy** | High | Medium | Trust design per section 10. Confidence levels, disclaimers, "What Would Change." |
| **App feels like a wrapper around a prompt** | High | Medium | The native experience (streaming, case library, structured output) must deliver value a chat interface can't match. |
| **OpenAI API changes or rate limits** | Low | Low | Provider-agnostic architecture. Protocol-based LLM layer. |

---

## Appendix C: Open Questions for Implementation

These don't need answers before coding starts, but should be resolved during implementation:

1. **Structured output format:** JSON mode vs. function calling vs. structured outputs (OpenAI's newer feature)? Test which produces the most reliable section parsing.
2. **Streaming granularity:** Stream the entire response as one, or make separate calls per section? Single call is simpler and cheaper. Multiple calls allow per-section error recovery but add latency and cost.
3. **Case number collision:** The `YYYY-MMDD-NNN` format needs a counter. Use a simple incrementing integer stored in UserDefaults, or derive from SwiftData count?
4. **URL handling in v1:** Rely entirely on GPT-5.4's ability to process URLs, or do a lightweight `URLSession` fetch and pass the text? The latter is more reliable but adds complexity.
5. **Light mode:** Ship with light mode support in v1, or dark-only? Dark-only is faster to ship and fits the brand. Light mode can come in a point release.
