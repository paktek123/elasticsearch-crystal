module Elasticsearch
  module API
    module Tasks
      module Actions; end

      # Client for the "tasks" namespace (includes the {Tasks::Actions} methods)
      #
      class TasksClient < Common::Client
        include Tasks::Actions
      end
    end
  end
end
