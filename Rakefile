require 'pact/tasks'
require 'pact_broker/client/tasks'

task :default => 'pact:verify'


PactBroker::Client::PublicationTask.new do | task |
  task.consumer_version = "1.0.0"
  task.pact_broker_base_url = "http://pactbroker-sandbox.sbx-apps.ticketfly.com/"
  # task.pact_broker_basic_auth =  { username: 'basic_auth_user', password: 'basic_auth_pass'} #optional
end
