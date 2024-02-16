<p align="left">
  <img src="https://app.bugbug.io/favicon/favicon-apple.png" width="120" />
</p>

## BugBug Cloud Runner
Official GitHub action to run tests and suites on BugBug Cloud.

> [!IMPORTANT]
> Available only for paid plans.

### Inputs

`apiToken`

- **Description**: A token to authenticate with BugBug. Available only for paid plans.
- **Required**: Yes

`testId` / `suiteId`

- **Description**: Run with a specific test/suite ID.
- **Required**: Yes

`profileName`

- **Description**: Run with a specific profile by providing its name (string).
- **Required**: No

`variables`

- **Description**: Override variable during a single run. Pass all variables in a format: `key1=value1,key2=value2`.
- **Required**: No

`debug`

- **Description**: Show more data (like raw API response).
- **Required**: No
- **Default**: false

### Example Usage

```yaml
on: [push]

jobs:
  run-bugbug-tests:
    runs-on: ubuntu-latest
    name: Run BugBug Tests
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Run BugBug Cloud Runner
        uses: bugbug-io/bugbug-github-action@v1
        with:
          apiToken: ${{ secrets.BUGBUG_API_TOKEN }}
          testId: "Your BugBug test ID"
          suiteId: "Your BugBug suite ID"
          profileName: "Your BugBug profile name"
          variables: "key1=value1,key2=value2"
          debug: "true"
```