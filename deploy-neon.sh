#!/bin/bash

# Automated Vercel + Neon Deployment Script
# Usage: ./deploy-neon.sh

set -e

echo "🚀 Deploying Rails App to Vercel with Neon Database"
echo "===================================================="
echo ""

# Check Vercel CLI
if ! command -v vercel &> /dev/null; then
    echo "❌ Vercel CLI not found"
    echo "Installing: npm install -g vercel"
    npm install -g vercel
fi

echo "✅ Vercel CLI found: $(vercel --version)"
echo ""

# Check if logged in
echo "📝 Checking Vercel login..."
if ! vercel whoami &> /dev/null; then
    echo "❌ Not logged into Vercel"
    echo "Running: vercel login"
    vercel login
fi
echo ""

# Get Neon connection string
echo "🔗 Neon Database Configuration"
echo ""
read -p "Enter your Neon connection string: " NEON_URL
if [ -z "$NEON_URL" ]; then
    echo "❌ Connection string is required!"
    exit 1
fi

# Verify format
if [[ ! $NEON_URL =~ ^postgresql:// ]]; then
    echo "❌ Invalid connection string format"
    exit 1
fi

echo "✅ Connection string received"
echo ""

# Get Rails master key
RAILS_MASTER_KEY=$(cat config/master.key 2>/dev/null || echo "")
if [ -z "$RAILS_MASTER_KEY" ]; then
    echo "❌ Rails master key not found!"
    exit 1
fi
echo "✅ Rails master key found"
echo ""

# Push to GitHub if not already
echo "📝 Checking Git status..."
if [ -n "$(git status --porcelain)" ]; then
    echo "⚠️  You have uncommitted changes"
    read -p "Commit and push changes? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add .
        git commit -m "Deployment configuration" || true
        git push origin main
    fi
fi
echo ""

# Deploy
echo "🚀 Starting Vercel deployment..."
echo ""

# Check if project already exists on Vercel
PROJECT_NAME="ruby-crud-catalog"
if vercel projects ls | grep -q "$PROJECT_NAME"; then
    echo "📦 Project exists, redeploying..."
    vercel --prod \
        --env RAILS_ENV=production \
        --env RAILS_MASTER_KEY=$RAILS_MASTER_KEY \
        --env DATABASE_URL=$NEON_URL
else
    echo "📦 Creating new Vercel project..."
    vercel --prod
fi

echo ""
echo "✅ Deployment initiated!"
echo ""
echo "Next steps:"
echo "1. Go to https://vercel.com/dashboard"
echo "2. Select your project"
echo "3. Go to Settings > Environment Variables"
echo "4. Add these if not auto-imported:"
echo "   - RAILS_ENV = production"
echo "   - RAILS_MASTER_KEY = $RAILS_MASTER_KEY"
echo "   - DATABASE_URL = $NEON_URL"
echo "5. Redeploy: vercel --prod"
echo "6. Run migrations: vercel env pull && RAILS_ENV=production rails db:migrate"
echo ""
echo "🎉 Your app will be live at: https://your-app-name.vercel.app"
echo ""
