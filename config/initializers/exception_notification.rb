Rails.application.config.middleware.use ExceptionNotification::Rack,
  ignore_crawlers: %w(Googlebot bingbot),
  email: {
    email_prefix: "「oiax」500 Error",
    sender_address: %("oiax 500 Error" <error500@gameon.co.jp>),
    exception_recipients: %w(error500@gameon.co.jp)
  },
  slack: {
    webhook_url: "#{Settings.webhook_url.oiax}",
    channel: "#oiax"
  }
