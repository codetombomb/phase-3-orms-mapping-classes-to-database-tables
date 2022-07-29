require 'pry'

class Song

  attr_accessor :name, :album, :id

  def initialize(name:, album:, id: nil)
    @name = name
    @album = album
    @id = @id
  end

  def self.all
    sql = 
    <<-SQL
      SELECT * FROM songs;
    SQL
    
    songs = DB[:conn].execute(sql)
    self.convert_to_instances(songs)
  end


  def self.create_table
    sql = <<-SQL 
    CREATE TABLE IF NOT EXISTS songs
    (
      id INTEGER PRIMARY KEY,
      name TEXT,
      album TEXT
    );
    SQL
    DB[:conn].execute(sql)
  end

  def self.first
    sql = 
    <<-SQL
      SELECT * from songs WHERE songs.id = 1
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop
    sql = <<-SQL
    DROP TABLE songs
    SQL
    DB[:conn].execute(sql)
  end

  def self.create(name:, album:)
    song = Song.new(name: name, album: album)
    song.save
  end

  def save
    sql = 
    <<-SQL
    INSERT INTO songs
    (name, album)
    VALUES ("#{self.name}" ,"#{self.album}");
    SQL
    song = DB[:conn].execute(sql)
    new_song = DB[:conn].execute("SELECT * FROM songs ORDER BY songs.id DESC LIMIT 1")
    self.id = new_song[0][0]
    self
  end

  private 
  def self.convert_to_instances(arr)
    song_arr = []
    arr.each do |s|
      new_s = Song.new(name: s[1], album: s[2])
      song_arr << new_s
    end 
    song_arr
  end

end
