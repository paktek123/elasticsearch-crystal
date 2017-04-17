#require "./src/elasticsearch/api/utils"
#a = Utils.__listify({:hello => true})
#puts a
#c = Elasticsearch::API::Client.new({:host => "localhost", :port => 9250})
#puts c.indices.perform_request
#puts c.cat.aliases

class Inside
  def bye
    puts "bye"
  end
end

class Example
  def hello
    puts "hello"
  end

  def inside
    Inside.new()
  end
end

a = Example.new
b = Example.new
c = Example.new

hh = [a,b,c]

macro stuff(*data)
  {% for name,index in data %}
    puts {{name.id}}.hello
  {% end %}
end

stuff(a,b,c)

def say_hi
