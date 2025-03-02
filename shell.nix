let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.11";

  pkgs = import nixpkgs {
    config = {};
    overlays = [
    ];
  };
in
  pkgs.mkShellNoCC {
    packages = with pkgs; [
      python313 # Python
      cargo # Rust package manager
      rustc # Rust compiler
      libgcc # GNU Compiler Collection
      gcc14 # GCC
      age # Modern encryption tool with small explicit keys
      cloudflared # Cloudflare Tunnel daemon, Cloudflare Access toolkit, and DNS-over-HTTPS client
      direnv # Shell extension that manages your environment
      fluxcd # Open and extensible continuous delivery solution for Kubernetes
      go-task # Task runner / simpler Make alternative written in Go
      yq-go # Portable command-line YAML processor
      kubernetes-helm # Package manager for kubernetes
      helmfile # Declarative spec for deploying Helm charts
      jq # Lightweight and flexible command-line JSON processor
      kubeconform # FAST Kubernetes manifests validator, with support for Custom Resources!
      kubectl # Kubernetes CLI
      kubecolor # Colorizes kubectl output
      kustomize # Customization of kubernetes YAML configurations
      moreutils # Growing collection of the unix tools that nobody thought to write long ago when unix was young
      sops # Simple and flexible tool for managing secrets
      stern # Multi pod and container log tailing for Kubernetes
      (builtins.getFlake "github:budimanjojo/talhelper?ref=v3.0.19").packages.x86_64-linux.default # A helper tool to help creating Talos cluster in your GitOps repository.
      talosctl # CLI for out-of-band management of Kubernetes nodes created by Talos
    ];

    shellHook = ''
      # Create/update virtual environment
      if ! grep -q "cluster" .venv/pyvenv.cfg; then
          rm -rf .venv;
          task workstation:venv
      fi
    '';
  }
