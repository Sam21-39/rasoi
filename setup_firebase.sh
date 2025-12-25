#!/bin/bash

# ============================================
# Rasoi - Firebase & Firestore Setup Script
# ============================================
# This script sets up Firebase services for the Rasoi app.
# 
# Prerequisites:
# 1. Firebase CLI installed (npm install -g firebase-tools)
# 2. Logged in to Firebase (firebase login)
# 3. FlutterFire CLI installed (dart pub global activate flutterfire_cli)
#
# Usage: ./setup_firebase.sh
# ============================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Rasoi Firebase Setup Script${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo -e "${RED}Error: Firebase CLI is not installed.${NC}"
    echo "Install it using: npm install -g firebase-tools"
    exit 1
fi

echo -e "${GREEN}✓ Firebase CLI is installed${NC}"

# Check if user is logged in
if ! firebase projects:list &> /dev/null; then
    echo -e "${YELLOW}You need to login to Firebase first.${NC}"
    firebase login
fi

echo -e "${GREEN}✓ Firebase authentication confirmed${NC}"
echo ""

# Project ID
PROJECT_ID="rasoi-94446"

echo -e "${YELLOW}Setting up Firebase project: ${PROJECT_ID}${NC}"
echo ""

# Initialize Firebase in the project if not already done
if [ ! -f ".firebaserc" ]; then
    echo -e "${YELLOW}Initializing Firebase project...${NC}"
    cat > .firebaserc << EOF
{
  "projects": {
    "default": "${PROJECT_ID}"
  }
}
EOF
    echo -e "${GREEN}✓ Created .firebaserc${NC}"
fi

# Deploy Firestore rules
echo -e "${YELLOW}Deploying Firestore security rules...${NC}"
if firebase deploy --only firestore:rules --project "$PROJECT_ID"; then
    echo -e "${GREEN}✓ Firestore rules deployed successfully${NC}"
else
    echo -e "${RED}✗ Failed to deploy Firestore rules${NC}"
    echo "  Make sure Firestore is enabled in your Firebase Console"
fi

echo ""

# Deploy Firestore indexes
echo -e "${YELLOW}Deploying Firestore indexes...${NC}"
if firebase deploy --only firestore:indexes --project "$PROJECT_ID"; then
    echo -e "${GREEN}✓ Firestore indexes deployed successfully${NC}"
else
    echo -e "${RED}✗ Failed to deploy Firestore indexes${NC}"
fi

echo ""

# Deploy Storage rules
echo -e "${YELLOW}Deploying Storage security rules...${NC}"
if firebase deploy --only storage --project "$PROJECT_ID"; then
    echo -e "${GREEN}✓ Storage rules deployed successfully${NC}"
else
    echo -e "${RED}✗ Failed to deploy Storage rules${NC}"
    echo "  Make sure Firebase Storage is enabled in your Firebase Console"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Next steps:"
echo "1. Enable Google Sign-In in Firebase Console > Authentication > Sign-in method"
echo "2. Create Firestore database in Firebase Console > Firestore Database"
echo "3. Create Storage bucket in Firebase Console > Storage"
echo "4. Run 'fvm flutter pub get' to fetch dependencies"
echo "5. Run 'fvm flutter run' to start the app"
echo ""
