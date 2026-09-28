# sec

Lightweight, open-source macOS security baseline. Config as code, no resident
daemons beyond two event-driven agents.

## Stack

| Layer | Tool | Footprint |
|---|---|---|
| Outbound firewall | [LuLu](https://objective-see.org/products/lulu.html) | event-driven, idle until new connection |
| Persistence monitor | [BlockBlock](https://objective-see.org/products/blockblock.html) | event-driven, idle until new persistence attempt |
| Malware scan | ClamAV (`clamscan`, not `clamd`) | on-demand, weekly launchd job only |
| VPN | Surfshark (already installed, paid) | manual, run only when torrenting or on untrusted networks |
| Disk/App firewall | FileVault + macOS Application Firewall | native, no extra process |

Deliberately excluded to stay light: resident AV daemon (`clamd`), always-on
VPN, full EDR. Not the threat model for a single personal laptop.

## Setup

```sh
./setup.sh
```

Installs LuLu + BlockBlock (casks) and ClamAV (CLI only), then registers a
weekly `clamscan` LaunchAgent (Sundays 09:00) against `~/Downloads` and
`~/torrents`. Adjust the paths in `com.local.clamscan.plist` to match your
actual qBittorrent save directory before running.

After install, open LuLu.app and BlockBlock.app once each to grant
permissions and enable "start at login".

## Verify

```sh
brew list --cask lulu blockblock
launchctl list | grep com.local.clamscan
clamscan --version
```

## Torrent-specific hardening (qBittorrent)

- Save path: dedicated isolated folder, not `~/Downloads` or `~/Desktop`
- Options → BitTorrent → Encryption: Require encryption
- Options → Connection → uncheck UPnP / NAT-PMP
- Options → Downloads → no "run external program on completion" unless set by you
- Run Surfshark before starting any torrent session
- Never execute downloaded files directly — extract archives into an
  isolated folder and scan with `clamscan` first
