# Vercel Production Deployment Guide

## Prerequisites

- Vercel account (https://vercel.com)
- Vercel CLI installed: `npm i -g vercel`
- PostgreSQL database (use a managed service like:
  - Supabase (https://supabase.com)
  - Railway (https://railway.app)
  - Heroku Postgres
  - AWS RDS
  - DigitalOcean Managed Databases)

## Setup Steps

### 1. Prepare Database

Create a PostgreSQL database on your chosen service:

**Supabase Example:**
1. Go to https://supabase.com
2. Create new project
3. Get connection string from Settings > Database

**Railway Example:**
1. Go to https://railway.app
2. Create new project
3. Add PostgreSQL plugin
4. Copy connection URL

### 2. Generate Rails Master Key

```bash
# Get your Rails master key (already in config/master.key)
cat config/master.key
```

### 3. Update Configuration

Ensure `config/database.yml` supports environment variables:

```yaml
production:
  <<: *default
  database: <%= ENV['DB_NAME'] %>
  username: <%= ENV['DB_USER'] %>
  password: <%= ENV['DB_PASSWORD'] %>
  host: <%= ENV['DB_HOST'] %>
  port: <%= ENV['DB_PORT'] || 5432 %>
```

### 4. Create Environment Variables in Vercel

Push to GitHub first:

```bash
git add .
git commit -m "Add Vercel deployment configuration"
git push origin main
```

Then:

1. Go to https://vercel.com/dashboard
2. Connect your GitHub repository
3. Create new project
4. Add environment variables in Settings > Environment Variables:

```
RAILS_ENV = production
RAILS_MASTER_KEY = [your-master-key-from-config/master.key]
DATABASE_URL = postgres://user:password@host:5432/database
DB_HOST = [your-database-host]
DB_PORT = 5432
DB_NAME = [your-database-name]
DB_USER = [your-database-user]
DB_PASSWORD = [your-database-password]
RACK_ENV = production
```

### 5. Deploy

**Option A: Direct Vercel CLI**
```bash
vercel --prod
```

**Option B: Via GitHub (Recommended)**
1. Push changes to GitHub
2. Vercel will automatically detect and deploy
3. Watch build progress in Vercel dashboard

### 6. Run Database Migrations on Vercel

After deployment:

```bash
# Option 1: Via Vercel CLI
vercel env pull
RAILS_ENV=production bundle exec rails db:create db:migrate db:seed

# Option 2: Run migrations through the deployed app
curl -X POST https://your-app.vercel.app/admin/migrations
```

## Important Notes

### ⚠️ Limitations on Vercel

1. **Serverless Functions:** Each request runs in isolation
   - Session state may not persist perfectly
   - File uploads go to /tmp (temporary)
   - Database connections should use pooling

2. **Build Time:** Limited to 45 seconds
   - Use `bundle install --deployment` for faster builds
   - Precompile assets beforehand

3. **Memory:** 3GB max per function
   - Should be sufficient for Rails + database operations

4. **Cold Starts:** Functions may experience latency after inactivity
   - Use "Keep Alive" monitoring service

### Production Recommendations

1. **Use a Managed Database Service**
   ```
   Supabase (PostgreSQL + Auth) ✅
   Railway (PostgreSQL) ✅
   Heroku Postgres ✅
   AWS RDS ✅
   ```

2. **Static Assets/CDN**
   - Vercel auto-serves static assets from CDN
   - Images should be stored externally (S3, Cloudinary)

3. **SSL/HTTPS**
   - Automatic with Vercel domains
   - Custom domains also get free SSL

4. **Monitoring**
   - Enable Vercel Analytics
   - Set up error tracking (Sentry)
   - Monitor database performance

5. **Environment Security**
   - Never commit `config/master.key`
   - Use Vercel's environment variables UI
   - Rotate secrets regularly

## Alternative: Use Railway or Render (Easier for Rails)

If deploying to Vercel proves complex, consider:

**Railway.app:**
```bash
# Install Railway CLI
npm i -g @railway/cli

# Login
railway login

# Initialize project
railway init

# Deploy
railway up
```

**Render.com:**
1. Connect GitHub
2. Create new Web Service
3. Select Rails from template
4. Set environment variables
5. Deploy

Both are more Rails-native and handle database/asset management better.

## Troubleshooting Vercel Deployment

### Build Fails

```bash
# Check build logs
vercel logs --prod

# Rebuild
vercel --prod --force
```

### Database Connection Issues

```bash
# Verify connection string
vercel env pull
echo $DATABASE_URL

# Test connection locally
RAILS_ENV=production bundle exec rails db:version
```

### Cold Start Issues

1. Add a Keep-Alive service:
   ```
   https://uptimerobot.com (free tier)
   Set to ping your app every 5 minutes
   ```

2. Use Vercel's Pro plan for faster cold starts

### Session Data Lost

```ruby
# Add to config/session_store.rb
Rails.application.config.session_store :cookie_store, key: '_app_session'

# Use database store instead (optional)
# Rails.application.config.session_store :active_record_store
```

## Success Indicators

✅ Deployment completes without errors  
✅ App loads at https://your-app.vercel.app  
✅ Login works with database  
✅ Can create/edit categories and products  
✅ Excel export generates successfully  

## Next Steps

1. Set up monitoring and alerting
2. Configure custom domain
3. Set up backup strategy for database
4. Monitor error tracking
5. Optimize cold start performance
6. Set up CI/CD for automated deployments

---

**For support:**
- Vercel Docs: https://vercel.com/docs
- Rails Deployment: https://guides.rubyonrails.org/deployment.html
- GitHub Issues: Post any deployment questions
