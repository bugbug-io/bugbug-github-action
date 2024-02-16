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

if [ -n "$VARIABLES" ]; then
    IFS=',' read -ra elements <<< "$myVar"

    # Add something to each element in the array
    for ((i=0; i<${#elements[@]}; i++)); do
        extra_args+="--variable=${elements[$i]}"
    done
fi

echo "$DEBUG $PROFILE_NAME $VARIABLES"

bugbug config set-token $API_TOKEN
bugbug remote run $run_context $related_id --no-progress "${extra_args[@]}"