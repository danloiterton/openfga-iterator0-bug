# OpenFGA Iterator 0 bug #
Minimal git repo to reproduce the bug described here:
<br/>https://github.com/orgs/openfga/discussions/491

Where doing a specific tuple check, with certain relationships defined, I get:
```
"internal_error": "iterator 0 is not in ascending order"
```

Observations:
- The error does not occur when using the default in-memory database. 
<br/>This repo uses the postgres setup documented here: https://openfga.dev/docs/getting-started/setup-openfga/docker
- It may be related to id casing?
<br/>If you remove the `team:C` relationship in `tuples.json`, the error goes away. Same if you change it to any lower-case id, like `team:c`
- Simplifying the model slightly also fixes the error. 
<br/>Remove the `team>manager` definition (and reference in `team>member`) in `authModel.fga`

---

To reproduce the error, run `docker compose up`