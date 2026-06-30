#!/bin/bash

# ========================================================
# Arrays de dependências
# ========================================================
APT_PACKAGES=(
  "curl"
  "wget"
  "git"
  "unzip"
  "build-essential"
  "postgresql"
  "postgresql-contrib"
  "python3"
  "python3-pip"
)

SNAP_PACKAGES=(
  "brave"
  "insomnia"
  "obsidian --classic"
  "intellij-idea-community --classic"
  "gh"
)

# ========================================================
# Atualização do Sistema
# ========================================================
echo "[+] Atualizando repositórios do sistema..."
sudo apt update && sudo apt upgrade -y

# ========================================================
# Instalação de Pacotes Base (APT)
# ========================================================
echo "[+] Instalando pacotes base via APT..."
for pkg in "${APT_PACKAGES[@]}"; do
  sudo apt install -y "$pkg"
done

# ========================================================
# Instalação de Aplicativos (SNAP)
# ========================================================
echo "[+] Instalando aplicativos via SNAP..."
for pkg in "${SNAP_PACKAGES[@]}"; do
  sudo snap install $pkg
done

# ========================================================
# Instalação Node.js e NVM
# ========================================================
echo "[+] Instalando NVM e Node.js v24..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install 24
nvm alias default 24
nvm use 24

# ========================================================
# Instalação Rust
# ========================================================
echo "[+] Instalando ecossistema Rust (rustup/cargo)..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# ========================================================
# Instalação PHP 8.4 e Composer
# ========================================================
echo "[+] Instalando PHP 8.4 e Composer..."
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt install -y php8.4 php8.4-cli php8.4-pgsql php8.4-xml php8.4-curl php8.4-mbstring unzip
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# ========================================================
# Instalação Editor Zed
# ========================================================
echo "[+] Instalando o editor Zed..."
curl -f https://zed.dev/install.sh | sh

# ========================================================
# Instalação Input-Remapper (.deb)
# ========================================================
echo "[+] Baixando e instalando input-remapper..."
wget https://github.com/sezanzeb/input-remapper/releases/download/2.2.1/input-remapper-2.2.1.deb
sudo apt install -f ./input-remapper-2.2.1.deb -y
rm ./input-remapper-2.2.1.deb

# ========================================================
# Conclusão
# ========================================================
echo "[+] Instalação finalizada com sucesso! Reinicie o terminal."
