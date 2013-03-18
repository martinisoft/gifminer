module SiteSearch
  extend self
  include HTTParty

  SearchResult = Struct.new :url

  def search(tags)
    search_tumblr tags
  end

  def search_tumblr(tags)
    search_results = []
    # Marc says: Yeah, this is search all registered sites. We'll want to not do that in future
    Site.find_each do |site|
      result = get "http://api.tumblr.com/v2/blog/#{site.name}.tumblr.com/posts/photo?tag=#{tags}&api_key=#{ENV['TUMBLR_KEY']}"
      data = JSON.parse(result.body)

      data['response']['posts'].each do |post_data|
        search_results << SearchResult.new(post_data["photos"].first["original_size"]["url"])
      end
    end
    search_results
  end
end