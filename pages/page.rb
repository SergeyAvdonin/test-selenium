require 'selenium-webdriver'
require 'yaml'
require 'page-object/platforms/selenium_webdriver/element'
require 'page-object'

class Page
  include PageObject
  path = '../config/config.yaml'
  @@config = YAML.load_file(path)
  def initialize(root,visit = false)
    super(root, visit)
  end

  Selenium::WebDriver::Element.class_eval do
    def initialize(bridge, id)
      @bridge = bridge
      @id = id
    end

    def click

      wait = Object::Selenium::WebDriver::Wait.new({:timeout => 1, :message => "ff"})
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

    #need for find_element reconstruction
    def extract_args(args)
      case args.size
        when 3
          args
        when 2
          # base timeout for find_element
          args.push(5)
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

    #standard element search with 5 seconds default
    def find_element(*args)
      sleep 0.1
      how, what, timeout = extract_args(args)
      by = Selenium::WebDriver::SearchContext::FINDERS[how.to_sym]
      wait = Object::Selenium::WebDriver::Wait.new({:timeout => timeout, :message => "element not found"})
      wait.until {
        bridge.find_element_by by, what.to_s, ref
      }
    rescue Selenium::WebDriver::Error::TimeOutError => e
      return nil
      #raise Selenium::WebDriver::Error::NoSuchElementError
    end
  end


  #short checks for existing here
  PageObject::Platforms::SeleniumWebDriver::SurrogateSeleniumElement.class_eval do
    def attempt_to_find_element
      begin
        @element = browser.find_element(identifier, type, 1) unless @element
      rescue Selenium::WebDriver::Error
        @element = nil if @element.element.instance_of?(::PageObject::Platforms::SeleniumWebDriver::SurrogateSeleniumElement)
      end
    end
  end

  #lets make 1 second {name}? waiting
  PageObject::Accessors.module_eval do
    def standard_methods(name, identifier, method, &block)
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        platform.send(method, identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block).exists? if block_given?
        how, what = PageObject::Elements::Element.selenium_identifier_for identifier.clone
        !browser.find_element(how, what, 1).nil?
      end
    end

  end

end