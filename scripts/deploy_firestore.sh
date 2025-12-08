#!/bin/bash

# Script to deploy Firestore Rules and Indexes
# Prerequisite: firebase-tools installed (npm install -g firebase-tools)
# Usage: ./scripts/deploy_firestore.sh

echo "🔥 Deploying Firestore Rules and Indexes..."

# Navigate to project root if script is run from scripts/ dir
if [[ $PWD == */scripts ]]; then
  cd ..
fi

# Check if firebase CLI is installed
if ! command -v firebase &> /dev/null
then
    echo "❌ Firebase CLI could not be found. Please install it with: npm install -g firebase-tools"
    exit 1
fi

# Deploy only Firestore with explicit project ID
firebase deploy --only firestore --project rasoi-app-08122025

echo "✅ Deployment command finished."
