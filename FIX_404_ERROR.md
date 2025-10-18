# ✅ FIX: 404 NOT_FOUND Error on Vercel

The 404 error means your deployment didn't complete successfully or the project wasn't created.

## Quick Fix

### Option 1: Fresh Deployment (Recommended)

```bash
# 1. Go to your project directory
cd h:/fauzi/project/ruby

# 2. Make sure code is committed
git status

# 3. Delete existing Vercel configuration (start fresh)
rm -rf .vercel

# 4. Login to Vercel
vercel login

# 5. Deploy to Vercel (this will create the project)
vercel --prod
```

When prompted:
```
Set up and deploy? [Y/n] → Y
Which scope? → Select your account (fauzi-fadhlurrohmans-projects)
Link to existing project? [y/N] → N
What's your project's name? → ruby-crud-catalog
In which directory is your code located? [.] → . (press Enter)
Want to override the settings? [y/N] → N
```

**Wait for deployment to complete** (should see ✓ Ready [URL])

### Option 2: Check Existing Project

If project exists:

```bash
# View project info
vercel projects ls | grep ruby-crud-catalog

# If it exists, get details
vercel projects inspect ruby-crud-catalog

# View deployments
vercel deployments ruby-crud-catalog
```

## After Deployment

### 1. Add Environment Variables

1. Go to https://vercel.com/dashboard
2. Click **ruby-crud-catalog**
3. Click **Settings** (top menu)
4. Click **Environment Variables**
5. Add these variables:

| Name | Value | Environments |
|------|-------|--------------|
| RAILS_ENV | production | Production ✅ |
| RAILS_MASTER_KEY | [from config/master.key] | Production ✅ |
| DATABASE_URL | [your Neon connection string] | Production ✅ |

### 2. Redeploy

```bash
cd h:/fauzi/project/ruby
vercel --prod
```

### 3. Run Migrations

```bash
vercel env pull
RAILS_ENV=production bundle exec rails db:create db:migrate db:seed
```

### 4. Test

Open: https://ruby-crud-catalog.vercel.app
Login: admin / password

## Troubleshooting

### "Deployment not found"
- Fresh deploy: `rm -rf .vercel && vercel --prod`
- Check status: `vercel status`
- View logs: `vercel logs ruby-crud-catalog --prod`

### "Build failed"
```bash
# View detailed error logs
vercel logs ruby-crud-catalog --prod

# Check Gemfile
cat Gemfile | head -20

# Try rebuilding
vercel --prod --force
```

### "Database connection refused"
- Make sure DATABASE_URL is set in Vercel dashboard
- Verify connection string format: `postgresql://user:pass@host/db?sslmode=require`
- Test: `psql $DATABASE_URL -c "SELECT 1"`

### "Cannot access URL"
- Wait 2-3 minutes for deployment to propagate
- Clear browser cache: Ctrl+Shift+Del
- Try different browser

## Commands Reference

```bash
# Check login status
vercel whoami

# List projects
vercel projects ls

# View current project status
vercel status

# View live logs
vercel logs ruby-crud-catalog --prod

# Pull environment variables
vercel env pull

# Redeploy
vercel --prod

# Force rebuild
vercel --prod --force

# Rollback
vercel rollback ruby-crud-catalog

# Delete project (nuclear option)
vercel remove ruby-crud-catalog
```

## Success Indicators

✅ No 404 errors
✅ Deployment shows "Ready" status
✅ URL is accessible
✅ Login page displays
✅ Can authenticate with admin/password
✅ Database connection works

---

**Still stuck?** Run this for help:
```bash
vercel logs ruby-crud-catalog --prod -f
```

This shows real-time logs - paste error messages to see what's wrong.
