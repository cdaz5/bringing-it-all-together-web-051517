class Dog

attr_accessor :name, :breed
attr_reader :id

def initialize(name:, breed:, id: nil)
  @name = name
  @breed = breed
  @id = id
end

def self.create_table
  sql = <<-SQL
  CREATE TABLE IF NOT EXISTS dogs (
    id INTEGER PRIMARY KEY,
    name TEXT,
    breed TEXT
  )
  SQL

  DB[:conn].execute(sql)
end

def self.drop_table
  sql = <<-SQL
  DROP TABLE dogs
  SQL

  DB[:conn].execute(sql)
end

def save
  if self.id
    #UPDATE METHOD
  else
    sql = <<-SQL
    INSERT INTO dogs (name, breed)
    VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.breed)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
  end
  self
  end

  def self.create(name:, breed:)
    # binding.pry
    dog = Dog.new(name: name, breed: breed)
    dog.save
    dog
  end

  def self.find_by_id(id)
    sql = <<-SQL
    SELECT * FROM dogs
    WHERE id = ?
    SQL

    row = DB[:conn].execute(sql, id).flatten
    # binding.pry
    self.new_from_db(row)
  end

  def self.new_from_db(row)
    name = row[1]
    breed = row[2]
    id = row[0]
    dog = Dog.new(name: name, breed: breed, id: id)
    dog
  end

  def self.find_or_create_by(name:, breed:)
    sql = <<-SQL
    SELECT * FROM dogs
    WHERE name = ? AND breed = ?
    LIMIT 1
    SQL

    row = DB[:conn].execute(sql, name, breed).flatten

    if !row.empty?
      dog = self.new_from_db(row)
    else
    dog = self.create(name: name, breed: breed)
  end
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM dogs
    WHERE name = ?
    SQL

    row = DB[:conn].execute(sql, name).flatten
    self.new_from_db(row)
  end

  def update
    sql = <<-SQL
    UPDATE dogs
    SET name = ?, breed = ?
    WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end







end
