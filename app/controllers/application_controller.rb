class ApplicationController < ActionController::API

  # I use code from https://github.com/Netflix/fast_jsonapi/issues/53#issuecomment-517492495
  # to handle error and compliant with json api spec
  around_action :handle_errors

  def handle_errors
    yield
  rescue ActiveRecord::RecordNotFound => e
    render_api_error(e.message, 404)
  # rescue ActiveRecord::RecordInvalid => e
  #   render_api_error(e.record.errors.full_messages, 422)
  # rescue JWT::ExpiredSignature => e
  #   render_api_error(e.message, 401)
  # rescue InvalidTokenError => e
  #   render_api_error(e.message, 422)
  # rescue MissingTokenError => e
  #   render_api_error(e.message, 422)
  end

  def render_api_error(messages, code)
    data = { errors: { code: code, details: Array.wrap(messages) } }
    render json: data, status: code
  end

  def generate_links(record, url, current_page)
    options = {links: {}}
    
    # Use guard clause so the rest code won't be executed
    return options if record.total_pages == 1

    if current_page.blank? or current_page < 2
      options[:links][:next] = url + '?page=2'
    elsif current_page >= record.total_pages
      options[:links][:prev] = "#{url}?page=#{current_page - 1}"
    else
      options[:links][:prev] = "#{url}?page=#{current_page - 1}"
      options[:links][:next] = "#{url}?page=#{current_page + 1}"
    end
    options
  end
end
