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

- **Description**: Override variable during a single run. Pass all variables in a format: `key1=value1,key2=value2`. All overridden variables should be defined in BugBug as well.
- **Required**: No

`debug`

- **Description**: Show more data (like raw API response).
- **Required**: No
- **Default**: false

`outputPath`

- **Description**: Path to the output file with the test results (junit).
- **Required**: No
- **Default**: `test-results.xml`

### Outputs

`suiteRunId`

- **Description**: The Run ID when executing passing a suiteId.

`testRunId`

- **Description**: The Run ID when executing passing a testId.

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
        id: run-bugbug-tests
        uses: bugbug-io/bugbug-github-action@v1.2.1
        with:
          apiToken: ${{ secrets.BUGBUG_API_TOKEN }}
          testId: "Your BugBug test ID"
          suiteId: "Your BugBug suite ID"
          profileName: "Your BugBug profile name"
          variables: "key1=value1,key2=value2"
          debug: "true"

      - name: Getting Run Output
        run: |
          echo "Suite Run ID: ${{ steps.run-bugbug-tests.outputs.suiteRunId }}"
          echo "Test Run ID: ${{ steps.run-bugbug-tests.outputs.testRunId }}"
```
