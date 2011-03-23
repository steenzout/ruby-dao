require 'rubygems'
require 'steenzout-cfg'


module Steenzout
  module DAO

    autoload :DAOManager, "#{File.dirname(__FILE__)}/dao/manager"
    autoload :TokyoCabinetDAO, "#{File.dirname(__FILE__)}/dao/tokyocabinet"

  end
end