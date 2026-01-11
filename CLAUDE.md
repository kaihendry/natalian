The code to drive the blog is /home/hendry/tmp/blog

The output is served by python -m http.server (likely already running) from /tmp/www/natalian

Use `AWS_PROFILE=mine /home/hendry/.local/bin/upload` to upload static content like images.

> e.g. curl -O https://www.albamclothing.com/cdn/shop/files/wcdevf.png?v=1762948077
> AWS_PROFILE=mine upload wcdevf.png

Result: https://s.natalian.org/2026-01-11/wcdevf.png
