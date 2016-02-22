require "rvm/capistrano"
require "bundler/capistrano"

set :application, "PMFocus"

set :scm, :git
set :repository,  "https://github.com/vkarnaukhov/pmfocus.git"
set :deploy_via, :copy
set :copy_cache, true

set :deploy_server, "192.168.182.131"
set :use_sudo, false

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_to,       "/etc/deployment/#{application}"  # наша папка куда мы размещаем 
set :bundle_dir,      File.join(fetch(:shared_path), 'gems')
role :web, deploy_server                          # Your HTTP server, Apache/etc
role :app, deploy_server                          # This may be the same as your `Web` server

set :copy_dir, "/home/core/tmp"
set :remote_copy_dir, "/tmp"

set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,'') 
#set :rvm_ruby_string, "2.0.0@projects_gemset"  # здесь версия нашего ruby и созданного gemset'а, может его и надо будет создать
set :rvm_type, :user

set :rake,            "rvm use #{rvm_ruby_string} do bundle exec rake --trace"
set :bundle_cmd,      "rvm use #{rvm_ruby_string} do bundle"

set :unicorn_conf,    "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid,     "#{deploy_to}/shared/tmp/unicorn.pid"  # путь к нашему unicorn инстансу
set :unicorn_start_cmd, "(cd #{deploy_to}/current; rvm use #{rvm_ruby_string} do bundle exec unicorn -Dc #{unicorn_conf})"  # команда для его запуска

namespace :deploy do
  desc "Start application"
  task :start, :roles => :app do
    run unicorn_start_cmd
  end

  desc "Stop application"
  task :stop, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -QUIT `cat #{unicorn_pid}`"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -USR2 `cat #{unicorn_pid}` || #{unicorn_start_cmd}"
  end
end

