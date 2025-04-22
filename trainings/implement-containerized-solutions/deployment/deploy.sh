#!/bin/bash

az deployment sub create \
  --name acr-deployment \
  --location eastus \
  --template-file ./infra/main.bicep

echo FROM mcr.microsoft.com/hello-world > Dockerfile