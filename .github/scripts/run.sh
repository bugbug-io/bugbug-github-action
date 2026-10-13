run_context="test"
related_id="$TEST_ID"

if [ -n "$SUITE_ID" ]; then
    run_context="suite"
    related_id="$SUITE_ID"
fi

extra_args=()
if [ -n "$PROFILE_NAME" ]; then
    extra_args+=(--profile "$PROFILE_NAME")
fi

if [[ "$DEBUG" == "true" ]]; then
    extra_args+=(--verbose)
fi

if [ -n "$OUTPUT_PATH" ]; then
    extra_args+=(--output-path "$OUTPUT_PATH")
fi

if [ -n "$VARIABLES" ]; then
    IFS=',' read -ra var_pairs <<< "$VARIABLES"
    for pair in "${var_pairs[@]}"; do
        extra_args+=(--variable "$pair")
    done
fi

if [ -n "$TAGS" ]; then
    IFS=',' read -ra tag_values <<< "$TAGS"
    for tag in "${tag_values[@]}"; do
        tag="${tag#"${tag%%[![:space:]]*}"}"
        tag="${tag%"${tag##*[![:space:]]}"}"
        if [ -n "$tag" ]; then
            extra_args+=(--tag "$tag")
        fi
    done
fi

tmp_output=$(mktemp)

export BUGBUG_API_TOKEN="$API_TOKEN"
if [ "$run_context" = "suite" ]; then
    command=(bugbug --ci suites run "$related_id")
else
    command=(bugbug --ci tests run "$related_id")
fi
"${command[@]}" --reporter junit "${extra_args[@]}" | tee "$tmp_output"
bugbug_status=${PIPESTATUS[0]}

# Setting output suiteRunId or testRunId
while IFS= read -r line; do
    if [[ $line =~ Suite\ run\ id:\ ([a-z0-9-]+) ]]; then
        SUITE_RUN_ID="${BASH_REMATCH[1]}"
        echo "Setting output suiteRunId = $SUITE_RUN_ID"
        echo "suiteRunId=${SUITE_RUN_ID}" >> $GITHUB_OUTPUT
    elif [[ $line =~ Test\ run\ id:\ ([a-z0-9-]+) ]]; then
        TEST_RUN_ID="${BASH_REMATCH[1]}"
        echo "Setting output testRunId = $TEST_RUN_ID"
        echo "testRunId=${TEST_RUN_ID}" >> $GITHUB_OUTPUT
    fi
done < $tmp_output

exit $bugbug_status
