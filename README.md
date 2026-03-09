# nix-dev

统一的 Nix 开发环境，提供日常工具和固定版本的交叉编译工具链。

## Nix 的作用

Nix 提供可复现的开发环境，确保所有工具版本一致。本项目将工具分为两类：
- **滚动更新**：日常工具跟随最新版本
- **固定版本**：编译工具链和构建系统锁定版本，保证构建一致性

## 使用方法

```bash
cd nix-dev
nix develop              # 加载开发环境
cd ../your-project       # 进入你的项目目录
```

环境加载后，所有工具和交叉编译器都可直接使用。

## 工具列表

### 滚动更新 (nixos-unstable)
- 日常工具: `git`, `make`, `curl`, `wget`, `python3`, `go`, `jq`, `ripgrep`, `fd`, `tree`, `zip`, `unzip`, `which`, `file`, `xz`

### 固定版本 (nixos-25.05)
- 构建系统: `bazel`, `cmake`, `ninja`, `meson`, `pkg-config`, `ccache`
- 调试工具: `gdb`, `binutils`, `strace`, `patchelf`
- 编译器: `clang`, `lld`, `verilator`
- 模拟器: `qemu`
- 交叉编译工具链 (Linux):
  - `riscv32-unknown-linux-gnu-gcc`
  - `riscv64-unknown-linux-gnu-gcc`
  - `loongarch64-unknown-linux-gnu-gcc`
  - `armv7l-unknown-linux-gnueabihf-gcc`
  - `aarch64-unknown-linux-gnu-gcc`
  - `x86_64-w64-mingw32-gcc`
- 交叉编译工具链 (bare metal):
  - `riscv32-none-elf-gcc`
  - `riscv64-none-elf-gcc`

## 首次使用

```bash
cd nix-dev
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
