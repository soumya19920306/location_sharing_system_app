# Location Sharing Application

 In this application a user can create his/her own account and can share any location to other people within this 
 application from a map view. Users can share these locations in two ways. Firstly, users can share locations publicly and secondly,with some available selected users. A user can also view all other users and the publicly shared places in map view.

### Prerequisites

* Ruby version: 2.7.2

* Rails version: 6.1.1

* Database: PostgreSQL (Version: 10)

### Installation

Make sure we have preinstalled Node JS and yarn:

Install Ruby using ruby version manager (rvm):

```
sudo apt-get install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 2.7.2
#To set this as default ruby version
rvm use 2.7.2 --default
ruby -v
# To verify
ruby -v
```

Now install bundler using:
```
gem install bundler
```

Now install Rails
```
gem install rails -v 6.1.1
# To verify
rails -v
```

Setting Up PostgreSQL
```
sudo apt-get install postgresql-10

# And start the server.
sudo su - postgres
```
### Creating new rails project

```
# Create the new application with postgresql adapter
# To run this application in another machine need to edit config/database.yml
rails new location_sharing_app -d postgresql
```

```
# Go to the application directory
cd location_sharing_app
```

run bundle install to install additional dependencies
```
bundle install
```

To create the database
```
# Create the database
# Check twice tha config/database.yml file with correct postgresql credentials
rake db:create
```

Final step to run the project
```
# To start the puma server
rails s
```

## Project deployed in Heroku for set up 
### Requirements:
* A free Heroku account.
* Ruby 2.3.5 installed locally
* Bundler installed locally - run gem install bundler.

* Reference:
'''
https://devcenter.heroku.com/articles/getting-started-with-ruby
'''

### Load sample data from seed file
To load sample data from from seed file:
* Seed files are available under app_root/db/fixtures/
```
# Need to run first to reset all existing data in the database
# otherwise data mappings will not be matched
rails db:reset

# Now load seed data to db



```
### References
* https://gorails.com/setup/windows/10

* https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-database

* https://www.rubydoc.info/gems/seed-fu/2.3.9