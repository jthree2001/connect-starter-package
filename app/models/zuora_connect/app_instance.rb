module ZuoraConnect
  class AppInstance < ZuoraConnect::AppInstanceBase


    def self.example
      puts "Class Method"
    end

    def example
      puts "Instance method"
    end

  end
end
