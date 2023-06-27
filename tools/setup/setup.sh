#! /bin/bash

set -Eeuo pipefail

echo 'Running development environment setup for thesis'

if ! [ -x "$(command -v nix)" ]; then
  echo 'Nix not found, installing now...' >&2
  sudo mkdir -p /nix
  sudo chown -R $(whoami) /nix
  curl -L https://nixos.org/nix/install | sh
fi

if [[ "$OSTYPE" == darwin* ]]; then
  if ! [ -x "$(command -v brew)" ]; then
    echo 'brew not found, installing...' >&2
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  if ! [ -x "$(command -v direnv)" ]; then
    echo 'Installing direnv'
    brew install direnv
  fi
elif [[ "$OSTYPE" == linux-gnu* ]]; then
  if ! [ -x "$(command -v direnv)" ]; then
    echo 'direnv not found, installing now' >&2
    sudo apt-get install -y direnv dirmngr
  fi
else
  echo 'Only MacOS & Debian/Ubuntu Supported for automatic setup' >&2
  exit 2
fi

echo "Attempting to add direnv hook to your shell ($SHELL) config."
if [[ "$SHELL" == *zsh ]]; then
  echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
  echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
elif [[ "$SHELL" == *bash ]]; then
  echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
  echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
else
  echo 'Your shell is not supported for automatic setup, use zsh or bash (or add `eval "$(direnv hook <YOUR_SHELL>)"` to your config)' >&2
fi

$SHELL -c "echo 'Development environment setup complete'"