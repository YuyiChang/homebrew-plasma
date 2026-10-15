cask "plasma" do
  version "2.3.0"
  sha256 "69d9de6f2d24228c916f9172d048fc507844a828358ddee232d3fccdaf7e27bd"

  url "https://github.com/YuyiChang/PLASMA/releases/download/v#{version}/PLASMA_MacOS_arm64.app.zip"
  name "PLASMA"
  desc "Platform for LSL-based Acquisition of Sensor Metrics and Analytics"
  homepage "https://github.com/YuyiChang/PLASMA"

  livecheck do
    url :url
    strategy :github_latest
  end

  # only the Apple-silicon binary is built (see .github/workflows/build.yml)
  depends_on arch: :arm64
  depends_on :macos

  app "PLASMA.app"
  # Also expose the console binary directly as `plasma`, for anyone who'd
  # rather skip PLASMA.app's Terminal-launcher indirection (see
  # .github/build_macos_app.sh — the .app has no window of its own; it opens
  # this same binary in a visible Terminal window so startup failures stay
  # visible instead of failing silently in the background).
  binary "#{appdir}/PLASMA.app/Contents/Resources/PLASMA_MacOS_arm64/PLASMA_MacOS_arm64", target: "plasma"

  postflight_steps do
    # {{appdir}} is expanded at run time by the install-steps runner — the
    # DSL block here has no `appdir` method of its own (see Homebrew's
    # install_steps.rb CONTENT_PATH_TOKENS). must_succeed: false because a
    # local/test install may not carry the quarantine attribute at all.
    run "/usr/bin/xattr", args:         ["-dr", "com.apple.quarantine", "{{appdir}}/PLASMA.app"],
                          must_succeed: false
  end

  caveats <<~EOS
    PLASMA is not code-signed or notarized; this cask clears the
    com.apple.quarantine attribute so Gatekeeper won't block the first run.

    Launching PLASMA.app opens a Terminal window running the real console
    app. Prefer a plain terminal instead? Run `plasma` directly.

    Config, gyro-bias calibration and recordings are written to
    ~/Library/Application Support/PLASMA — not the working directory or a
    pip install's PLASMA_HOME/cwd default, since this binary runs "frozen".
  EOS
end
