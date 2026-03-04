# nix-dev

Unified Nix flake for daily tools plus pinned cross toolchains.

## Included

- Common tools (rolling): `git`, `make`, `curl`, `wget`, `python3`, `jq`, `rg`, `fd`, `tree`, `zip`, `unzip`
- Pinned core tools: `bazel`, `qemu`
- Pinned cross toolchains:
  - `riscv32-unknown-linux-gnu-gcc`
  - `riscv64-unknown-linux-gnu-gcc`
  - `riscv32-none-elf-gcc`
  - `riscv64-none-elf-gcc`
  - `loongarch64-unknown-linux-gnu-gcc`

## First use

```bash
cd /home/yesnexttoken1/nix-dev
nix flake lock
nix develop
```

## Update policy

- Update common tools only:

```bash
nix flake lock --update-input nixpkgs-rolling
```

- Update pinned toolchains only:

```bash
nix flake lock --update-input nixpkgs-pinned
```
