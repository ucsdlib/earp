Rails.application.config.middleware.use OmniAuth::Builder do
  provider :azure_activedirectory,
    Rails.credentials.dig(:azure_ad, :client),
    Rails.credentials.dig(:azure_ad, :tenant)
end
