#!/bin/bash

# ========================================================
# Versões usadas pelo script
# ========================================================
NVM_VERSION="v0.40.8"
NODE_VERSION="24"
ECLIPSE_RELEASE="2026-06"
ECLIPSE_BUILD="R"
STS_VERSION="5.4.0.RELEASE"
STS_ECLIPSE="e4.40"

# ========================================================
# Caminhos de instalação (padrão XDG do usuário)
# ========================================================
LOCAL_BIN="$HOME/.local/bin"
LOCAL_OPT="$HOME/.local/opt"
APPS_DIR="$HOME/.local/share/applications"

mkdir -p "$LOCAL_BIN" "$LOCAL_OPT" "$APPS_DIR"

# ========================================================
# Funções auxiliares
# ========================================================
has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

apt_pkg_installed() {
  dpkg -s "$1" >/dev/null 2>&1
}

snap_installed() {
  snap list "$1" >/dev/null 2>&1
}

add_to_bashrc() {
  local line="$1"
  if ! grep -qF "$line" "$HOME/.bashrc" 2>/dev/null; then
    echo "$line" >>"$HOME/.bashrc"
  fi
}

# ========================================================
# Arrays de dependências
# ========================================================
APT_PACKAGES=(
  # Utilitários básicos
  "curl"
  "wget"
  "git"
  "unzip"
  "build-essential"
  "dkms"
  "ca-certificates"
  "ca-certificates-java"
  # Banco de dados
  "postgresql"
  "postgresql-contrib"
  # Java
  "openjdk-17-jdk"
  "maven"
  # Utilitários de sistema
  "xclip"
  # Janelas e monitoramento
  "gnome-terminal"
  "gnome-system-monitor"
  # Escritório
  "libreoffice"
  "libreoffice-l10n-pt-br"
  # Navegador
  "firefox"
)

SNAP_PACKAGES=(
  "brave"
  "insomnia"
  "gh"
  "docker"
)

# ========================================================
# Repositórios APT de terceiros
# ========================================================
setup_extra_repos() {
  echo "[+] Configurando repositórios de terceiros..."

  # Claude Desktop
  if ! apt_pkg_installed "claude-desktop"; then
    curl -fsSL https://downloads.claude.ai/claude-desktop/key.asc \
      | sudo tee /usr/share/keyrings/claude-desktop-archive-keyring.asc >/dev/null
    echo "deb [signed-by=/usr/share/keyrings/claude-desktop-archive-keyring.asc] https://downloads.claude.ai/claude-desktop/apt/stable stable main" \
      | sudo tee /etc/apt/sources.list.d/claude-desktop.list >/dev/null
  fi
}

# ========================================================
# Atualização do Sistema
# ========================================================
echo "[+] Atualizando repositórios do sistema..."
sudo apt update && sudo apt upgrade -y

setup_extra_repos
sudo apt update

# ========================================================
# Instalação de Pacotes Base (APT)
# ========================================================
echo "[+] Instalando pacotes via APT..."
for pkg in "${APT_PACKAGES[@]}"; do
  if apt_pkg_installed "$pkg"; then
    echo "    - $pkg já instalado, pulando..."
    continue
  fi
  sudo apt install -y "$pkg"
done

# ========================================================
# Instalação de Aplicativos (SNAP)
# ========================================================
echo "[+] Instalando aplicativos via SNAP..."
for pkg in "${SNAP_PACKAGES[@]}"; do
  name="${pkg%% *}"
  if snap_installed "$name"; then
    echo "    - $name já instalado, pulando..."
    continue
  fi
  sudo snap install $pkg
done

# ========================================================
# Docker: permissão de uso sem sudo
# ========================================================
echo "[+] Liberando Docker para o usuário $USER..."
sudo usermod -aG docker "$USER"

# ========================================================
# Instalação Node.js e NVM
# ========================================================
echo "[+] Instalando NVM ($NVM_VERSION) e Node.js v$NODE_VERSION..."
if [ ! -s "$HOME/.nvm/nvm.sh" ]; then
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash
fi
export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install "$NODE_VERSION"
nvm alias default "$NODE_VERSION"
nvm use "$NODE_VERSION"
npm install -g npm@latest

# ========================================================
# Instalação do Neovim
# ========================================================
echo "[+] Instalando o Neovim..."
if [ ! -x "$LOCAL_BIN/nvim" ]; then
  NVIM_VERSION="$(curl -fsSL https://api.github.com/repos/neovim/neovim/releases/latest | grep -oE '"tag_name": *"v[^"]+"' | cut -d'"' -f4)"
  curl -fsSL -o /tmp/nvim.tar.gz \
    "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz"
  tar -xzf /tmp/nvim.tar.gz -C "$HOME/.local"
  rm -f /tmp/nvim.tar.gz
  ln -sfn "$HOME/.local/nvim-linux-x86_64/bin/nvim" "$LOCAL_BIN/nvim"
fi

cat >"$APPS_DIR/nvim.desktop" <<EOF
[Desktop Entry]
Name=Neovim
GenericName=Text Editor
Comment=Edit text files
Exec=$LOCAL_BIN/nvim %F
Icon=$HOME/.local/share/icons/nvim.svg
Terminal=true
Type=Application
Categories=Utility;TextEditor;
StartupNotify=false
MimeType=text/plain;
EOF

# ========================================================
# Instalação do uv (gerenciador Python)
# ========================================================
echo "[+] Instalando o uv..."
if ! has_cmd "uv"; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# ========================================================
# Instalação do Claude Code
# ========================================================
echo "[+] Instalando o Claude Code..."
if ! has_cmd "claude"; then
  curl -fsSL https://claude.ai/install.sh | bash
fi

# ========================================================
# Instalação do Claude Desktop
# ========================================================
echo "[+] Instalando o Claude Desktop..."
if ! apt_pkg_installed "claude-desktop"; then
  sudo apt install -y claude-desktop
fi

# ========================================================
# Instalação do Eclipse IDE
# ========================================================
echo "[+] Instalando o Eclipse IDE ($ECLIPSE_RELEASE$ECLIPSE_BUILD)..."
if [ ! -x "$LOCAL_OPT/eclipse/eclipse" ]; then
  curl -fsSL -o /tmp/eclipse.tar.gz \
    "https://download.eclipse.org/technology/epp/downloads/release/$ECLIPSE_RELEASE/$ECLIPSE_BUILD/eclipse-java-$ECLIPSE_RELEASE-$ECLIPSE_BUILD-linux-gtk-x86_64.tar.gz"
  tar -xzf /tmp/eclipse.tar.gz -C "$LOCAL_OPT"
  rm -f /tmp/eclipse.tar.gz
  ln -sfn "$LOCAL_OPT/eclipse/eclipse" "$LOCAL_BIN/eclipse"
fi

# GTK_THEME=Adwaita:light evita a interface escura quebrada do Eclipse/STS
cat >"$APPS_DIR/eclipse.desktop" <<EOF
[Desktop Entry]
Name=Eclipse IDE for Java Developers
Comment=Eclipse IDE $ECLIPSE_RELEASE com Spring Tools (Spring Boot)
Exec=env GTK_THEME=Adwaita:light $LOCAL_BIN/eclipse
Icon=$LOCAL_OPT/eclipse/icon.xpm
Terminal=false
Type=Application
Categories=Development;IDE;Java;
StartupWMClass=Eclipse
StartupNotify=true
EOF

cat >"$APPS_DIR/_home_${USER}_.local_opt_eclipse_.desktop" <<EOF
[Desktop Entry]
Name=Eclipse IDE
Exec=$LOCAL_OPT/eclipse/eclipse %u
NoDisplay=true
Type=Application
EOF

# ========================================================
# Instalação do Spring Tool Suite (Spring Tools for Eclipse)
# ========================================================
echo "[+] Instalando o Spring Tool Suite ($STS_VERSION)..."
if [ ! -x "$LOCAL_BIN/sts" ]; then
  curl -fsSL -o /tmp/sts.tar.gz \
    "https://cdn.spring.io/spring-tools/release/dist/$STS_VERSION/$STS_ECLIPSE/spring-tools-for-eclipse-$STS_VERSION-$STS_ECLIPSE.0-linux.gtk.x86_64.tar.gz"
  tar -xzf /tmp/sts.tar.gz -C /tmp
  mv "/tmp/spring-tools-for-eclipse-$STS_VERSION-$STS_ECLIPSE.0-linux.gtk.x86_64" \
    "$LOCAL_OPT/sts-$STS_VERSION"
  rm -f /tmp/sts.tar.gz
  ln -sfn "$LOCAL_OPT/sts-$STS_VERSION/SpringToolsForEclipse" "$LOCAL_BIN/sts"
fi

cat >"$APPS_DIR/sts.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Spring Tool Suite 4
GenericName=Spring Boot IDE
Comment=Spring Tools for Eclipse (STS4)
StartupWMClass=Spring Tools for Eclipse
Exec=env GTK_THEME=Adwaita:light $LOCAL_BIN/sts
Icon=$LOCAL_OPT/sts-$STS_VERSION/icon.xpm
Terminal=false
Categories=Development;IDE;Java;
StartupNotify=true
EOF

# ========================================================
# Variáveis de ambiente
# ========================================================
echo "[+] Configurando as variáveis de ambiente no ~/.bashrc..."
add_to_bashrc 'export PATH="$HOME/.local/bin:$PATH"'
add_to_bashrc 'export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"'
add_to_bashrc 'export PATH="$JAVA_HOME/bin:$PATH"'

# ========================================================
# Conclusão
# ========================================================
echo ""
echo "[+] Instalação finalizada com sucesso!"
echo "    Reinicie o terminal (ou o computador) para carregar as variáveis de ambiente."
