#!/bin/bash

# Vercel + Neon Deployment Script
# This script will guide you through deploying to Vercel

set -e

echo ""
echo "🚀 VERCEL DEPLOYMENT HELPER FOR RAILS"
echo "======================================"
echo ""

# Step 1: Check prerequisites
echo "📝 STEP 1: Checking prerequisites..."
echo ""

# Check Vercel CLI
if ! command -v vercel &> /dev/null; then
    echo "❌ Vercel CLI not found"
    exit 1
fi
echo "✅ Vercel CLI installed"

# Check git
if ! command -v git &> /dev/null; then
    echo "❌ Git not found"
    exit 1
fi
echo "✅ Git installed"

# Check logged in
if ! vercel whoami &> /dev/null; then
    echo "❌ Not logged into Vercel"
    echo "Running: vercel login"
    vercel login
fi
VERCEL_USER=$(vercel whoami)
echo "✅ Logged in as: $VERCEL_USER"
echo ""

# Step 2: Get Neon connection string
echo "📝 STEP 2: Database Configuration"
echo ""
echo "You need a Neon PostgreSQL database:"
echo "  1. Go to: https://neon.tech/console"
echo "  2. Create a project"
echo "  3. Create a database"
echo "  4. Copy the connection string (from 'Pooling' tab)"
echo ""
read -p "Paste your Neon connection string: " NEON_URL

if [ -z "$NEON_URL" ]; then
    echo "❌ Connection string required"
    exit 1
fi

if [[ ! $NEON_URL =~ ^postgresql:// ]]; then
    echo "❌ Invalid connection string format"
    exit 1
fi
echo "✅ Connection string received"
echo ""

# Step 3: Get Rails master key
echo "📝 STEP 3: Rails Configuration"
echo ""
if [ ! -f "config/master.key" ]; then
    echo "❌ config/master.key not found"
    exit 1
fi
RAILS_MASTER_KEY=$(cat config/master.key)
echo "✅ Rails master key found"
echo ""

# Step 4: Deploy
echo "📝 STEP 4: Deploying to Vercel"
echo ""
echo "Running: vercel --prod"
echo ""

# Create .vercelenv for this deployment
cat > .vercelenv << EOF
RAILS_ENV=production
RAILS_MASTER_KEY=$RAILS_MASTER_KEY
DATABASE_URL=$NEON_URL
EOF

# Deploy
vercel --prod \
    --env RAILS_ENV=production \
    --env RAILS_MASTER_KEY=$RAILS_MASTER_KEY \
    --env DATABASE_URL=$NEON_URL

echo ""
echo "✅ Deployment initiated!"
echo ""

# Step 5: Get project info
echo "📝 STEP 5: Getting project information..."
echo ""

# Try to get the deployment URL
VERCEL_URL=$(vercel projects inspect ruby-crud-catalog --json 2>/dev/null | grep -o '"productionDeployment"[^}]*' | head -1 || echo "")

echo "🎯 Next steps:"
echo ""
echo "1. Go to https://vercel.com/dashboard"
echo "2. Select your project"
echo "3. Go to Settings > Environment Variables"
echo "4. Verify these variables are set:"
echo "   - RAILS_ENV = production"
echo "   - RAILS_MASTER_KEY = [set]"
echo "   - DATABASE_URL = [set]"
echo ""
echo "5. If not all set, add them and redeploy:"
echo "   $ vercel --prod"
echo ""
echo "6. Run database migrations:"
echo "   $ vercel env pull"
echo "   $ RAILS_ENV=production bundle exec rails db:create db:migrate db:seed"
echo ""
echo "7. Visit your app:"
echo "   https://ruby-crud-catalog.vercel.app"
echo ""
echo "✅ All done!"
echo ""
