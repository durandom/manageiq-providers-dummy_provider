class ManageIQ::Providers::DummyProvider::CloudManager < ManageIQ::Providers::CloudManager
  require_nested :Refresher
  require_nested :RefreshWorker
  require_nested :Vm

  def verify_credentials(auth_type = nil, options = {})
    begin
      connect
    rescue => err
      raise MiqException::MiqInvalidCredentialsError, err.message
    end

    true
  end

  def connect(options = {})
    raise MiqException::MiqHostError, "No credentials defined" if missing_credentials?(options[:auth_type])

    auth_token = authentication_token(options[:auth_type])
    self.class.raw_connect(project, auth_token, options, options[:proxy_uri] || http_proxy_uri)
  end

  def self.validate_authentication_args(params)
    # return args to be used in raw_connect
    return [params[:default_userid], MiqPassword.encrypt(params[:default_password])]
  end

  def self.hostname_required?
    # TODO: ExtManagementSystem is validating this
    false
  end

  def self.raw_connect(*args)
    true
  end

  def self.ems_type
    @ems_type ||= "dummy_provider".freeze
  end

  def self.description
    @description ||= "Dummy Provider".freeze
  end
end
