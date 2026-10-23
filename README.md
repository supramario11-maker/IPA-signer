# IPA-signer

GitHub Actions workflows to build a Linux/Docker package for the upstream [SideStore Omnisette server](https://github.com/SideStore/omnisette-server), optionally sign an IPA with signing material you are authorized to use, and publish a static GitHub Pages interface.

## What it does

- Builds the upstream server into a Docker image on a temporary GitHub-hosted Linux runner.
- Runs a short container smoke test and uploads the image archive, Compose file and instructions as `omnisette-server-package`.
- Optionally signs one IPA downloaded from a GitHub Release on a macOS runner, uploading it as the short-lived `signed-ipa` artifact.
- Deploys the static `site/` interface to GitHub Pages.

**Important:** the workflow runner is temporary. The server package is not a permanently hosted Anisette endpoint. Anisette data is not an Apple signing identity and does not authorize an app for installation.

## Setup from iPad

1. Open repository **Settings → Pages** and set **Build and deployment → Source** to **GitHub Actions**.
2. Open **Actions → Build Omnisette Package and Sign IPA → Run workflow**.
3. For the server only, keep the server option enabled and leave IPA signing disabled.
4. To sign, upload exactly one `.ipa` asset to a GitHub Release and note its tag. If the app is private, make this repository private before uploading: public release assets in a public repository may be downloaded by anyone.
5. In **Settings → Secrets and variables → Actions**, add the secrets listed below.
6. Run the workflow with the release tag and enable the IPA signing option. Download `signed-ipa` from the run summary; artifacts expire after 3 days.

## Signing secrets

- `APPLE_CERTIFICATE_BASE64`: base64-encoded P12 containing an authorized Apple Development or Distribution identity and private key.
- `APPLE_CERTIFICATE_PASSWORD`: password for that P12.
- `APPLE_PROFILE_BASE64`: base64-encoded provisioning profile compatible with the app and identity.

A matching certificate/profile, bundle identifier and entitlements are required. This general workflow cannot automatically fix incompatible entitlements, expired profiles, missing device registration, or app-specific signing requirements. Signing does not guarantee installation. Complex apps may need custom signing steps and should be validated.

## Security

- The Pages site never asks for Apple Account passwords, 2FA codes, cookies, or Apple authentication tokens.
- The Pages buttons navigate to GitHub Actions. Starting a run requires GitHub authentication; no PAT is embedded in browser JavaScript.
- Never commit signing assets or secret values. Use GitHub Actions secrets.
- Keep private apps/release assets in a private repository. Check repository visibility before publishing.
- Review workflow code and dependencies before running it.

## Files

- `site/index.html` — static Pages interface
- `.github/workflows/pages.yml` — Pages deployment
- `.github/workflows/sign-ipa.yml` — server build and optional IPA signing
- `script/inspect-ipa.sh` — local IPA archive/bundle inspection

This repository builds the upstream server; it does not claim ownership of that project.
