#!/bin/bash
set -e

# Check input
if [ -z "$1" ]; then
  echo "Usage: $0 <chart-name>"
  exit 1
fi
cd charts
CHART_NAME=$1
HELM_REPO_DIR=../ # <-- Change this to your Git repo path
GIT_BRANCH="master"                                  # <-- Change if using a different branch
HELM_REPO_URL="https://argadepp.github.io/helm-chart" # <-- Update this

echo "Packaging Helm chart: $CHART_NAME"
helm package $CHART_NAME

PACKAGE_FILE=$(ls ${CHART_NAME}-*.tgz | head -n1)
echo "Packaged file: $PACKAGE_FILE"

echo "Copying package to Helm repo directory..."
cp $PACKAGE_FILE $HELM_REPO_DIR

cd $HELM_REPO_DIR

echo "Updating Helm repo index..."
helm repo index . --url $HELM_REPO_URL

echo "Adding changes to Git..."
git add .
git commit -m "Add/update chart $CHART_NAME"
git push origin $GIT_BRANCH

echo "Helm chart $CHART_NAME published successfully!"
