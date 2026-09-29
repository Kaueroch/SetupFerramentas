# Setups Bash

Criado para toda vez que estiver em uma máquina nova ou fizer a formatação do computador, não ter que instalar tudo novamente sem ter que lembrar de algo.

## 📦 O que este script instala?

**Base e Ferramentas do Sistema (APT):**
- `curl`, `wget`, `git`, `unzip`, `build-essential`, `dkms`, `ca-certificates`, `ca-certificates-java`
- `postgresql`, `postgresql-contrib`
- `openjdk-17-jdk`, `maven`
- `xclip`
- `gnome-terminal`, `gnome-system-monitor`, `neofetch`
- `libreoffice` (pt-BR)
- `firefox`

**Aplicativos (SNAP):**
- Brave Browser
- Insomnia
- GitHub CLI (`gh`)
- Docker

**Repositório externo:**
- Claude Desktop

**Editores e IDEs:**
- **Eclipse IDE** 2026-06 + **Spring Tool Suite** 5.4.0 (`~/.local/opt`, com JRE próprio)
- **Neovim** (última versão, via tarball oficial)

**Ecossistemas de Desenvolvimento:**
- **Node.js**: NVM v0.40.8 e Node.js v24
- **Java**: OpenJDK 17 e Maven
- **uv** (gerenciador de pacotes Python)
- **Claude**: Claude Code (CLI) e Claude Desktop

## 🚀 Como usar

1. Dê permissão de execução para o arquivo:
```bash
chmod +x setup.sh
```

2. Execute o script de instalação:
```bash
./setup.sh
```

> **Nota:** É recomendado reiniciar o terminal após a execução do script para carregar as variáveis de ambiente (como as do NVM e do `JAVA_HOME`).

> **Nota:** o script é idempotente — pacotes e programas já instalados são apenas pulados, então pode rodar novamente com segurança.
