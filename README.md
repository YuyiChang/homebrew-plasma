# homebrew-plasma

Homebrew tap for [PLASMA](https://github.com/YuyiChang/PLASMA) — Platform for
LSL-based Acquisition of Sensor Metrics and Analytics.

## Install

```bash
brew install --cask yuyichang/plasma/plasma
```

This installs **PLASMA.app** into `/Applications` from the [latest PLASMA
release](https://github.com/YuyiChang/PLASMA/releases/latest), plus a
`plasma` command on `$PATH` — no Python environment or `liblsl` install
required. Apple silicon only; there is no Intel build.

## Run

Either launch **PLASMA** from Applications/Spotlight/Dock, or run:

```bash
plasma
```

PLASMA has no GUI window of its own — it's a local web server, so either
path opens a Terminal window running the real console app and then a
browser tab at <http://127.0.0.1:7860>. (`PLASMA.app` itself is just a
launcher that opens `plasma` inside Terminal, so startup errors stay
visible instead of failing silently in the background — see
`.github/build_macos_app.sh` in the main repo.) Config, gyro-bias
calibration and recordings are written to
`~/Library/Application Support/PLASMA`.

The binary is not code-signed or notarized; the cask clears the
`com.apple.quarantine` attribute on install so Gatekeeper won't block the
first run.

## Updating the cask

`Casks/plasma.rb` pins a `version` and `sha256` to a specific PLASMA release.
After a new PLASMA version is tagged and its GitHub Release build finishes
(`PLASMA_MacOS_arm64.app.zip` + its `.sha256` attached), bump this tap:

```bash
brew bump-cask-pr --version <new-version> --write-only yuyichang/plasma/plasma
git -C "$(brew --repo yuyichang/plasma)" diff   # review, then commit + push
```

`brew bump-cask-pr` downloads the new `url` itself and computes the sha256 —
no need to copy it by hand from the release's `.sha256` file.
