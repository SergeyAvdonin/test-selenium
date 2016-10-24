
require_relative 'spec_helper'
describe "Login spec" do
  driver = Selenium::WebDriver.for :chrome
  driver.manage.window.maximize
  main_page = PortalMainPage.new(driver)

  after(:each) do
    main_page.logout
  end

  it "login normal user" do
    main_page.login_as_normal_user
    expect(main_page.get_my_cabinet_title).to eq ("Мой кабинет")
  end

  it "login super user" do
    main_page.login_as_super_user
    expect(main_page.get_my_cabinet_title).to eq ("Мой кабинет")
  end
end