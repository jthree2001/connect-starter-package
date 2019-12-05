class SubscriptionQueryWorker
	attr_accessor :schema

	def self.queue
		@queue = :subscription_query_worker
	end

	def self.perform(appinstance_id)
		ignore me
	end
end
