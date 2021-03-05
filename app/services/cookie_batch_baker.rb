class CookieBatchBaker
    attr_reader :fillings, :batch_size, :oven

    def initialize(fillings, batch_size, oven)
        @fillings = fillings
        @batch_size = batch_size
        @oven = oven
    end

    def self.perform(fillings, batch_size, oven)
        new(fillings, batch_size, oven).perform
    end
    
    def perform
        cookie_batch = Array.new(@batch_size) do
            { fillings: @fillings, storage_id: @oven.id, storage_type: 'Oven' }
        end
        cookie_ids = cookie_batch.map do |c|
            cookie = Cookie.create!(c)
            cookie.id
        end
        OvenWorker.perform_async(cookie_ids, @oven.id)
    end
end
  