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
              pkgsRolling.bear

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
              pkgsPinned.verilog
              pkgsPinned.patchelf
              pkgsPinned.strace
              pkgsPinned.qemu

              # Pinned cross toolchains (Linux userland)
              pkgsPinned.pkgsCross.riscv32.stdenv.cc
              pkgsPinned.pkgsCross.riscv64.stdenv.cc

              # Pinned cross toolchains (bare metal)
              pkgsPinned.pkgsCross."riscv32-embedded".stdenv.cc
              pkgsPinned.pkgsCross."riscv64-embedded".stdenv.cc
            ];

            shellHook = ''
              export LD_LIBRARY_PATH="${pkgsPinned.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH"

              export CC_RV32_LINUX="$(command -v riscv32-unknown-linux-gnu-gcc || true)"
              export CC_RV64_LINUX="$(command -v riscv64-unknown-linux-gnu-gcc || true)"
              export CC_RV32_ELF="$(command -v riscv32-none-elf-gcc || true)"
              export CC_RV64_ELF="$(command -v riscv64-none-elf-gcc || true)"

              export QEMU_RISCV32="$(command -v qemu-riscv32 || true)"
              export QEMU_RISCV64="$(command -v qemu-riscv64 || true)"

              echo "Loaded nix-dev shell (${system})"
              echo "CC_RV32_LINUX=$CC_RV32_LINUX"
              echo "CC_RV64_LINUX=$CC_RV64_LINUX"
              echo "CC_RV32_ELF=$CC_RV32_ELF"
              echo "CC_RV64_ELF=$CC_RV64_ELF"
              echo "QEMU_RISCV32=$QEMU_RISCV32"
              echo "QEMU_RISCV64=$QEMU_RISCV64"
            '';
          };
        });
    };
}
