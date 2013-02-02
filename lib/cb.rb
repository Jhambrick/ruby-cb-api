require "cb/cb_api"
require "cb/cb_job"
require "cb/cb_job_api"
require "cb/config"

module Cb
	def self.configure
		yield configuration
	end

	def self.configuration
		@configuration ||= Cb::Config.new
	end
end