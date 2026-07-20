# aniketmi.github.io

My digital garden. Built on the
[digital-garden-jekyll-template](https://github.com/maximevaillancourt/digital-garden-jekyll-template)
(MIT, by Maxime Vaillancourt), restyled with the
[Flexoki](https://github.com/kepano/flexoki) palette (MIT) and a light/dark
toggle. Deployed on GitHub Pages via GitHub Actions.

## Features

- `[[wiki-links]]` between notes
- Automatic backlinks ("Notes mentioning this note")
- Hover link previews
- Interactive notes graph
- Light / dark theme toggle (remembers your choice, respects OS default)

## Write a note

Create a Markdown file in `_notes/`, e.g. `_notes/my-idea.md`:

```markdown
---
title: My idea
---

Some thoughts. Link to another note with [[welcome]].
```

Filename or title both work in links: `[[my-idea]]` or `[[My idea]]`.
Pages (non-note) live in `_pages/` (`index.md`, `about.md`).

## Run locally

Needs Ruby 3.x (the macOS system Ruby 2.6 is too old — install via `rbenv` or
Homebrew). The template pins `3.2.1` in `.ruby-version`.

```bash
bundle install
bundle exec jekyll serve
# open http://localhost:4000
```

## Deploy to GitHub Pages (via Actions)

This template uses custom Jekyll plugins, which classic GitHub Pages does NOT
run. The included workflow (`.github/workflows/jekyll.yml`) builds with plugins
and deploys, so everything works.

1. Create a repo named **`aniketmi.github.io`** (must match your GitHub
   username for a user site). Different repo name? Set `baseurl: '/reponame'`
   in `_config.yml`.
2. Push this folder to the **`main`** branch.
3. Repo → **Settings → Pages → Build and deployment → Source: GitHub Actions**.
4. The workflow runs on every push to `main`; site goes live at
   `https://aniketmi.github.io`.

## Customize

- Name / URL: `_config.yml`
- Nav + theme toggle: `_includes/nav.html`
- Footer: `_includes/footer.html`
- Colors: CSS variables at the top of `_sass/_style.scss`

## Credits

- Template: [Maxime Vaillancourt](https://github.com/maximevaillancourt/digital-garden-jekyll-template) (MIT — see `LICENSE`)
- Color palette: [Flexoki](https://github.com/kepano/flexoki) by Steph Ango (MIT)
