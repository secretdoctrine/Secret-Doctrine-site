# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Authors" do
    describe "Admin" do
      describe "poems", type: :feature do
        refinery_login

      end
    end
  end
end
