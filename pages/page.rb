require 'selenium-webdriver'
require 'yaml'
require 'page-object/platforms/selenium_webdriver/element'
require 'page-object'

class Page
  include PageObject
  @@config = YAML.load_file('../config/config.yaml')

  def initialize(root,visit = false)
    super(root, visit)
    Selenium::WebDriver::Element.class_eval do

      def initialize(bridge, id)
        @bridge = bridge
        @id = id
      end

      def click

        wait = Object::Selenium::WebDriver::Wait.new({:timeout => 2, :message => "ff"})
        wait.until {
           begin
             @bridge.click_element @id
             true
           rescue Exception => e
             puts e.message
             puts e.backtrace.inspect
             puts "rescue click"
             false
           end
        }


        #@bridge.mouse_move_to @id
      end
      def text
        #wait = Object::Selenium::WebDriver::Wait.new({:timeout => 5, :message => "ff"})
        #wait.until {(@bridge.element_enabled? @id) && (@bridge.element_displayed? @id)}
        @bridge.element_text @id
      end
    end

    Selenium::WebDriver::SearchContext.module_eval do




      def extract_args(args)
        case args.size
          when 2
            args
          when 1
            arg = args.first

            unless arg.respond_to?(:shift)
              raise ArgumentError, "expected #{arg.inspect}:#{arg.class} to respond to #shift"
            end

            # this will be a single-entry hash, so use #shift over #first or #[]
            arr = arg.dup.shift
            unless arr.size == 2
              raise ArgumentError, "expected #{arr.inspect} to have 2 elements"
            end

            arr
          else
            raise ArgumentError, "wrong number of arguments (#{args.size} for 2)"
        end
      end


      def find_element(*args)
        sleep 0.1
        how, what = extract_args(args)
        by = Selenium::WebDriver::SearchContext::FINDERS[how.to_sym]
        i = 0
        wait = Object::Selenium::WebDriver::Wait.new({:timeout => 5, :message => "element not found"})
        wait.until {
          bridge.find_element_by by, what.to_s, ref
        }
      rescue Selenium::WebDriver::Error::TimeOutError
          puts by
          puts what.to_s
          raise Selenium::WebDriver::Error::NoSuchElementError
        end

    end
  end

end