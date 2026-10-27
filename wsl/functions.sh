function o-commit() {
    branchName=$(git rev-parse --abbrev-ref HEAD)
    commitMessage="$1"
    if [ -z "$commitMessage" ]; then
        commitMessage="Small changes made on $branchName ⚙️"
    fi
    echo ''
    git add .
    git commit -m "$commitMessage"
    echo ''
    git push
}
