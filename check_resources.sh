#!/usr/bin/env bash

# Exit immediately if any command fails
set -e

########################################
# Preflight Checks
########################################

# 1. Check Bash version (requires Bash 4+)
if (( BASH_VERSINFO[0] < 4 )); then
  echo "❌ Bash 4+ required. Current version: $BASH_VERSION"
  exit 1
fi

# 2. Check if Azure CLI is installed
if ! command -v az >/dev/null 2>&1; then
  echo "❌ Azure CLI not installed. Please install it first."
  exit 1
fi

# 3. Check Azure login status
if ! az account show >/dev/null 2>&1; then
  echo "❌ Not logged into Azure. Run: az login"
  exit 1
fi

# 4. Confirm subscription context
SUBSCRIPTION_NAME=$(az account show --query name -o tsv)

if [[ -z "$SUBSCRIPTION_NAME" ]]; then
  echo "❌ No Azure subscription set."
  exit 1
fi

echo "✅ Preflight checks passed"
echo "🔐 Subscription: $SUBSCRIPTION_NAME"
echo "========================================"

########################################
# Resource Audit
########################################

RESOURCE_GROUPS=$(az group list --query "[].name" -o tsv)

if [[ -z "$RESOURCE_GROUPS" ]]; then
  echo "⚠️ No resource groups found in this subscription."
  exit 0
fi

for RG in $RESOURCE_GROUPS; do
  echo ""
  echo "📁 Resource Group: $RG"
  echo "--------------------------"

  RESOURCES=$(az resource list -g "$RG" --query "[].name" -o tsv)

  if [[ -z "$RESOURCES" ]]; then
    echo "  ⚠️ No resources found"
  else
    for RES in $RESOURCES; do
      echo "  ✅ $RES"
    done
  fi
done

echo ""
echo "✅ Azure resource audit complete"
