# This filter assumes the users are at /username (not /users/username)
module HTML
  class Pipeline
    class MentionFilter < Filter

      def link_to_mentioned_user(login)
        result[:mentioned_usernames] |= [login]
        url = File.join("#{base_url}/characters", login)
        "<a href='#{url}' class='user-mention'>" +
        "@#{login}" +
        "</a>"
      end
    end
  end
end

context = {
  :asset_root => "https://a248.e.akamai.net/assets.github.com/images/icons",
  :base_url   => "http://canaryclip.com"
}

SocialPipeline = HTML::Pipeline.new [
  HTML::Pipeline::AutolinkFilter,
  HTML::Pipeline::MentionFilter,
  HTML::Pipeline::EmojiFilter
], context
