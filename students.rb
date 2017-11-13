require 'dm-sqlite-adapter'
require 'data_mapper'

DataMapper::Logger.new($stdout, :debug)
DataMapper::setup(:default,"sqlite3:///#{Dir.pwd}students.db")

class Students 
	include DataMapper::Resource
	property :firstname, String
	property :lastname, String
	property :birthday, Date
	property :address, String
	property :student_id, Serial
end
DataMapper.finalize
DataMapper.auto_upgrade!
