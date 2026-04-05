# Architecture Overview

## System Summary

Browser-facing web application backed by a relational data store and operated as a production SaaS.

## Major Components

| Component | Responsibility | Owner | Notes |
|-----------|----------------|-------|-------|
| Web UI | User-facing flows | @owner | Browser-facing |
| Application service | Validation and write path | @owner | Server-controlled |
| Postgres | Relational state | @owner | Migration-governed |
