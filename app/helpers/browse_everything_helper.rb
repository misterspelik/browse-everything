module BrowseEverythingHelper
  def array_to_hidden_fields(array, key)
    fields = array.to_query(key).split(Rack::Utils::DEFAULT_SEP).collect do |pair|
      key, value = pair.split('=', 2).map { |str| Rack::Utils.unescape(str) }
      hidden_field_tag(key, value)
    end
    fields.join("\n").html_safe
  end

  # Extracted from Rack::Mime 1.5.2 for use with earlier versions of Rack/Rails
  # @param [String] value
  # @param [String] matcher
  # @return [TrueClass,FalseClass]
  def mime_match?(value, matcher)
    v1, v2 = value.split('/', 2)
    m1, m2 = matcher.split('/', 2)
    return false if m1 != '*' && v1 != m1
    m2.nil? || m2 == '*' || m2 == v2
  end

  # @param [BrowseEverything::FileEntry] file
  # @return [TrueClass,FalseClass]
  def is_acceptable?(file)
    acceptable = params[:accept] || '*/*'
    acceptable_types = acceptable.split(/,\s*/)
    acceptable_types << 'application/x-directory'
    acceptable_types.any? { |type| mime_match?(file.type, type) }
  end

  def image_prew(full_path)
    img_path = full_path.split(':')[1]
    b64img = Base64.encode64(open(img_path, &:read))
    image_tag "data:image/jpeg;base64,#{b64img}", size: '50'
  end

  def b_create_folder(full_path)
    dir_path = full_path.split(':')[1]
    button_tag('', curr_path: dir_path, onclick: 'addSubFolder(this)') do
      content_tag(:i, '*', class: 'fa fa-folder').html_safe
    end
  end
end
