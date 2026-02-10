# arch-docs

[![Go 1.25](https://img.shields.io/badge/Go-1.25-00ADD8?logo=go)](https://go.dev)
[![GitHub Action](https://img.shields.io/badge/GitHub-Action-2088FF?logo=github-actions)](https://github.com/supermodeltools/arch-docs)

Generate architecture documentation for any repository using [Supermodel](https://supermodeltools.com). Produces a full static site with search, SEO, taxonomy navigation, interactive charts, and dependency graphs.

## Usage

```yaml
name: Architecture Docs
on:
  push:
    branches: [main]

jobs:
  docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: supermodeltools/arch-docs@main
        id: docs
        with:
          supermodel-api-key: ${{ secrets.SUPERMODEL_API_KEY }}

      - uses: actions/upload-pages-artifact@v3
        with:
          path: ${{ steps.docs.outputs.site-path }}

      - uses: actions/deploy-pages@v4
```

## Inputs

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| `supermodel-api-key` | Yes | — | Supermodel API key |
| `site-name` | No | `<repo> Architecture Docs` | Display name for the docs site |
| `base-url` | No | GitHub repo URL | Base URL for the generated site |
| `output-dir` | No | `./arch-docs-output` | Output directory relative to workspace |
| `templates-dir` | No | — | Custom templates directory (overrides bundled defaults) |

## Outputs

| Output | Description |
|--------|-------------|
| `site-path` | Absolute path to the built site directory |
| `entity-count` | Number of entities generated |
| `page-count` | Total HTML pages generated |

## How It Works

1. Zips the repository (skipping `.git/`, `node_modules/`, binaries, large files)
2. Sends the zip to the Supermodel API for code analysis
3. Receives a graph JSON with nodes (files, functions, classes, domains) and relationships
4. Runs [graph2md](https://github.com/supermodeltools/graph2md) to convert the graph to markdown
5. Runs [pssg](https://github.com/greynewell/pssg) to build a static site with the bundled templates

## Custom Templates

To customize the look of the generated site, create a `templates/` directory in your repository with your own HTML templates and pass it via the `templates-dir` input:

```yaml
- uses: supermodeltools/arch-docs@main
  with:
    supermodel-api-key: ${{ secrets.SUPERMODEL_API_KEY }}
    templates-dir: './my-templates'
```

See the bundled [templates/](./templates/) directory for the default templates and available template variables.

## Example Output

The generated site includes:

- Homepage with architecture overview chart and codebase composition treemap
- Entity pages with dependency diagrams, relationship graphs, and source code
- Taxonomy pages for node types, languages, domains, subdomains, directories, extensions, and tags
- Full-text search with keyboard navigation
- SEO metadata, Open Graph tags, JSON-LD structured data, sitemap, and RSS feed
