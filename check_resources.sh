#!/usr/bin/env bash

SUBSCRIPTION_NAME=$(az account show --query name -o tsv)


echo "========================================"
echo " Azure Resource Audit"
echo " Subscription: $SUBSCRIPTION_NAME"
echo "========================================"

RESOURCE_GROUPS=$(az group list --query "[].name" -o tsv)

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
