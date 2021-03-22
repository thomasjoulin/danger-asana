# frozen_string_literal: true

require "asana"

module Danger
  # Links Asana issues to a pull request.
  # @example Check PR for the following Asana project keys and links them
  #
  #          asana.check()
  #
  # @see  thomasjoulin/danger-asana
  # @tags asana
  #
  class DangerAsana < Plugin
    def initialize(dangerfile)
      super(dangerfile)

      @client = Asana::Client.new do |c|
        c.authentication :access_token, ENV["_ASANA_TOKEN"]
        c.default_headers "asana-enable" => "new_user_task_lists"
      end
    end

    # Checks PR for Asana IDs and links them
    #
    # @return [void]
    #
    def check
      issues = find_asana_issues

      messages = [
        "Asana tasks in this PR |",
        "--- |"
      ]

      issues.each do |issue|
        task = find_by_id(issue)

        unless task.nil?
          messages << "**[#{task.name}](#{task.permalink_url})**\n#{task.notes} |"
        end
      end

      markdown messages.join("\n")
    end

    private

    def vcs_host
      return gitlab if defined? @dangerfile.gitlab

      return github
    end

    def find_asana_issues(search_title: true, search_commits: true, search_body: true)
      regexp = Regexp.new(/\[#([^\]]+)\]/)

      asana_issues = []

      if search_title
        vcs_host.pr_title.gsub(regexp) do |match|
          asana_issues << Regexp.last_match(1)
        end
      end

      if search_commits
        git.commits.map do |commit|
          commit.message.gsub(regexp) do |match|
            asana_issues << Regexp.last_match(1)
          end
        end
      end

      if search_body
        vcs_host.pr_body.gsub(regexp) do |match|
          asana_issues << Regexp.last_match(1)
        end
      end

      return asana_issues.uniq
    end

    def find_by_id(id)
      @client.tasks.find_by_id(id)
    rescue Asana::Errors::NotFound
      puts "task #{id} not found"
      return nil
    end
  end
end
