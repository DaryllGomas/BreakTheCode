# Handoff — Breaking Your Genetic Code

**Last session:** 2026-09-27
**State:** LIVE and public at **https://breakthecode.daryllgomas.com/** (repo `DaryllGomas/BreakTheCode`, serves `main`, `CNAME` in main). Mirror still serves at https://breakthecode.meatball-labs.com/ from `Namkuzu-da-OS/BreakTheCode` branch `pages-meatball` (= main + one CNAME-swap commit). `daryllgomas.github.io/BreakTheCode/` 301s to the new domain. DNS: Namecheap CNAME `breakthecode` → `daryllgomas.github.io.`; HTTPS enforced. Linked from daryllgomas.com (home contact list, legacy.html, v2).

**Publish = `bash scripts/publish.sh`** from a clean `main`. It verifies content, then pushes both repos and rebuilds `pages-meatball`. Never hand-edit `CNAME` on main.

**Moved 2026-09-27** out of R&D. The old 2025 personal-repo site is archived on branch `archive/v1-2025` + tag `v1-2025-06`, and bundled to Drive at `BigPic - Technology/Website/Backups/BreakTheCode-DaryllGomas-v1-2025-archive-2026-09-27/`.
**Next session:** pick up at "Where to start" below.

---

## Where things stand

The 2.0 redesign is built, verified and deployed. `main` is live on `DaryllGomas/BreakTheCode`.

| Piece | State |
|---|---|
| Home page (7 bands + footer) | live |
| `/journey/` + 6 chapter pages | live |
| `/library/` + 16 text pages | live |
| `/web/` interactive graph | live |
| `/practices/`, `/about/` | live |
| Content preserved | 6 chapters, 16 texts, 28 quotes, 19 connections, 4 paths |
| Quote sourcing | 28 of 28 verified to a named edition (last five replaced 2026-09-27) |
| Art | all 26 plates generated and wired; every text has a real artefact plate |
| Old site | preserved at `/legacy/index.html` + backed up to Drive |

---

## Where to start next session

**0. Nothing is half-finished. Done 2026-09-27:** `library-09` regenerated as a closed binding (no longer duplicates `library-10`); the five paraphrase quotes replaced with verified same-author lines (see RESEARCH-REPORT addendum). Verifier: "Approved quote corrections applied: 12".

**1. Footer social icons (YouTube / Instagram / X) are still decorative, unlinked** — waiting on the owner's handles.

**3. Mobile is broken at phone width — deferred by the owner, desktop is fine.**

Confirmed 2026-09-20 in Chromium device emulation at 400px: the hero display type overflows its container and is clipped mid-word ("BREA… / YOUR G…"), and the eyebrow truncates to "ANCIENT WISDOM." with "MODERN AWAKENING." cut off. Reproducible across a reload, so it is not a stale-render artifact.

Ruled out already:
- `<meta name="viewport" content="width=device-width, initial-scale=1">` is present and correct
- A `@media (max-width: 419px)` block exists for `.hero__title` — it reflows the title into a two-column grid but **does not reduce font-size**, and the rendered type is far larger than the `clamp(2rem, 9vw, 3.25rem)` set in the wider phone block would produce

So the likely cause is a cascade problem: either the narrow block is not winning, or a later rule re-raises the size. Start by inspecting the computed `font-size` on `.hero__title` at 390px in DevTools and finding which rule wins.

Owner's call 2026-09-20: **desktop-only is acceptable for now.** Do not treat this as a release blocker. Worth fixing before the site is promoted to people on phones, which is the stated audience.

**4. Nice-to-haves, none urgent.**
- Mobile QA pass at 390px on the real device
- Lighthouse run (packet 08's checklist is in `NOTES.md`)
- Open Graph image for link sharing

---

## How to work on this

**Preview locally** (does NOT work from `file://` — data JSON is fetched at runtime):
```bash
cd <repo> && python -m http.server 8080
# open http://localhost:8080/
```

**Run a build packet with Codex:**
```bash
codex exec -C "<repo>" -s workspace-write -c model_reasoning_effort=high \
  -i "docs/redesign/reference/MASTER-mockup.png" \
  # prompt via stdin - `-i` is variadic and will swallow a trailing prompt arg
```
Configured model is `gpt-5.6-sol`. `gpt-5-codex` is a stale name.

**Check remaining Codex quota** (it logs rate-limit snapshots):
```bash
grep -o '"rate_limits":{[^}]*}[^}]*}' "$(ls -t ~/.codex/sessions/*/*/*/*.jsonl | head -1)" | tail -1
```

**The contract that protects the content:** `scripts/verify-content.mjs` reads `legacy/index.html` and asserts nothing was lost or silently reworded. It must pass at every commit. It carries an explicit allowlist of the seven approved quote swaps — any *other* wording change fails the build. Don't loosen it; add to the allowlist deliberately if a swap is approved.

---

## Rules that are settled (don't relitigate)

- The title is **Breaking Your Genetic Code**. "Break the code" is supporting copy only.
- `docs/redesign/reference/MASTER-mockup.png` is the design. The old site supplies content and functionality only.
- The six journey stages are the owner's own words, asserted verbatim by the verifier. Do not rewrite them.
- Don't blend in ideas from rejected concept images (the temple/Court-map direction is dead and archived).
- Art is generated with the master mockup passed as a reference on **every** call.
- Artefact plates must match the text's real tradition. Modern authors get the *kind* of object, never a fabricated cover of a real edition.

---

## Backups

- `BigPic - Technology/Website/Backups/BreakTheCode-pre-redesign-2026-09-20/` — live capture + full `main` tree at `ed8485c`
- `legacy/index.html` in the repo (and the verifier reads it every run)
- Rollback: `git checkout main -- index.html`

## The method

Written up as a reusable playbook: `BigPic - Technology/Playbooks/Internal/Image-First Interface Design.md`.
Project-specific record: `docs/redesign/PROCESS.md`.
