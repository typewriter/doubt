require 'rubygems' unless defined? ::Gem
require 'unicorn/worker_killer'
require File.dirname(__FILE__) + '/app.rb'

# Max requests per worker
use Unicorn::WorkerKiller::MaxRequests, 1024, 2048
# Max memory size (RSS) per worker
use Unicorn::WorkerKiller::Oom, (192*(1024**2)), (256*(1024**2))

run Sinatra::Application

