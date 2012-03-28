class PageObserver < ActiveRecord::Observer
  
  def reload_routes(page)
    ActionController::Routing::Routes.reload!
  end

  alias_method :after_save,    :reload_routes
  alias_method :after_destroy, :reload_routes
end
