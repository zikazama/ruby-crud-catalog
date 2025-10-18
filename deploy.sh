#!/bin/bash

# Vercel Production Deployment Helper Script
# Usage: ./deploy.sh

set -e

echo "🚀 Rails Catalog Dashboard - Vercel Deployment Helper"
echo "=================================================="
echo ""

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "❌ Vercel CLI not found. Installing..."
    npm install -g vercel
fi

echo "✅ Vercel CLI found"
echo ""

# Step 1: Git setup
echo "📝 Step 1: Setting up Git repository..."
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not a git repository. Initializing..."
    git init
    git add .
    git commit -m "Initial commit for Vercel deployment"
else
    echo "✅ Git repository found"
fi
echo ""

# Step 2: Check for uncommitted changes
echo "📝 Step 2: Checking for uncommitted changes..."
if [ -n "$(git status --porcelain)" ]; then
    echo "⚠️  You have uncommitted changes. Staging them..."
    git add .
    git commit -m "Update deployment configuration"
fi
echo ""

# Step 3: Get Rails master key
echo "📝 Step 3: Rails Master Key"
RAILS_MASTER_KEY=$(cat config/master.key 2>/dev/null || echo "")
if [ -z "$RAILS_MASTER_KEY" ]; then
    echo "❌ Rails master key not found!"
    echo "Please run: rails credentials:edit"
    exit 1
fi
echo "✅ Rails master key found (first 8 chars: ${RAILS_MASTER_KEY:0:8}...)"
echo ""

# Step 4: Database setup
echo "📝 Step 4: Database Setup"
echo ""
echo "You need to set up a PostgreSQL database for production."
echo "Choose one of the following:"
echo ""
echo "1. Supabase (https://supabase.com)"
echo "   - Free tier with 2 GB storage"
echo "   - Built-in authentication"
echo ""
echo "2. Railway (https://railway.app)"
echo "   - \$5 monthly credit"
echo "   - Simple PostgreSQL setup"
echo ""
echo "3. Heroku Postgres"
echo "   - Available on paid plans"
echo ""
echo "4. AWS RDS"
echo "   - Scalable but requires AWS setup"
echo ""
read -p "Enter your database host [leave blank to skip]: " DB_HOST
if [ -n "$DB_HOST" ]; then
    read -p "Enter database user: " DB_USER
    read -p "Enter database password: " DB_PASSWORD
    read -p "Enter database name [morbis_production]: " DB_NAME
    DB_NAME=${DB_NAME:-morbis_production}
    read -p "Enter database port [5432]: " DB_PORT
    DB_PORT=${DB_PORT:-5432}
fi
echo ""

# Step 5: Deploy to Vercel
echo "📝 Step 5: Deploying to Vercel..."
echo ""

if [ -z "$DB_HOST" ]; then
    echo "⚠️  Skipping environment variable setup"
    echo "You'll need to add these manually in Vercel dashboard:"
    echo "  - RAILS_ENV=production"
    echo "  - RAILS_MASTER_KEY=$RAILS_MASTER_KEY"
    echo "  - DATABASE_URL or DB_* variables"
    echo ""
    echo "Then redeploy with: vercel --prod"
else
    echo "Setting up environment variables..."
    export RAILS_ENV=production
    export RAILS_MASTER_KEY=$RAILS_MASTER_KEY
    export DATABASE_URL="postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}"
fi

echo ""
echo "🚀 Running Vercel deployment..."
vercel --prod

echo ""
echo "✅ Deployment started!"
echo "📊 View deployment progress: https://vercel.com/dashboard"
echo ""
echo "Next steps:"
echo "1. Wait for deployment to complete"
echo "2. Get your app URL from Vercel dashboard"
echo "3. Add environment variables if not set"
echo "4. Run migrations: vercel env pull && RAILS_ENV=production rails db:migrate"
echo ""
