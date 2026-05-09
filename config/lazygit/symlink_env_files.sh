#!/bin/bash
# symlink_env_files.sh
# Symlinks .env and .envrc files from the main worktree to a new worktree
# Usage: symlink_env_files.sh <target_directory>

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the source directory (main worktree)
SOURCE_DIR="${DPC_MAIN_WORKTREE:-$HOME/github/data-platform-core}"

# Get the target directory from argument or use current directory
TARGET_DIR="${1:-.}"

# Normalize paths
SOURCE_DIR="$(cd "$SOURCE_DIR" 2>/dev/null && pwd)" || {
    echo -e "${RED}Error: Source directory not found: ${SOURCE_DIR}${NC}"
    exit 1
}

TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || {
    echo -e "${RED}Error: Target directory not found: $1${NC}"
    exit 1
}

# Check that target is different from source
if [[ "$SOURCE_DIR" == "$TARGET_DIR" ]]; then
    echo -e "${YELLOW}Target directory is the same as source. Skipping symlink creation.${NC}"
    exit 0
fi

echo -e "${GREEN}Symlinking .env and .envrc files${NC}"
echo "Source: $SOURCE_DIR"
echo "Target: $TARGET_DIR"
echo ""

# List of relative paths to symlink
# Exclude generated files like .env_example and CDK output
PATHS_TO_SYMLINK=(
    "elt/.env"
    "elt/.envrc"
    "elt/transformations/.env"
    "cdk_iac/.envrc"
    ".envrc"
)

CREATED_COUNT=0
SKIPPED_COUNT=0

for relative_path in "${PATHS_TO_SYMLINK[@]}"; do
    source_file="$SOURCE_DIR/$relative_path"
    target_file="$TARGET_DIR/$relative_path"
    target_dir="$(dirname "$target_file")"

    # Skip if source doesn't exist
    if [[ ! -f "$source_file" ]]; then
        echo -e "${YELLOW}⊘ Skipped (not found): $relative_path${NC}"
        ((SKIPPED_COUNT++))
        continue
    fi

    # Create target directory if needed
    if [[ ! -d "$target_dir" ]]; then
        mkdir -p "$target_dir"
    fi

    # Remove existing file/symlink at target
    if [[ -e "$target_file" || -L "$target_file" ]]; then
        rm -f "$target_file"
    fi

    # Create symlink
    ln -s "$source_file" "$target_file"
    echo -e "${GREEN}✓ Symlinked: $relative_path${NC}"
    ((CREATED_COUNT++))
done

echo ""
echo -e "${GREEN}Done! Created $CREATED_COUNT symlinks, skipped $SKIPPED_COUNT files.${NC}"
