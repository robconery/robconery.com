# robconery.com

The landing page at [robconery.com](https://robconery.com), served by GitHub Pages from this repo's `main` branch.

- `index.html` is the whole site: plain HTML and CSS with a few lines of JavaScript for scroll reveals and the mobile menu. No build step. Fonts (Instrument Serif, Geist, Geist Mono) come from Google Fonts.
- `img/` holds every image the page uses. `this-developers-life.jpg` is a screenshot of thisdeveloperslife.com.
- `CNAME` tells GitHub Pages which domain to answer to. Leave it alone.
- DNS lives at Cloudflare: `A` and `AAAA` records on the apex pointing at GitHub Pages, and `www` as a CNAME to `robconery.github.io`.

Design notes: paper, basalt and iron-oxide red (Red:4 is Mars). The work history is drawn as a stratigraphic column, youngest rock on top, geology as bedrock. Colors and type live in the `:root` tokens at the top of the stylesheet.

To change the page, edit `index.html` and push to `main`. GitHub rebuilds in about a minute.
