require 'data_mapper'

DataMapper::Logger.new($stdout, :debug)
DataMapper::setup(:default,"sqlite3:///#{Dir.pwd}comments.db")

class Comments 
	include DataMapper::Resource
	property :name, String
	property :created_at, DateTime
	property :content, String
	property :student_id, Serial
end
DataMapper.finalize
DataMapper.auto_upgrade!
