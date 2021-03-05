class OvenWorker
  include Sidekiq::Worker

  def perform(cookie_ids, oven_id)
    Kernel.sleep(120)
    completion_time = DateTime.current
    Oven.find(oven_id).update(batch_completed_baking_at: completion_time)
    Cookie.where(id: cookie_ids).update_all(completed_baking_at: completion_time)
  end
end
