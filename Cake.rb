#the method that cuts our raisin pie
def cutting(array_cake, piece, size)
  start_position = find_spot(array_cake)  #search for the top leftmost point for the piece
  return piece if start_position == nil
  #we start with the largest width of the slice,
  #since according to the condition we choose the option where the first element is the widest
  width = size
  while width > 0
    break if width == 0
    height = 0

    while height < size
      break if height == size
      height += 1
      next unless width*height == size
      #checks if you can cut off some piece
      slice = valid_piece(array_cake, start_position[:x], start_position[:y], width, height)
      next if slice.nil?

      #make a copy of the array so that we can find other ways to cut the cake
      new_piece = piece.dup
      new_piece.push(slice)

      new_array_cake = []
      i = 0
      #copying a two-dimensional array
      while i < array_cake.size
        new_array_cake[i] = array_cake[i].dup
        i += 1
      end
      #cut off a piece of the pie, thereby replacing all characters with "x"
      (start_position[:y]...(start_position[:y] + height)).each do |k|
        (start_position[:x]...(start_position[:x] + width)).each { |l| new_array_cake[k][l] = "x" }
      end
      #call the recursion
      cake = cutting(new_array_cake, new_piece, size)
      return cake if cake.size > 0 #return the cut cake
    end
    width -= 1
  end
  []
end

#search for the top leftmost point for the next piece
def find_spot(array_cake)
  (0...array_cake.size).each do |i|
    (0...array_cake[i].size).each do |j|
      return { y: i, x: j } if array_cake[i][j] != "x"
    end
  end
  nil
end

#checks if you can cut off some piece
def valid_piece(array_cake, x, y, width, height)
  if (x + width) > array_cake[0].size || (y + height) > array_cake.size
    return nil
  end
  #cut the cake and check for raisins
  piece = array_cake.slice(y, height)
  piece = piece.map {|i| i.slice(x,width)}
  slice = piece.map { |row| row.join }.join("\n")
  return nil if (slice.include? "x") || (slice.count("o") != 1)
  slice
end


# cake = "........\n..o.....\n...o....\n........"
#cake = ".o......\n......o.\n....o...\n..o....."
cake = ".o.o....\n........\n....o...\n........\n.....o..\n........"

#or if we want to use the terminal
unless ARGV.empty?
  # puts("Enter: ruby Cake.rb '.o...... ......o. ....o... ..o.....'")
  cake = ''
  ARGV.each { |i| cake += i + "\n"}
end

#to replace all " " with "\n" if using ARGV
cake = cake.gsub(' ', "\n")
puts "cake =\n#{cake}"

raisins = cake.count("o")
puts "Amount of raisins: #{raisins}"
arr = cake.split("\n")

#checking the number of raisins
if raisins <= 1 || raisins >= 10
  puts "Raisins should be <10 and >1"
  exit
end

#check that the cake is rectangular
unless arr.all? { |str| str.length == arr[0].size }
  puts "The cake is not rectangular in shape"
  exit
end

#each string is divided into characters, and a two-dimensional array is obtained
array_cake = arr.map(&:chars)
print array_cake
puts

array_cake_size = array_cake.size * array_cake[0].size
puts "array_cake_size = #{array_cake_size}"

piece = []
if array_cake_size%raisins != 0 #checking if the pie can be divided equally
  print piece
  exit
end

piece_size = array_cake_size/raisins
puts "piece_size = #{piece_size}"

piece = cutting(array_cake, piece, piece_size)

print "Result =\n["
piece.each do |i|
  puts "\n" + i
  print "," unless i == piece.last
end
print"]"