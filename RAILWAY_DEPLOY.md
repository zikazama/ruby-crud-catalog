# 🚀 Deploy to Railway.app (Recommended)

Railway is perfect for Rails applications. Much easier than Vercel!

## Step-by-Step Guide

### 1. Create Railway Account

1. Go to https://railway.app
2. Click "Login"
3. Choose "GitHub" (recommended)
4. Authorize Railway to access your GitHub
5. You're logged in!

### 2. Create New Project

1. Click "New Project" or "+"
2. Select "Deploy from GitHub"
3. Select your repository: `ruby-crud-catalog`
4. Click "Deploy now"

### 3. Configure Environment

Railway will automatically:
- ✅ Detect Rails application
- ✅ Create PostgreSQL database
- ✅ Set up environment variables
- ✅ Start building and deploying

### 4. Add Neon Database (Optional)

If you want to use Neon instead of Railway's PostgreSQL:

1. Go to your Railway project
2. Click "Add"
3. Select "Add Plugin" > "PostgreSQL"

Or use your Neon database:
1. Copy Neon connection string
2. Add as `DATABASE_URL` variable in Railway settings

### 5. Configure Variables

Go to your project settings and add:

```
RAILS_ENV = production
RAILS_MASTER_KEY = [from config/master.key]
DATABASE_URL = [auto-set by Railway or use Neon]
```

### 6. Deploy

That's it! Railway auto-deploys when you push to GitHub.

Check deployment:
- Go to https://railway.app/dashboard
- Click your project
- View logs and status

### 7. Access Your App

Railway gives you a unique URL:
```
https://ruby-crud-catalog.up.railway.app
(or your custom domain)
```

## Cost

- **Free tier**: $5 credit/month (perfect for hobby projects)
- **Pay as you go**: $0.00001/hour of compute after free tier

## What's Included

✅ Automatic PostgreSQL database
✅ Auto-deploys from GitHub
✅ Free SSL/HTTPS
✅ Custom domain support
✅ Environment variables
✅ Logs and monitoring
✅ Automatic backups

## Commands (Optional CLI)

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Deploy from current directory
railway up

# View logs
railway logs

# View status
railway status

# Open dashboard
railway open
```

## Migration Commands

After deployment:

```bash
# SSH into Railway environment
railway shell

# Run migrations
rails db:create db:migrate db:seed

# Check database
rails console
```

Or use Railway dashboard:
1. Go to project
2. Click "Deployments"
3. View and manage instances

## Troubleshooting

### App won't start

Check logs:
1. Go to https://railway.app/dashboard
2. Select project
3. Click "Logs" tab
4. Find error message

Common causes:
- Missing environment variables
- Database not connected
- Gemfile lock issues

### Database issues

```bash
# Check if db exists
rails dbconsole

# Recreate database
rails db:drop db:create db:migrate db:seed
```

### Stuck? Contact Railway

Railway has excellent support:
- Docs: https://docs.railway.app
- Discord: https://discord.gg/railway

---

## Quick Comparison

| Feature | Vercel | Railway | Heroku |
|---------|--------|---------|--------|
| Rails Support | ❌ | ✅ | ✅ |
| PostgreSQL | Manual | ✅ Included | ✅ Included |
| Free Tier | Limited | $5/month | ✅ Free |
| Setup Time | Complex | 5 min | 10 min |
| Cost | $20+/mo Pro | $5+/mo | $7+/mo |
| Best For | Node.js | Rails | Hobby Projects |

**Verdict**: Railway is the clear winner for Rails! ⭐

---

## Next Steps

1. ✅ Go to https://railway.app
2. ✅ Connect GitHub
3. ✅ Select repository
4. ✅ Deploy
5. ✅ Done! App is live

That's it! No complex configuration needed.

---

**Your app is production-ready. Let's get it live!** 🚀
