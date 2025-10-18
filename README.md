# Catalog Dashboard - Ruby on Rails

A full-stack Ruby on Rails application for managing product catalogs with categories, complete with authentication, CRUD operations, and Excel export functionality.

## Features

- **User Authentication** - Login with email or username
- **Dashboard Overview** - Statistics and recent products
- **Category Management** - Full CRUD with delete protection for categories with products
- **Product Management** - Full CRUD with category association and publish status
- **Excel Export** - Export products to XLSX format
- **REST API v1** - Complete RESTful API endpoints for all operations
- **UUID Primary Keys** - PostgreSQL with pgcrypto extension for better security
- **Publish Status** - Control visibility of categories and products
- **Docker Support** - Fully containerized application with PostgreSQL
- **CORS Support** - Cross-origin requests enabled for API
- **Hotwire Integration** - Turbo & Stimulus for modern Rails experience

## Tech Stack

- **Ruby**: 3.2.9
- **Rails**: 8.0.3
- **Database**: PostgreSQL 15+ (with UUID support via pgcrypto)
- **Authentication**: bcrypt with has_secure_password
- **Excel Export**: caxlsx + caxlsx_rails
- **Frontend**: Rails Views with Hotwire (Turbo + Stimulus)
- **Containerization**: Docker & docker-compose
- **API**: JSON API format

## Installation

### Prerequisites

- Docker and docker-compose installed
- Git
- At least 2GB of free disk space

### Quick Start

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ruby
   ```

2. **Build and start the containers**
   ```bash
   docker-compose up -d --build
   ```
   This will:
   - Build the Rails application image
   - Start PostgreSQL database container
   - Start the Rails web server on port 3000

3. **Create and migrate the database**
   ```bash
   docker-compose run --rm web rails db:create db:migrate db:seed
   ```
   This will:
   - Create a fresh PostgreSQL database
   - Run all migrations to create tables
   - Seed with sample data (1 admin user, 3 categories, 6 products)

4. **Access the application**
   - **Frontend**: http://localhost:3000
   - **API**: http://localhost:3000/api/v1
   - **Default Credentials**: 
     - Username: `admin`
     - Email: `admin@example.com`
     - Password: `password`

### Docker Compose Commands

```bash
# Start containers in background
docker-compose up -d

# Stop containers
docker-compose down

# Stop and remove volumes (clean slate)
docker-compose down -v

# View logs
docker-compose logs -f web

# Execute Rails commands
docker-compose exec web rails console
docker-compose exec web rails generate migration MigrationName

# Restart containers
docker-compose restart
```

## Project Structure

```
app/
├── controllers/
│   ├── api/v1/              # API controllers (ActionController::API)
│   │   ├── base_controller.rb
│   │   ├── sessions_controller.rb
│   │   ├── categories_controller.rb
│   │   └── products_controller.rb
│   ├── application_controller.rb  # Frontend base (ActionController::Base)
│   ├── sessions_controller.rb     # Login/logout pages
│   ├── dashboard_controller.rb    # Dashboard overview
│   ├── categories_controller.rb   # Category management UI
│   └── products_controller.rb     # Product management UI
├── models/
│   ├── user.rb              # Authentication model
│   ├── category.rb          # Category with delete protection
│   └── product.rb           # Product with category association
└── views/
    ├── layouts/
    │   └── application.html.erb   # Main layout with embedded CSS
    ├── sessions/
    │   └── new.html.erb           # Login page
    ├── dashboard/
    │   └── index.html.erb         # Dashboard overview
    ├── categories/
    │   ├── index.html.erb         # List categories
    │   ├── new.html.erb           # Create category form
    │   └── edit.html.erb          # Edit category form
    └── products/
        ├── index.html.erb         # List products with Excel export
        ├── new.html.erb           # Create product form
        └── edit.html.erb          # Edit product form
```

## API Endpoints

### Authentication
- `POST /api/v1/login` - Login with email/username and password
  ```json
  {
    "identifier": "admin or admin@example.com",
    "password": "password"
  }
  ```

### Categories
- `GET /api/v1/categories` - List all categories (with filters)
- `GET /api/v1/categories/:id` - Get single category by ID
- `POST /api/v1/categories` - Create new category (requires: name, publish)
- `PATCH /api/v1/categories/:id` - Update category (name, publish)
- `PUT /api/v1/categories/:id` - Update category (full update)
- `DELETE /api/v1/categories/:id` - Delete category (protected if has products)

### Products
- `GET /api/v1/products` - List all products with pagination and filters
- `GET /api/v1/products/:id` - Get product details with category info
- `POST /api/v1/products` - Create product (requires: name, category_id, publish)
- `PATCH /api/v1/products/:id` - Update product (name, category_id, publish)
- `PUT /api/v1/products/:id` - Update product (full update)
- `DELETE /api/v1/products/:id` - Delete product
- `GET /api/v1/products/export` - Export all products to XLSX format

## Frontend Routes

### Authentication
- `GET /login` - Login page
- `POST /login` - Submit login form
- `DELETE /logout` - Logout and clear session

### Dashboard & Management
- `GET /` - Root/Dashboard (redirects to login if not authenticated)
- `GET /dashboard` - Dashboard with overview and recent products

### Categories
- `GET /categories` - List all categories with CRUD actions
- `GET /categories/new` - New category form
- `POST /categories` - Submit new category
- `GET /categories/:id/edit` - Edit category form
- `PATCH /categories/:id` - Update category
- `DELETE /categories/:id` - Delete category (with protection)

### Products
- `GET /products` - List all products with Excel export option
- `GET /products/new` - New product form
- `POST /products` - Submit new product
- `GET /products/:id/edit` - Edit product form
- `PATCH /products/:id` - Update product
- `DELETE /products/:id` - Delete product

## Database Schema

### Users Table
```sql
CREATE TABLE users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email varchar UNIQUE NOT NULL,
  username varchar UNIQUE NOT NULL,
  password_digest varchar NOT NULL,
  created_at timestamp,
  updated_at timestamp
);
```

### Categories Table
```sql
CREATE TABLE categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name varchar NOT NULL,
  publish integer DEFAULT 0,
  created_at timestamp,
  updated_at timestamp
);
```

### Products Table
```sql
CREATE TABLE products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name varchar NOT NULL,
  category_id uuid REFERENCES categories(id),
  publish integer DEFAULT 0,
  created_at timestamp,
  updated_at timestamp
);
CREATE INDEX index_products_on_category_id ON products(category_id);
```

## Usage Guide

### Adding a New Category
1. Navigate to **Categories** menu
2. Click **+ New Category**
3. Enter category name
4. Select publish status (Yes/No)
5. Click **Create Category**

### Adding a New Product
1. Navigate to **Products** menu
2. Click **+ New Product**
3. Enter product name
4. Select a category
5. Select publish status
6. Click **Create Product**

### Exporting Products
1. Navigate to **Products** menu
2. Click **Export Excel** button
3. XLSX file will download automatically

### Updating Publish Status
1. Edit the category or product
2. Change the **Publish** dropdown
3. Click **Update** button
4. Status will be reflected immediately in the list

## Configuration

### Environment Setup

The application is configured via `config/` files:

```
config/
├── application.rb         # Main Rails configuration
├── boot.rb               # Boot configuration
├── cable.yml             # WebSocket adapter (ActionCable)
├── database.yml          # Database connection settings
├── puma.rb              # Application server configuration
├── storage.yml          # Active Storage configuration
├── environments/        # Environment-specific configs
│   ├── development.rb
│   ├── production.rb
│   └── test.rb
└── initializers/        # Initialization hooks
    ├── cors.rb         # CORS configuration
    ├── active_record_uuid.rb  # UUID support
    └── filter_parameter_logging.rb  # Sensitive params filtering
```

### Database Configuration

PostgreSQL connection defined in `config/database.yml`:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: postgres
  password: password
  host: db
  port: 5432

development:
  <<: *default
  database: morbis_development

test:
  <<: *default
  database: morbis_test

production:
  <<: *default
  database: morbis
  username: <%= ENV['DB_USER'] %>
  password: <%= ENV['DB_PASSWORD'] %>
```

### CORS Configuration

Enabled in `config/initializers/cors.rb`:

```ruby
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete]
  end
end
```

## Sample Data

Run `rails db:seed` to populate the database with:
- **Admin User**: 
  - Username: `admin`
  - Email: `admin@example.com`
  - Password: `password`
- **3 Categories**: Electronics, Clothing, Books
- **6 Products**: 2 products per category with varied publish statuses

View seed data in `db/seeds.rb`

## Development

### Running Tests
```bash
docker-compose exec web rails test
docker-compose exec web rails test:system
```

### Rails Console
```bash
# Interactive console for testing queries
docker-compose exec web rails console

# Example queries:
# User.first
# Category.all
# Product.where(publish: 1)
```

### Database Migrations
```bash
# Generate new migration
docker-compose exec web rails generate migration AddFieldToProducts

# Run pending migrations
docker-compose exec web rails db:migrate

# Rollback last migration
docker-compose exec web rails db:rollback

# Reset database (fresh start)
docker-compose exec web rails db:drop db:create db:migrate db:seed

# Show migration status
docker-compose exec web rails db:migrate:status
```

### Debugging
```bash
# View application logs in real-time
docker-compose logs -f web

# View all container logs
docker-compose logs -f

# Check container status
docker-compose ps

# Execute shell in container
docker-compose exec web /bin/bash
```

### Code Generation
```bash
# Generate model, controller, views
docker-compose exec web rails generate scaffold Article title:string content:text

# Generate controller only
docker-compose exec web rails generate controller Articles

# Generate model only
docker-compose exec web rails generate model Article title:string content:text
```

## Key Features Explained

### UUID Primary Keys
- All tables use UUID (Universally Unique Identifier) instead of auto-incrementing integers
- Generated using PostgreSQL `pgcrypto` extension with `gen_random_uuid()`
- Advantages:
  - Better security (harder to guess IDs)
  - Suitable for distributed systems
  - Prevent ID enumeration attacks
  - Enable horizontal scaling

### Delete Protection
- Categories cannot be deleted if they have associated products
- Prevents data integrity issues
- Returns friendly error: "Cannot delete category with active products."
- Uses Rails association with `dependent: :restrict_with_error`

### Authentication & Security
- Session-based authentication with bcrypt password hashing
- Supports login with either email OR username
- Uses Rails `has_secure_password` for password management
- Before-action filter ensures authentication on protected routes
- Sessions stored server-side (secure)

### Publish Status System
- Integer-based publish flag (0=No, 1=Yes)
- Applied to both categories and products
- Scopes for easy filtering: `Category.published`, `Category.unpublished`
- Helper methods: `published?`, `unpublished?`, `publish_status`

### Excel Export
- Uses `caxlsx` gem to generate XLSX files
- Includes: ID, Name, Category, Publish status, Created date
- Download directly from frontend button or API endpoint
- Supports large datasets efficiently

### RESTful API
- Standard REST conventions for all resources
- JSON request/response format
- Proper HTTP status codes (200, 201, 400, 404, 422, 500)
- CORS enabled for cross-origin requests
- Located in `app/controllers/api/v1/`

## Troubleshooting

### Port Already in Use
```bash
# Stop all containers
docker-compose down

# Check what's using port 3000 (Linux/Mac)
lsof -i :3000

# Check port 3000 (Windows)
netstat -ano | findstr :3000

# Start containers again
docker-compose up -d
```

### Database Connection Error
```bash
# Check if database container is running
docker-compose ps

# Recreate database from scratch
docker-compose down -v  # Remove volumes
docker-compose up -d    # Restart containers
docker-compose exec web rails db:create db:migrate db:seed
```

### Application Won't Start
```bash
# View logs
docker-compose logs web

# Rebuild containers
docker-compose down
docker-compose up -d --build

# Check for errors in logs
docker-compose logs web | tail -50
```

### Session/Authentication Issues
```bash
# Clear session by logging out
# Delete browser cookies for localhost:3000

# Or reset database and re-login
docker-compose exec web rails db:seed
```

### Cannot Edit/Update Records
```bash
# Ensure form is submitting with correct HTTP method
# Check browser network tab for failed requests
# View server logs: docker-compose logs -f web

# Verify database has data
docker-compose exec web rails console
# Then: Category.count, Product.count
```

### Permission Errors
```bash
# Ensure Docker daemon is running
# On Windows/Mac, ensure Docker Desktop is started

# If getting permission denied on Linux
sudo usermod -aG docker $USER
newgrp docker
```

## Performance Optimization

### Database Indexing
```ruby
# Existing indices
- users.email (unique)
- users.username (unique)
- products.category_id (indexed for foreign key lookups)
```

### Caching Considerations
- Dashboard counts query all categories/products
- Consider caching for large datasets: `Category.count` → Rails.cache

### Pagination
- API supports pagination via `page` and `per_page` params
- Can reduce query load for large result sets

## Security Best Practices

- ✅ Password hashing with bcrypt
- ✅ Session-based authentication  
- ✅ CSRF protection via Rails form helpers
- ✅ SQL injection prevention via ORM (ActiveRecord)
- ✅ XSS protection via template escaping
- ✅ UUID IDs prevent ID enumeration
- ✅ CORS configured for allowed origins

**Recommendations for Production:**
- Enable HTTPS/SSL
- Use strong CSRF tokens
- Implement rate limiting
- Add request logging and monitoring
- Use environment variables for secrets
- Enable database backups
- Set up error tracking (Sentry, etc.)

## Contributing

To contribute to this project:

1. Create a feature branch: `git checkout -b feature/your-feature`
2. Make your changes
3. Test locally: `docker-compose exec web rails test`
4. Commit: `git commit -am 'Add new feature'`
5. Push: `git push origin feature/your-feature`
6. Open a Pull Request

## Deployment

### Deploy to Vercel (Recommended for Easy Deployment)

This application can be deployed to Vercel with a managed PostgreSQL database.

**Prerequisites:**
- GitHub account with repository pushed
- Vercel account (https://vercel.com)
- PostgreSQL database (Supabase, Railway, or similar)

**Quick Deploy:**

1. **Push to GitHub**
   ```bash
   git add .
   git commit -m "Ready for Vercel deployment"
   git push origin main
   ```

2. **Connect to Vercel**
   - Go to https://vercel.com/new
   - Select your GitHub repository
   - Click "Import"

3. **Set Environment Variables** (in Vercel Settings > Environment Variables)
   ```
   RAILS_ENV = production
   RAILS_MASTER_KEY = [your-master-key-from-config/master.key]
   DATABASE_URL = postgresql://user:password@host:5432/database
   ```

4. **Deploy**
   - Click "Deploy"
   - Wait for build to complete

For detailed instructions, see: **[VERCEL_DEPLOYMENT.md](./VERCEL_DEPLOYMENT.md)**

### Deploy to Traditional Hosting

For Docker-based deployment or traditional hosting:

```bash
# Build Docker image
docker build -t ruby-crud-catalog .

# Push to Docker Hub/Registry
docker tag ruby-crud-catalog username/ruby-crud-catalog
docker push username/ruby-crud-catalog

# Deploy using docker-compose
docker-compose up -d
```

### Deploy to Railway.app (Simple Alternative)

```bash
# Install Railway CLI
npm i -g @railway/cli

# Login to Railway
railway login

# Initialize project
railway init

# Deploy
railway up
```

### Deploy to Render.com (Rails-Friendly)

1. Push to GitHub
2. Go to https://render.com
3. Create new Web Service
4. Connect GitHub repository
5. Select Rails template
6. Set environment variables
7. Deploy

See environment-specific guides:
- **[VERCEL_DEPLOYMENT.md](./VERCEL_DEPLOYMENT.md)** - Vercel with PostgreSQL

## License

This project is for demonstration purposes.

---

**Last Updated**: October 19, 2025  
**Version**: 1.0.0  
**Status**: Production Ready

## Support

For issues and questions:
- Check the Troubleshooting section
- Review application logs: `docker-compose logs -f web`
- Consult Rails documentation: https://guides.rubyonrails.org/
- See deployment guides: [VERCEL_DEPLOYMENT.md](./VERCEL_DEPLOYMENT.md)
# ruby-crud-catalog
