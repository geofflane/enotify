class FilterSweeper < ActionController::Caching::Sweeper
  observe Incident

  # If our sweeper detects that a Incident was created call this
  def after_create(incident)
    expire_cache_fragment()
  end
  
  # If our sweeper detects that a Incident was deleted call this
  def after_destroy(incident)
    expire_cache_fragment(incident)
  end
          
  private
  def expire_cache_fragment(incident)
    expire_fragment(incident.class_name +'_filter')
  end
end