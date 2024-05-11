# FiM DB Schema
This repository contains the schema and migrations for the main databased used by FiM internal tooling.

## Working Locally
It's recommended to use the [Supabase CLI](https://supabase.com/docs/guides/cli) to spin up a local database or create new migrations. Please be mindful when creating new migrations that old data in the database may not match your new schema. Run updates on existing data where appropriate to fit it to new schemas.

## CI/CD
Each commit on main or a PR into main will start an action which validates all migrations, then spins up a new database to ensure they apply without error. This action passing is required for a PR to get merged.

Once changes have been merged into main, a trusted repo maintainer can approve a deployment to prod, at which point the changes will go live.
