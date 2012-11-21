require 'dbcompile/transaction.rb'

module DbCompile
  class Task < Rails::Railtie
    rake_tasks do
      Dir[File.join(File.dirname(__FILE__),'tasks/*.rake')].each { |f| load f }
    end
  end
  def self.build_transaction(path=nil)
    if not path
      path = File.join(Rails.root, 'db')
    end
    transaction = Transaction.new(path)
    transaction.execute
    if not transaction.verify
      exit 1
    end
  end
end

