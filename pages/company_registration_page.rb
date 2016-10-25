require_relative 'page'

class CompanyRegistrationPage < Page
  puts "1"

  button(:continue_registration, :xpath => "//input[@value='Продолжить регистрацию']")
  span(:name_error, :xpath => ".//*[@id='company_new']/div[2]/fieldset/ul/li[1]/div[2]/span[2]")
  span(:mail_error, :xpath => "//li[2]/div[2]/span[2]")
  span(:company_name_error, :xpath => "//div[3]/li/div[2]/span[2]")
  span(:phone_code_error, :xpath => "//div[3]/div[2]/span")
  span(:phone_number_error, :xpath => "//div[3]/span")
  span(:rubric_error, :xpath => "//*[contains(text(),'не указан вид деятельности для компании')]")
  text_field(:user_name, :id => 'user_profile_attributes_name')
  text_field(:user_mail, :id => 'user_email')
  text_field(:company_name, :id => 'company_name')
  text_field(:phone_code, :name => 'address[phones_attributes][0][code]')
  text_field(:phone_number, :name => 'address[phones_attributes][0][code]')
  text_field(:company_about, :id => 'apress_company_abouts_company_about_announce')
  text_field(:user_cell_phone, :id => 'user_profile_attributes_contacts')


  def set_company_name(text)
    self.company_name = text
    self
  end

  def set_user_default_fields(mail)
    set_user_name(yaml['company_user_name'])
    set_user_mail(mail)
    self
  end

  def set_user_mail(mail)
    self.user_mail = mail
    self
  end

  def set_user_name(text)
    self.user_name = text
    self
  end

  def set_company_default_fields()
    set_company_name(yaml['company_name'])
    set_company_phone_code(yaml['company_code'])
    set_company_phone_number(yaml['company_phone_number'])
    set_about(yaml['company_about'])
    self
  end

  def set_about(text)
    self.company_about = text
    self
  end

  def set_company_phone_number(text)
    self.phone_code = text
    self
  end

  def set_company_phone_code(text)
    self.phone_code = text
    self
  end

end