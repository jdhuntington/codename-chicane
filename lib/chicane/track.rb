require 'digest/md5'

module Chicane
  class Track

    attr_reader :document

    def initialize(id)
      @track_id = id
      load_document
    end

    def new?
      @new
    end

    def filename=(filename)
      @document['filename'] = filename
    end

    def filename
      @document['filename']
    end

    def parse_metadata_from_file
      @document['metadata'] = { "implement" => "me" }
    end

    def record_play
      @document['plays'] ||= []
      @document['plays'] << Time.new.gmtime
      @document.save
    end

    def load_document
      @document = CouchDB::Document.new(Chicane::Database.database, "_id" => @track_id)
      @document.load
      @new = false
      true
    rescue CouchDB::Document::NotFoundError
      @document = CouchDB::Document.new(Chicane::Database.database, "_id" => @track_id)
      @new = true
      true
    end

    def save
      @document.save
    end

    def self.import(filename)
      track = from_file(filename)
      track.filename = filename
      track.parse_metadata_from_file
      track.save
      track
    end

    def self.from_file(filename)
      track_id = Digest::MD5.file(filename)
      track = new(track_id)
    end
  end
end
