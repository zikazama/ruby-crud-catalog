# ✅ DEPLOYMENT CHECKLIST

Use this checklist to ensure everything is ready before deploying.

## Pre-Deployment Checklist

### Code & Repository
- [ ] Code is committed: `git status` shows clean
- [ ] Code is pushed to GitHub: `git push origin main`
- [ ] Repository is public or you have access
- [ ] `.gitignore` includes `.env`, `config/master.key`

### Rails Configuration
- [ ] `config/master.key` exists and is NOT in git
- [ ] `config/database.yml` supports PostgreSQL
- [ ] `Gemfile` has all dependencies
- [ ] No hardcoded passwords or secrets

### Vercel Setup
- [ ] Vercel CLI installed: `vercel --version` works
- [ ] You're logged into Vercel: `vercel whoami` shows your account
- [ ] Account is linked to GitHub

### Neon Database
- [ ] Neon account created: https://neon.tech
- [ ] Database project created
- [ ] Connection string copied (with ?sslmode=require)
- [ ] Connection string starts with `postgresql://`

---

## Deployment Checklist

### Step 1: Deploy Application
- [ ] Run `vercel --prod`
- [ ] Select your account when prompted
- [ ] Create new project (don't link existing)
- [ ] Deployment starts successfully
- [ ] Deployment completes (2-5 min)

### Step 2: Add Environment Variables
- [ ] Go to https://vercel.com/dashboard
- [ ] Click your project `ruby-crud-catalog`
- [ ] Go to Settings > Environment Variables
- [ ] Added `RAILS_ENV = production`
- [ ] Added `RAILS_MASTER_KEY = [your-key]`
- [ ] Added `DATABASE_URL = [your-neon-url]`
- [ ] All set to "Production" environment only

### Step 3: Redeploy
- [ ] Run `vercel --prod` again
- [ ] New deployment starts
- [ ] Deployment completes successfully

### Step 4: Run Migrations
- [ ] Run `vercel env pull`
- [ ] Run `RAILS_ENV=production bundle exec rails db:create`
- [ ] Run `RAILS_ENV=production bundle exec rails db:migrate`
- [ ] Run `RAILS_ENV=production bundle exec rails db:seed`
- [ ] All commands complete without errors

---

## Post-Deployment Checklist

### Testing
- [ ] Copy your app URL from Vercel dashboard
- [ ] Open app URL in browser
- [ ] Page loads without errors
- [ ] Can access login page
- [ ] Login with admin/password works
- [ ] Dashboard displays correctly
- [ ] Can view categories
- [ ] Can view products
- [ ] Can create new category
- [ ] Can create new product
- [ ] Can edit categories/products
- [ ] Can delete categories/products (with protection)
- [ ] Excel export button works
- [ ] API endpoints respond (test in Postman/curl)

### Verification
- [ ] Vercel shows "Ready" status
- [ ] No error logs: `vercel logs ruby-crud-catalog --prod`
- [ ] Database connection works
- [ ] Data persists after page reload
- [ ] Can logout successfully

---

## Troubleshooting Checklist

If something doesn't work:

### Deployment Failed
- [ ] Check logs: `vercel logs ruby-crud-catalog --prod`
- [ ] Check error details in Vercel dashboard
- [ ] Verify `Gemfile.lock` exists
- [ ] Try redeploy: `vercel --prod --force`

### Cannot Connect to Database
- [ ] Verify DATABASE_URL in Vercel dashboard
- [ ] Check if DATABASE_URL includes `?sslmode=require`
- [ ] Test connection: `psql $DATABASE_URL -c "SELECT 1"`
- [ ] Re-enter DATABASE_URL carefully (copy-paste)
- [ ] Redeploy: `vercel --prod`

### Login Doesn't Work
- [ ] Check RAILS_MASTER_KEY is correct in dashboard
- [ ] Verify credentials: admin / password
- [ ] Check if db:seed ran successfully
- [ ] Check logs: `vercel logs ruby-crud-catalog --prod`

### App Shows Error 500
- [ ] View logs: `vercel logs ruby-crud-catalog --prod -f`
- [ ] Check if migrations ran
- [ ] Verify all environment variables are set
- [ ] Check Rails logs for specific error

### Slow Response (30+ seconds)
- [ ] This is normal for first request (cold start)
- [ ] Subsequent requests will be faster
- [ ] Use uptime monitoring to prevent cold starts
- [ ] Upgrade to Vercel Pro for faster cold starts

---

## Success Indicators

You'll know it's working when:

✅ App URL is: `https://ruby-crud-catalog.vercel.app`
✅ Page loads in 1-5 seconds
✅ Login page displays
✅ Admin login works
✅ Dashboard shows categories and products
✅ Can perform CRUD operations
✅ No error messages
✅ Vercel dashboard shows "Ready"
✅ Neon dashboard shows active connections

---

## Next Steps (After Successful Deployment)

- [ ] Test all features thoroughly
- [ ] Set up monitoring (optional)
- [ ] Configure custom domain (optional)
- [ ] Enable auto-deploys from GitHub (optional)
- [ ] Set up database backups (Neon has auto-backups)
- [ ] Document production access details
- [ ] Share app URL with team/users

---

## Important Notes

⚠️ **Do NOT:**
- Commit `config/master.key` to git
- Commit `.env` or `.env.production` to git
- Share RAILS_MASTER_KEY or DATABASE_URL publicly
- Use `sslmode=disable` in production

✅ **Do:**
- Keep RAILS_MASTER_KEY safe
- Keep DATABASE_URL in Vercel (not in git)
- Test all features before sharing
- Monitor app logs regularly
- Keep Rails updated

---

## Resources

- Vercel Dashboard: https://vercel.com/dashboard
- Neon Console: https://console.neon.tech
- Vercel Docs: https://vercel.com/docs
- Neon Docs: https://neon.tech/docs

---

## Support

If you get stuck:

1. **Read**: `DEPLOYMENT_STEPS.md`
2. **Check**: Vercel logs (`vercel logs ruby-crud-catalog --prod`)
3. **Verify**: All environment variables in dashboard
4. **Test**: Database connection manually
5. **Ask**: Check guides for similar issues

---

**Print or bookmark this checklist for reference!**

Last Updated: October 19, 2025
Status: Ready for Production ✅
