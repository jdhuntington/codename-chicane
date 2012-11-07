require 'couchdb'

module Chicane
  class Database
    def self.database
      @database ||= begin
                      server = CouchDB::Server.new '127.0.0.1', 5984
                      database = CouchDB::Database.new server, 'music'
                      database.create_if_missing!
                      database
                    end
    end

    def self.db_directory
      File.expand_path('../../../db', __FILE__)
    end

    def self.load_design_document
      document = CouchDB::Design.new database, "chicane"
      document.load
      document
    rescue CouchDB::Document::NotFoundError
      CouchDB::Design.new database, "chicane"
    end

    def self.create_design_documents
      design = load_design_document
      Dir[File.join(db_directory, '*')].each do |view_directory|
        view_name = view_directory.split('/').last
        map = nil
        reduce = nil
        if File.exist?(File.join(view_directory, 'map.js'))
          map = File.read(File.join(view_directory, 'map.js'))
        end
        if File.exist?(File.join(view_directory, 'reduce.js'))
          reduce = File.read(File.join(view_directory, 'reduce.js'))
        end
        CouchDB::Design::View.new design, view_name, map, reduce
      end
      design.save
    end

    def self.activate
      create_design_documents
    end
  end
end
