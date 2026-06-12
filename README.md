# minimal-server-setup

An [Ansible](https://docs.ansible.com/ansible/latest/index.html) playbook that
fully automates the setup of a personal Debian server — user accounts, firewall,
hardening, Docker Compose services, and monitoring scripts.

## Quick start

```sh
ansible-galaxy collection install community.docker
ansible-playbook -i hosts site.yml
```

Targets a single host (`192.168.122.150`, group `[linux]`) via SSH. The
playbook becomes root through sudo.

## Prerequisites

- A Debian (Bookworm) server reachable at `192.168.122.150`
- Ansible installed on the control machine
- SSH access to the target (password is in `hosts` — see warning below)
- The `community.docker` collection: `ansible-galaxy collection install community.docker`

## What it does

| Role | What it does |
|------|--------------|
| `user_management` | Creates an admin user with sudo and an auditor user with read-only log access. Configures password policy, SSH hardening (no root login, user allowlist), umask, and sensitive file permissions. |
| `auditing` | Installs auditd, configures audit rules for user/group/sudo changes, deploys a weekly audit report script. |
| `security` | Configures UFW (deny incoming, allow outgoing, open ports 2222/80/443). Installs `dnsutils`, `iputils-ping`, `curl`. |
| `reporting` | Deploys a system report script and runs it once at setup time. |
| `docker_compose` | Installs Docker Engine and Docker Compose plugin from the official Docker repository. |
| `navidrome` | Deploys [Navidrome](https://www.navidrome.org/) (music streaming server) as a Docker Compose service on port 4533. |
| `nginx` | Installs Nginx and configures it as a reverse proxy for Navidrome. |
| `scripts` | Deploys a backup script and a health check script, each with cron jobs. |

## Role order

```
user_management ─┬─ auditing     (needs guest user from user_management)
                 ├─ security
                 └─ reporting    (needs admin user from user_management)
docker_compose ──── navidrome ──── nginx   (Docker → Navidrome → reverse proxy)
scripts          (independent, last)
```

Roles run in this order so each one has what it needs.

## Repository structure

```
site.yml          # playbook entrypoint — all 8 roles enabled
hosts             # inventory: [linux] group, single host, plaintext password
ansible.nix       # NixOS module that writes /etc/ansible/ansible.cfg
roles/            # 8 roles (listed above)
AGENTS.md         # guidance for AI coding assistants
```

Ansible config is managed by a NixOS module (`ansible.nix`). There is no local
`ansible.cfg`. Pipelining is enabled for faster SSH.

## Variables

Global variables are defined once in `site.yml` and available to every role:

| Variable | Default | Description |
|----------|---------|-------------|
| `admin_user` | `asur` | Sudo-enabled admin account |
| `guest_user` | `guest` | Read-only auditor account |

Role-specific variables (e.g. `navidrome_port`, `nginx_server_name`) are
defined in `roles/<name>/vars/main.yml`.

## notes
- This is a local-lab setup — no CI, tests, linters, or pre-commit hooks are
  configured.
