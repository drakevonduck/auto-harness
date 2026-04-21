# HARNESS.md

This sample project uses the modular harness manifest at `harness.manifest.yaml`.

Source modules:

- `kernel/base`
- `node-typescript`
- `web-app`
- `relational-postgres`
- `production-saas`
- `product-lite`
- `project-standard`
- `base`
- `claude-code`

Validators live inside the mounted harness submodule. Invoke them through
`.harness/platform/...` paths, for example:

```
ruby -I .harness/platform/validators/lib .harness/platform/validators/test/test_harness_registry.rb
ruby -I .harness/platform/validators/lib .harness/platform/validators/test/test_validators_integration.rb
```
