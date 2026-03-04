{
  description = "Unified dev environment with pinned cross toolchains";

  inputs = {
    nixpkgs-pinned.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-rolling.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs-pinned, nixpkgs-rolling }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSystem = f:
        builtins.listToAttrs (map
          (system: {
            name = system;
            value = f system;
          })
          systems);
    in {
      devShells = forEachSystem (system:
        let
          pkgsPinned = import nixpkgs-pinned { inherit system; };
          pkgsRolling = import nixpkgs-rolling { inherit system; };
        in {
          default = pkgsPinned.mkShell {
            packages = [
              # Rolling/common tools
              pkgsRolling.git
              pkgsRolling.gnumake
              pkgsRolling.curl
              pkgsRolling.wget
              pkgsRolling.python3
              pkgsRolling.go_1_25
              pkgsRolling.jq
              pkgsRolling.ripgrep
              pkgsRolling.fd
              pkgsRolling.tree
              pkgsRolling.unzip
              pkgsRolling.zip
              pkgsRolling.which
              pkgsRolling.file
              pkgsRolling.xz

              # Pinned build/debug/emulation tools
              pkgsPinned.bazel
              pkgsPinned.cmake
              pkgsPinned.ninja
              pkgsPinned.meson
              pkgsPinned.pkg-config
              pkgsPinned.ccache
              pkgsPinned.gdb
              pkgsPinned.binutils
              pkgsPinned.clang
              pkgsPinned.lld
              pkgsPinned.verilator
              pkgsPinned.patchelf
              pkgsPinned.strace
              pkgsPinned.qemu

              # Pinned cross toolchains (Linux userland)
              pkgsPinned.pkgsCross.riscv32.stdenv.cc
              pkgsPinned.pkgsCross.riscv64.stdenv.cc
              pkgsPinned.pkgsCross."loongarch64-linux".stdenv.cc
              pkgsPinned.pkgsCross."armv7l-hf-multiplatform".stdenv.cc
              pkgsPinned.pkgsCross."aarch64-multiplatform".stdenv.cc
              pkgsPinned.pkgsCross.mingwW64.stdenv.cc

              # Pinned cross toolchains (bare metal)
              pkgsPinned.pkgsCross."riscv32-embedded".stdenv.cc
              pkgsPinned.pkgsCross."riscv64-embedded".stdenv.cc
            ];

            shellHook = ''
              export CC_RV32_LINUX="$(command -v riscv32-unknown-linux-gnu-gcc || true)"
              export CC_RV64_LINUX="$(command -v riscv64-unknown-linux-gnu-gcc || true)"
              export CC_RV32_ELF="$(command -v riscv32-none-elf-gcc || true)"
              export CC_RV64_ELF="$(command -v riscv64-none-elf-gcc || true)"
              export CC_LOONG64_LINUX="$(command -v loongarch64-unknown-linux-gnu-gcc || true)"
              export CC_ARMV7_LINUX="$(command -v armv7l-unknown-linux-gnueabihf-gcc || true)"
              export CC_AARCH64_LINUX="$(command -v aarch64-unknown-linux-gnu-gcc || true)"
              export CC_MINGW64="$(command -v x86_64-w64-mingw32-gcc || true)"

              export QEMU_RISCV32="$(command -v qemu-riscv32 || true)"
              export QEMU_RISCV64="$(command -v qemu-riscv64 || true)"
              export QEMU_LOONGARCH64="$(command -v qemu-loongarch64 || true)"
              export QEMU_ARM="$(command -v qemu-arm || true)"
              export QEMU_AARCH64="$(command -v qemu-aarch64 || true)"
              export QEMU_X86_64="$(command -v qemu-x86_64 || true)"

              echo "Loaded nix-dev shell (${system})"
              echo "CC_RV32_LINUX=$CC_RV32_LINUX"
              echo "CC_RV64_LINUX=$CC_RV64_LINUX"
              echo "CC_RV32_ELF=$CC_RV32_ELF"
              echo "CC_RV64_ELF=$CC_RV64_ELF"
              echo "CC_LOONG64_LINUX=$CC_LOONG64_LINUX"
              echo "CC_ARMV7_LINUX=$CC_ARMV7_LINUX"
              echo "CC_AARCH64_LINUX=$CC_AARCH64_LINUX"
              echo "CC_MINGW64=$CC_MINGW64"
              echo "QEMU_RISCV32=$QEMU_RISCV32"
              echo "QEMU_RISCV64=$QEMU_RISCV64"
              echo "QEMU_LOONGARCH64=$QEMU_LOONGARCH64"
              echo "QEMU_ARM=$QEMU_ARM"
              echo "QEMU_AARCH64=$QEMU_AARCH64"
              echo "QEMU_X86_64=$QEMU_X86_64"
            '';
          };
        });
    };
}
