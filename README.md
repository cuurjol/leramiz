# LERAMIZ

LERAMIZ is a simple chat based on ActionCable WebSockets. When you enter the application, you get a unique name. 
You can create public and private rooms, invite people there (giving them a link to the room) and communicate with them.

## Annotation

Application was created on `Ruby (v2.6.3)` and `Ruby on Rails (v5.2.3)`.

## Installation and running

Before running the application, you need to clone the repository, install all the necessary gems and prepare 
the database. In order to do this, you need to run the following commands in the terminal:

```
# Clone the repository and change directory:
git clone https://github.com/cuurjol/leramiz.git
cd leramiz

# List of used gems are in the Gemfile.
# Install gems:
bundle install

# Prepare the database (Postgresql) for working with the application:
bundle exec rake db:create
bundle exec rake db:migrate
```

Also you need to install redis-server on your local machine for working with Redis Cache Store.

By default the application use `async` backend adapter for working with web-sockets, workers and delayed jobs.
You can change the backend adapter to `redis` in `config/cable.yml` (for web-sockets) and 
`config/environments/development.rb` (for workers and delayed jobs) files:

```
# config/cable.yml
development:
  adapter: redis
  
# config/environments/development.rb
config.active_job.queue_adapter     = :resque
config.active_job.queue_name_prefix = "leramiz_#{Rails.env}"
```

If you use the `redis` backend adapter, run the following commands on the other console tab:

```
# The command for starting redis-server
# redis-server (or sudo systemctl start redis.service)
sudo systemctl start redis.service

# The command for starting workers and delayed jobs
foreman start
```

Then, run the local server and go to the browser at `http://localhost:3000`:
```
bundle exec rails s
```
Also the application has an access to the page `http://localhost:3000/resque_web`. You can protect it by 
creating the following settings file:

```
# config/resque_env/yml

RESQUE_WEB_HTTP_BASIC_AUTH_USER: 'YOUR USERNAME'
RESQUE_WEB_HTTP_BASIC_AUTH_PASSWORD: 'YOUR PASSWORD'
```