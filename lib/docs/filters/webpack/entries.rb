module Docs
  class Webpack
    class EntriesFilter < Docs::EntriesFilter
      def get_name
        name = at_css('h1').content
        name.sub! ' - ', ': '
        name
      end

      TYPE_BY_DIRECTORY = {
        'get-started'   => 'Getting Started',
        'concepts'      => 'Concepts',
        'guides'        => 'Guides',
        'api'           => 'API',
        'configuration' => 'Configuration',
        'loaders'       => 'Loaders',
        'plugins'       => 'Plugins'
      }

      def get_type
        TYPE_BY_DIRECTORY[slug.split('/').first]
      end

      def additional_entries
        if slug.start_with?('configuration')
          css('h2[id] code').map do |node|
            [node.content, node.parent['id']]
          end
        elsif slug.start_with?('api')
          css('.header[id] code').each_with_object [] do |node, entries|
            next if node.previous.try(:content).present?
            entries << ["#{self.name}: #{node.content.sub(/\(.*\)/, '()')}", node.parent['id']]
          end
        else
          []
        end
      end
    end
  end
end

