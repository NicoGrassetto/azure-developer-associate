#!/bin/bash

az deployment sub create \
  --name acr-deployment \
  --location eastus \
  --template-file ./infra/main.bicep