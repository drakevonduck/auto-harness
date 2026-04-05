# Stack Overlay: Node.js / TypeScript

This overlay activates Node- and TypeScript-specific assumptions only when composed.

It owns:

- runtime pinning and lockfile expectations
- package-manager behavior
- typecheck, lint, test, and build command expectations
- dependency-review sensitivity

It does not own architecture examples such as web apps or Next.js. Those belong in architecture or domain overlays.
