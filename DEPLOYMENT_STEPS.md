# 🚀 DEPLOYMENT INSTRUCTIONS - Vercel + Neon

Your Rails application is ready to deploy! Follow these exact steps:

## 📋 STEP-BY-STEP DEPLOYMENT

### Step 1: Prepare Neon Database (5 minutes)

1. Go to **https://neon.tech/console**
2. Sign up / Log in
3. Create a new project
4. In your project:
   - Go to "SQL Editor" and create a database
   - Go to "Connection" tab
   - Select "Pooling" (important for serverless)
   - Copy the full connection string
   
   **It should look like:**
   ```
   postgresql://user:password@ep-xxxx.us-east-1.neon.tech/dbname?sslmode=require
   ```
5. Save this string - you'll need it in Step 5

### Step 2: Verify Git is Ready

```bash
cd h:/fauzi/project/ruby

# Check if everything is committed
git status

# If clean, you're ready!
# If not:
git add .
git commit -m "Ready for production"
git push origin main
```

### Step 3: Login to Vercel

```bash
vercel login
```

Browser will open - complete the authentication.

### Step 4: Deploy to Vercel

```bash
cd h:/fauzi/project/ruby
vercel --prod
```

**Respond to prompts:**
- `Set up and deploy?` → `Y`
- `Which scope?` → Select your account
- `Link to existing project?` → `N`
- `Project name?` → `ruby-crud-catalog`
- `Root directory?` → Press Enter (use `.`)
- `Override settings?` → `N`

**Wait for deployment to complete** (2-5 minutes)

### Step 5: Add Environment Variables

1. Go to **https://vercel.com/dashboard**
2. Click **ruby-crud-catalog** project
3. Click **Settings** (top menu)
4. Click **Environment Variables** (left sidebar)

**Add 3 variables** (one at a time):

#### Variable 1:
```
Name: RAILS_ENV
Value: production
Select: Production checkbox only
```
Click **Save**

#### Variable 2:
```
Name: RAILS_MASTER_KEY
Value: [copy from config/master.key - the long string]
Select: Production checkbox only
```
Click **Save**

#### Variable 3:
```
Name: DATABASE_URL
Value: [paste your Neon connection string from Step 1]
Select: Production checkbox only
```
Click **Save**

### Step 6: Redeploy with Variables

```bash
cd h:/fauzi/project/ruby
vercel --prod
```

Wait for deployment (1-2 minutes).

### Step 7: Run Database Migrations

```bash
# Go to project directory
cd h:/fauzi/project/ruby

# Pull environment variables
vercel env pull

# Run migrations (creates tables and seeds data)
RAILS_ENV=production bundle exec rails db:create db:migrate db:seed
```

### Step 8: Test Your App

1. Go to **https://vercel.com/dashboard**
2. Click **ruby-crud-catalog**
3. You'll see a URL like `https://ruby-crud-catalog.vercel.app`
4. Click it to open your app

**Login with:**
```
Username: admin
Password: password
```

You should see:
- ✅ Login page
- ✅ Dashboard with categories
- ✅ Products list
- ✅ Can create/edit items
- ✅ Can export to Excel

---

## 🛠️ USEFUL COMMANDS

```bash
# Check deployment status
vercel status

# View live logs
vercel logs ruby-crud-catalog --prod

# Rollback to previous version
vercel rollback ruby-crud-catalog

# View environment variables
vercel env pull

# List all deployments
vercel deployments

# Rebuild/redeploy
vercel --prod --force
```

---

## ❌ TROUBLESHOOTING

### "Database Connection Failed"

```bash
# 1. Verify DATABASE_URL is correct
vercel env pull
grep DATABASE_URL .env.production.local

# 2. Test connection directly
psql "postgresql://user:pass@host/db?sslmode=require" -c "SELECT 1"

# 3. If it works locally but not on Vercel:
# - Go to Vercel dashboard
# - Settings > Environment Variables
# - Re-enter DATABASE_URL
# - Redeploy: vercel --prod
```

### "Migrations Failed"

```bash
# Re-run with explicit URL
DATABASE_URL="postgresql://user:pass@host/db?sslmode=require" \
RAILS_ENV=production bundle exec rails db:migrate

# Check migration status
RAILS_ENV=production bundle exec rails db:version
```

### "App shows 500 Error"

```bash
# View error logs
vercel logs ruby-crud-catalog --prod -f

# Common causes:
# 1. RAILS_MASTER_KEY not set or wrong
# 2. DATABASE_URL not set or wrong
# 3. Missing migrations
```

### "Cannot Access App"

```bash
# 1. Get the correct URL
vercel projects inspect ruby-crud-catalog

# 2. Check if it's still building
# Go to https://vercel.com/dashboard
# Watch the "Deployments" tab

# 3. If stuck, redeploy
vercel --prod --force
```

---

## 📊 MONITORING

### View Logs (Real-time)
```bash
vercel logs ruby-crud-catalog --prod -f
```

### Database Usage
- Go to https://console.neon.tech
- Click your project
- Check "Monitoring" section

### Vercel Analytics
- Go to https://vercel.com/dashboard
- Click your project
- View "Analytics" tab

---

## 🔐 SECURITY NOTES

✅ **Good practices:**
- RAILS_MASTER_KEY is safe in Vercel (encrypted)
- DATABASE_URL uses SSL (sslmode=require)
- Code is only in your private GitHub repo
- Environment variables are NOT in git

⚠️ **Don't:**
- Don't commit `config/master.key`
- Don't commit `.env` files
- Don't share connection strings in git
- Don't use `sslmode=disable`

---

## 🎯 WHAT'S NEXT

After successful deployment:

1. **Test all features**
   - Login
   - Create category
   - Create product
   - Update items
   - Delete items
   - Export Excel

2. **Monitor performance**
   - Check Vercel logs: `vercel logs ruby-crud-catalog --prod`
   - Monitor Neon database

3. **Optional enhancements**
   - Add custom domain (Vercel dashboard)
   - Enable auto-deploys from GitHub
   - Set up error tracking (Sentry)
   - Add monitoring alerts

4. **Database backups**
   - Neon has built-in backups
   - Check console.neon.tech > Backups

---

## 📞 SUPPORT

- **Vercel Issues?** → https://vercel.com/docs
- **Neon Issues?** → https://neon.tech/docs
- **Rails Issues?** → https://guides.rubyonrails.org/

---

## ✨ YOU'RE DONE!

Your app is now live on:
```
https://ruby-crud-catalog.vercel.app
```

Database is secure on:
```
Neon PostgreSQL (automatically backed up)
```

Every `git push` to main will auto-deploy if you enable it.

Congratulations! 🎉
