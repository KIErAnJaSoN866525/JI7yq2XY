# 代码生成时间: 2025-09-12 08:57:17
# 定义数学计算工具集的类
class MathCalculator
  # 加法方法
  def add(*numbers)
    # 错误处理：确保所有参数都是数字
    unless numbers.all? { |n| n.is_a?(Numeric) }
      return 'Error: All arguments must be numeric'
    end
    numbers.sum
  end

  # 减法方法
  def subtract(*numbers)
    # 错误处理：确保至少有两个参数且都是数字
    unless numbers.size > 1 && numbers.all? { |n| n.is_a?(Numeric) }
      return 'Error: At least two numeric arguments are required'
    end
    numbers[0] - numbers[1..-1].sum
  end

  # 乘法方法
  def multiply(*numbers)
    # 错误处理：确保所有参数都是数字
    unless numbers.all? { |n| n.is_a?(Numeric) }
      return 'Error: All arguments must be numeric'
    end
    numbers.reduce(:*)
  end

  # 除法方法
  def divide(*numbers)
    # 错误处理：确保至少有两个参数且都是数字，且除数不为零
    unless numbers.size > 1 && numbers.all? { |n| n.is_a?(Numeric) } && numbers[1..-1].all? { |n| n != 0 }
      return 'Error: At least two numeric arguments are required and second argument must not be zero'
    end
    numbers[0] / numbers[1..-1].inject(1) { |acc, i| acc * i }
  end
end

# 创建Sinatra应用
get '/' do
  erb :index
end

# 路由处理加法请求
get '/add/:numbers' do |numbers|
  numbers_array = numbers.split(',').map(&:to_f)
  calculator = MathCalculator.new
  "Result: #{calculator.add(*numbers_array)}"
end

# 路由处理减法请求
get '/subtract/:numbers' do |numbers|
  numbers_array = numbers.split(',').map(&:to_f)
  calculator = MathCalculator.new
  "Result: #{calculator.subtract(*numbers_array)}"
end

# 路由处理乘法请求
get '/multiply/:numbers' do |numbers' do
  numbers_array = numbers.split(',').map(&:to_f)
  calculator = MathCalculator.new
  "Result: #{calculator.multiply(*numbers_array)}"
end

# 路由处理除法请求
get '/divide/:numbers' do |numbers|
  numbers_array = numbers.split(',').map(&:to_f)
  calculator = MathCalculator.new
  "Result: #{calculator.divide(*numbers_array)}"
end

# 定义视图模板index.erb
__END__
@@ index
<html>
<head>
  <title>Math Calculator</title>
</head>
<body>
  <h1>Math Calculator</h1>
  <p>Welcome to the math calculator service.</p>
  <ul>
    <li><a href='/add/1,2,3'>Try add: 1 + 2 + 3</a></li>
    <li><a href='/subtract/10,2,3'>Try subtract: 10 - 2 - 3</a></li>
    <li><a href='/multiply/2,3,4'>Try multiply: 2 * 3 * 4</a></li>
    <li><a href='/divide/12,3,2'>Try divide: 12 / 3 / 2</a></li>
  </ul>
</body>
</html>
