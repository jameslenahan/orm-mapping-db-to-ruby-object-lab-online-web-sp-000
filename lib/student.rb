class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student

  end

  def self.all
    sql = "SELECT * FROM students"
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    student_row = DB[:conn].execute(sql, name)[0]
    self.new_from_db(student_row)
  end
  def self.count_all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9"
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade<12;"
    DB[:conn].execute(sql)
  end

  def self.first_x_students_in_grade_10(num)
    sql = "SELECT * FROM students WHERE grade = 10 ORDER BY students.id LIMIT ?;"
    DB[:conn].execute(sql, num)
  end

  def self.first_student_in_grade_10
    student = self.first_x_students_in_grade_10(1).flatten
    self.new_from_db(student)
  end

  def self.all_students_in_grade_X(num)
    sql = "SELECT * FROM students WHERE grade=?;"
    DB[:conn].execute(sql, num)
  end	
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    
    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
