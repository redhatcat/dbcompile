module DbCompile
  class Function < Construct
    def build_path
      @path = File.join('functions', "#{name}.sql")
    end

    def verify
      sql = nil
      case ActiveRecord::Base.connection.class.to_s
        when 'ActiveRecord::ConnectionAdapters::PostgreSQLAdapter'
          sql = "SELECT proname FROM pg_proc WHERE proname = '#{name.downcase}';"
      end
      return does_one_exist?(sql) if sql
    end
  end
end
