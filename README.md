# Setups Bash

O objetivo principal deste projeto é **automatizar tarefas repetitivas** na configuração de ambientes de desenvolvimento. Ele foi criado para agilizar o processo sempre que for necessário formatar o computador ou configurar uma máquina nova, garantindo que você não esqueça de instalar nenhuma ferramenta essencial.

Este repositório é público! Se você deseja automatizar a instalação dos seus próprios programas, sinta-se à vontade para utilizar este projeto como base, fazer um fork e adaptar a lista de pacotes para o seu uso pessoal.

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

## 🚀 Como instalar e usar no seu computador

Para utilizar este script no seu próprio computador, basta abrir o seu terminal e seguir o passo a passo abaixo:

1. **Clone este repositório** para a sua máquina local:
```bash
git clone https://github.com/SEU_USUARIO/SetupsBash.git
```
*(Não se esqueça de substituir `SEU_USUARIO` pelo seu usuário do GitHub caso faça um fork)*

2. **Acesse a pasta do projeto:**
```bash
cd SetupsBash
```

3. **Dê a permissão de execução** necessária para o script rodar:
```bash
chmod +x setup.sh
```

4. **Execute o script de instalação:**
```bash
./setup.sh
```

> **Nota:** Feito para automatizar a instalação de pacotes e configurações básicas em derivações do **Ubuntu**.

> **Nota:** Dependendo da sua máquina, a instalação pode demorar alguns minutos. Após o script finalizar com sucesso, **feche e abra o seu terminal novamente** para garantir que as novas variáveis de ambiente (como as do NVM e do Rust) sejam carregadas corretamente.
