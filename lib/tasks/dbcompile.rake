namespace :db do
  desc "compile based on the contents of #{Rails.root}/db/compile.yml"
  task :compile => 'environment' do
    require 'dbcompile'
    DbCompile.build_transaction
  end
end
