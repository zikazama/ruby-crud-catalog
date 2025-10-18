# Vercel + Neon Deployment Guide

Quick step-by-step guide to deploy Rails app to Vercel with Neon PostgreSQL.

## Prerequisites

✅ Vercel CLI installed: `npm install -g vercel`
✅ Code pushed to GitHub
✅ Neon account: https://neon.tech

## Step 1: Create Neon Database

1. Go to https://neon.tech and sign up (free tier available)
2. Create a new project
3. Copy your connection string:
   ```
   postgresql://user:password@ep-xxxx.region.neon.tech/dbname?sslmode=require
   ```
4. Save this connection string for later

## Step 2: Get Rails Master Key

```bash
# In your project directory
cat config/master.key
```

Save this key - you'll need it for Vercel.

## Step 3: Login to Vercel

```bash
vercel login
```

This will open a browser to authenticate. Follow the prompts.

## Step 4: Deploy Project

```bash
cd h:/fauzi/project/ruby
vercel --prod
```

Follow the prompts:
- Link to existing project? **No** (first time)
- Which scope? Select your personal account
- Project name? **ruby-crud-catalog** (or your choice)
- Framework? **Other** (Rails)
- Root directory? **./** (leave default)

## Step 5: Add Environment Variables

After deployment starts, add environment variables via Vercel dashboard:

1. Go to https://vercel.com/dashboard
2. Select your project
3. Go to Settings > Environment Variables
4. Add these variables:

```
Name: RAILS_ENV
Value: production
Environments: Production

Name: RAILS_MASTER_KEY
Value: [copy from config/master.key]
Environments: Production

Name: DATABASE_URL
Value: [your Neon connection string]
Environments: Production
```

## Step 6: Redeploy with Variables

```bash
# Redeploy to apply environment variables
vercel --prod
```

## Step 7: Run Database Migrations

After deployment, run migrations on Neon:

```bash
# Option 1: Via Vercel CLI (pull env vars first)
vercel env pull
RAILS_ENV=production bundle exec rails db:create db:migrate db:seed

# Option 2: Using the Neon connection directly
RAILS_ENV=production DATABASE_URL="postgresql://..." rails db:migrate db:seed
```

## Step 8: Verify Deployment

1. Get your Vercel URL from dashboard
2. Open https://your-app.vercel.app
3. Test login with credentials:
   - Username: `admin`
   - Password: `password`

## Common Issues

### Database Connection Error

**Error**: `PG::ConnectionBad: could not translate host name "ep-xxxx..."`

**Fix**:
```bash
# Verify connection string
vercel env pull

# Test connection
bundle exec rails db:version

# Check if DATABASE_URL is set
echo $DATABASE_URL
```

### SSL/TLS Error

**Error**: `SSL CERTIFICATE_VERIFY_FAILED`

**Fix**: Add `?sslmode=require` to your Neon connection string (should be automatic)

### Migrations Failed

**Error**: `PG::Error: ERROR: could not connect to server`

**Fix**:
```bash
# Pull latest env vars
vercel env pull

# Manually run migrations with explicit URL
RAILS_ENV=production DATABASE_URL="postgresql://user:pass@host/db?sslmode=require" bundle exec rails db:migrate
```

### Cold Start Issues

If app takes 30+ seconds to load:

1. This is normal for first request
2. Use https://uptimerobot.com to keep app alive
3. Upgrade to Vercel Pro for faster cold starts

## Useful Commands

```bash
# Check deployment status
vercel status

# View logs
vercel logs [project-name] --prod

# View environment variables
vercel env pull

# Redeploy
vercel --prod

# Rollback to previous deployment
vercel rollback

# Open dashboard
vercel dashboard

# See project info
vercel projects ls
vercel inspect ruby-crud-catalog
```

## Next Steps

1. ✅ Deployment complete
2. ✅ Database running on Neon
3. Set up monitoring:
   - Vercel Analytics
   - Error tracking (Sentry, etc.)
4. Set up keep-alive service to avoid cold starts
5. Configure custom domain (optional)
6. Set up automated backups

## Neon Database Tips

### Backup Your Data

```bash
# Export data from Neon
pg_dump -h ep-xxxx.region.neon.tech -U user -d dbname > backup.sql

# Import to local
psql -U postgres -d local_db < backup.sql
```

### Monitor Database Usage

1. Go to https://console.neon.tech
2. Check:
   - Storage used (free tier: 3GB)
   - Active connections
   - Query performance

### Scale Database

If you hit limits:
- Free tier: 3GB storage, 10 branches
- Paid: More storage, advanced features

## Troubleshooting Checklist

- [ ] Vercel CLI installed: `vercel --version`
- [ ] Logged in to Vercel: `vercel whoami`
- [ ] Environment variables set in Vercel dashboard
- [ ] Database URL starts with `postgresql://`
- [ ] Database URL includes `?sslmode=require`
- [ ] Redeploy after setting variables: `vercel --prod`
- [ ] Migrations run successfully
- [ ] Can access app URL

## Success Indicators

✅ App loads at https://your-app.vercel.app
✅ Login page works
✅ Can create/edit categories and products
✅ Database operations succeed
✅ Excel export works

## Getting Help

- Vercel Docs: https://vercel.com/docs
- Neon Docs: https://neon.tech/docs
- Rails Deployment: https://guides.rubyonrails.org/deployment.html

---

**Ready to deploy? Run:**
```bash
vercel --prod
```

Good luck! 🚀
