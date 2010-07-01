namespace :db do
  task :compile => 'environment' do
    require 'dbcompile'
    DbCompile.build_transaction
  end
end
