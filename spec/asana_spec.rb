# frozen_string_literal: true

require File.expand_path("spec_helper", __dir__)

module Danger
  describe Danger::DangerAsana do
    it "should be a plugin" do
      expect(Danger::DangerAsana.new(nil)).to be_a Danger::Plugin
    end

    describe "with Dangerfile" do
      before do
        @dangerfile = testing_dangerfile
        @asana = @dangerfile.asana

        @task1 = double("Task 1", {
          name: "task 1",
          notes: "description 1",
          permalink_url: "https://app.asana.com/0/1"
        })

        @task2 = double("Task 2", {
          name: "task 2",
          notes: "description 2",
          permalink_url: "https://app.asana.com/0/2"
        })
      end

      it "Finds multiple Asana tasks ids in body and title" do
        allow(@asana).to receive_message_chain("github.pr_title").and_return("[#1200084894659941] Test PR")
        allow(@asana).to receive_message_chain("github.pr_body").and_return("[#1200084894659949]")

        allow(@asana).to receive("find_by_id").with("1200084894659941").and_return(@task1)
        allow(@asana).to receive("find_by_id").with("1200084894659949").and_return(@task2)

        @asana.check

        expect(@dangerfile.status_report[:markdowns].first.message).to eq(%(Asana tasks in this PR |
--- |
**[task 1](https://app.asana.com/0/1)**
description 1 |
**[task 2](https://app.asana.com/0/2)**
description 2 |))
      end

      it "Finds Asana tasks by URL" do
        allow(@asana).to receive_message_chain("github.pr_title").and_return("Test PR")
        allow(@asana).to receive_message_chain("github.pr_body").and_return("testing\n\nhttps://app.asana.com/0/1199918955119300/1200084193308092]\nhttps://app.asana.com/0/1199972814069143/1199619253751287")

        allow(@asana).to receive("find_by_id").with("1200084193308092").and_return(@task1)
        allow(@asana).to receive("find_by_id").with("1199619253751287").and_return(@task2)

        @asana.check

        expect(@dangerfile.status_report[:markdowns].first.message).to eq(%(Asana tasks in this PR |
--- |
**[task 1](https://app.asana.com/0/1)**
description 1 |
**[task 2](https://app.asana.com/0/2)**
description 2 |))
      end

      it "Ignore duplicate task IDs" do
        allow(@asana).to receive_message_chain("github.pr_title").and_return("[#1200084894659941]")
        allow(@asana).to receive_message_chain("github.pr_body").and_return("https://app.asana.com/0/1199972814069143/1200084894659941")

        allow(@asana).to receive("find_by_id").with("1200084894659941").and_return(@task1)

        @asana.check

        expect(@dangerfile.status_report[:markdowns].first.message).to eq(%(Asana tasks in this PR |
--- |
**[task 1](https://app.asana.com/0/1)**
description 1 |))
      end
    end
  end
end
