# LERAMIZ

LERAMIZ is a simple chat based on ActionCable WebSockets. When you enter the application, you get a unique name. 
You can create rooms, invite people there (giving them a link to the room) and communicate with them.

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

Then, run the local server and go to the browser at `http://localhost:3000`:
```
bundle exec rails s
```

## Heroku deployment

The application is ready for deployment on the Heroku. The working version of the project can be viewed at 
[Heroku website](https://cuurjol-leramiz.herokuapp.com/).