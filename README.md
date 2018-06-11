# Connect Starter Package

## Setup
- Install [Homebrew](https://brew.sh/)
- Install Postgres
 - `brew install postgresql`
   - If you have problem with homebrew after OSX upgrade to Yosemite, run following commands
   - `cd /usr/local/Library`
   - `git pull origin master`
 - Start Database: `pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start`
 - Setup User: Create "postgres" user: `/usr/local/Cellar/postgresql/9.3.5/bin/createuser -s postgres`
   - Version number of postgresql may be different, highlighted in red. Check install by typing `psql --version`
 - Log into psql and change the postgres users password `psql -U postgres`
 - Change the postgres password `ALTER USER postgres WITH PASSWORD 'root';`
 - Exit out of postgres `\q`
- Install [Redis](https://redis.io/)
  - `brew install redis`
  - Start Server: `redis-server`
- Install [PgAdmin](https://www.pgadmin.org/) or [Postico](https://eggerapps.at/postico/)
- Install [RVM](https://rvm.io/rvm/install)
  - Install RVM with `\curl -sSL https://get.rvm.io | bash`
  - From terminal run `source ~/.bash_profile`
  - If you run into brew permission issues, please try the following command: `sudo chown -R `*whoami*`:admin/usr/local/bin"` Replace *whoami* with your current terminal user. My terminal screen reads as follows: Karols-Macbook-Air:zhub kchudy$. In this case kchudy would replace '*whoami*'. If rvm install ruby still throws permission errors remove homebrew and reinstall the latest version by following the below steps:
    - `brew update`
    - `rm -rf /usr/local/Cellar /usr/local/.git && brew cleanup`
    - `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
  - Install Ruby
    - Install ruby-2.3.1 with `rvm install ruby-2.3.1 --disable-binary`
  - Install Bundler
    - `gem install bundler`
  - Clone the Repository
    - `git clone https://github.com/zuora/connect-starter-package.git`

## Running the Starter Package
- Run `bundle install`
- Run `rake db:create`
- Run `rake db:migrate`
- Start the server with `rails s`
