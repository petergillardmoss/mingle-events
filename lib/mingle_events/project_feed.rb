module MingleEvents
  
  # Simple means of iterating over a project's events, hiding the mechanics
  # of pagination.
  class ProjectFeed
    
    def initialize(project_identifier, mingle_access)
      @mingle_access = mingle_access
      @project_identifier = project_identifier
    end
  
    # All entries/events for a project, starting with the most recent. Be careful
    # not to take all events for a project with significant history without considering
    # the time this will require.
    def entries
      AllEntries.new(Page.new(latest_events_path, @mingle_access))
    end
  
    private 
  
    def latest_events_path
      "/api/v2/projects/#{@project_identifier}/feeds/events.xml"
    end
  
    class AllEntries
    
      include Enumerable
    
      def initialize(first_page)
        @current_page = first_page
      end
    
      def each
        while (@current_page) 
          @current_page.entries.each{|e| yield e}
          @current_page = @current_page.next
        end
      end
    
      # TODO: what do i really want to do here?
      def <=>(other)
        return 0
      end
    
    end
  
  end 
end