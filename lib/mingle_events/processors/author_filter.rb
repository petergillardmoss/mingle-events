module MingleEvents
  module Processors
    
    # Removes all events from stream not triggered by the specified author
    class AuthorFilter
    
      def initialize(spec, mingle_access, project_identifier)
        @author_spec = AuthorSpec.new(spec, mingle_access, project_identifier)
      end
    
      def process_events(events)
        events.select{|event| @author_spec.event_triggered_by?(event)}
      end
      
      class AuthorSpec
        
        def initialize(spec, mingle_access, project_identifier)
          @spec = spec
          @mingle_access = mingle_access
          @project_identifier = project_identifier
        end
        
        def event_triggered_by?(event)
          event.author.uri == author_uri
        end
        
        private 
        
        def author_uri
          lookup_author_uri
        end
        
        def lookup_author_uri
          team_resource = "/api/v2/projects/#{@project_identifier}/team.xml"
          @raw_xml ||= @mingle_access.fetch_page(URI.escape(team_resource))
          @doc ||= Nokogiri::XML(@raw_xml)

          users = @doc.search('/projects_members/projects_member/user').map do |user|
            {
              :url => user.attribute('url').inner_text,
              :name => user.at('name').inner_text,
              :login => user.at('login').inner_text,
              :email => user.at('email').inner_text
            }
          end
          
          spec_user = users.find do |user|
            # is this too hacky?
            user.merge(@spec) == user
          end
          
          spec_user.nil? ? nil : spec_user[:url]
        end
        
      end
    
    end
  end
end