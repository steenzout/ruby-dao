include TokyoCabinet

module Steenzout
  module DAO

    # Generic TokyoCabinet Data Access Object.
    #
    # @var name: the name of the implemented DAO.
    # @var database: the TokyoCabinet database.
    #
    class TokyoCabinetDAO

      attr_reader :database

      # Constructs a generic TokyoCabinet DAO.
      #
      # @param name: the name of the implemented DAO.
      # @param configuration: hash containing the DAO configuration.
      #                       :kvstore => the TokyoCabinet database implementation.
      #                       :location => the TokyoCabinet database location.
      #
      def initialize(name, configuration)

        @name = name

        raise ArgumentError, "TokyoCabinetDAO name is nil!" \
          if name.nil?
        raise ArgumentError, "TokyoCabinetDAO configuration nil!" \
          if configuration.nil?
        raise ArgumentError, "TokyoCabinetDAO configuration for #{@name} is missing the :kvstore property!" \
          if !configuration.has_key? :kvstore
        raise ArgumentError, "TokyoCabinetDAO configuration for #{@name} is missing the :location property!" \
          if !configuration.has_key? :location


        case configuration[:kvstore]
          when :hdb, :hash
            @database = HDB::new
          when :bdb, :btree
            @database = BDB::new
          when :fdb, :'fixed-length'
            @database = FDB::new
          when :tdb, :table
            @database = TDB::new
          when :adb, :abstract
            @database = ADB::new
          else
            raise ArgumentError, "Unknown TokyoCabinet database #{configuration[:kvstore]}!"
        end

        @location = configuration[:location]

      end

      def open()

        if !@database.open(@location, HDB::OWRITER | HDB::OCREAT)
          LOGGER.error('steenzout-dao.TokyoCabinetDAO][#{@name}') {"open error: #{@database.errmsg(@database.ecode)}"} if LOGGER.error?
        end

      end

      def close()

        if !@database.nil?
          LOGGER.error('steenzout-dao.TokyoCabinetDAO[#{@name}') {"close error: #{@database.errmsg(@database.ecode)}"} if !@database.close
        end

      end



      def delete(key)

        @database.out key

        LOGGER.info('steenzout-dao.TokyoCabinetDAO[#{@name}') {"deleted #{key} mapping."}

        nil

      end



      def has?(key)

        !@database[key].nil?

      end



      def get(key)

        @database[key]

      end



      def list()

        @database.iterinit
        while key = @database.iternext
          yield key, get(key)
        end

      end



      def map(key, value)

        status = @database.put key, value
        if !status
          LOGGER.debug('steenzout-dao.TokyoCabinetDAO][#{@name}') {"#{@database.ecode} : #{@database.errmsg(@database.ecode)}"}
          error = "failed mapping #{key}->#{value}!"
          LOGGER.error('steenzout-dao.TokyoCabinetDAO][#{@name}') {error}
          raise Exception, error
        end
        LOGGER.info('steenzout-dao.TokyoCabinetDAO][#{@name}') {"created #{key}->#{value} mapping."}

      end



      def update(key, value)

        if !has? key
          raise ArgumentError, "There is no mapping for the given #{key} key."
        end

        map(key, value)

      end

    end

  end
end
