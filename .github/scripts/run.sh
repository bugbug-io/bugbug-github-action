run_context="test"
related_id="$TEST_ID"

if [ -n "$SUITE_ID" ]; then
    run_context="suite"
    related_id="$SUITE_ID"
fi

extra_args=()
if [ -n "$PROFILE_NAME" ]; then
    extra_args+=("--profile=$PROFILE_NAME")
fi

if [ -n "$DEBUG" ]; then
    extra_args+=("--debug=$DEBUG")
fi

if [ -n "$OUTPUT_PATH" ]; then
    extra_args+=("--output-path=$OUTPUT_PATH")
fi

if [ -n "$VARIABLES" ]; then
    IFS=',' read -ra var_pairs <<< "$VARIABLES"
    for pair in "${var_pairs[@]}"; do
        extra_args+=("--variable='$pair'")
    done
fi

echo "$DEBUG $PROFILE_NAME $VARIABLES"

tmp_output=$(mktemp)

bugbug config set-token $API_TOKEN
bugbug remote run $run_context $related_id --no-progress --reporter=junit --triggered-by=github "${extra_args[@]}" | tee $tmp_output
bugbug_status=${PIPESTATUS[0]}

# Setting output suiteRunId or testRunId
while IFS= read -r line; do
    if [[ $line =~ suiteRunId:\ ([a-z0-9-]+) ]]; then
        SUITE_RUN_ID="${BASH_REMATCH[1]}"
        echo "Setting output suiteRunId = $SUITE_RUN_ID"
        echo "suiteRunId=${SUITE_RUN_ID}" >> $GITHUB_OUTPUT
    elif [[ $line =~ testRunId:\ ([a-z0-9-]+) ]]; then
        TEST_RUN_ID="${BASH_REMATCH[1]}"
        echo "Setting output testRunId = $TEST_RUN_ID"
        echo "testRunId=${TEST_RUN_ID}" >> $GITHUB_OUTPUT
    fi
done < $tmp_output

exit $bugbug_status
