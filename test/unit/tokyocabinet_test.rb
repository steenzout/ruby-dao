require 'test/unit'
require 'logger'
require 'tokyocabinet'
require 'lib/steenzout-dao'


LOGGER = Logger.new('log/development.log') if !defined? LOGGER


KEY_STRING1 = 'string1'
KEY_STRING2 = 'string2'
VALUE_STRING1 = 'value_string1'
VALUE_STRING2 = 'value_string2'

class TestTokyoCabinetDAO < Test::Unit::TestCase

  def setup()

    @dao = Steenzout::DAO::TokyoCabinetDAO.new(:test_dao, {:kvstore => :hdb, :location => 'test/test.tch'})
    @dao.open

    @dao.map(KEY_STRING1, VALUE_STRING1)

  end

  def teardown()

    @dao.database.vanish unless @dao.nil? or @dao.database.nil? # removes all records from the database

  ensure
    @dao.close if !@dao.nil?
  end


### test methods

  def test_create_abstract()

    dao = Steenzout::DAO::TokyoCabinetDAO.new(:test_dao, {:kvstore => :adb, :location => 'test/abstract.tch'})

    assert(dao.database.instance_of? ADB)

  end

  def test_create_btree()

    dao = Steenzout::DAO::TokyoCabinetDAO.new(:test_dao, {:kvstore => :bdb, :location => 'test/btree.tch'})

    assert(dao.database.instance_of? BDB)

  end

  def test_create_hash()

    dao = Steenzout::DAO::TokyoCabinetDAO.new(:test_dao, {:kvstore => :hdb, :location => 'test/hash.tch'})

    assert(dao.database.instance_of? HDB)

  end

  def test_create_fixed_length()

    dao = Steenzout::DAO::TokyoCabinetDAO.new(:test_dao, {:kvstore => :fdb, :location => 'test/fixed.tch'})

    assert(dao.database.instance_of? FDB)

  end

  def test_create_table()

    dao = Steenzout::DAO::TokyoCabinetDAO.new(:test_dao, {:kvstore => :tdb, :location => 'test/abstract.tch'})

    assert(dao.database.instance_of? TDB)

  end


  def test_delete()

    @dao.delete(KEY_STRING1)
    assert_nil @dao.get(KEY_STRING1)

  end


  def test_delete_unknown_key()
    assert_nil @dao.delete('UNKNOWN')
  end


  def test_get()

    # 0. adding one more mapping
    @dao.map(KEY_STRING2, VALUE_STRING2)

    # 1. test
    assert_equal VALUE_STRING1, @dao.get(KEY_STRING1)
    assert_equal VALUE_STRING2, @dao.get(KEY_STRING2)

  end


  def test_get_unknown_key()
    assert_nil @dao.get('UNKNOWN')
  end


  def test_has?()
    assert @dao.has? KEY_STRING1
    assert_equal false, @dao.has?('UNKNOWN')
  end


  def test_list()

    # 1. with mappings
    @dao.list { |key, value|
      assert_equal key, KEY_STRING1
      assert_equal value, VALUE_STRING1}

    # 2. with no mappings
    @dao.delete(KEY_STRING1)
    assert_nil @dao.list

  end


  def test_map()
    assert_equal VALUE_STRING1, @dao.get(KEY_STRING1)
  end

end