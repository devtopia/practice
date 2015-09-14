Rails.application.config.cache_store = :dalli, Settings.cache_server, {namespace: 'oiax', compress: true}
