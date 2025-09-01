# Sunrise Sunset Looker 🌅

A modern Rails application that provides historical sunrise and sunset data for any location. Built with Ruby on Rails 8, PostgreSQL, and modern JavaScript, this application allows users to query historical astronomical data and visualize it through an interactive charts.

## 🚀 Features

- **Location-based Data**: Query sunrise and sunset times for any coordinates worldwide
- **Date Range Queries**: Search for historical data across custom date ranges
- **Automatic Location Detection**: Browser-based geolocation for instant access to local data using Geocoder
- **Interactive Charts**: Uses Chart.js visualizations showing sunrise, sunset, and golden hour times
- **Data Caching**: Intelligent caching system to reduce API calls and improve performance


## 🛠 Tech Stack
### Backend
- **Ruby 3.4.3**
- **Rails 8.0.2**
- **PostgreSQL**
- **Redis**
- **Puma**

### Frontend
- **Stimulus.js**
- **Bootstrap 5**
- **Sass**
- **ESBuild**

## 📋 Prerequisites

Before running this application, ensure you have the following installed:

- **Ruby 3.4.3** (use `.ruby-version` file)
- **Node.js 18.0.0** (use `.node-version` file)
- **PostgreSQL** (version 12 or higher)
- **Redis** (for caching and sessions)
- **Yarn** (for JavaScript package management)

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone <repository-url>
cd weather-app
```

### 2. Install Dependencies
```bash
# Install Ruby gems
bundle install

# Install JavaScript packages
yarn install
```

### 3. Database Setup
```bash
# Create and setup database
rails db:create
rails db:migrate
```

### 4. Environment Configuration
Create a `.env` file in the root directory:
```bash
# Database
DATABASE_URL=postgresql://localhost/weather_app_development

# Redis
REDIS_URL=redis://localhost:6379/0

# External API (you'll need to obtain API keys)
SUNSET_SUNRISE_API_URL=https://api.sunrise-sunset.org
```

### 5. Start the Application
```bash
# Start the Rails server
rails server

# In another terminal, start Redis (if not running)
redis-server

# Visit the application
open http://localhost:3000
```

## 🧪 Testing

### Run Test Suite
```bash
# Run Ruby tests
rspec

# Run JavaScript tests
yarn test

# Run all tests
rspec && yarn test
```

### Code Quality
```bash
# Ruby code quality
bundle exec rubocop

# Security audit
bundle exec brakeman

# JavaScript code quality
yarn standard
```

## 📊 API Documentation

### Endpoints

#### POST `/historical_informations`
- **Description**: Create a new historical information query
- **Parameters**:
  - `latitude` (decimal): Location latitude
  - `longitude` (decimal): Location longitude
  - `start_date` (date): Start date for data range
  - `end_date` (date): End date for data range
- **Response**: Redirects to show page with results

#### GET `/historical_informations/:id`
- **Description**: Display historical information results
- **Response**: HTML page with chart and data table

### Data Structure for `Historical Information`
```json
{
  "id": 1,
  "latitude": "40.7128",
  "longitude": "-74.0060",
  "start_date": "2024-01-01",
  "end_date": "2024-01-07",
  "data": [
    {
      "date": "2024-01-01",
      "sunrise_time": "07:20:00",
      "golden_hour": "16:30:00",
      "sunset_time": "16:50:00"
    }
  ]
}
```

## 🏗 Architecture

### Application Structure
```
app/
├── controllers/          # RESTful controllers
├── models/              # ActiveRecord models
├── services/            # Business logic services
├── lib/                 # Custom libraries and API clients
├── views/               # HAML templates
├── javascript/          # Stimulus controllers and JS
└── assets/              # Stylesheets and static assets
```

### Key Components

#### Models
- **HistoricalInformation**: Core model for storing location and date range queries with JSONB data storage

#### Services
- **FetchDateRangeSunsetSunrise**: Service object handling API calls and caching logic

#### API Integration
- **SunsetSunriseApi::Client**: External API client with Faraday HTTP client
  - **GetDateRangeResponse**: Response parser for a GET response data

#### Frontend
- **Chart Controller**: Stimulus controller for Chart.js integration
- **Bootstrap UI**: Responsive, modern interface

## 🔧 Configuration

### Environment Variables
- `DATABASE_URL`: PostgreSQL connection string
- `REDIS_URL`: Redis connection string
- `SUNSET_SUNRISE_API_URL`: External API endpoint

### Database Configuration
The application uses PostgreSQL with the following key features:
- JSONB columns for flexible data storage
- Indexed columns for performance optimization
- Proper foreign key constraints

## Performance Optimizations

### Caching Strategy
- **Database Caching**: Stores API responses to avoid redundant calls

### Database Optimizations
- **Indexed Queries**: Optimized database indexes for location and date queries
- **JSONB Storage**: Efficient storage of complex astronomical data
- **Connection Pooling**: Optimized database connections


## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

Created with ❤️ for a tech challenge

---
