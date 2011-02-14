# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mingle-events}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Rice"]
  s.date = %q{2011-02-14}
  s.description = %q{A gem that lets you process Mingle events in a pipes and filters style.}
  s.email = %q{david.rice at gmail dot com}
  s.extra_rdoc_files = ["LICENSE.txt", "README.textile", "lib/mingle_events.rb", "lib/mingle_events/author.rb", "lib/mingle_events/category.rb", "lib/mingle_events/element_support.rb", "lib/mingle_events/entry.rb", "lib/mingle_events/http_error_support.rb", "lib/mingle_events/mingle_basic_auth_access.rb", "lib/mingle_events/mingle_oauth_access.rb", "lib/mingle_events/page.rb", "lib/mingle_events/poller.rb", "lib/mingle_events/processors.rb", "lib/mingle_events/processors/abstract_no_retry_processor.rb", "lib/mingle_events/processors/card_data.rb", "lib/mingle_events/processors/card_type_filter.rb", "lib/mingle_events/processors/category_filter.rb", "lib/mingle_events/processors/http_post_publisher.rb", "lib/mingle_events/processors/pipeline.rb", "lib/mingle_events/processors/puts_publisher.rb", "lib/mingle_events/project_event_broadcaster.rb", "lib/mingle_events/project_feed.rb"]
  s.files = ["Gemfile", "Gemfile.lock", "LICENSE.txt", "Manifest", "README.textile", "lib/mingle_events.rb", "lib/mingle_events/author.rb", "lib/mingle_events/category.rb", "lib/mingle_events/element_support.rb", "lib/mingle_events/entry.rb", "lib/mingle_events/http_error_support.rb", "lib/mingle_events/mingle_basic_auth_access.rb", "lib/mingle_events/mingle_oauth_access.rb", "lib/mingle_events/page.rb", "lib/mingle_events/poller.rb", "lib/mingle_events/processors.rb", "lib/mingle_events/processors/abstract_no_retry_processor.rb", "lib/mingle_events/processors/card_data.rb", "lib/mingle_events/processors/card_type_filter.rb", "lib/mingle_events/processors/category_filter.rb", "lib/mingle_events/processors/http_post_publisher.rb", "lib/mingle_events/processors/pipeline.rb", "lib/mingle_events/processors/puts_publisher.rb", "lib/mingle_events/project_event_broadcaster.rb", "lib/mingle_events/project_feed.rb", "mingle-events.gemspec", "Rakefile", "test/mingle_events/author_test.rb", "test/mingle_events/category_test.rb", "test/mingle_events/entry_test.rb", "test/mingle_events/page_test.rb", "test/mingle_events/processors/abstract_no_retry_processor_test.rb", "test/mingle_events/processors/card_data_test.rb", "test/mingle_events/processors/card_type_filter_test.rb", "test/mingle_events/processors/category_filter_test.rb", "test/mingle_events/processors/pipeline_test.rb", "test/mingle_events/project_event_broadcaster_test.rb", "test/mingle_events/project_feed_test.rb", "test/test_helper.rb"]
  s.homepage = %q{https://github.com/ThoughtWorksStudios/mingle-events}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Mingle-events", "--main", "README.textile"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{mingle-events}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A gem that lets you process Mingle events in a pipes and filters style.}
  s.test_files = ["test/mingle_events/author_test.rb", "test/mingle_events/category_test.rb", "test/mingle_events/entry_test.rb", "test/mingle_events/page_test.rb", "test/mingle_events/processors/abstract_no_retry_processor_test.rb", "test/mingle_events/processors/card_data_test.rb", "test/mingle_events/processors/card_type_filter_test.rb", "test/mingle_events/processors/category_filter_test.rb", "test/mingle_events/processors/pipeline_test.rb", "test/mingle_events/project_event_broadcaster_test.rb", "test/mingle_events/project_feed_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
