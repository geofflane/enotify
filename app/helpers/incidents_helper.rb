module IncidentsHelper
  def current_model_name
      controller_name.classify
  end
  
  def current_model
      Object.const_get controller_name.classify
  end
end
