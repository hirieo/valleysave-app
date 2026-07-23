<div align="center">

<img src="../../assets/icons/icon.png" width="200" height="200" alt="ValleySave — logótipo da app de sincronização de saves de Stardew Valley">

# ValleySave

**Sincroniza os teus saves de Stardew Valley entre Windows, macOS, Linux e Android — com o teu próprio Google Drive.**

Sem servidores de terceiros. Sem subscrições. Sem rastreio. Os teus saves nunca saem da tua própria conta Google.

[![Última versão](https://img.shields.io/github/v/release/hirieo/valleysave-app?label=Transferir&color=brightgreen)](https://github.com/hirieo/valleysave-app/releases/latest)
[![Transferências](https://img.shields.io/github/downloads/hirieo/valleysave-app/total?color=blue)](https://github.com/hirieo/valleysave-app/releases)
[![Licença: Polyform NC](https://img.shields.io/badge/Licen%C3%A7a-Polyform%20NC-orange)](../../LICENSE)
![Plataformas](https://img.shields.io/badge/Windows%20%7C%20macOS%20%7C%20Linux%20%7C%20Android-lightgrey)

[🇬🇧 English](../../README.md) · [🇪🇸 Español](README.es.md) · [🇫🇷 Français](README.fr.md) · [🇩🇪 Deutsch](README.de.md) · [🇮🇹 Italiano](README.it.md) · 🇵🇹 Português · [Euskera](README.eu.md) · [🇷🇺 Русский](README.ru.md) · [🇺🇦 Українська](README.uk.md) · [🇯🇵 日本語](README.ja.md) · [🇰🇷 한국어](README.ko.md) · [🇨🇳 中文](README.zh.md) · [🇹🇼 中文（繁體）](README.zh-Hant.md) · [🇹🇭 ไทย](README.th.md)

</div>

---

> [!IMPORTANT]
> **O ValleySave está em acesso antecipado.** O ecrã de início de sessão da Google ainda está pendente de verificação por parte da Google, por isso, para já, só contas Google na lista de permissões podem ligar-se. Para obteres acesso, envia um email para **lhirieo@gmail.com** com a conta Google (email) que vais usar com o ValleySave. Vai abrir para todos assim que a verificação da Google estiver concluída.

## O que é o ValleySave?

O Stardew Valley não tem sincronização oficial de saves na nuvem entre PC e telemóvel. **O ValleySave preenche essa lacuna**: deteta as tuas quintas, envia-as para uma pasta `ValleySave/` no **teu próprio Google Drive**, e permite-te transferi-las e continuar a jogar em qualquer outro dispositivo — Windows, macOS, Linux ou Android.

- 🔒 **Privacidade primeiro** — usa o scope restrito `drive.file` da Google: a app só vê os ficheiros que ela própria criou, nunca o resto do teu Drive.
- 🖥️ **Verdadeiramente multiplataforma** — um só código (Flutter), builds nativas para as quatro plataformas.
- 🌍 **14 idiomas** — português, inglês, espanhol, basco, francês, alemão, italiano, russo, ucraniano, japonês, coreano, chinês (simplificado e tradicional) e tailandês.

## Funcionalidades

### Sincronização e transferência de saves
- **Deteção automática de quintas** — encontra os teus saves em todas as plataformas, incluindo Steam (nativo, Flatpak e Snap no Linux) e a pasta protegida `Android/data` no Android (modos root, [Shizuku](https://shizuku.rikka.app/) ou ponte manual).
- **Enviar / transferir com um clique** — cada quinta mostra que lado está à frente (local ou Drive) e recomenda a ação certa.
- **Proteção contra saves incompletos** — um save com ficheiros em falta no Drive é assinalado e não pode ser transferido pela metade.

### Segurança dos dados (a parte de que mais nos orgulhamos)
- **Substituição transacional** — cada transferência, importação e restauro segue *preparar → validar → salvaguardar → substituir → verificar* com rollback automático. Se o PC crashar a meio, o save original fica intacto ou é restaurado automaticamente. Nunca uma quinta escrita pela metade.
- **Envios atómicos** — os envios vão para uma nova pasta de "geração" imutável e são publicados com uma única atualização final do manifesto. Outros dispositivos nunca veem um save enviado pela metade.
- **Backups automáticos com retenção** — antes de qualquer substituição é criado um backup verificado; guardam-se os últimos 5 automáticos por quinta (os manuais nunca são apagados).
- **Recuperação após crashes** — as pastas temporárias de uma operação interrompida são detetadas e resolvidas em segurança no arranque seguinte, preferindo sempre a cópia válida.

### Multijogador cooperativo
- **Mudança de anfitrião** — transfere o papel de anfitrião de uma quinta coop para outro jogador no ficheiro do save, com validação completa de integridade antes e depois. Continuem a mesma quinta mesmo quando o anfitrião habitual está ausente.
- **Partilha quintas com amigos** — partilha uma quinta pelo Drive para outros jogadores a transferirem e continuarem a jogar, com distintivos de papel (só leitura ou sincronização).
- **Cartões com todos os jogadores** — as quintas coop mostram todos os agricultores, não só o anfitrião.

### Qualidade de vida
- **Lança o jogo a partir da app** — deteta e inicia o Stardew Valley no Windows, macOS e Linux (Steam nativo / Flatpak / Snap).
- **Importa saves de .zip** — com a mesma segurança transacional das transferências.
- **Atualizador integrado** — verifica o GitHub Releases e transfere a nova versão por ti.
- **Interface sazonal** — toda a interface segue a estação do jogo: pétalas na primavera, pirilampos no verão, folhas no outono, neve no inverno.

## Transferências

Obtém a versão mais recente em **[Releases](https://github.com/hirieo/valleysave-app/releases/latest)**:

| Plataforma | Ficheiro | Notas |
|---|---|---|
| **Windows** | `ValleySave-Setup-*.exe` | Instalador — runtime VC++ incluído, 14 idiomas |
| **Windows** (portátil) | `ValleySave-*-windows.zip` | Extrair e executar |
| **macOS** | `valleysave-macos.zip` | Extrair, mover para Aplicações |
| **Linux** (Ubuntu/Debian) | `valleysave_*_amd64.deb` | Duplo clique para instalar — com ícone no menu |
| **Linux** (portátil) | `valleysave-linux-x64.tar.gz` | Extrair e executar, qualquer distro |
| **Android** | `ValleySave-*.apk` | Android 8+ |

> [!NOTE]
> **📱 iOS:** Já está pronta. O que falta são os 99 USD/ano que a Apple cobra como taxa de entrada — [ajude no Ko-fi](https://ko-fi.com/hirieo) e o iOS entra na festa.

## Como funciona

1. **Liga** — associa a tua própria conta Google (OAuth, apenas scope `drive.file`).
2. **Deteta** — o ValleySave encontra as tuas quintas automaticamente.
3. **Sincroniza** — envia as quintas para uma pasta `ValleySave/` do teu Drive.
4. **Continua onde quiseres** — instala o ValleySave noutro dispositivo, liga a mesma conta, transfere e joga.

## Perguntas frequentes

**O Stardew Valley tem saves na nuvem oficiais entre PC e telemóvel?**
Não — os saves são locais e não existe sincronização oficial entre plataformas. O ValleySave fornece-a usando o teu próprio Google Drive.

**Os meus saves estão seguros?**
Toda a operação destrutiva é transacional: o original é salvaguardado e verificado antes de ser substituído, e restaurado automaticamente se algo falhar.

**Onde ficam guardados os meus saves?**
Numa pasta `ValleySave/` dentro do *teu próprio* Google Drive. Não existe nenhum servidor ValleySave.

**Posso mover uma quinta entre Windows e Android?**
Sim — é o caso de uso principal. Também macOS e Linux, em qualquer direção.

## Compilar a partir do código

Requisitos: [Flutter](https://docs.flutter.dev/get-started/install) ≥ 3.12 · Android Studio (para Android)

```bash
git clone https://github.com/hirieo/valleysave-app.git
cd valleysave-app

flutter pub get
cp .env.example .env
# Desktop: preenche GOOGLE_CLIENT_ID e GOOGLE_CLIENT_SECRET no .env
flutter run
```

## Licença

[Polyform Noncommercial 1.0.0](../../LICENSE) — podes ler o código, aprender com ele e contribuir; o uso comercial requer autorização explícita.

Distribuído **sem qualquer garantia**. Usa por tua conta e risco.
