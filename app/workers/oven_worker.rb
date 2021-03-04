class OvenWorker
  include Sidekiq::Worker

  def perform(cookieId)
    Kernel.sleep(120)
    Cookie.update(cookieId, completed_baking_at: DateTime.current)
  end
end
