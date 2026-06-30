# Setups Bash

Criado para toda vez que estiver em uma máquina nova ou fizer a formatação do computador, não ter que instalar tudo novamente sem ter que lembrar de algo.

## 📦 O que este script instala?

**Utilitários Básicos & Banco de Dados (APT):**
- `curl`, `wget`, `git`, `unzip`, `build-essential`
- `postgresql`, `postgresql-contrib`
- `python3`, `python3-pip`
- `input-remapper` (via .deb)

**Aplicativos & Ferramentas (SNAP):**
- Brave Browser
- Insomnia
- Obsidian
- IntelliJ IDEA Community
- GitHub CLI (`gh`)

**Ecossistemas de Desenvolvimento:**
- **Node.js**: NVM e Node.js (v24)
- **Rust**: rustup, rustc e cargo
- **PHP**: PHP 8.4 (com extensões essenciais) e Composer
- **Code Editor**: Zed

## 🚀 Como usar

1. Dê permissão de execução para o arquivo:
```bash
chmod +x setup.sh
```

2. Execute o script de instalação:
```bash
./setup.sh
```

> **Nota:** É recomendado reiniciar o terminal após a execução do script para carregar as variáveis de ambiente (como o NVM e o Rust).
