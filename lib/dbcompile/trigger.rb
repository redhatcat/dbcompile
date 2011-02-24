module DbCompile
  class Trigger < Construct
    def build_path
      @path = File.join('triggers', "#{name}.sql")
    end

    def verify
      sql = nil
      case ActiveRecord::Base.connection.class.to_s
        when 'ActiveRecord::ConnectionAdapters::PostgreSQLAdapter'
          sql = "SELECT * FROM pg_trigger WHERE tgname = '#{name}';"
      end
      does_one_exist?(sql)
    end
  end
end
