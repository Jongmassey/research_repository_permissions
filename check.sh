#!/bin/bash
#export GITHUB_REPOSITORY="opensafely_dummy_icnarc"
allowed_datasets=$(
    sed -e "/$GITHUB_REPOSITORY:/,/^\S*/!d" repository_permissions.yaml |
        sed -e "/^$GITHUB_REPOSITORY/d" |
        sed -e 's/\s*allow\:\s*\[//g' |
        sed -e 's/\]//g' |
        sed -e "s/'//g"
)

declare -A FOUND_DATASETS
matches_found=false
#echo $allowed_datasets
for f in $(ls datasources | sed 's/.txt//g'); do
    if [[ ",$allowed_datasets," = *",$f,"* ]]; then
        continue
    fi
    matches=()
    for rf in $(cat "datasources/$f.txt"); do
        matches+=$(grep -n $rf $1 | grep "^[0-9]*\:[^#]")
    done
    #add to dict if matches found
    if [[ ${matches[@]} ]]; then
        matches_found=true
        FOUND_DATASETS["${f}"]=$matches
    fi
done

if "$matches_found" = true; then
    echo "Instances of restricted function calls found:"
    for key in "${!FOUND_DATASETS[@]}"; do
        echo " - $key"
        matches=${FOUND_DATASETS[$key]}
        for match in "${matches[@]}"; do
            echo -e "\t ${match}"
        done
    done

    echo "If you believe this to be in error, please contact the OpenSAFELY Team"
    exit 1
fi

exit 0
