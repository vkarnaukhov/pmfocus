require "bundler/vlad"
set :application, "pmfocus"
set :domain, "192.168.182.131"
set :deploy_to, "/etc/deployment/#{application}"
set :repository, 'https://github.com/vkarnaukhov/pmfocus.git'

set :unicorn_pid, "#{deploy_to}/shared/log/unicorn.pid"
set :unicorn_command, "cd #{deploy_to}/current && RACK_ENV=production bundle exec unicorn"

set :web_command, "nginx"
