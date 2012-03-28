class Page < ActiveRecord::Base
	acts_as_tree :order => "title"

	def url
		( self.parent ? self.parent.url + '/' : '' ) + self.name
	end
end
