module Paginable
  protected

  DEFAULT_CURRENT_PAGE = 1
  DEFAULT_PER_PAGE = 20

  def current_page
    (params[:page] || DEFAULT_CURRENT_PAGE).to_i
  end

  def per_page
    (params[:per_page] || DEFAULT_PER_PAGE).to_i
  end

  def meta_attributes(collection)
    {
      current_page: collection.current_page,
      total: collection.total_count,
      itemsPerPage: collection.limit_value
    }
  end
end