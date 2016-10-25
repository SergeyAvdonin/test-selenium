require_relative 'spec_helper'
describe "Register company spec" do
  driver = Selenium::WebDriver.for :chrome
  driver.manage.window.maximize
  main_page = PortalMainPage.new(driver)
  main_page.navigate_home
  main_page.navigate_to_company_creation
  company_registration_page = CompanyRegistrationPage.new(driver)
  company_registration_page.continue_registration
  it 'all empty fields' do
    company_registration_page.continue_registration
    expect(company_registration_page.name_error?).to be true
    expect(company_registration_page.mail_error?).to be true
    expect(company_registration_page.company_name_error?).to be true
    expect(company_registration_page.phone_code_error?).to be true
    expect(company_registration_page.phone_number_error?).to be true
    expect(company_registration_page.rubric_error?).to be true
  end

  it 'invalid company name' do
    company_registration_page.set_company_name('1')
    company_registration_page.continue_registration
    expect(company_registration_page.company_name_error?).to be true
  end

  it 'valid company name' do
    company_registration_page.set_company_name('a')
    company_registration_page.continue_registration
    expect(company_registration_page.company_name_error?).to be false
  end

end
