Rails.configuration.stripe = {
  publishable_key: Rails.application.credentials.dig(:stripe, :publishable_key),
  secret_key: Rails.application.credentials.dig(:stripe, :secret_key)
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
# 以下は必要に応じて。
# Stripe.log_level = Stripe::LEVEL_DEBUG if Rails.env.development? || Rails.env.test?
