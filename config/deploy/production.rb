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

set :ssh_options, forward_agent: true, auth_methods: ["publickey"],keys: ['~/rbm-prod.pem'],proxy: Net::SSH::Proxy::Command.new('ssh mingle@10.109.253.216 -W %h:%p')

#Front end
server  '10.240.2.241' , roles: [:web, :app], user: 'deploy'

set :deploy_to, '/var/www/apps/production'
set :rails_env, "production"
set :branch, "master"

set :rvm_type, :system
set :rvm_ruby_version, '2.3.1'



