require_relative 'page'
class PortalMainPage < Page
  button(:enter, :id => 'open-auth-popup')
  text_field(:email, :id => 'session_email')
  text_field(:password, :id => 'session_password')
  button(:login_submit, :id => 'session_submit')
  link(:my_cabinet_link, :class => 'js-mycompany')
  link(:exit, :link_text => 'Выход')

  def login(mail, pwd)
    navigate_to("http://www.test-blizko.ru")
    enter
    self.email = mail
    self.password = pwd
    login_submit
  end

  def login_as_normal_user
    login(@@config['normal_user_mail'], @@config['normal_user_pwd'])
  end

  def login_as_super_user
    login(@@config['super_user_mail'], @@config['super_user_pwd'])
  end

  def get_my_cabinet_title
    my_cabinet_link_element.text
  end

  def logout
    my_cabinet_link
    exit
  end

end