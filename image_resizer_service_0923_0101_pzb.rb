# 代码生成时间: 2025-09-23 01:01:39
# 图片尺寸批量调整器服务
class ImageResizerService < Sinatra::Base
  # POST /resize 接口，用于接收图片并调整尺寸
  post '/resize' do
    # 检查是否有文件上传
# TODO: 优化性能
    unless params[:images] && params[:images].respond_to?(:each)
      return json_error(400, 'No images provided.')
# 添加错误处理
    end

    # 检查目标尺寸参数
    target_width = params[:width].to_i
    target_height = params[:height].to_i
    unless target_width > 0 && target_height > 0
      return json_error(400, 'Invalid dimensions.')
    end

    # 存储调整后的图片文件名
# 增强安全性
    resized_images = []

    # 遍历上传的图片
    params[:images].each do |image|
      # 检查图片文件类型
      next unless image[:filename].match(/\.(jpg|jpeg|png)\Z/i)

      # 创建图片临时路径
      temp_path = "#{Dir::Tmpname.create('img', '/tmp')}#{File.extname(image[:filename])}"
      File.open(temp_path, 'wb') { |f| f.write(image[:tempfile].read) }

      # 使用MiniMagick调整图片尺寸
      resized_image = MiniMagick::Image.new(temp_path)
      resized_image.resize "#{target_width}x#{target_height}"
      resized_image_path = "#{Dir::Tmpname.create('resized_img', '/tmp')}#{File.extname(image[:filename])}"
# FIXME: 处理边界情况
      resized_image.write resized_image_path

      # 添加调整后的图片路径到数组
      resized_images << resized_image_path

      # 清理临时文件
      File.delete(temp_path)
    end

    # 返回调整后的图片路径
    json_success({ resized_images: resized_images })
  end
# NOTE: 重要实现细节

  # 私有方法，用于返回JSON格式的错误信息
  def json_error(status_code, message)
    content_type :json
    "{"error": "#{message}"}"
  end

  # 私有方法，用于返回JSON格式的成功信息
  def json_success(data)
    content_type :json
    "{"success": true, "data": #{data.to_json}}
  end
end
