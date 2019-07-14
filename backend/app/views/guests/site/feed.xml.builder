# frozen_string_literal: true

xml.instruct! :xml, version: '1.0'
xml.rss version: '2.0' do
  xml.channel do
    xml.title "Francis' Blog"
    xml.author 'FrancisTM'
    xml.description 'Ruby, PHP, Frontend, Backend'
    xml.link root_url
    xml.language 'zh-CN'

    @posts.each do |post|
      xml.item do
        xml.title post.try(:title)
        xml.author post.admin.nickname
        xml.pubDate post.published_at.to_s(:rfc822)
        xml.link guests_post_url(post.slug)
        xml.guid guests_post_url(post.slug)
        xml.description parse_markdown(post.content)
      end
    end
  end
end
