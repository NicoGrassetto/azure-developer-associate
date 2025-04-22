#!/bin/bash

# Deploy the main.bicep file at subscription scope
az deployment sub create \
  --location eastus \
  --template-file main.bicep