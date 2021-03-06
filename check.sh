#!/bin/bash
GITHUB_REPOSITORY=$(echo "$GITHUB_REPOSITORY" | sed 's/\//\\\//g')
CHECK_DIR=`dirname $BASH_SOURCE`
allowed_datasets=$(
    sed -e "/$GITHUB_REPOSITORY:/,/^\S*/!d" "$CHECK_DIR/repository_permissions.yaml" |
        sed -e "/^$GITHUB_REPOSITORY/d" |
        sed -e 's/\s*allow\:\s*\[//g' |
        sed -e 's/\]//g' |
        sed -e "s/'//g"
)
declare -A MATCHED_FILES
global_matches_found=false
for study_def in $(find $1 -name "*.py"); do
    if echo "$study_def"|grep -q "$CHECK_DIR"; then
        continue
    fi
    echo "checking: $study_def"
    declare -A FOUND_DATASETS
    file_matches_found=false
    for f in $(ls "$CHECK_DIR/datasources" | sed 's/.txt//g'); do
        if [[ ",$allowed_datasets," = *",$f,"* ]]; then
            continue
        fi
        echo "  looking for usage of $f"
        matches=()
        for rf in $(cat "$CHECK_DIR/datasources/$f.txt"); do
            matches+=$(grep -n $rf $study_def | grep "^[0-9]*\:[^#]")
        done
        #add to dict if matches found
        if [[ ${matches[@]} ]]; then
            file_matches_found=true
            FOUND_DATASETS["${f}"]=$matches
        fi
    done
    if "$file_matches_found" = true; then
        global_matches_found=true
        MATCHED_FILES["${study_def}"]=$FOUND_DATASETS
    fi
done

if "$global_matches_found" = true; then
    for study_def in "${!MATCHED_FILES[@]}"; do
        echo "Instances of restricted function calls found in $study_def:"
        for key in "${!FOUND_DATASETS[@]}"; do
            echo " - $key"
            matches=${FOUND_DATASETS[$key]}
            for match in "${matches[@]}"; do
                echo -e "\t ${match}"
            done
        done
    done
    echo "If you believe this to be in error, please contact the OpenSAFELY Team"
    exit 1
fi

exit 0
