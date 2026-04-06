# ⚖️ Tribunal

**Paste any claim. Watch it go to trial.**

Tribunal is a macOS app that takes any claim — a viral headline, a hot take, a "well actually" — and runs it through a structured adversarial analysis modeled after a courtroom hearing. Prosecution argues against it. Defense argues for it. Evidence gets weighed. You get a verdict.

It's not a fact-checker, not a chatbot, and not a summarizer. It cross-examines.

## 🔍 How it works

1. Paste a claim, link, or piece of text
2. Hit **Open Hearing**
3. Watch the analysis stream in section by section:
   - **Claim Summary** — what's actually being claimed
   - **Prosecution** — the case against
   - **Defense** — the case for
   - **Evidence Gaps** — what's missing or unverifiable
   - **Rhetorical Analysis** — logical fallacies and persuasion tricks
   - **What Would Change the Verdict** — what new evidence would flip the outcome
   - **Final Verdict** — Supported, Partially Supported, Unsupported, or Disproven, with a confidence level

Every hearing is auto-saved to a case library for later reference.

## 📋 Requirements

- macOS 14 (Sonoma) or later
- An OpenAI API key (entered in Settings on first launch)
- Swift 5.9+

## 🛠 Building from source

```bash
git clone https://github.com/Robert-Conover/tribunal.git
cd tribunal
swift build
swift run Tribunal
```

Or open in Xcode and run the `Tribunal` target.

## 🧪 Running tests

```bash
swift test
```

## 📌 Current status

Tribunal is in active development. The core hearing flow works end-to-end: input a claim, stream the analysis via the OpenAI API, view the structured verdict, and browse saved cases in the sidebar.

## 🗺 Roadmap

- [x] Paste-and-analyze with streaming courtroom output
- [x] Auto-saved case library with sidebar navigation
- [x] Verdict with confidence scoring (High / Moderate / Low / Insufficient)
- [x] Copy and share verdicts as formatted text
- [x] OpenAI API integration with model selection (GPT-5.4-mini / GPT-5.4)
- [x] Keychain-secured API key storage
- [x] Dark and light mode
- [ ] URL content extraction — auto-fetch and parse articles from pasted links
- [ ] Screenshot/image input via vision models
- [ ] Follow-up questions after a verdict ("What if X?")
- [ ] Inline rhetoric/fallacy tagging with structured labels
- [ ] Source quality grading
- [ ] Case search and filtering
- [ ] PDF/Markdown export
- [ ] Side-by-side claim comparison
- [ ] Claim tracking — re-analyze when new info emerges
- [ ] Multi-provider support (Claude, Gemini, local models)
- [ ] Browser extension companion
- [ ] CloudKit sync across devices
- [ ] iPad and iPhone apps

## 📄 License

This project is not yet licensed. All rights reserved.
