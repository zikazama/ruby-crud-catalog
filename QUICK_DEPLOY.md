# Quick Vercel + Neon Deployment (Copy-Paste Ready)

## 1️⃣ Prepare Your Neon Database

Visit https://neon.tech/console and:
1. Create a new project
2. Create a database
3. Copy connection string from "Connection string" > "Pooling" tab
4. Should look like: `postgresql://user:password@ep-xxxx.region.neon.tech/dbname?sslmode=require`

## 2️⃣ Commit Your Code

```bash
cd h:/fauzi/project/ruby
git add .
git commit -m "Ready for Vercel deployment"
git push origin main
```

## 3️⃣ Login to Vercel

```bash
vercel login
# Browser will open for authentication
```

## 4️⃣ Deploy to Vercel

```bash
cd h:/fauzi/project/ruby
vercel --prod
```

When prompted:
- `Set up and deploy? [Y/n]` → Press `Y`
- `Which scope do you want to deploy to?` → Select your account
- `Link to existing project? [y/N]` → Press `N`
- `What's your project's name?` → Type `ruby-crud-catalog`
- `In which directory is your code located?` → Press Enter (`.`)
- `Want to override the settings? [y/N]` → Press `N`

## 5️⃣ Add Environment Variables

After deployment, go to Vercel dashboard:

1. Open https://vercel.com/dashboard
2. Click on your project `ruby-crud-catalog`
3. Go to **Settings** > **Environment Variables**
4. Click **Add New** and add these variables:

### Variable 1: RAILS_ENV
```
Name: RAILS_ENV
Value: production
Environments: ✅ Production, ❌ Preview, ❌ Development
```
Click **Save**

### Variable 2: RAILS_MASTER_KEY
```
Name: RAILS_MASTER_KEY
Value: [paste contents of config/master.key]
Environments: ✅ Production, ❌ Preview, ❌ Development
```
Click **Save**

### Variable 3: DATABASE_URL
```
Name: DATABASE_URL
Value: [paste your Neon connection string]
Environments: ✅ Production, ❌ Preview, ❌ Development
```
Click **Save**

## 6️⃣ Redeploy with Environment Variables

```bash
cd h:/fauzi/project/ruby
vercel --prod
```

## 7️⃣ Run Database Migrations

```bash
# Pull environment variables
vercel env pull

# Run migrations
RAILS_ENV=production bundle exec rails db:create db:migrate db:seed
```

## 8️⃣ Visit Your App

1. Go to https://vercel.com/dashboard
2. Click your project
3. Click the URL under "Production"
4. You should see your app! 🎉

## 🔧 Test Login

Username: `admin`
Password: `password`

---

## 🆘 Troubleshooting

### "Cannot find database"
```bash
# Verify DATABASE_URL is set correctly
vercel env pull
echo $DATABASE_URL

# Manually test connection
psql $DATABASE_URL -c "SELECT 1"
```

### "Deployment failed"
```bash
# View detailed logs
vercel logs ruby-crud-catalog --prod

# Rebuild
vercel rebuild
```

### "Page not found"
```bash
# Check if Rails is responding
curl https://your-app-name.vercel.app

# View logs
vercel logs ruby-crud-catalog --prod -f
```

---

## 📊 Monitor Your Deployment

```bash
# View deployment status
vercel status

# View logs
vercel logs ruby-crud-catalog --prod

# Rollback if needed
vercel rollback ruby-crud-catalog
```

---

## 🎯 Next Steps

- ✅ Database is on Neon (persistent)
- ✅ App is deployed on Vercel (auto-scales)
- ✅ Environment variables are secure
- 📊 Set up monitoring (Sentry, New Relic, etc.)
- 🔄 Set up CI/CD (auto-deploy on git push)
- 🌍 Add custom domain (optional)

---

**Questions?** See detailed guide: [NEON_VERCEL_DEPLOY.md](./NEON_VERCEL_DEPLOY.md)
