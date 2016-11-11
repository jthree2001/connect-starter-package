# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
# Don't declare `role :all`, it's a meta role
# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
require 'net/ssh/proxy/command'

#Front end
server  '1.1.1.1' , roles: [:web, :app, :worker, :db], user: 'deploy'

set :deploy_to, '/var/www/apps/production'
set :rails_env, "production"
set :branch, "master"
set :deployment_server, :passenger

set :rvm_type, :system
set :rvm_ruby_version, '2.3.1'


