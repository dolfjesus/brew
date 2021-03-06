require "hbc/artifact/abstract_artifact"

module Hbc
  module Artifact
    class NestedContainer < AbstractArtifact
      attr_reader :path

      def initialize(cask, path)
        super(cask)
        @path = cask.staged_path.join(path)
      end

      def install_phase(**options)
        extract(**options)
      end

      private

      def summarize
        path.relative_path_from(cask.staged_path).to_s
      end

      def extract(verbose: nil, **_)
        container = Container.for_path(path)

        unless container
          raise CaskError, "Aw dang, could not identify nested container at '#{source}'"
        end

        ohai "Extracting nested container #{path.relative_path_from(cask.staged_path)}"
        container.new(cask, path).extract(to: cask.staged_path, verbose: verbose)
        FileUtils.remove_entry_secure(path)
      end
    end
  end
end
