namespace :db do
  desc "compile based on the contents of #{RAILS_ROOT}/db/compile.yml"
  task :compile => 'environment' do
    require 'dbcompile'
    DbCompile.build_transaction
  end
end
