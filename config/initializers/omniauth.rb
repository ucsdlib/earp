Rails.application.config.middleware.use OmniAuth::Builder do
  provider :azure_activedirectory,
    Rails.application.credentials.dig(:azure_ad, :client),
    Rails.application.credentials.dig(:azure_ad, :tenant)
end
