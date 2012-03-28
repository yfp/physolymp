class Formula < ActiveRecord::Base
	validates :text, :filename, :presence => true

	@@formulae_list = []
	@@render_list = []
	@@def_font_size = 16
	@@def_color     = '000000'

	def self.add_formula(hash)
		text = ( hash[:ds] ? '\displaystyle ' : '' ) + ( hash[:text] or hash )
		cur_params = {:text => text, :size => (hash[:size] or @@def_font_size) }
		f = Formula.find :first, :conditions => cur_params
		if !f
			f = Formula.new cur_params
			@@render_list << "$#{text}$"
			@@formulae_list << {:formula => f, :render => true}			
		else
			@@formulae_list << {:formula => f}
		end
	end

	def self.find_or_render(arr, font_size = 16)
		@@def_font_size = font_size
		arr.each{ |h|  self.add_formula h }

		formulae = Texrender.new(font_size).formulae_to_img(@@render_list)
		i=0
		@@formulae_list.map do |h|
			if h[:render]
				h[:formula].filename, h[:formula].depth =
					formulae[i][:name], formulae[i][:depth]
				h[:formula].save
				i+=1
			else
				h[:formula].touch
			end
			h[:formula]
		end
	end
end
