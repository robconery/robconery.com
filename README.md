# robconery.com

The landing page at [robconery.com](https://robconery.com), served by GitHub Pages from this repo's `main` branch.

- `index.html` is the whole site: one self-contained file exported from Claude Design, with fonts and the hero photo inlined. No build step.
- `CNAME` tells GitHub Pages which domain to answer to. Leave it alone.
- DNS lives at Cloudflare: `A` and `AAAA` records on the apex pointing at GitHub Pages, and `www` as a CNAME to `robconery.github.io`.

To change the page, replace `index.html` and push to `main`. GitHub rebuilds in about a minute.
