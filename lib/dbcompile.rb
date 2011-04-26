require 'dbcompile/transaction.rb'

module DbCompile
  def self.build_transaction(path=nil)
    if not path
      path = File.join(RAILS_ROOT, 'db')
    end
    transaction = Transaction.new(path)
    transaction.execute
    if not transaction.verify
      exit 1
    end
  end
end
