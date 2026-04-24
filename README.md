# 🐳 docker-cli-shorts

A collection of sweet and simple Bash shortcuts to make working with Docker easier and faster.

No more typing long `docker` or `docker-compose` commands — just plug & play!

---

## ✨ Features

- Handy aliases for Docker and Docker Compose  
- Interactive container manager (`dm`) to stop or restart containers with one keystroke  
- One-liners for logs, IPs, pruning, container managing and more!

---

## 🚀 Installation

Just run this in your terminal:

```bash
wget -O - https://raw.githubusercontent.com/eness/docker-cli-shorts/main/docker-cli-shorts.sh >> ~/.bashrc
```

Then reload your shell:

```bash
source ~/.bashrc
```

Or copy the contents of `docker-cli-shorts.sh` into your `.bashrc` or `.zshrc`.

---

## Dops Command

Install `dops` with:

```bash
wget "https://github.com/Mikescher/better-docker-ps/releases/latest/download/dops_linux-amd64-static" -O "/usr/local/bin/dops" && sudo chmod +x "/usr/local/bin/dops"
```

Sampe alias with custom columns :

```bash
alias dops='dops --all --format "table {{.ID}}\\t{{.Names}}\\t{{.State}}\\t{{.Status}}\\t{{.Ports}}"'
```

---

## 🛠️ Usage

| Command             | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `dc`                | Run `docker compose`                                                        |
| `dcu`               | Run `docker compose up -d`                                                  |
| `dcd`               | Run `docker compose down`                                                   |
| `dcr`               | Run `docker compose run` with arguments                                     |
| `dm`                | Interactive mode to STOP or RESTART a container with keystroke              |
| `dex <container>`   | Open bash/sh shell in a running container                                   |
| `di <container>`    | Inspect container metadata                                                  |
| `dim`               | List all Docker images                                                      |
| `dip`               | Show IP addresses of all running containers                                 |
| `dl <container>`    | View live logs from a container (`docker logs -f`)                          |
| `dnames`            | List names of all running containers                                        |
| `dps`               | Shortcut for `docker ps`                                                    |
| `dpsa`              | Shortcut for `docker ps -a`                                                 |
| `drmc`              | Remove all exited containers                                                |
| `drmid`             | Remove all dangling (unused) images                                         |
| `drun <image>`      | Run a bash shell in a new container from an image                           |
| `dsr <container>`   | Stop then remove a container                                                |
| `dlab <label>`      | Get container ID(s) by Docker label                                         |
| `dsp`               | Run `docker system prune --all`                                             |

---

## 💡 Highlight: `dm` Interactive Mode

The `dm` command opens a terminal-based interactive prompt:

- Press `R` or `S` anytime to switch between **restart** and **stop** mode.
- Press a number to act on a container (multi-digit supported).
- Press `Q` to quit.

It's like a little TUI, but fast, minimal, and keyboard-driven. ⚡

---

## 🙏 Credits

Inspired by the awesome Docker CLI workflow needs of everyday developers.  
Crafted with care by [@eness](https://github.com/eness).

---

## 🐙 License

MIT — use freely, improve happily.
