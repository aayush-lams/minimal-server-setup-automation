# AGENTS.md — Ansible: minimal-server-setup

## Quick start

```sh
ansible-galaxy collection install community.docker  # one-time
ansible-playbook -i hosts site.yml
```

Ansible config is managed via NixOS (`ansible.nix`); there is no local `ansible.cfg`.

## Repo structure

```
site.yml               # playbook entrypoint — all 8 roles enabled
hosts                  # inventory: single host [linux], plaintext SSH password (do not commit)
roles/                 # 8 roles (see below)
ansible.nix            # NixOS module that writes /etc/ansible/ansible.cfg
```

## Key facts

- **Target**: Debian host `192.168.122.150`, user `asur`, become root via sudo.
- **Global vars** (`admin_user=asur`, `guest_user=guest`) defined once in `site.yml` under `vars:` — available to all roles.
- **Role order** in `site.yml` respects dependencies:
  `user_management → auditing → security → reporting → docker_compose → navidrome → nginx → scripts`
- **Required collection**: `community.docker` — install with `ansible-galaxy collection install community.docker`.
- **No tests, no CI, no linters, no pre-commit** in this repo.
- **No `.gitignore`** — be careful not to commit secrets (the `hosts` file contains SSH password).

## Execution notes

- `community.docker.docker_compose_v2` module is used for Docker Compose — not `docker-compose` command.
- UFW module controls firewall; no `iptables` rules directly.
- SSH password in `hosts` is a plaintext `ansible_ssh_pass`. This is a local-lab setup.
- `ansible.nix` enables `pipelining = True` for faster SSH.

## What to avoid

- Do not commit the `hosts` file to public remotes (contains password).
- Do not add `ansible.cfg` locally — it's managed by NixOS.
- Do not add CI/test infra unless specifically asked — this is a personal playbook.
