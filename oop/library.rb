require_relative 'book'
require_relative 'author'
require_relative 'reader'
require_relative 'order'
require 'pp'
require 'yaml'

class Library
  attr_accessor :books, :orders, :readers, :authors

  def initialize
    @books = []
    @orders = []
    @readers = []
    @authors = []
  end

  def add_book(book)
    @books << book unless @books.include? book
    @authors << book.author unless @authors.include? book.author
  end

  def order_book(book, reader)
    return "This book is not in the library" unless @books.include? book
    @readers << reader unless @readers.include? reader
    @orders << Order.new(book, reader)
  end

  def who_often_take_book(book)
    return "This book is not in the library" unless @books.include? book
    reader = @orders.select { |order| order.book == book }.map!(&:reader)
                    .each_with_object(Hash.new(0)) { |key, hash| hash[key] +=1; hash }
                    .sort_by { |_reader, value| value }.last[0]
    puts "Reader #{reader.name} often take a book #{book.title}"
  end

  def most_popular_book
    return [] if @orders.empty?
    popular_book = @orders.map!(&:book)
                          .each_with_object(Hash.new(0)) { |key, hash| hash[key] +=1; hash }
                          .sort_by { |_book, value| value }.last[0]
    puts "The most popular book is #{popular_book.title}"    
  end

  def count_readers_popular_books
    return "There are not orders in a library" if @orders.empty?
    number = @orders.group_by(&:book).max_by(3) { |book, order| order.size }
                    .to_h.values.first.map(&:reader).uniq.count
    puts "#{number} readers ordered one of the three most popular books"
  end

  def self.load_from_file
    YAML.load(File.read('./temp.txt'))
  end

  def save_to_file
    File.open('./temp.txt', 'w') {|f| f.write(YAML.dump(self)) }
    puts "Library saved to file"
  end
end

# stiven = Author.new("Stiven King", "")
# book_1 = Book.new("Dark Tower", stiven)
# book_2 = Book.new("Dark Tower 1", stiven)
# book_3 = Book.new("Dark Tower 2", stiven)

# reader_1 = Reader.new("Reader_1", "test1@test.ru", "", "", "")
# reader_2 = Reader.new("Reader_2", "test2@test.ru", "", "", "")
# reader_3 = Reader.new("Reader_3", "test1@test.ru", "", "", "")
# reader_4 = Reader.new("Reader_4", "test1@test.ru", "", "", "")

# library = Library.new
# library.add_book book_1
# library.add_book book_2
# library.add_book book_3
# pp library.books

# 3.times { library.order_book(book_1, reader_1) }

# library.order_book(book_1, reader_2)
# library.order_book(book_1, reader_3)
# library.order_book(book_1, reader_4)

# library.order_book(book_2, reader_1)
# library.order_book(book_3, reader_2)
# library.order_book(book_2, reader_3)
# library.order_book(book_3, reader_4)

# pp library.who_often_take_book book_1
# pp library.most_popular_book
# pp library.count_readers_popular_books
# pp library.find_readers(book_1)
# pp library.popular_books(3)
# library.save_to_file
# pp library.orders
# library = Library.load_from_file
# pp library.most_popular_book