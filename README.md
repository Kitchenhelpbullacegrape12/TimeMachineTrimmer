![Static Badge](https://img.shields.io/badge/26_Tahoe-orange?label=macOS&style=flat-square)
![GitHub release (with filter)](https://img.shields.io/github/v/release/ricardoleal/TimeMachineTrimmer?style=flat-square)
![Homebrew](https://img.shields.io/badge/tap-ricardoleal%2Ftap-FBB040?logo=homebrew&label=homebrew&style=flat-square)
# TimeMachineTrimmer

Trim old Time Machine backups and reclaim disk space.

![TimeMachineTrimmer screenshot](.github/TimeMachineTrimmer.png)

## Features

- **Trim snapshots** — delete old backups from any Time Machine volume
- **Reclaim space** — remove unwanted snapshots and free up disk
- **macOS-native** — lightweight, native SwiftUI app

## In the News

> "TimeMachineTrimmer … un petit outil … C'est simple et c'est gratuit."
> — [VVMac (FR)](https://vvmac.fr/wordpress_b/flash-du-samedi-13-juin-2026/#avec-timemachinetrimmer-desengorgez-votre-disque-time-machine)

## Install

### Homebrew

```bash
brew tap ricardoleal/tap
brew trust ricardoleal/tap/time-machine-trimmer
brew install --cask time-machine-trimmer
```

### Manual

Download the latest `.dmg` from [Releases](https://github.com/ricardoleal/TimeMachineTrimmer/releases/latest), open it, and drag the app to `/Applications`.

> [!WARNING]
> The app is not signed with a paid Apple Developer ID certificate. If macOS blocks it, right-click the app in `/Applications` and select **Open**, then click **Open** in the dialog.

## Build from Source

Open `TimeMachineTrimmer.xcodeproj` in **Xcode 26+** on macOS 26 (Tahoe).

> [!IMPORTANT]
> Change the signing team to your own, otherwise entitlements may not persist.

## Contributing

Have an idea or found a bug? We'd love your contribution! 

### Quick Start
1. **Fork** this repository
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Make your changes** and test thoroughly
4. **Push to your fork** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request** from your fork to `main`

### Guidelines
- **Discuss first** — Open an [issue](https://github.com/ricardoleal/TimeMachineTrimmer/issues/new) to discuss your idea before starting work
- **Follow the template** — Our PR template will guide you through the submission process
- **Keep it focused** — One feature or fix per PR

For detailed instructions, see [CONTRIBUTING.md](CONTRIBUTING.md).

## License

See [LICENSE](LICENSE).

## Star History

<a href="https://www.star-history.com/?repos=ricardoleal%2FTimeMachineTrimmer&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=ricardoleal/TimeMachineTrimmer&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=ricardoleal/TimeMachineTrimmer&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=ricardoleal/TimeMachineTrimmer&type=date&legend=top-left" />
 </picture>
</a>
