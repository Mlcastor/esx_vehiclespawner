# Contributing to **esx_resource_template**

First off, thanks for taking the time to contribute!  This project follows a few simple rules so that every PR is easy to review and releases stay predictable.

---

## 1. Development setup

```bash
# lint Lua & TS
make lint

# auto-format Lua (Stylua)
make format

# run tests (placeholder)
make test
```

---

## 2. Code style

| Language | Formatter / Linter | Notes |
|----------|--------------------|-------|
| **Lua**  | [Stylua](https://github.com/JohnnyMorganz/StyLua) (`make format`) | 2-space indent, 120-col width |
| **Lua**  | [Luacheck](https://github.com/mpeterv/luacheck) (`make lint`) | config in `.luacheckrc` |
| **TS/JS**| [Prettier](https://prettier.io/) | Tailwind plugin enabled |
| **Shell**| `shfmt` (CI) | POSIX-compatible |

Early returns, descriptive variable names, and DRY helpers are encouraged. Follow the patterns already in the repo.

---

## 3. Commit message convention

We use **[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)**.  This is _required_ because our release automation parses the commit history.

```
<type>(optional scope): <summary>

<body>

<footer>
```

### Allowed `<type>` values

* `feat` – new feature (🔖 MINOR bump)
* `fix`  – bug fix     (🔖 PATCH bump)
* `perf` – performance improvement (PATCH)
* `docs` – documentation only
* `refactor`, `chore`, `build`, `test`

Add `!` after the type (`feat!:`) **or** a `BREAKING CHANGE:` footer to indicate a **major** (⚠️) release.

If you need to force a specific version, add a footer:

```
Release-As: 2.1.0
```

---

## 4. Release workflow (Release Please)

1. Push commits to `main` (use PRs—branch protection blocks direct pushes).
2. CI opens a PR named `chore(main): release x.y.z` summarising the changelog.
3. Review & **squash-merge** that PR.  CI then:
   * Tags `vX.Y.Z`.
   * Publishes a GitHub Release.
4. Done. No manual version bumps! 🎉

If you see a CI failure about permissions, ensure the repository settings grant GitHub Actions **read & write** + allow it to create PRs.

---

## 5. Pull-request checklist

* [ ] Follows code style (`make lint` passes).
* [ ] Uses Conventional Commit title.
* [ ] Adds tests / docs when appropriate.
* [ ] Keeps PR focused—one logical change.

Thank you! 🚀 