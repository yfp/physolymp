require 'digest/md5'

class Array
  def to_s
    res = ''
    each do |e|
      res << ', ' if !res.empty?
      res << e.to_s
    end
    "[#{res}]"
  end
end 

class Texrender
  attr_accessor :font_size, :color

  def initialize(font_size = 16, color = :black)
    @font_size = font_size
    @color = color
    @format = '.png'
    @ext = 'png'
    @temp_dir_path = '/tmp/tex'
    @template_path = '/lib/tex/render_template.tex.erb'
    @formulae_path = '/public/formulae/'
    @public_path   = '/formulae/'

    @tex_size = 12
    @step = 1.0 * @tex_size / @font_size
    @density = Integer(72.27 * @font_size / @tex_size);

    @log = []
  end

  def self.generate_filename(hash)
    Digest::MD5.hexdigest(hash[:size].to_s + hash[:text])
  end

  def generate_img_name(formula)
    Texrender.generate_filename :size => @font_size, :text => formula
  end

  # process temp image and transfer to public
  def public_img(temp_name, pub_name)
    
    # width and height of image (!) strings, not integers
    width, height =
      %x[identify -format "%wx%h" #{temp_name}].split('x').map(&:to_i)
    
    # Have no idea what's going on here
    # We crop image to first column where
    # black pixel on the baseline is located
    # then trim it from the top
    # Height of the leftover is our depth+1
    depth = %x[convert #{temp_name} -crop 1x#{height}+0+0 \
      +repage -affine 2,0,0,1,0,0 -transform -gravity South \
      -background blue -splice 0x1 -trim +repage #{@ext}:- \
      | identify -format \"%h\" #{@ext}:-].to_i - 2
    
    #
    # here should be the test on dimensions
    #

    # remove first column and save to pub_name
    # -crop #{width-1}x#{height}+1+0 +repage
    %x[convert -comment \"#{depth}\" #{temp_name} \
       -crop #{width-1}x#{height}+1+0 +repage #{pub_name}]

    # set permissions and delete temp img
    FileUtils.chmod 0777, pub_name

    depth
  end

  def formulae_to_img(arr)
        root_dir = Rails.root.to_s 

        # Change directory to "temp". Don't shit in the root
        Dir.chdir(root_dir + @temp_dir_path)

        # Generate random name of process. Don't mess with parallel threads
        temp_name = "temp#{rand(9999).to_s}"

        temp = ERB.new IO.read(root_dir + @template_path)

        @arr = arr
        File.open("#{temp_name}.tex", 'w') {|f| f.write temp.result(binding)}

        # Run latex (tex -> dvi), dvips(dvi -> ps)
        system("latex --interaction=nonstopmode #{temp_name}")
        system("dvips #{temp_name}.dvi -o #{temp_name}.ps")

        # imagemagick convert ps to image and trim picture
        system("convert -density #{@density} -trim -transparent \"#FFFFFF\" #{temp_name}.ps " +
          "+repage #{temp_name}#{@format}");

        ret = arr.each_with_index.map do |f, i|
          # md5 hash for unique name of formula
          name = generate_img_name f
          temp_img_name = temp_name + (arr.size==1 ? '' : '-'+i.to_s) + @format
          { :depth => public_img(temp_img_name, 
              root_dir + @formulae_path + name + @format),
            :name => name }
        end

        # Clean shit
        system("rm #{temp_name}*")

        # Change directory back to rails_app_root
        Dir.chdir root_dir

        ret.map{|h| h.merge({:url => (@public_path + h[:name])}) }
  end

end