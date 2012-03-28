class RenderController < ApplicationController

	def render_tex_text
		text = params[:text]
		arr = text.split('$')
		Formula
		formula_arr = Formula.find_or_render \
			arr.values_at(* arr.each_index.select {|i| i.odd?}).map {|f| "#{f}" }, \
			(params[:size].to_i || 20)
		arr = arr.each_with_index.map do |s, i|
			if i.even?
				CGI.escapeHTML(s)
			else
				"<img src=\"/formulae/#{formula_arr[(i-1)/2].filename}.png\"" +
					" style=\"vertical-align:-#{formula_arr[(i-1)/2].depth}px;\" / >"
			end
		end

		@html = {:html => arr.join, :params => params, :arr => formula_arr}

		respond_to do |format|
			format.json { render :json => @html }
		end
	end

end
